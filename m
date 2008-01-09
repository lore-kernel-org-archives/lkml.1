Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYAIDWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYAIDWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYAIDWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:22:44 -0500
Received: from smtpoutm.mac.com ([17.148.16.67]:49320 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYAIDWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:22:43 -0500
In-Reply-To: <p734pdoqbva.fsf@bingen.suse.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
Cc: Theodore Tso <tytso@mit.edu>, LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 22:21:02 -0500
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 08, 2008, at 15:51:53, Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
>> Now, there are good reasons for doing periodic checks every N  
>> mounts and after M months.  And it has to do with PC class  
>> hardware.  (Ted's aphorism: "PC class hardware is cr*p").
>
> If these reasons are good ones (some skepticism here) then the  
> correct way to really handle this would be to do regular background  
> scrubbing during runtime; ideally with metadata checksums so that  
> you can actually detect all corruption.

Poor man's background scrubbing:

(A)  Use LVM like virtually all modern distros offer
(B)  Leave some extra space in your LVM volume group (enough for 1  
snapshot over the time it takes to do an FSCK).
(C)  Periodically run the following scriptlet:

set -e
START="$(date +'%Y%m%d%H%M%S')"
lvcreate -s -n "${VOLUME}-snap" "${VG}/${VOLUME}"
if nice +20 fsck -fy "/dev/mapper/${VG}_${VOLUME}-snap"; then
	echo 'Background scrubbing succeeded!'
	tune2fs -T "${START}" "/dev/mapper/${VG}_${VOLUME}"
else
	echo 'Background scrubbing failed!  Reboot to fsck soon!'
	tune2fs -C 16383 -T "19000101" "/dev/mapper/${VG}_${VOLUME}"
fi
lvremove "${VG}/${VOLUME}-snap"

Basically you can fsck the offline snapshot in the background.  If it  
succeeds you can adjust the "last checked" date to the time when the  
snapshot was taken and if it fails you can schedule an FSCK at next  
reboot (and possibly remount the filesystem read-only or reboot  
immediately).

You can do the same thing for your /boot volume, although you  
probably have to manually use dmsetup since most bootloaders can't  
interpret LVM volumes.

I've always been surprised that distros like RedHat which  
automatically use LVM don't stuff this in their weekly or monthly  
checks on desktop systems.  User experience could also be  
dramatically improved with automated smartd configuration and user- 
interactive logging and warning messages.


> But since fsck is so slow and disks are so big this whole thing is  
> a ticking time bomb now. e.g. it is not uncommon to require tens of  
> minutes or even hours of fsck time and some server that reboots  
> only every few months will eat that when it happens to reboot. This  
> means you get a quite long downtime.

My servers all have an "interval-between-checks" of 2-6 weeks and are  
configured to run nice +20 background "fsck" checks during off-hours  
between once every few days and once every few weeks.  I also have  
the "max mount count" numbers set to primes between 7 and 37  
(depending on the filesystem) so that troubled or frequently-rebooted  
systems are more frequently verified.  The end result is that I  
almost never have the dreaded 4-hour-fsck-on-boot problem.  A drive  
has certainly been fscked within the last few weeks of operation, and  
I will only ever have multiple large filesystems all fscked at the  
same time very rarely (gcd of their max-mount-counts).

Cheers,
Kyle Moffett

