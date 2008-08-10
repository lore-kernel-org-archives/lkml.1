Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYHJK0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYHJK0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 06:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYHJK0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 06:26:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37405 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYHJK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 06:26:28 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Aug 2008 06:26:28 EDT
Date: Sun, 10 Aug 2008 12:17:30 +0200
From: Andreas Mohr <andi@lisas.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dominik Brodowski <linux@brodo.de>, john stultz <johnstul@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org
Subject: ACPI PM-Timer on K6-3 SiS5591: Houston...
Message-ID: <20080810101730.GA10024@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

forgive me for such a blunt description, but:
"bad hardware - PASS, good hardware - FAIL"
That's about what could be used as a summary for my recent observations
about our ACPI PM-Timer usage ;)

With a modified pmtmr_test on my stoneage system, I get the following
sequence (relevant excerpt only):


652419 <==
65241b <===================
65241d <==
65201e
65241f
652020
652421
652022
652423
652024
652425
652429
65202e
652431
652032
652433
652034
652435
652036
652437
652038 <==
65203a <====================
65203c <==
65203e
652040
652042
652044
652046
652048

Result: catastrophic timer behaviour (a large backwards skip is possible),
even in case we do a triple-read workaround, due to a floating bit at
0x0400 (possibly caused by underclocking from 400 to 150, but whatever...).

And my system does pass the bootup PM-Timer check quite often despite
this severe defect (2 in 4 bootups _did_ register my defective
acpi_pm clocksource).

That was the "PASS for broken hardware" part.

Now to the "FAIL for sufficiently-good hardware" part:

I realized that in historic versions (e.g. 2.6.12) read_pmtmr()
encompassed the _entire_ "triple-reading due to latch bug" logic.
Nowadays read_pmtmr() is the raw inline version of a single inl() only!
However despite this large change, the initial hardware check
(at init_acpi_pm_clocksource()) _kept using_ the now single-read read_pmtmr()
as if nothing had happened. Why nobody realized this during review is
beyond me.
The result is that even on latch-bugged systems which are capable to be used
successfully (via the triple-read workaround) the PM-Timer bootup check most
likely can fail quite often now due to now doing buggy single-reads
during initial check
(cannot verify this in real life due to lack of affected P3 hardware here).


Both issues are caused by very weak monotony verification in
init_acpi_pm_clocksource(), thus that init check should get improved
by leaps and bounds instead of stupidly exiting at the very first sign of a
working timer (or maybe even create a generic "verify counter increment" function to be used for all sorts of hardware counters of a configurable counter width?).
I.e. something like
if (timer_ok(timeout_loops, num_checks, counter_width, read_val_func()))
	"everything's ok"

And the triple-read/single-read switch should be moved out of the lateish
clocksource struct registration, to be available during generic read_pmtmr()
already, from the very beginning.

I.e.:
- "known good workaround" systems should provide workaround from the beginning
- initial timer check should then do at least 10 increment checks with
  10 of 10 successful
- if this improved logic fails, then we know that hardware _can_ be considered
  to be broken for use in current kernels
  (and should then be externally analysed using pmtmr_test)

I will try to work on this, but no promises (production system, not too much
time).



Other than this, migrating towards ACPI usage on this rotten system
seems to work just fine, which is quite some feat for Linux I'd think.
Except for the following bootup errors though:


Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
ACPI Error (dsopcode-0595): Field [IRQL] at 208 exceeds Buffer [BUF0] size 192 (bi
ts) [20080321]
ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.ISA_.FDC0._CR
S] (Node c781e270), AE_AML_BUFFER_LIMIT
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.ISA_.FDC0._CRS] (Nod
e c781e270), AE_AML_BUFFER_LIMIT
pnp 00:08: can't evaluate _CRS: 12300<6>pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered



Note (hello Alan!) that this system might be a bug candidate for the recent
libata SiS5513 issue report, but I haven't done the libata migration yet.

# lspci
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 5591/5592 Host (rev 02)
00:00.1 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0)
00:01.0 ISA bridge: Silicon Integrated Systems [SiS] SiS85C503/5513 (LPC Bridge) (rev 01)
00:01.1 Class ff00: Silicon Integrated Systems [SiS] ACPI
00:01.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 11)
00:02.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge (AGP)

Thanks,

Andreas Mohr
