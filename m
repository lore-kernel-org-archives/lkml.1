Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYAIIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYAIIA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYAIIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:00:49 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:46436 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYAIIAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:00:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aIozaj65Qt+yI7qDmw1r7fJIzP6f5PLEnzkaeh0YwI2wkoDG8VcnTuwzFyFenCtEC9jwszaFyTDUaheeo1M0wKSB6QMvc9au++ZyhKrbnvfO7VlxWiULiZfnLLnyw7u7SbPjYirixEHLITJ3yacT9YD4bNqURi9UBVCMRwxLmm4=
Message-ID: <5d75f4610801090000j20eb7c07m78a07abbffe590ba@mail.gmail.com>
Date: Wed, 9 Jan 2008 15:00:46 +0700
From: "BuraphaLinux Server" <buraphalinuxserver@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: The ext3 way of journalling
Cc: "LKML Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <p73odbwqmx2.fsf@bingen.suse.de>
	 <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de>
	 <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help for CONFIG_DM_SNAPSHOT says it is EXPERIMENTAL (in
2.6.23.12).  So this would mean that there is very high risk of
software failure using snapshots.  Would you want to do that for your
fsck?

On 1/9/08, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> On Jan 08, 2008, at 15:51:53, Andi Kleen wrote:
> > Theodore Tso <tytso@mit.edu> writes:
> >> Now, there are good reasons for doing periodic checks every N
> >> mounts and after M months.  And it has to do with PC class
> >> hardware.  (Ted's aphorism: "PC class hardware is cr*p").
> >
> > If these reasons are good ones (some skepticism here) then the
> > correct way to really handle this would be to do regular background
> > scrubbing during runtime; ideally with metadata checksums so that
> > you can actually detect all corruption.
>
> Poor man's background scrubbing:
>
> (A)  Use LVM like virtually all modern distros offer
> (B)  Leave some extra space in your LVM volume group (enough for 1
> snapshot over the time it takes to do an FSCK).
> (C)  Periodically run the following scriptlet:
>
> set -e
> START="$(date +'%Y%m%d%H%M%S')"
> lvcreate -s -n "${VOLUME}-snap" "${VG}/${VOLUME}"
> if nice +20 fsck -fy "/dev/mapper/${VG}_${VOLUME}-snap"; then
> 	echo 'Background scrubbing succeeded!'
> 	tune2fs -T "${START}" "/dev/mapper/${VG}_${VOLUME}"
> else
> 	echo 'Background scrubbing failed!  Reboot to fsck soon!'
> 	tune2fs -C 16383 -T "19000101" "/dev/mapper/${VG}_${VOLUME}"
> fi
> lvremove "${VG}/${VOLUME}-snap"
>
> Basically you can fsck the offline snapshot in the background.  If it
> succeeds you can adjust the "last checked" date to the time when the
> snapshot was taken and if it fails you can schedule an FSCK at next
> reboot (and possibly remount the filesystem read-only or reboot
> immediately).
>
> You can do the same thing for your /boot volume, although you
> probably have to manually use dmsetup since most bootloaders can't
> interpret LVM volumes.
>
> I've always been surprised that distros like RedHat which
> automatically use LVM don't stuff this in their weekly or monthly
> checks on desktop systems.  User experience could also be
> dramatically improved with automated smartd configuration and user-
> interactive logging and warning messages.
>
>
> > But since fsck is so slow and disks are so big this whole thing is
> > a ticking time bomb now. e.g. it is not uncommon to require tens of
> > minutes or even hours of fsck time and some server that reboots
> > only every few months will eat that when it happens to reboot. This
> > means you get a quite long downtime.
>
> My servers all have an "interval-between-checks" of 2-6 weeks and are
> configured to run nice +20 background "fsck" checks during off-hours
> between once every few days and once every few weeks.  I also have
> the "max mount count" numbers set to primes between 7 and 37
> (depending on the filesystem) so that troubled or frequently-rebooted
> systems are more frequently verified.  The end result is that I
> almost never have the dreaded 4-hour-fsck-on-boot problem.  A drive
> has certainly been fscked within the last few weeks of operation, and
> I will only ever have multiple large filesystems all fscked at the
> same time very rarely (gcd of their max-mount-counts).
>
> Cheers,
> Kyle Moffett
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
