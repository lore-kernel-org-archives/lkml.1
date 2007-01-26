Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXAZJZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXAZJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965602AbXAZJZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:25:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965579AbXAZJZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:25:54 -0500
Date: Fri, 26 Jan 2007 01:25:05 -0800
From: Andrew Morton <akpm@osdl.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba ->
 RAID5)
Message-Id: <20070126012505.d8cb07f2.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701241836590.2930@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	<45B5261B.1050104@redhat.com>
	<Pine.LNX.4.64.0701241836590.2930@p34.internal.lan>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 18:37:15 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> > Without digging too deeply, I'd say you've hit the same bug Sami Farin and
> > others
> > have reported starting with 2.6.19: pages mapped with kmap_atomic() become
> > unmapped
> > during memcpy() or similar operations.  Try disabling preempt -- that seems to
> > be the
> > common factor.
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> After I run some other tests, I am going to re-run this test and see if it 
> OOPSes again with PREEMPT off.

Strange.  The below debug patch might catch it - please run with this
applied.  


--- a/arch/i386/mm/highmem.c~kmap_atomic-debugging
+++ a/arch/i386/mm/highmem.c
@@ -30,7 +30,43 @@ void *kmap_atomic(struct page *page, enu
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
+	static unsigned warn_count = 10;
 
+	if (unlikely(warn_count == 0))
+		goto skip;
+
+	if (unlikely(in_interrupt())) {
+		if (in_irq()) {
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (!irqs_disabled()) {	/* softirq */
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
+			    type != KM_SKB_SUNRPC_DATA &&
+			    type != KM_SKB_DATA_SOFTIRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		}
+	}
+
+	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ) {
+		if (!irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
+		if (irq_count() == 0 && !irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	}
+skip:
 	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
 	pagefault_disable();
 	if (!PageHighMem(page))
_

