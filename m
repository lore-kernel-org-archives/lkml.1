Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZBRVif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZBRVif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZBRVff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:35 -0500
Received: from kroah.org ([198.145.64.141]:56129 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754243AbZBRVfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:34 -0500
Date: Wed, 18 Feb 2009 13:32:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 08/39] x86/cpa: make sure cpa is safe to call in lazy mmu
	mode
Message-ID: <20090218213228.GI19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-cpa-make-sure-cpa-is-safe-to-call-in-lazy-mmu-mode.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.

Impact: fix race leading to crash under KVM and Xen

The CPA code may be called while we're in lazy mmu update mode - for
example, when using DEBUG_PAGE_ALLOC and doing a slab allocation
in an interrupt handler which interrupted a lazy mmu update.  In this
case, the in-memory pagetable state may be out of date due to pending
queued updates.  We need to flush any pending updates before inspecting
the page table.  Similarly, we must explicitly flush any modifications
CPA may have made (which comes down to flushing queued operations when
flushing the TLB).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -576,6 +576,13 @@ static int __change_page_attr(struct cpa
 	else
 		address = *cpa->vaddr;
 
+	/*
+	 * If we're called with lazy mmu updates enabled, the
+	 * in-memory pte state may be stale.  Flush pending updates to
+	 * bring them up to date.
+	 */
+	arch_flush_lazy_mmu_mode();
+
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -854,6 +861,13 @@ static int change_page_attr_set_clr(unsi
 	} else
 		cpa_flush_all(cache);
 
+	/*
+	 * If we've been called with lazy mmu updates enabled, then
+	 * make sure that everything gets flushed out before we
+	 * return.
+	 */
+	arch_flush_lazy_mmu_mode();
+
 out:
 	return ret;
 }

