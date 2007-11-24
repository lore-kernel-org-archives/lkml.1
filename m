Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXKXR0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXKXR0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXKXR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:26:33 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:58647 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbXKXR0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:26:32 -0500
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2007 12:26:31 EST
Date: Sat, 24 Nov 2007 17:51:12 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>
Subject: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071124175112.58193424@morte>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __STOCK_PHRASE_24 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the jiffies counter sometimes jumps back and forth of some
hundreds seconds in 2.6.24-rc3. I observed that this happens when I use the
su(1) command, e.g.:

Nov 24 06:17:17 morte [190769.065301] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 232 (6730/29)
Nov 24 06:17:22 morte su[16826]: Successful su for root by st3
Nov 24 06:17:22 morte su[16826]: + pts/1 st3:root
Nov 24 06:17:22 morte su(pam_unix)[16826]: session opened for user root by (uid=1000)
Nov 24 06:17:38 morte [715682.606983] b43-phy2 ERROR: PHY transmission error
Nov 24 06:18:17 morte [715707.765415] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 194 (970/5)

or

Nov 23 20:55:40 morte [627074.320296] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 10 (550/55)
Nov 23 20:56:01 morte su[5452]: Successful su for root by st3
Nov 23 20:56:01 morte su[5452]: + pts/4 st3:root
Nov 23 20:56:01 morte su(pam_unix)[5452]: session opened for user root by (uid=1000)
Nov 23 20:56:03 morte su(pam_unix)[5452]: session closed for user root
Nov 23 20:56:40 morte [167187.102931] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 10 (40/4)

or

Nov 23 06:31:00 morte [156536.124549] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 240 (6480/27)
Nov 23 06:31:58 morte su[4350]: Successful su for root by st3
Nov 23 06:31:58 morte su[4350]: + pts/0 st3:root
Nov 23 06:31:58 morte su(pam_unix)[4350]: session opened for user root by (uid=1000)
Nov 23 06:32:09 morte [587438.574530] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 240 (4080/17)

(I checked with a clock the timestamp prepended by syslog-ng, and it's
correct.)

I'm thinking this could be somehow related to the setpriority() call made
by su(1), but I don't know how to debug this further. Any clue?

morte st3 # cat /proc/interrupts
           CPU0
  0:  319167512    XT-PIC-XT        timer
  1:     459332    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          1    XT-PIC-XT
  4:          1    XT-PIC-XT
  5:          1    XT-PIC-XT
  7:          9    XT-PIC-XT
  8:          2    XT-PIC-XT        rtc
  9:       9114    XT-PIC-XT        acpi
 10:   46272099    XT-PIC-XT        uhci_hcd:usb1, i915@pci:0000:00:02.0
 11:   23691749    XT-PIC-XT        yenta, Intel 82801DB-ICH4, uhci_hcd:usb2, uhci_hcd:usb3, ehci_hcd:usb4, Intel 82801DB-ICH4 Modem, ohci1394, b43
 12:    3287633    XT-PIC-XT        i8042
 14:    1076167    XT-PIC-XT        ide0
 15:         47    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          8
MIS:          0

morte st3 # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.50GHz
stepping        : 6
cpu MHz         : 1500.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips        : 2993.47
clflush size    : 64


-- 
Ciao
Stefano
