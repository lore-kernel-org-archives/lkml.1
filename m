Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZCMVGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZCMVGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCMVGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:06:43 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:37848 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZCMVGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:06:42 -0400
Message-ID: <49BACABE.7060003@msgid.tls.msk.ru>
Date: Sat, 14 Mar 2009 00:06:06 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: phenom, amd780g, tsc, hpet, kvm, kernel -- who's at fault?
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today (Friday, the 13th) I had a very bad sequence of failures
with our servers leading to data loss and almost the whole day
of very hard work.  And now I'm *really* interested where the
fault(s) is(are).

What I have here is an AMD780G-based system (Asus M3A-H/HDMI
motherboard, latest BIOS) with AND Phenom 9750 CPU and 8Gig of
ECC memory.  The system is built for KVM (kernel virtual machine)
work, and is running several guests, but I'm not sure anymore
that KVM is related to the problem at hand.

The problem is that - it seems - timekeeping on this machine is
quite unreliable.

It's Phenom, so TSC should be synced.  And it is being choosen
at bootup as clocksource.  But regardless of current_clocksource
(tsc), it constantly increases hpet min_delta_ns, like this:

Mar 13 19:58:02 gate kernel: CE: hpet increasing min_delta_ns to 15000 nsec
Mar 13 19:59:16 gate kernel: CE: hpet increasing min_delta_ns to 22500 nsec
Mar 13 19:59:16 gate kernel: CE: hpet increasing min_delta_ns to 33750 nsec
Mar 13 19:59:16 gate kernel: CE: hpet increasing min_delta_ns to 50624 nsec
Mar 13 20:47:02 gate kernel: CE: hpet increasing min_delta_ns to 75936 nsec
Mar 13 20:48:17 gate kernel: CE: hpet increasing min_delta_ns to 113904 nsec
Mar 13 21:02:23 gate kernel: CE: hpet increasing min_delta_ns to 170856 nsec
Mar 13 21:05:27 gate kernel: CE: hpet increasing min_delta_ns to 256284 nsec
Mar 13 21:07:28 gate kernel: Clocksource tsc unstable (delta = 751920452 ns)
Mar 13 21:09:12 gate kernel: CE: hpet increasing min_delta_ns to 384426 nsec

and finally, it declares that TSC is unstable (pre-last line) and
switches to the (unstable) HPET.

HPET min_delta_ns will be increasing further and further, i've seen it
increased to 576638 and more.

And no doubt the system is unstable with KVM like crazy, especially under
some, even light, load.

Today I were copying some relatively large amount of data over network from
another to this machine (to the host itself, not to any virtual guest), and
had numerous guest and host stalls and lockups.  At times, host sops doing
anything at all, all guests stalling too, load average jumps to 80 and more,
and nothing happens.  I can do something over console still, like running
top/strace, but nothing interesting shows.  I captured Sysrq+T of this situation
here: http://www.corpit.ru/mjt/host-high-la -- everything I was able to find
in kern.log.

After some time, sometimes it's several seconds, sometimes it's up to 10
minutes, the thing "unstucks" and continues working.  Today it happened after
about 10 minutes.  But after it continued, 2 of the KVM guests were eating
100% CPU and did not respond at all.  The Sysrq+T of this is available at
http://www.corpit.ru/mjt/guest-stuck -- two KVM guests were not responsible.

It's even more - the system started showing sporadic, random I/O errors
unrelated to the disks - for example, one of software RAID5 arrays started
behaving really oddly, so that finally, after a reboot, I had to re-create
the array and some of the filesystems on it (which I never saw in last ~10
years I'm using sofraid on linus, on many different systems and disks and
with various failure cases).

Now, I switched to acpi_pm clocksource.  And also tried to disable nested
page tables with kvm (kvm_amd npt=0).  With that, everything is slow and
sluggish, but I was finally able to copy that data without errors, while
the guests were running.

It were about to stuck as before, but I noticed it switched to hpet (see
"tsc is unstable" above) and I forced it to use acpi_pm instead, and it
survived.

So, to the hell out of it all, and ignoring the magical Friday the 13th --
who's fault it is?

  o why it declares tsc is unstable while phenom supposed to keep it ok?
  o why hpet is malfunctioning?
  o why the system time on this machine is dog slow without special
    adjtimex adjustments, while it worked before (circa 2.6.26) and
    windows works ok here?

For reference:

  https://sourceforge.net/tracker/?func=detail&atid=893831&aid=2351676&group_id=180599
   -- kvm bug on sourceforge, without any visible interest in even looking at it

  http://www.google.com/search?q=CE%3A+hpet+increasing+min_delta_ns
   -- numerous references to that "CE: hpet increasing min_delta_ns" on the 'net,
   mostly for C2Ds, mentioning various lockup issues

  http://marc.info/?t=123246270000002&r=1&w=2 --
   "slow clock on AMD 740G chipset" -- it's about the clock issue, also without
   any visible interest.

What's the next thing to do here?  I for one don't want to see todays failures
again, it was very, and I mean *very* difficult day to restore the functionality
of this system that (and it isn't restored at full because of the slowness of
its current state).

Thanks!

/tired mjt.
