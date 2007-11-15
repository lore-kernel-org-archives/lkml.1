Return-Path: <linux-kernel-owner+w=401wt.eu-S1764651AbXKOGVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764651AbXKOGVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762671AbXKOGQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762658AbXKOGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:39 -0500
Date: Wed, 14 Nov 2007 22:15:03 -0800
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
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten B?geskov <xen-users@morten.bogeskov.dk>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Keir Fraser <keir@xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [patch 13/19] xen: fix incorrect vcpu_register_vcpu_info hypercall
	argument
Message-ID: <20071115061503.GN7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-fix-register_vcpu_info.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

patch e3d2697669abbe26c08dc9b95e2a71c634d096ed in mainline.

The kernel's copy of struct vcpu_register_vcpu_info was out of date,
at best causing the hypercall to fail and the guest kernel to fall
back to the old mechanism, or worse, causing random memory corruption.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stable Kernel <stable@kernel.org>
Cc: Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>
Cc: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/xen/enlighten.c    |    2 +-
 include/xen/interface/vcpu.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -116,7 +116,7 @@ static void __init xen_vcpu_setup(int cp
 	info.mfn = virt_to_mfn(vcpup);
 	info.offset = offset_in_page(vcpup);
 
-	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %x, offset %d\n",
+	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %llx, offset %d\n",
 	       cpu, vcpup, info.mfn, info.offset);
 
 	/* Check to see if the hypervisor will put the vcpu_info
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -160,8 +160,9 @@ struct vcpu_set_singleshot_timer {
  */
 #define VCPUOP_register_vcpu_info   10  /* arg == struct vcpu_info */
 struct vcpu_register_vcpu_info {
-    uint32_t mfn;               /* mfn of page to place vcpu_info */
-    uint32_t offset;            /* offset within page */
+    uint64_t mfn;    /* mfn of page to place vcpu_info */
+    uint32_t offset; /* offset within page */
+    uint32_t rsvd;   /* unused */
 };
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */

-- 
