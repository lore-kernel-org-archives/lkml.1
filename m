Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYAHSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYAHSPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYAHSPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:15:32 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51799 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbYAHSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:15:31 -0500
Date: Tue, 8 Jan 2008 13:15:25 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108181525.GL27800@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 05:01:30PM +0000, Tuomo Valkonen wrote:
> On 2008-01-08, Andi Kleen <andi@firstfloor.org> wrote:
> > tune2fs -i0 -c0 device      for each file system
> >
> > Yes that should be default, unfortunately it is not. It's one 
> > of the first things I do on new machines.
> 
> I have ages ago increased those counts, but I don't want to
> completely disable them. The problem is that the superblock
> is corrupted to indicate absurd "31352 days since last check".
> Who knows, maybe it would even corrupt those settings.

Newer e2fsprogs display a better message, and you can set an
/etc/e2fsck.conf setting:

[options]
        buggy_init_scripts = 1

That will fix the this issue.  The problem you are facing is that you
have your hardware clock set to ticking localtime, instead of GMT.
Windows ticks localtime, which is a mistake carried over from the
1970's and MS-DOS.  Ticking localtime has all sorts of problems, among
which is if you reboot around the transition between Summer Time (or
Daylight Savings Time, depending on your contry) and normal time, the
OS has no idea whether the DST adjustment has been applied or not.  

It gets even worse if you have multiple operating systems, because
then one OS may have made the adjustment, and other one may no have
made the adjustment.  It's for that reason that if you reboot around
the right time of year, Windows throws up a big dialog box asking you
what the correct time should be.  Genius!

The problem on the Linux side is that some distributions, and Ubuntu
is the worse offender, but probably not the only one, do not correctly
set the system clock before they run fsck.  And if you live east of
GMT, such that your localtime offset is positive instead of negative,
then time can appear to go backwards and e2fsck can't trust the last
superblock check time.  Old versions of e2fsprogs display a funny
large time interval due to an integer overflow bug; that's since been
fixed.  (This bug doesn't support people in the US, because of our
time zone offset, but it tends to affect people in Europe who are
dual-booting with Windows and hance have their hardware clock tick
localtime.)

Now, there are good reasons for doing periodic checks every N mounts
and after M months.  And it has to do with PC class hardware.  (Ted's
aphorism: "PC class hardware is cr*p").  Windows users don't notice it
much because they generally blame the occasional blue screen of death
or corrupted file as an OS bug.  But very often, it is a hardware
issue, particularily on the cheaper PC class machines with no ECC
memory, and cheapest, unshielded hard drive cables from Taiwan that
the manufacturers can find.  Hence, the default is to do periodic
checks, since if you don't a random corruption can cause massive
filesystem corruption leading to massive data loss.

But, if you're confident in your hardware, you can turn that off.
tune2fs -c 0 will disable the number of mounts check, and tune2fs -i 0
will turn of the periodic time-based check.  And given that you have a
Linux distribution with buggy init scripts, that is one way of working
around the problem.

You could also simply change your CMOS/hardware clock to use GMT time,
and not localtime.  But that doesn't work well when you need to
dual-boot with Windows, since Windows doesn't support GMT time for the
hardware clock.

Another approach would involve using the /etc/e2fsck.conf settings
described above, but that will require possibly upgrading the version
of e2fsprogs that you have.  This will be the preferred mechanism
going forward, but perhaps not for the version of e2fsprogs you have
installed on your system.

Finally, I'm sorry this has obviously caused you so much stress.  If
you're happier using some other OS, please use whatever OS you find
makes you happiest.  I find that other deficiencies in Windows caused
my blood pressure to boil when I was forced (for a previous job) to
work on making programs run on Windows.  I consider the fact that I
can spend full-time working on Linux to be a blessing.  But if you
don't feel that way, my condolences, and please do what you need to do
so you can stay in your happy place.

Best regards,

						- Ted
