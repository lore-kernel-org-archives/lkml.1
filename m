Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYDRD6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYDRD6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYDRD6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:58:11 -0400
Received: from ozlabs.org ([203.10.76.45]:53688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYDRD6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:58:10 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <20080413191338.9776ebd0.akpm@linux-foundation.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	 <20080413171953.bde5e9ac.akpm@linux-foundation.org>
	 <1208133506.6958.82.camel@pasglop>
	 <20080413191338.9776ebd0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 13:58:06 +1000
Message-Id: <1208491086.6958.381.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > otoh, if only one .c file will ever call this function then I think that
> > > all problems are solved by
> > > 
> > > a) moving the above ifdeffery into the .c file
> > > b) adding a comment explaining which arch file must provide the override
> > > c) directly including that file from within the .c file.
> > 
> > I can definitely do that. I have no problem either way. I can add to all
> > archs too, it's just that whatever way I choose, some people won't be
> > happy with it :-)
> > 
> > Anyway, I'll move the ifdeferry to init/main.c then.
> 
> Thanks ;)
> 
> I'm still wounded by my recent encounter with set_softirq_pending()
> and or_softirq_pending().

Well, looking there, I saw we already used weak symbols for that so what
about the patch below ? If you're ok, I'll re-send with appropriate sob
& adapted powerpc part.

Cheers,
Ben.

Index: linux-work/init/main.c
===================================================================
--- linux-work.orig/init/main.c	2008-03-26 10:39:25.000000000 +1100
+++ linux-work/init/main.c	2008-04-18 13:10:35.000000000 +1000
@@ -504,6 +504,10 @@ void __init __attribute__((weak)) smp_se
 {
 }
 
+void __init __attribute__((weak) thread_info_cache_init(void)
+{
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -623,6 +627,7 @@ asmlinkage void __init start_kernel(void
 	if (efi_enabled)
 		efi_enter_virtual_mode();
 #endif
+	thread_info_cache_init();
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
Index: linux-work/include/linux/sched.h
===================================================================
--- linux-work.orig/include/linux/sched.h	2008-04-02 09:47:56.000000000 +1100
+++ linux-work/include/linux/sched.h	2008-04-18 13:11:10.000000000 +1000
@@ -1893,6 +1893,8 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+extern void thread_info_cache_init(void);
+
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
  */


