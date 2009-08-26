Return-Path: <linux-kernel-owner+w=401wt.eu-S1751107AbZHZEIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbZHZEIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZHZEIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZHZEIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:08:30 -0400
Message-ID: <4A94B529.1080308@redhat.com>
Date: Wed, 26 Aug 2009 00:08:09 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <19092.28371.793339.764701@notabene.brown> <20090825234454.GI4300@elf.ucw.cz>
In-Reply-To: <20090825234454.GI4300@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Ok, can you help? Having a piece of MD documentation explaining the
> "powerfail nukes entire stripe" and how current filesystems do not
> deal with that would be nice, along with description when exactly that
> happens.

Except of course for the inconvenient detail that a power
failure on a degraded RAID 5 array does *NOT* nuke the
entire stripe.

A 5-disk RAID 5 array will have 4 data blocks and 1 parity
block in each stripe.  A degraded array will have either
4 data blocks or 3 data blocks and 1 parity block in the
stripe.

If we are dealing with a parity-less stripe, we cannot
lose any data due to RAID 5, because each of the 4 data
blocks has a disk block available.  We could still lose
a data write due to a power failure, but this could also
happen with the RAID 5 array still intact.

If we are dealing with a 3-data, 1-parity stripe, then
3 of the 4 data blocks have an available disk block and
will not be lost (if they make it to disk).  The only
block that maintains on all 3 data blocks and the parity
block being correct is the block that does not currently
have a disk to be written to.

In short, if a stripe is not written completely on a
degraded RAID 5 array, you can lose:
1) the blocks that were not written (duh)
2) the block that doesn't have a disk

The first part of this loss is also true in a non-degraded
RAID 5 array.  The fact that the array is degraded really
does not add much additional data loss here and you certainly
will not lose the entire stripe like you suggest.

-- 
All rights reversed.
