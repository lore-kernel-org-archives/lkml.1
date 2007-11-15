Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbXKOGUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbXKOGUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXKOGQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51077 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762625AbXKOGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:37 -0500
Date: Wed, 14 Nov 2007 22:14:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Keir Fraser <keir@xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [patch 11/19] xen: add batch completion callbacks
Message-ID: <20071115061457.GL7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-multicall-callbacks.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

patch 91e0c5f3dad47838cb2ecc1865ce789a0b7182b1 in mainline.

This adds a mechanism to register a callback function to be called once
a batch of hypercalls has been issued.  This is typically used to unlock
things which must remain locked until the hypercall has taken place.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/xen/multicalls.c |   29 ++++++++++++++++++++++++++---
 arch/i386/xen/multicalls.h |    3 +++
 2 files changed, 29 insertions(+), 3 deletions(-)

--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -32,7 +32,11 @@
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
 	u64 args[MC_ARGS];
-	unsigned mcidx, argidx;
+	struct callback {
+		void (*fn)(void *);
+		void *data;
+	} callbacks[MC_BATCH];
+	unsigned mcidx, argidx, cbidx;
 };
 
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
@@ -43,6 +47,7 @@ void xen_mc_flush(void)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	int ret = 0;
 	unsigned long flags;
+	int i;
 
 	BUG_ON(preemptible());
 
@@ -51,8 +56,6 @@ void xen_mc_flush(void)
 	local_irq_save(flags);
 
 	if (b->mcidx) {
-		int i;
-
 		if (HYPERVISOR_multicall(b->entries, b->mcidx) != 0)
 			BUG();
 		for (i = 0; i < b->mcidx; i++)
@@ -65,6 +68,13 @@ void xen_mc_flush(void)
 
 	local_irq_restore(flags);
 
+	for(i = 0; i < b->cbidx; i++) {
+		struct callback *cb = &b->callbacks[i];
+
+		(*cb->fn)(cb->data);
+	}
+	b->cbidx = 0;
+
 	BUG_ON(ret);
 }
 
@@ -88,3 +98,16 @@ struct multicall_space __xen_mc_entry(si
 
 	return ret;
 }
+
+void xen_mc_callback(void (*fn)(void *), void *data)
+{
+	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct callback *cb;
+
+	if (b->cbidx == MC_BATCH)
+		xen_mc_flush();
+
+	cb = &b->callbacks[b->cbidx++];
+	cb->fn = fn;
+	cb->data = data;
+}
--- a/arch/i386/xen/multicalls.h
+++ b/arch/i386/xen/multicalls.h
@@ -42,4 +42,7 @@ static inline void xen_mc_issue(unsigned
 	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
 }
 
+/* Set up a callback to be called when the current batch is flushed */
+void xen_mc_callback(void (*fn)(void *), void *data);
+
 #endif /* _XEN_MULTICALLS_H */

-- 
