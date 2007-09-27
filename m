Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXI0QNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXI0QNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXI0QNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:13:31 -0400
Received: from bender.weihenstephan.org ([62.245.246.226]:51735 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbXI0QNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:13:30 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 18:13:25 +0200
User-Agent: KMail/1.9.4
Cc: "Marco Tralli" <marco.tralli@snapon.com>,
       "Jordan Crouse" <jordan.crouse@amd.com>
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
In-Reply-To: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271813.26103.juergen127@kreuzholzen.de>
X-CTCH-RefID: str=0001.0A0B0203.46FBD6A7.0027,ss=1,fgs=0
X-cff-SpamScore: 0(/)
X-cff-SpamReport: ----- ----- Message is unknown to the spam scanner.
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi AMrco,

On Thursday 27 September 2007 16:44, Marco Tralli wrote:
> I have random hangs on kernel boot or after few minutes on a NatSemi Geode
> GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system
> locks, no way to use SysRq key, no usefull logs.
>
> No problems using kernel 2.6.21 series that I was using before with same
> config options.
>
> I found that commenting out "geode_configure" call in
> arch/i386/kernel/cpu/cyrix.c the problem is fixed.
>
> I guess recent changes to cyrix.c that replace macros setCx86/getCx86 with
> inlined functions have now "activate" performance tricks in geode_configure
> code that previously were "inactive" due to wrong macro espansion. So not
> only "Suspend on Halt" function is enabled but also less or not documented
> geode tricks (incrementor margin, fast fpu, write-back) now broken on some
> GX1/GXm platform (maybe because of BIOS?)

Seems so.

> I can further investigate on what exact geode_configure part cause my
> hangs, but I suggest to make a config options to explicity enable Geode
> performance tricks only if requested (maybe using CONFIG_MGEODEGX1) .

That's my system:

root@morgan:~ uname -a
Linux morgan 2.6.22.8-cfs-v22-Igel316 #1 PREEMPT Wed Sep 26 15:09:46 CEST 2007 i586 unknown

root@morgan:~ cat /proc/cpuinfo
processor       : 0
vendor_id       : Geode by NSC
cpu family      : 5
model           : 9
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 2
cache size      : 16 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu msr cx8 cmov mmx cxmmx
bogomips        : 99.94
clflush size    : 32

It runs stable on 5 different GX1 systems.

But I do not use a standard BIOS. I'm using LinuxBIOS instead. But I'm also using
these patches.

For documentation only:

Index: linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
@@ -139,6 +139,23 @@ static void __cpuinit set_cx86_memwb(voi
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14 );
 }
 
+/*
+ * Setup the chipset specific Performance Control Incrementer
+ *
+ * The Performance Control Incrementer seems to be a delay line to control data
+ * setup time for DRAM access or it controls jitter. Its setting depends on CPU
+ * and DRAM clock (CPU and DRAM clock are coupled through a simple clock
+ * divider. For a 300 MHz CPU the divider is 3.0 to get a DRAM clock of 100MHz)
+ * There is an application note how to setup it:
+ *  "AMD Geode GX1 Processor Memory Timings for Maximum Performance."
+ * Values for various CPUs:
+ * 1-0 for processor speed 200...266MHz
+ * 1-1 for processor speed 300 and 333MHz
+ *
+ * Note: If your system runs unstable after setting new values here,
+ * try with other values or leave the value as the BIOS setup it.
+ * The setting depends also on physical layout!
+ */
 static void __cpuinit set_cx86_inc(void)
 {
 	unsigned char ccr3;


And here I'm using an incrementer value for my 300MHz CPU:

Index: linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
@@ -169,7 +169,7 @@ static void __cpuinit set_cx86_inc(void)
 	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
 	/* PCR0 -- Performance Control */
 	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
+	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x05);	/* 300MHz CPU */
 	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
 }
 
This should be done at runtime in relation to the real CPU clock.

Hope it helps
Juergen

