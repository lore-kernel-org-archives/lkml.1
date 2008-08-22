Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYHVNe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYHVNe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYHVNer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:34:47 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56615 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYHVNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:34:45 -0400
X-Greylist: delayed 1208 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 09:34:44 EDT
From: Nicos Gollan <gtdev@spearhead.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.10] pm_qos_params: change spinlock to rwlock
Date: Fri, 22 Aug 2008 15:14:30 +0200
User-Agent: KMail/1.9.9
References: <200807130119.19663.jozwicki@aster.pl> <20080713012816.8c136efa.akpm@linux-foundation.org> <200807131505.25990.jozwicki@aster.pl>
In-Reply-To: <200807131505.25990.jozwicki@aster.pl>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5045
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200808221514.30675.gtdev@spearhead.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I stumbled across mysterious system freezes in kernels from 2.6.23. After some 
digging around, I ended up with http://kerneltrap.org/node/16521 (I'll 
reproduce it in this mail for completeness). The stacktrace I get from the 
NMI watchdog looks like it might actually be related to the issue the patch 
was originally aimed at.

--- Copied text from kerneltrap.org ---

I have a fun little issue with a few kernels. A lot of releases, if not all, 
after 2.6.22 tend to randomly freeze after a few minutes. One system this 
happens on is a Lenovo Thinkpad Z61m (model 9453-A11), another one is a Dell 
Precision. The laptop has a Core Duo CPU, the desktop a C2D. Both use Intel 
ICH7 chipsets.

The freezes result in a complete lockup of the system. No output is generated 
on the console, in syslog, or in messages.

    * Magic SysRq is inoperable.
    * I tried a lot of options in kernel hacking, including lock debugging. 
That only sped up the time to freeze. The NMI watchdog produces output.
    * I built a minimal kernel with all but the essential drivers disabled, so 
I rule out issues with sound, network, PCCard, DRI/DRM, and others.
    * It happens with a stock Debian kernel (2.6.25, built for 486 arch) as 
well as with custom-built kernels.
    * I tried building with both GCC 4.3 and 4.2.
    * The systems run perfectly fine with older kernels (2.6.21, 2.6.22 
series), as well as Windows. memtest86+ doesn't find any issues.
    * "noacpi" is not an option since the laptop won't even boot with that. I 
tried disabling stuff like MSI(-X), IRQ balancing, tick-free kernel, all to 
no avail.
    * 2.6.26.2 runs fine on a non-SMP AMD system. Both affected systems are 
dual-core. Setting the "nosmp" option doesn't help.

--- End copied text ---

Now for the thing that makes me hope for a patch:

On Sunday 13 July 2008 15:05:25 Jakub W. Jozwicki wrote:
> [  114.647010] BUG: sleeping function called from invalid context
> swapper(0) at kernel/rtmutex.c:742
> [  114.647010] in_atomic():1 [00000001], irqs_disabled():0
> [  114.647010] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
> [  114.647010]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> [  114.647010]  [<c045499c>] __rt_spin_lock+0x24/0x61
> [  114.647010]  [<c04549e1>] rt_spin_lock+0x8/0xa
> [  114.647010]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
> [  114.647010]  [<c038ef36>] menu_select+0x5d/0x7f
> [  114.647010]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
> [  114.647010]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
> [  114.647010]  [<c01060ff>] cpu_idle+0xaf/0x106
> [  114.647010]  [<c0441c87>] rest_init+0x67/0x69
> [  114.647010]  =======================

The output from the watchdog handler (from a 2.6.26.2 stock kernel) reads 
similar:

Pid: 0, comm: swapper Not tainted (2.6.26.2-debug #2)
EIP: 0060:[<c0117210>] EFLAGS: 00000097 CPU: 0
EIP is at hpet_rtc_interrupt+0x2e0/0x320
EAX: 00000000 EBX: 00000002 ECX: 00000046 EDX: 00000002
ESI: ffffc8ab EDI: c03f1edc EBP: c03f1ee8 ESP: c03f1e9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03f0000 task=c03c9300 task.ti=c03f0000)
Stack: 03aa5b2e 00000000 f7bc7c00 f8800128 00000000 a61408d3 0061fd6e 00000000
       00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
       f7b87f80 00000000 00000000 c03f1f00 c0159d81 00000000 c03e7080 f7b87f80
Call Trace:
 [<c0159d81>] ? handle_IRQ_event+0x31/0x60
 [<c015af65>] ? handle_edge_irq+0xb5/0x150
 [<c0106c50>] ? do_IRQ+0x40/0x80
 [<c0104783>] ? common_iterrupt+0x23/0x28
 [<c013007b>] ? del_timer_sync+0x1b/0x20
 [<f8858058>] ? acpi_idle_enter_bm+0x2c2/0x344 [processor]
 [<c013f6c6>] ? pm_qos_requirement+0x26/0x30
 [<c0298891>] ? cpuidle_idle_call+0x81/0xc0
 [<c0298810>] ? cpuidle_idle_call+0x0/0xc0
 [<c0102c82>] ? cpu_idle+0x62/0xe0
 [<c0319f6e>] ? rest_init+0x4e/0x60
 =======================
Code: 80 8d 04 46 89 45 d8 89 f8 83 e7 0f c1 f8 04 8d 04 80 8d 04 47 89 45 dc 
8b 45 cc 48 89 45 e0 e9 70 fd ff ff 8d b4 26 00 00 00 00 <f3> 90 a1 80 6b 3e 
c0 29 f0 83 f8 04 76 f2 e9 d2 fe ff ff 90 8d

Regards,
  Nicos Gollan
(not subscribed to the list)
