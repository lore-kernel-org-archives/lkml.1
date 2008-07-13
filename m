Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYGMSyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYGMSyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYGMSxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:53:53 -0400
Received: from mail4.aster.pl ([212.76.33.58]:15108 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbYGMSxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:53:52 -0400
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Date: Sun, 13 Jul 2008 20:53:29 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@timesys.com
References: <200807130127.36706.jozwicki@aster.pl> <200807131517.51795.jozwicki@aster.pl> <487A3F75.5010405@goop.org>
In-Reply-To: <487A3F75.5010405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807132053.30849.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, 13 of July 2008 19:46:29 Jeremy Fitzhardinge napisał(a):
> Jakub W. Jozwicki wrote:
> > Sorry, this was for -rt only.
> >
> > [   17.012011] BUG: sleeping function called from invalid context
> > IRQ-14(5732) at arch/x86/mm/highmem_32.c:8
> > [   17.012011] in_atomic():0 [00000000], irqs_disabled():1
> > [   17.012011] Pid: 5732, comm: IRQ-14 Not tainted 2.6.25.10-rtXXX #11
> > [   17.012011]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> > [   17.012011]  [<c011c035>] kmap+0x47/0x5a
>
> The subject says kmap_atomic, but this is kmap.  It definitely makes no
> sense to call kmap in an IRQ, regardless of the locking.  There seems to
> be a larger structural problem here.
>

--- linux-2.6.25.8-rt7.orig/include/asm-x86/highmem.h   2008-06-23 
19:12:47.000000000 -0400
+++ linux-2.6.25.8-rt7/include/asm-x86/highmem.h        2008-06-23 
19:13:58.000000000 -0400


+/*
+ * on PREEMPT_RT kmap_atomic() is a wrapper that uses kmap():
+ */
+#ifdef CONFIG_PREEMPT_RT
+# define kmap_atomic_prot(page, type, prot)    ({ pagefault_disable(); 
kmap(page); })
+# define kmap_atomic(page, type)       ({ pagefault_disable(); kmap(page); })
+# define kmap_atomic_pfn(pfn, type)    kmap(pfn_to_page(pfn))
+# define kunmap_atomic(kvaddr, type)   do { pagefault_enable(); 
kunmap_virt(kvaddr); } while(0)
+# define kmap_atomic_to_page(kvaddr)   kmap_to_page(kvaddr)
+#else
+# define kmap_atomic_prot(page, type, prot)    __kmap_atomic_prot(page, type, 
prot)
+# define kmap_atomic(page, type)       __kmap_atomic(page, type)
+# define kmap_atomic_pfn(pfn, type)    __kmap_atomic_pfn(pfn, type)
+# define kunmap_atomic(kvaddr, type)   __kunmap_atomic(kvaddr, type)
+# define kmap_atomic_to_page(kvaddr)   __kmap_atomic_to_page(kvaddr)
+#endif
+
