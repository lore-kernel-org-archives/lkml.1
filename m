Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXI0GNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXI0GNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXI0GNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:13:40 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:31751 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXI0GNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:13:39 -0400
Date: Thu, 27 Sep 2007 08:13:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Shreyansh Jain <shreyansh.jain@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: try_module_get code understanding
Message-ID: <20070927061304.GA7966@osiris.boeblingen.de.ibm.com>
References: <loom.20070927T051622-501@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20070927T051622-501@post.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I was going through try_module_get function in include/linux/module.h file
> (2.6.22 stock kernel) - which is like:
> 
> -----
> static inline int try_module_get(struct module *module){
>   int ret = 1;   <--- error case when !module
>     if (module) {
>          unsigned int cpu = get_cpu();
>          if (likely(module_is_live(module)))
>                 local_inc(&module->ref[cpu].count);
>          else
>                 ret = 0;   <--- error case
>          put_cpu();
>   }
>   return ret;   <----
> }
> ----
> 
> What I understand about the code flow is:
> -- module live would return the flag stating that this module can be reference
> and is NOT being removed currently.
> 
> 1. In case the module pointer passed is invalid (NULL) this function would
> return 1 (error case)
> 2. In case the module pointer is OK, and module is currently not being removed,
> reference count would be incremented and 1 returned (non error case)
> 3. In case the module pointer is OK, and module reference count can NOT be
> increased, 0 would be returned (error case).
> 
> As you can observe from above points, 0 and 1 are returned for error cases. I am
> a little confused and wondering if there is something which I am missing in this
> code??.
> 
> Can anyone help me out with this? Any help would be highly appreciated.

Somewhere in module.h you have:

#ifdef MODULE
#define THIS_MODULE (&__this_module)
#else  /* !MODULE */
#define THIS_MODULE ((struct module *)0)
#endif

So this just means, that THIS_MODULE is NULL for compiled in modules
and therefore try_module_get(NULL) succeeds. It's not an error case.
