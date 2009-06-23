Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFWDlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFWDlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFWDlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:41:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34134 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZFWDlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:41:00 -0400
Message-ID: <4A404EC6.8080902@jp.fujitsu.com>
Date: Tue, 23 Jun 2009 12:40:54 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com>	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com>	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>	 <4A3F55C7.4030909@linux.intel.com>	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>	 <4A3F7A93.5080004@linux.intel.com>	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>	 <4A3F8BF7.6010406@linux.intel.com> <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
In-Reply-To: <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/6/22 Andi Kleen <ak@linux.intel.com>:
> 
>> Here's a debug patch for the poller: http://firstfloor.org/ak/mcp-debug
>> Can you apply that and try again and send me the output?
>>
> 
> Dmesg after resume:
> http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/dmesg-2.6.30-git17-patch.txt
> 
> System hangs when uptime is roughly 5-6 minutes (when I don't change
> check_interval). netconsole doesn't show anything.
> 

I found in the dmesg that mce_init() and mce_cpu_features() are called
on cpu0 twice in short time:

[   82.989005] mcp on cpu 0 flags 2 banks ecc39e70
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:502
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:506
[   82.989005] bank 0
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 1
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 2
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 3
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 4
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 5
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] mcp on cpu 0 finished
[   82.989005] CPU0: Thermal LVT vector (0xfa) already installed
[   82.989005] PM: Restoring platform NVS memory
[   82.989005] mcp on cpu 0 flags 2 banks ecc39e70
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:502
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:506
[   82.989005] bank 0
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 1
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 2
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 3
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 4
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] bank 5
[   82.989005] [0] arch/x86/kernel/cpu/mcheck/mce.c:518
[   82.989005] mcp on cpu 0 finished
[   82.989005] CPU0: Thermal LVT vector (0xfa) already installed

mce_cpu_features() (which prints "Thermal ...") is always paired with
mce_init(), and is called only from mcheck_init() and mce_resume().

One of the above would be from mce_resume(), and if another was from
mcheck_init(), then setup_timer() in mce_init_timer() will break the
pending timer...

[arch/x86/power/cpu.c]
> static void __restore_processor_state(struct saved_context *ctxt)
> {
>  :
> #ifdef CONFIG_X86_32
>         mcheck_init(&boot_cpu_data);
> #endif
> }

Hum?

Maciej, could you try this patch? 

Thanks,
H.Seto

===
[PATCH] x86: Fix mce resume on 32bit

Calling mcheck_init() on resume is required only with CONFIG_X86_OLD_MCE=y.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/power/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index d277ef1..b3d20b9 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -244,7 +244,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	do_fpu_end();
 	mtrr_ap_init();
 
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_OLD_MCE
 	mcheck_init(&boot_cpu_data);
 #endif
 }
-- 
1.6.3

