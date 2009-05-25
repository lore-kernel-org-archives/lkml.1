Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZEYNpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZEYNpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZEYNpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:45:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:47797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751780AbZEYNpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:45:24 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX1+slfpNGOGssayeJjOSWOG+H6qnCrVEDo22bKgiLY
	H2+z25OtgI+U5C
Date: Mon, 25 May 2009 15:45:22 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA,
	Gigabyte EG45M-DS2H
Message-ID: <20090525134522.GA7805@arbonne.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.51C.SQcGKB@chimera> <200905251448.40907.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905251448.40907.bzolnier@gmail.com> <20090516225153.GA7883@arbonne.lan>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this bug is still present, but so far (despite lots of useful help by 
Bartlomiej) I have been unable to bisect the issue.

We took some of the discussion off-list - here is a summary, with some new 
results at the end:

* I originally bisected the bug and identified this patch as the culprit:
295f00042aaf6b553b5f37348f89bab463d4a469: ide: don't execute the next 
queued command from the hard-IRQ context (v2)

* The fix for 295f000 (2ea5521: ide: fix suspend regression) did not fix my 
problem either.

* After some mails, I switched to CONFIG_IDE=n in the config I use for 
testing (was CONFIG_IDE=m before), because the problem still occurred in 
that case. The result of this:
295f000 (ide: don't execute the next queued command from the hard-IRQ
        context (v2)): ***Works*** with CONFIG_IDE=n
2ea5521 (ide: fix suspend regression): Hangs with CONFIG_IDE=n
1406de8 (2.6.30-rc6): Hangs with CONFIG_IDE=n

I also disconnected my second (PATA) disk at that point, since it does not 
influence the bug. So my system is SATA-only, both the (single) hard disk 
and my DVD writer are SATA.

* I bisected 295f000..2ea5521 and ended up at this as the first bad commit:
9ea09af3bd3090e8349ca2899ca2011bd94cda85: stop_machine: introduce stop_machine_create/destroy.
This turns out to be a bug that was fixed by
a0e280e0f33f6c859a235fb69a875ed8f3420388: stop_machine/cpu hotplug: fix disable_nonboot_cpus

* a0e280e worked for me, so (with increasing grumpiness;) I bisected 
a0e280e..2ea5521. This bisect didn't work, I ended up with a reported "bad" 
commit which was clearly not the problem. The configs and bisect log are at
<http://atterer.net/s2disk-config/>
The bisect log lines with "OK" mean that I went back and booted the kernel 
a second time, to make sure I hadn't mixed something up. But the second 
tries all had the same result as the first.

* Bart analysed that part of the history and suggested trying out 73d5931, 
and if that worked, bisecting 73d5931..2ea5521.

Today I re-tried both 73d5931 and 2ea5521, and it turns out that in both 
cases, s2disk hangs. :-|

By chance, I noticed that the behaviour during the hang is different from 
what I reported before, at least with these two versions. Initially, I 
said that the system would hang after the "s2disk: Snapshotting system" 
with a blinking cursor.
It turns out that actually it hangs for quite a while (maybe 2 minutes?) 
and only then starts to perform the s2disk!! The last lines written are 
"s2disk: Compression ratio 0.24" or similar, and then a line containing 
just "S¦". Afterwards, the system does *not* power off as it usually does, 
but just seems to hang again. (I think I waited for a few minutes, but 
nothing happened.)

Since the last, third bisect did not work, I'm at a loss what to try next.

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer
  | \/¯|  http://atterer.net
  ¯ '` ¯
