Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZJCCNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZJCCNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZJCCNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:13:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61867 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZJCCNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=jv2vy1gk6IEW39Sk/liuoQWoww9WtWVcjXYh84feBaczWAaln1w7YahzFe+ys5tges
         vRF7MhkIXDCSpY1KktoOYVGmju2+aYUtkqH9NBifM26cRxWcbptjLOk1eWzOMRAZ2iJy
         XKmXtgP1tKkysdRghVjydJ231ru9uQnYslYXk=
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 3 Oct 2009 04:12:47 +0200
Message-ID: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
Subject: i686 quirk for AMD Geode
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i686:

root@alix:/usr/src# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 5
model           : 10
model name      : Geode(TM) Integrated Processor by AMD PCS
stepping        : 2
cpu MHz         : 498.060
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
mmxext 3dnowext 3dnow
bogomips        : 996.12
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:

indeed it has mmx, mmxext and cmov.
So I added the quirk below and I can confirm that the system is running fine.
I did an x264 encode to trigger any SIGILL due to missing opcodes, but
it worked.

I also did this simple test which gives a ~2.5x speed boost:
http://pastebin.ca/1590089

I wish some feedback from someone, I really dunno why AMD set the
cpuid value to 5

--- a/arch/x86/kernel/cpu/bugs.c	2009-10-03 03:43:02.399323313 +0200
+++ b/arch/x86/kernel/cpu/bugs.c	2009-10-03 03:54:22.582205090 +0200
@@ -151,6 +151,12 @@
 #endif
 }

+static void __init check_geode_i586(void)
+{
+	if(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	   boot_cpu_data.x86_model == 10 && boot_cpu_data.x86 == 5)
+		boot_cpu_data.x86 = 6;
+}

 void __init check_bugs(void)
 {
@@ -163,6 +169,7 @@
 	check_fpu();
 	check_hlt();
 	check_popad();
+	check_geode_i586();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
