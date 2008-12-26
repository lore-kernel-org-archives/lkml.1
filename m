Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYLZOHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYLZOHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYLZOH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:07:26 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47293 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbYLZOHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:07:25 -0500
Date: Fri, 26 Dec 2008 09:07:21 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20081226140721.GN9871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <4954BAAB.9090108@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4954BAAB.9090108@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 12:06:19PM +0100, Andreas Sundstrom wrote:
> I use a little script that backup this xen VM from xen dom0.
> 
> Here is the interesting part of my script:
> /usr/sbin/xm sysrq xenfw1 s
> /usr/sbin/xm pause xenfw1
> sync
> /sbin/lvm lvcreate --snapshot --permission rw --size 1G --name xenfw1_s
> /dev/3w250g/xenfw1 > /dev/null
> /usr/sbin/xm unpause xenfw1
> /bin/mount -o ro,noatime /dev/3w250g/xenfw1_s /mnt/snapshots/xenfw1 ||
> /bin/rmdir /mnt/snapshots/xenfw1
> # Here's where the actual backups take place
> /bin/umount /mnt/snapshots/xenfw1 2> /dev/null
> /sbin/lvm lvremove --force /dev/3w250g/xenfw1_s > /dev/null

OK, so this is being run on Xen Dom0, which means your doing the
snapshot from Host OS, while the guest OS is suspended, correct?

> After the "lvcreate --snapshot" if I check within the xen VM (with cat
> /proc/mounts) I can see that / changed from rw to ro:
> Before snapshot:
> /dev/root / ext4 rw,noatime,barrier=1,noextents,data=ordered 0 0
> After snapshot:
> /dev/root / ext4 ro,noatime,barrier=1,noextents,data=ordered 0 0

But this was done from the guest OS --- what is /dev/root in the guest
OS?  Am I right in assuming it is the device /dev/3w250g/xenfw1?
Stupid question --- if this is the case, why are you taking the
snapshot from the Host OS?  It won't be a consistent snapshot, given
that it was mounted in the Guest OS, and all you've done in the Guest
OS is to ask it to sync the filesystem.  Given that there's no pause
between sysrq s and the pause, the write operations probably haven't
even been completed before the pause takes place, so the snapshot
probably has a chance of in pretty bad shape as it is.

If the filesystem is being remounted read-only, that tends to indicate
that the filesystem flagged an error for some reason.  So looking at
the dmesg on the Guest OS for any ext4 errors would be the useful
thing to do.

> It was not possible to do "mount -o remount,rw /":
> mount -o remount,rw /                                                 

There are multiple potential reasons for this, but I'm guessing this
was caused by an aborted journal, probably caused by an I/O error when
trying to write to the journal.  This may very well be related to
pausing guest OS in the middle of a write operations that would have
been caused by the sysrq s, but that's a guess; we need more
information about exactly what is going on.

> I hope I explained the scenario good enough, I can reproduce this if you
> want more details (now I'm back on ext3 on this xen VM)

If you could reproduce this and send back the messages from dmesg in
the guest OS, that would be quite helpful.  You might also try adding
a sleep 2 between the sysrq s and the pause xenfw1 commands, and see
if the problem goes away.  That's just a stab in the dark, of course,
but it's a simple enough thing to try.

Regards,

						- Ted
