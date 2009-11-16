Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZKPX7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZKPX7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZKPX7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:59:10 -0500
Received: from web53403.mail.re2.yahoo.com ([206.190.37.50]:22209 "HELO
	web53403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754474AbZKPX7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:59:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=az4zJLTPLFo3r00lTryFygQpbQxyOJhJ/e9O4FdKtbmoORqJtk3Dw1JJVldCiygMpRWvjlm1hX3TFjhPUlfBFJaapOUYHwculycceGCZ6/d7UbdS0QrQ3HQpGRnEClt5CVqe686x0/x2Cht7pHsaxxrwsMZZ7GXbmVCS+xbBpgg=;
Message-ID: <768725.48321.qm@web53403.mail.re2.yahoo.com>
X-YMail-OSG: y3iBecYVM1lHWX5vpDiwrJyYeRFzhTDPj_EAQtMZ3xj8N5SuzaSZ0fpoXqz7Jafsp0xBIyl6xTZGI6GxtOEwgzgLCvHac7W6odKMK1Zk1tHzq31hvKHZpjTLqQqEC4asFq13VWB6XRNeyJXzNLEs3y5wRJY7ShIrw05gZuSzJpKSghRoZRBdSMa7IKJh_kiy.h44ANqSM8W7WKED3VtKoffvVFga2h4L0poZVnQUEIrkXbY7YTJZWIcIJyfQksjjfTiTIsVTp7uPzjLSZ1ISTcwiYFfJrWGHzldBdlwKHiQ6gbWBGlb6pnAEcHUqLXngywSyHHWkxoA9eKc5PT02JSnr5Hhg7WxFSMi0.pbFjVa0SIFCI_GaQm7wOB37bGdp3qONq3iSGQ1xeg--
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
Date: Mon, 16 Nov 2009 15:59:15 -0800 (PST)
From: Lee Merrill <lee_merrill@yahoo.com>
Subject: Jiffies jumping with the x86 HPET
To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing jiffies go forward occasionally, by 300 seconds, this it appears is due to the following code in the 2.6.16 kernel:

mark_offset_tsc_hpet(void):
...
1       hpet_current = hpet_readl(HPET_COUNTER);
2       rdtsc(last_tsc_low, last_tsc_high);
3
4       /* lost tick compensation */
5       offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
6       if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
7                                       && detect_lost_ticks) {
8               int lost_ticks = (offset - hpet_last) / hpet_tick;
9               jiffies_64 += lost_ticks;
10      }
11      hpet_last = hpet_current;

where "offset - hpet_last" is an
unsigned -9, thus the test passes, and jiffies is incremented by a
large and invalid amount (by a bit less than 300 seconds). Now the
HPET_T0_CMP register being the timer comparison register, when the HPET's counter
reaches that value, the comparison register is incremented by
hpet_tick, and an interrupt is generated.

So let's say hpet_tick is 100, thus the
timer interrupts at every 100 HPET ticks, and let's say that just
before line 1, we get delayed, so that another timer interrupt becomes
pending.Then we read the counter (say, 809) and HPET_T0_CMP (900), and
store the counter value of 809 in "hpet_last". Then we get our pending
timer interrupt, and HPET_T0_CMPis still 900, so "offset" is 900 - 100
or 800, and "offset - hpet_last" would be unsigned -9, and jiffies gets
a large increment.

Here also are the actual values for a failure, annotating the disassembled code (whether or not the above scenario is correct).

0xfcd64600:     0x000124ef      0x0000dfb9      0x00000000      0xdff19ea8
                EAX             ECX             EDX             EBX

0xfcd64610:     0xdff19e3c      0x7a120471      0x00000000      0x00000000
                ESP             EBP             ESI             EDI

0xfcd64620:     0xc010d529      0x00000006      0x00000060      0x00000068
                EIP             PS              CS              SS

0xfcd64630:     0x0000007b      0x0000007b      0x00000000      0x00000000
                DS              ES              FS              GS

0xfcd64640:     0xc034cc00      0x00000000      0x00000000      0x00000000
0xfcd64650:     0xffff0ff1      0x000d0703      0xffff0ff1      0x000d0703

                // hpet_current = hpet_readl(HPET_COUNTER);
                // rdtsc(last_tsc_low, last_tsc_high);
c010d4e0:       0f 31                   rdtsc 
c010d4e2:       a3 4c db 38 c0          mov    %eax,0xc038db4c      // last_tsc_low: 0x55fe575c
                // offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
c010d4e7:       b8 08 01 00 00          mov    $0x108,%eax
c010d4ec:       89 15 50 db 38 c0       mov    %edx,0xc038db50      // last_tsc_high: 0x00099c39
c010d4f2:       e8 79 90 00 00          call   c0116570 <hpet_readl>
c010d4f7:       8b 15 20 90 39 c0       mov    0xc0399020,%edx      // hpet_tick: 0x0000dfb9
c010d4fd:       8b 0d 40 db 38 c0       mov    0xc038db40,%ecx      // hpet_last: 0x7a12047a
c010d503:       89 c5                   mov    %eax,%ebp
c010d505:       29 d5                   sub    %edx,%ebp            // %ebp: offset: 0x7a120471
                // (offset - hpet_last): -9
                // detect_lost_ticks: 1
                // if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
                //              && detect_lost_ticks) {
c010d507:       89 e8                   mov    %ebp,%eax
c010d509:       29 c8                   sub    %ecx,%eax
c010d50b:       39 d0                   cmp    %edx,%eax
c010d50d:       76 20                   jbe    c010d52f <mark_offset_tsc_hpet+0x87>
c010d50f:       85 c9                   test   %ecx,%ecx
c010d511:       74 1c                   je     c010d52f <mark_offset_tsc_hpet+0x87>
c010d513:       83 3d 60 db 38 c0 00    cmpl   $0x0,0xc038db60
c010d51a:       74 13                   je     c010d52f <mark_offset_tsc_hpet+0x87>
                // int lost_ticks = (offset - hpet_last) / hpet_tick;
c010d51c:       89 d1                   mov    %edx,%ecx
c010d51e:       31 d2                   xor    %edx,%edx
c010d520:       f7 f1                   div    %ecx
c010d522:       99                      cltd  
                // jiffies_64 += lost_ticks;
c010d523:       01 05 00 cc 34 c0       add    %eax,0xc034cc00
c010d529:       11 15 04 cc 34 c0       adc    %edx,0xc034cc04

The above scenario requires that the timer interrupt routine be either interrupted itself (can you tell what priority each interrupt is?) or that it get preempted, if such preemption of a timer interrupt is possible, or some such. The fix would be simple, to just make the comparison "((offset - hpet_last) > hpet_tick)" be a signed comparison.

The timer system being rewritten in 2.6.18 means this problem is not present from this version on, but we see one failure a week or so in the lab, and in several systems in the field, so a patch or at least a note for kernels before 2.6.18 might be helpful.

Lee Merrill
Bus-Tech Inc.


 
|===============================================================
| Lee Merrill -------------------------- Home page: leenotes.org
| "Give thanks in all circumstances..."
|===============================================================

