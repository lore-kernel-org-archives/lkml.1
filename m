Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXIYVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXIYVoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXIYVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:44:07 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:55502 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbXIYVoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:44:06 -0400
From: Frans Pop <elendil@planet.nl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI suspend/hibernate tests (was: ACPI power off regression in 2.6.23-rc8)
Date: Tue, 25 Sep 2007 23:44:01 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Damien Wyart <damien.wyart@free.fr>, Len Brown <len.brown@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org
References: <20070925065109.GA3080@localhost.localdomain> <alpine.LFD.0.999.0709250830420.3579@woody.linux-foundation.org> <200709251800.13272.rjw@sisk.pl>
In-Reply-To: <200709251800.13272.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709252344.02894.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2007 21:44:02.0883 (UTC) FILETIME=[305FB930:01C7FFBD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Rafael J. Wysocki wrote:
> On Tuesday, 25 September 2007 17:40, Linus Torvalds wrote:
> > Len - why are you guys moving stuff into CONFIG_PM_SLEEP? I know you
> > seem to think that absolutely *everybody* should always support suspend
> > and hibernation, but the fact is, not everybody does. And it's a
> > totally separate thing for normal ACPI CPU runstate support that people
> > have used to manage a *running* CPU (and shutting it down).
>
> This was a mistake and fixes have already been posted:
>
> http://marc.info/?l=linux-acpi&m=119052970904643&w=4
> http://marc.info/?l=linux-acpi&m=119073173625910&w=4

As this whole "separate suspend and hibernate" change seems to have been 
trickier than expected, I have done some additional testing using 
2.6.23-rc8 plus both patches referred to above.

I compiled kernels (i386) for my laptop (Toshiba Satellite A40) with:
A) PM + SUSPEND + HIBERNATION + ACPI
B) PM + SUSPEND + ACPI
C) PM + HIBERNATION + ACPI
D) PM + ACPI
E) PM + SUSPEND + HIBERNATION but _without_ ACPI
F) without PM

In all cases CONFIG_APM was not set; all compiled without errors.

With all I have have booted, tried to suspend (close lid, which runs sleep 
script, which does 'echo mem >/sys/power/state'), tried to hibernate ('echo 
disk >/sys/power/state') and powered off (all from KDE sessions).

RESULTS
	boot	s2ram	s2disk	off
A)	OK	OK	OK	OK
B)	OK	OK	N/A	OK
C)	OK	OK 1)	OK	OK
D)	OK 2)	OK 1)	N/A	OK
E)	OK 3)	N/A 4)	??? 5)	Only halted 6)
F)	OK	N/A	N/A	Only halted 6)

Comments:
1) sleep script ran, but laptop stayed on
2) dmesg lists S0,S5 supported
   /proc/acpi/{sleep,wakeup} do not exist (is that correct?)
3) /proc/acpi/{sleep,wakeup} do not exist; /sys/power/state only has 'mem'
   so SUSPEND seems missing even though compiled in
4) sleep script did not even run (as expected)
5) System did suspend, but power stayed on with on console:
     Shutdown: hda \ Power down. \ Shutdown: hda \ hda: lost interrupt (2x)
     \ psmouse.c: Failed to deactivate mouse on isa0060/serio1
   System powered off manually and resumed correctly after that
6) System halted correctly, but did not power off automatically

The results for E and F are possibly correct as basically the config 
(without ACPI) was broken for this laptop. In fact, I was somewhat 
surprised how well it behaved without ACPI.

I suspect that whether a system powers off without ACPI or not can depend on 
the system?

I have dmesg after boot and some other info available for all kernels if 
anybody is interested. If any additional tests are wanted, please ask.

Cheers,
FJP
