Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZBSLPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZBSLPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZBSLPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:15:18 -0500
Received: from ozlabs.org ([203.10.76.45]:35763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZBSLPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:15:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Thu, 19 Feb 2009 21:45:10 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <200902182227.14686.rusty@rustcorp.com.au> <ac3eb2510902180557p3b65fad5i933eed9d3e3d0b3b@mail.gmail.com>
In-Reply-To: <ac3eb2510902180557p3b65fad5i933eed9d3e3d0b3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192145.10616.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 00:27:58 Kay Sievers wrote:
> some modules wait for 200-500 milliseconds to
> get the lock released, some larger modules spend 50 milliseconds in
> load_module(), many of them around 20 milliseconds.

OK, this is an untested hack (don't try unloading modules, not sure symbol
resolution isn't racy now I've killed the lock).  Does it change the numbers?

Thanks!
Rusty.

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2020,10 +2020,13 @@ static noinline struct module *load_modu
 	}
 #endif
 	if (pcpuindex) {
+		mutex_lock(&module_mutex);
+
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
 					 sechdrs[pcpuindex].sh_addralign,
 					 mod->name);
+		mutex_unlock(&module_mutex);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_percpu;
@@ -2317,19 +2320,10 @@ SYSCALL_DEFINE3(init_module, void __user
 	if (!capable(CAP_SYS_MODULE))
 		return -EPERM;
 
-	/* Only one module load at a time, please */
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
-
 	/* Do all the hard work */
 	mod = load_module(umod, len, uargs);
-	if (IS_ERR(mod)) {
-		mutex_unlock(&module_mutex);
+	if (IS_ERR(mod))
 		return PTR_ERR(mod);
-	}
-
-	/* Drop lock so they can recurse */
-	mutex_unlock(&module_mutex);
 
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);



