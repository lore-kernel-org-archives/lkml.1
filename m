Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbYHRTBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbYHRTBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761857AbYHRS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:58:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbYHRS65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:58:57 -0400
Date: Mon, 18 Aug 2008 11:44:41 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Julia Lawall <julia@diku.dk>, Avi Kivity <avi@qumranet.com>
Subject: [patch 35/60] KVM: ia64: Fix irq disabling leak in error handling
	code
Message-ID: <20080818184441.GJ29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-ia64-fix-irq-disabling-leak-in-error-handling-code.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

(cherry picked from commit cab7a1eeeb007be309cd99cf14407261a72d2418)

There is a call to local_irq_restore in the normal exit case, so it would
seem that there should be one on an error return as well.

The semantic patch that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
expression E,E1,E2;
@@

local_irq_save(l);
... when != local_irq_restore(l)
    when != spin_unlock_irqrestore(E,l)
    when any
    when strict
(
if (...) { ... when != local_irq_restore(l)
               when != spin_unlock_irqrestore(E1,l)
+   local_irq_restore(l);
    return ...;
}
|
if (...)
+   {local_irq_restore(l);
    return ...;
+   }
|
spin_unlock_irqrestore(E2,l);
|
local_irq_restore(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kvm/kvm-ia64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -125,9 +125,9 @@ void kvm_arch_hardware_enable(void *garb
 				PAGE_KERNEL));
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
+	local_irq_restore(saved_psr);
 	if (slot < 0)
 		return;
-	local_irq_restore(saved_psr);
 
 	spin_lock(&vp_lock);
 	status = ia64_pal_vp_init_env(kvm_vsa_base ?
@@ -160,9 +160,9 @@ void kvm_arch_hardware_disable(void *gar
 
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
+	local_irq_restore(saved_psr);
 	if (slot < 0)
 		return;
-	local_irq_restore(saved_psr);
 
 	status = ia64_pal_vp_exit_env(host_iva);
 	if (status)
@@ -1258,6 +1258,7 @@ static int vti_vcpu_setup(struct kvm_vcp
 uninit:
 	kvm_vcpu_uninit(vcpu);
 fail:
+	local_irq_restore(psr);
 	return r;
 }
 

-- 
