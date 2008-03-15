Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYCOEJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYCOEJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYCOEJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:09:31 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:31894 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYCOEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OOfCSj5ZtRT1H7Otom1Se8E2KD63M6IKuBUR1H3SoWLjNeDjVERZD4B0zljAkZNGtuSFNIzuISwIMuuFfwN/+/7OMWO6R2kH3hR74XFi5yIrVI1hmkNQqmnEc4MAy8vblLhPrGLkV6gNx1vxah9XOGLQu2uJFE8mPAIKFxS/YH8=
Date: Sat, 15 Mar 2008 13:01:46 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Message-ID: <20080315040144.GA4003@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C> <20080310204853.3108d21c.akpm@linux-foundation.org> <200803111510.52761.nickpiggin@yahoo.com.au> <20080310212108.5882011e.akpm@linux-foundation.org> <961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com> <20080311103517.5b6dc23f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080311103517.5b6dc23f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course it can be used in those places.  Here's the idr.c conversion:
> 
> --- a/lib/idr.c~a
> +++ a/lib/idr.c
> @@ -585,14 +585,6 @@ static void idr_cache_ctor(struct kmem_c
>  	memset(idr_layer, 0, sizeof(struct idr_layer));
>  }
>  
> -static  int init_id_cache(void)
> -{
> -	if (!idr_layer_cache)
> -		idr_layer_cache = kmem_cache_create("idr_layer_cache",
> -			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
> -	return 0;
> -}
> -
>  /**
>   * idr_init - initialize idr handle
>   * @idp:	idr handle
> @@ -602,7 +594,9 @@ static  int init_id_cache(void)
>   */
>  void idr_init(struct idr *idp)
>  {
> -	init_id_cache();
> +	if (ONCE())
> +		idr_layer_cache = kmem_cache_create("idr_layer_cache",
> +			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
>  	memset(idp, 0, sizeof(struct idr));
>  	spin_lock_init(&idp->lock);
>  }
> 
> 

Maybe this doesn't handle kmem_cache_create() failure.

Anyhow this is the alternative patch to fix what the patch 1/5 was
trying to fix.

Subject: idr: create idr_layer_cache at boot time

This patch checks kmem_cache_create() failure by SLAB_PANIC
by creating idr_layer_cache unconditionary at boot time rather than
creates when idr_init() is called first time by someone.

This change also enables to eliminate unnecessary check every time
idr_init() is called.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/idr.h |    2 ++
 init/main.c         |    2 ++
 lib/idr.c           |   10 ++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

Index: 2.6-rc/lib/idr.c
===================================================================
--- 2.6-rc.orig/lib/idr.c
+++ 2.6-rc/lib/idr.c
@@ -585,12 +585,11 @@ static void idr_cache_ctor(struct kmem_c
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
 
-static  int init_id_cache(void)
+void __init init_id_cache(void)
 {
-	if (!idr_layer_cache)
-		idr_layer_cache = kmem_cache_create("idr_layer_cache",
-			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
-	return 0;
+	idr_layer_cache = kmem_cache_create("idr_layer_cache",
+				sizeof(struct idr_layer), 0, SLAB_PANIC,
+				idr_cache_ctor);
 }
 
 /**
@@ -602,7 +601,6 @@ static  int init_id_cache(void)
  */
 void idr_init(struct idr *idp)
 {
-	init_id_cache();
 	memset(idp, 0, sizeof(struct idr));
 	spin_lock_init(&idp->lock);
 }
Index: 2.6-rc/include/linux/idr.h
===================================================================
--- 2.6-rc.orig/include/linux/idr.h
+++ 2.6-rc/include/linux/idr.h
@@ -115,4 +115,6 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+void __init init_id_cache(void);
+
 #endif /* __IDR_H__ */
Index: 2.6-rc/init/main.c
===================================================================
--- 2.6-rc.orig/init/main.c
+++ 2.6-rc/init/main.c
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/idr.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -616,6 +617,7 @@ asmlinkage void __init start_kernel(void
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	init_id_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
