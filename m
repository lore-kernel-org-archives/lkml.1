Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbZIPWoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbZIPWoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933596AbZIPWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:44:22 -0400
Received: from kroah.org ([198.145.64.141]:55383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239AbZIPWkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:18 2009
Message-Id: <20090916223718.433647359@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 35/45] KVM guest: fix bogus wallclock physical address calculation
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-guest-fix-bogus-wallclock-physical-address-calculation.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Glauber Costa <glommer@redhat.com>

commit a20316d2aa41a8f4fd171648bad8f044f6060826 upstream.

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


