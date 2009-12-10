Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbZLJQ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbZLJQ4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbZLJQ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:56:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42904 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbZLJQ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AlsTBA5OnIPEFUTLL0AAh3SX9SU26T77vp4oRbRuHuaGXcr0HqVJ5hLQtsfmfTGYF/
         LfL+HNJjJPKNCmJ1OgxBTqpAngIdhQ2jaO03xzxiePeywbdZdYImJyXhQh28S40H6X4O
         BryvZUnj7+JEs9VXwo73etwr4ZnDQfbwKm8L8=
Date: Thu, 10 Dec 2009 19:56:34 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       linux-kernel@vger.kernel.org, x86team <x86@kernel.org>
Subject: Re: [2.6.32] WARNING: at arch/x86/kernel/apic/apic.c:249
	native_apic_write_dummy+0x30/0x3c()
Message-ID: <20091210165634.GF5086@lenovo>
References: <20091210154837.GT30903@charite.de> <20091210161335.GC5086@lenovo> <20091210163055.GD5086@lenovo> <20091210163745.GA32563@elte.hu> <20091210164904.GE5086@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210164904.GE5086@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 07:49:04PM +0300, Cyrill Gorcunov wrote:
...
> 
> OK, will update and resend. Thanks for comments!
> 
> 	-- Cyrill

Here is it, please review.

	-- Cyrill
---
x86,pmu: check if we have APIC enabled

Ralf Hildebrandt reported:

|
| Running a vanilla 2.6.32 as Xen DomU, I'm getting:
|
| [    0.000999] CPU: Physical Processor ID: 0
| [    0.000999] CPU: Processor Core ID: 1
| [    0.000999] Performance Events: AMD PMU driver.
| [    0.000999] ------------[ cut here ]------------
| [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x30/0x3c()
| [    0.000999] Modules linked in:
| [    0.000999] Pid: 0, comm: swapper Not tainted 2.6.32 #3
| [    0.000999] Call Trace:
| [    0.000999]  [<ffffffff8102611a>] ? native_apic_write_dummy+0x30/0x3c
| [    0.000999]  [<ffffffff8104c5a2>] warn_slowpath_common+0x77/0x8f
| [    0.000999]  [<ffffffff8104c5c9>] warn_slowpath_null+0xf/0x11
| [    0.000999]  [<ffffffff8102611a>] native_apic_write_dummy+0x30/0x3c
| [    0.000999]  [<ffffffff8101bf49>] perf_events_lapic_init+0x2e/0x30
| [    0.000999]  [<ffffffff818cc6fe>] init_hw_perf_events+0x300/0x39d
| [    0.000999]  [<ffffffff818cc25a>] identify_boot_cpu+0x3c/0x3e
| [    0.000999]  [<ffffffff818cc3da>] check_bugs+0x9/0x2d
| [    0.000999]  [<ffffffff818c4cae>] start_kernel+0x37a/0x38f
| [    0.000999]  [<ffffffff818c42c1>] x86_64_start_reservations+0xac/0xb0
| [    0.000999]  [<ffffffff818c7b79>] xen_start_kernel+0x530/0x534
| [    0.000999] ---[ end trace 4eaa2a86a8e2da22 ]---
|

So we need to check if APIC has a proper state (ie enabled).

Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -2062,12 +2062,6 @@ static __init int p6_pmu_init(void)
 
 	x86_pmu = p6_pmu;
 
-	if (!cpu_has_apic) {
-		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
-		pr_info("no hardware sampling interrupt available.\n");
-		x86_pmu.apic = 0;
-	}
-
 	return 0;
 }
 
@@ -2159,6 +2153,16 @@ static __init int amd_pmu_init(void)
 	return 0;
 }
 
+static void __init pmu_check_apic(void)
+{
+	if (cpu_has_apic)
+		return;
+
+	x86_pmu.apic = 0;
+	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
+	pr_info("no hardware sampling interrupt available.\n");
+}
+
 void __init init_hw_perf_events(void)
 {
 	int err;
@@ -2180,6 +2184,8 @@ void __init init_hw_perf_events(void)
 		return;
 	}
 
+	pmu_check_apic();
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
