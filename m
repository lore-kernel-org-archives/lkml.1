Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYBKUo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYBKUo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYBKUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:44:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbYBKUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:44:18 -0500
Date: Mon, 11 Feb 2008 12:27:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com, Nadia.Derbey@bull.net
Subject: Re: [PATCH 8/8] Re-enable msgmni automatic recomputing msgmni if
 set to negative
Message-Id: <20080211122748.64e7bc36.akpm@linux-foundation.org>
In-Reply-To: <20080211141816.520049000@bull.net>
References: <20080211141646.948191000@bull.net>
	<20080211141816.520049000@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 15:16:54 +0100
Nadia.Derbey@bull.net wrote:

> [PATCH 08/08]
> 
> This patch is the enhancement as asked for by Yasunori: if msgmni is set to
> a negative value, register it back into the ipcns notifier chain.
> 
> A new interface has been added to the notification mechanism:
> notifier_chain_cond_register() registers a notifier block only if not already
> registered. With that new interface we avoid taking care of the states changes
> in procfs.
> 
> ...
>
>  static int proc_ipc_callback_dointvec(ctl_table *table, int write,
>  	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
> +	struct ctl_table ipc_table;
>  	size_t lenp_bef = *lenp;
>  	int rc;
>  
> -	rc = proc_ipc_dointvec(table, write, filp, buffer, lenp, ppos);
> +	memcpy(&ipc_table, table, sizeof(ipc_table));
> +	ipc_table.data = get_ipc(table);
> +
> +	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
>  
>  	if (write && !rc && lenp_bef == *lenp)
> -		/*
> -		 * Tunable has successfully been changed from userland:
> -		 * disable its automatic recomputing.
> -		 */
> -		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
> +		tunable_set_callback(*((int *)(ipc_table.data)));
>  
>  	return rc;
>  }
> @@ -119,12 +142,14 @@ static int sysctl_ipc_registered_data(ct
>  	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
>  		newlen);
>  
> -	if (newval && newlen && rc > 0)
> +	if (newval && newlen && rc > 0) {
>  		/*
> -		 * Tunable has successfully been changed from userland:
> -		 * disable its automatic recomputing.
> +		 * Tunable has successfully been changed from userland
>  		 */
> -		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
> +		int *data = get_ipc(table);
> +
> +		tunable_set_callback(*data);
> +	}
>  
>  	return rc;
>  }

hm, what's happening here?  We take a local copy of the caller's ctl_table
and then pass that into proc_dointvec().  Is that as hacky as it seems??


