Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0BSRMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:12:01 -0500
Received: from kroah.org ([198.145.64.141]:57577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0BSRAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:39 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:42 2010
Message-Id: <20100219163242.455463839@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Wang <jasowang@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [42/93] kvmclock: count total_sleep_time when updating guest clock
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 923de3cf5bf12049628019010e36623fca5ef6d1 upstream.

Current kvm wallclock does not consider the total_sleep_time which could cause
wrong wallclock in guest after host suspend/resume. This patch solve
this issue by counting total_sleep_time to get the correct host boot time.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -583,7 +583,7 @@ static void kvm_write_wall_clock(struct
 {
 	static int version;
 	struct pvclock_wall_clock wc;
-	struct timespec now, sys, boot;
+	struct timespec boot;
 
 	if (!wall_clock)
 		return;
@@ -598,9 +598,7 @@ static void kvm_write_wall_clock(struct
 	 * wall clock specified here.  guest system time equals host
 	 * system time for us, thus we must fill in host boot time here.
 	 */
-	now = current_kernel_time();
-	ktime_get_ts(&sys);
-	boot = ns_to_timespec(timespec_to_ns(&now) - timespec_to_ns(&sys));
+	getboottime(&boot);
 
 	wc.sec = boot.tv_sec;
 	wc.nsec = boot.tv_nsec;
@@ -675,6 +673,7 @@ static void kvm_write_guest_time(struct
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
 	ktime_get_ts(&ts);
+	monotonic_to_bootbased(&ts);
 	local_irq_restore(flags);
 
 	/* With all the info we got, fill in the values */


