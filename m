Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYBENsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYBENsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYBENsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:48:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYBENsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:48:03 -0500
Date: Tue, 05 Feb 2008 22:38:39 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Nadia.Derbey@bull.net
Subject: Re: [RFC][PATCH v2 7/7] Do not recompute msgmni anymore if explicitely set by user
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       matthltc@us.ibm.com
In-Reply-To: <20080131135357.082657000@bull.net>
References: <20080131134018.273154000@bull.net> <20080131135357.082657000@bull.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080205222005.67FE.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Nadia-san.

I tested this patch set on my box. It works well.
I have only one comment.


> ---
>  ipc/ipc_sysctl.c |   43 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 41 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.24/ipc/ipc_sysctl.c
> ===================================================================
> --- linux-2.6.24.orig/ipc/ipc_sysctl.c	2008-01-29 16:55:04.000000000 +0100
> +++ linux-2.6.24/ipc/ipc_sysctl.c	2008-01-31 13:13:14.000000000 +0100
> @@ -34,6 +34,24 @@ static int proc_ipc_dointvec(ctl_table *
>  	return proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
>  }
>  
> +static int proc_ipc_callback_dointvec(ctl_table *table, int write,
> +	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	size_t lenp_bef = *lenp;
> +	int rc;
> +
> +	rc = proc_ipc_dointvec(table, write, filp, buffer, lenp, ppos);
> +
> +	if (write && !rc && lenp_bef == *lenp)
> +		/*
> +		 * Tunable has successfully been changed from userland:
> +		 * disable its automatic recomputing.
> +		 */
> +		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
> +
> +	return rc;
> +}
> +


Hmmm. I suppose this may be side effect which user does not wish.

I would like to recommend there should be a switch which can turn on/off
automatic recomputing.
If user would like to change this value, it should be turned off.
Otherwise, his requrest will be rejected with some messages.

Probably, user can understand easier than this side effect.

Bye.

-- 
Yasunori Goto 


