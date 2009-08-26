Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZHZSDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZHZSDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZHZSDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:03:14 -0400
Received: from thunk.org ([69.25.196.29]:38500 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZHZSDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:03:11 -0400
Date: Wed, 26 Aug 2009 14:02:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: david@lang.hm
Cc: Pavel Machek <pavel@ucw.cz>, Rik van Riel <riel@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090826180248.GB6997@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm> <20090826131028.GB1370@ucw.cz> <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 06:43:24AM -0700, david@lang.hm wrote:
>>>
>>> as the ext3 authors have stated many times over the years, you still need
>>> to run fsck periodicly anyway.
>>
>> Where is that documented?
>
> linux-kernel mailing list archives.

Probably from some 6-8 years ago, in e-mail postings that I made.  My
argument has always been that PC-class hardware is crap, and it's a
Really Good Idea to periodically check the metadata because corruption
there can end up causing massive data loss.  The main problem is that
doing it at reboot time really hurt system availability, and "after 20
reboots (plus or minus)" resulted in fsck checks at wildly varying
intervals depending on how often people reboot.

What I've been recommending for some time is that people use LVM, and
run fsck on a snapshot every week or two, at some convenient time when
the system load is at a minimum.  There is an e2croncheck script in
the e2fsprogs sources, in the contrib directory; it's short enough
that I'll attach here here.

Is it *necessary*?  In a world where hardware is perfect, no.  In a
world where people don't bother buying ECC memory because it's 10%
more expensive, and PC builders use the cheapest possible parts --- I
think it's a really good idea.

						- Ted

P.S.  Patches so that this shell script takes a config file, and/or
parses /etc/fstab to automatically figure out which filesystems should
be checked, are greatly appreciated.  Getting distro's to start
including this in their e2fsprogs packaging scripts would also be
greatly appreciated.

#!/bin/sh
#
# e2croncheck -- run e2fsck automatically out of /etc/cron.weekly
#
# This script is intended to be run by the system administrator 
# periodically from the command line, or to be run once a week
# or so by the cron daemon to check a mounted filesystem (normally
# the root filesystem, but it could be used to check other filesystems
# that are always mounted when the system is booted).
#
# Make sure you customize "VG" so it is your LVM volume group name, 
# "VOLUME" so it is the name of the filesystem's logical volume, 
# and "EMAIL" to be your e-mail address
#
# Written by Theodore Ts'o, Copyright 2007, 2008, 2009.
#
# This file may be redistributed under the terms of the 
# GNU Public License, version 2.
#

VG=ssd
VOLUME=root
SNAPSIZE=100m
EMAIL=sysadmin@example.com

TMPFILE=`mktemp -t e2fsck.log.XXXXXXXXXX`

OPTS="-Fttv -C0"
#OPTS="-Fttv -E fragcheck"

set -e
START="$(date +'%Y%m%d%H%M%S')"
lvcreate -s -L ${SNAPSIZE} -n "${VOLUME}-snap" "${VG}/${VOLUME}"
if nice logsave -as $TMPFILE e2fsck -p $OPTS "/dev/${VG}/${VOLUME}-snap" && \
   nice logsave -as $TMPFILE e2fsck -fy $OPTS "/dev/${VG}/${VOLUME}-snap" ; then
  echo 'Background scrubbing succeeded!'
  tune2fs -C 0 -T "${START}" "/dev/${VG}/${VOLUME}"
else
  echo 'Background scrubbing failed! Reboot to fsck soon!'
  tune2fs -C 16000 -T "19000101" "/dev/${VG}/${VOLUME}"
  if test -n "$RPT-EMAIL"; then 
    mail -s "E2fsck of /dev/${VG}/${VOLUME} failed!" $EMAIL < $TMPFILE
  fi
fi
lvremove -f "${VG}/${VOLUME}-snap"
rm $TMPFILE

