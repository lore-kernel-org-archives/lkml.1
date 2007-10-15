Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXJOUNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXJOUNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbXJOUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:13:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbXJOUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:13:44 -0400
Date: Mon, 15 Oct 2007 13:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <Pierre.Peiffer@bull.net>
Cc: Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPC: fix error case when idr-cache is empty in ipcget()
Message-Id: <20071015131310.fa519705.akpm@linux-foundation.org>
In-Reply-To: <20071011093222.5600520c.Pierre.Peiffer@bull.net>
References: <20071011093222.5600520c.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 09:32:22 +0200
Pierre Peiffer <Pierre.Peiffer@bull.net> wrote:

> @@ -373,7 +376,7 @@ int ipcget_public(struct ipc_namespace *
>  	struct kern_ipc_perm *ipcp;
>  	int flg = params->flg;
>  	int err;
> -
> +retry:
>  	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
>  
>  	mutex_lock(&ids->mutex);
> @@ -406,6 +409,9 @@ int ipcget_public(struct ipc_namespace *
>  	}
>  	mutex_unlock(&ids->mutex);
>  
> +	if (err == -EAGAIN)
> +		goto retry;
> +
>  	return err;
>  }

Not pretty, is it?  The idr interface isn't a good one.  But then, any
storage library (aka container class) which allocates memory at insertion
time is a pain to handle in the kernel.

btw, idr_pre_get() should return 0 on success, else an errno - the current
interface is silly.

