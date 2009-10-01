Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZJAXjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZJAXjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZJAXiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:22 -0400
Received: from kroah.org ([198.145.64.141]:42041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZJAXiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233320.826090384@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, avi@redhat.com
Subject: [patch 14/30] KVM guest: fix bogus wallclock physical address calculation
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-guest-fix-bogus-wallclock-physical-address-calculation.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Glauber Costa <glommer@redhat.com>

(cherry picked from commit a20316d2aa41a8f4fd171648bad8f044f6060826)

The use of __pa() to calculate the address of a C-visible symbol
is wrong, and can lead to unpredictable results. See arch/x86/include/asm/page.h
for details.

It should be replaced with __pa_symbol(), that does the correct math here,
by taking relocations into account.  This ensures the correct wallclock data
structure physical address is passed to the hypervisor.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/kvmclock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -50,8 +50,8 @@ static unsigned long kvm_get_wallclock(v
 	struct timespec ts;
 	int low, high;
 
-	low = (int)__pa(&wall_clock);
-	high = ((u64)__pa(&wall_clock) >> 32);
+	low = (int)__pa_symbol(&wall_clock);
+	high = ((u64)__pa_symbol(&wall_clock) >> 32);
 	native_write_msr(MSR_KVM_WALL_CLOCK, low, high);
 
 	vcpu_time = &get_cpu_var(hv_clock);


