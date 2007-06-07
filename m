Return-Path: <linux-kernel-owner+w=401wt.eu-S936131AbXFGTgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936131AbXFGTgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934693AbXFGTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:36:28 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:56195 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760927AbXFGTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:36:27 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Nadia.Derbey@bull.net
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into radix trees
Date: Thu, 7 Jun 2007 21:37:33 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, ak@suse.de
References: <20070607165302.917616000@bull.net> <20070607165555.155173000@bull.net>
In-Reply-To: <20070607165555.155173000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706072137.34563.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadia,

good to see someone is pounding this old beast again :-)

On Thursday 07 June 2007, Nadia.Derbey@bull.net wrote:
> Index: linux-2.6.21/ipc/util.h
> ===================================================================
> --- linux-2.6.21.orig/ipc/util.h	2007-06-07 11:00:30.000000000 +0200
> +++ linux-2.6.21/ipc/util.h	2007-06-07 11:07:22.000000000 +0200
> @@ -13,6 +13,8 @@
>  #define USHRT_MAX 0xffff
>  #define SEQ_MULTIPLIER	(IPCMNI)
>  
> +#define IPCS_MAX_SCAN_ENTRIES 256

That ...

> Index: linux-2.6.21/ipc/util.c
> ===================================================================
> --- linux-2.6.21.orig/ipc/util.c	2007-06-07 11:00:30.000000000 +0200
> +++ linux-2.6.21/ipc/util.c	2007-06-07 11:29:43.000000000 +0200
> @@ -252,72 +241,94 @@ void __init ipc_init_proc_interface(cons
>   *	@key: The key to find
>   *	
>   *	Requires ipc_ids.mutex locked.
> - *	Returns the identifier if found or -1 if not.
> + *	Returns the LOCKED pointer to the ipc structure if found or NULL
> + *	if not.
> + *      If key is found ipc contains its ipc structure
>   */
>   
> -int ipc_findkey(struct ipc_ids* ids, key_t key)
> +struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
>  {
> -	int id;
> -	struct kern_ipc_perm* p;
> -	int max_id = ids->max_id;
> +	struct kern_ipc_perm *ipc;
> +	struct kern_ipc_perm *ipcs[IPCS_MAX_SCAN_ENTRIES];

... together with this means 4*256 -> 1k of precious stack space used.
Please consider either lowering IPCS_MAX_SCAN_ENTRIES or kmalloc() that.

Same problem with your third patch called 
"Changing the loops on a single ipcid into radix_tree_gang_lookup() calls"

If you cannot sleep, try to lower that constant (e.g. 16-32). 
The current users use much smaller numbers.

If you can sleep and performance goes down after lowering that constant,
try to kmalloc these arrays (since kmalloc() of that small amount 
should succeed easily).



Regards

Ingo Oeser
