Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXGXDnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXGXDnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXGXDnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:43:05 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:32793 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXGXDnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:43:04 -0400
Message-ID: <46A574DA.30907@gmail.com>
Date: Tue, 24 Jul 2007 05:41:14 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Rene Herman <rene.herman@gmail.com>,
       Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com> <20070720160614.GG26752@thunk.org> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <46A31F55.2000009@gmail.com> <20070722163934.GB20174@thunk.org> <46A45A01.5050709@gmail.com> <20070723134835.GC19927@thunk.org>
In-Reply-To: <20070723134835.GC19927@thunk.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2007 03:48 PM, Theodore Tso wrote:

> On Mon, Jul 23, 2007 at 09:34:25AM +0200, Rene Herman wrote:

>> That's not quite correct. Logicals have a start field relative to the 
>> encompassing extended (ie, for me always 1, for others often always 63) and 
>> the encompassing extended are relative not to the previous extended but to 
>> the level 0 extended (the one in the MBR). 
> 
> This assumes that the extended partition is at the beginning of the
> disk, yes?

Err, well, no, that's not what I meant. The "start" field for the extended 
partition that sits in the primary partitition table (the one in the MBR) is 
absolute, or "relative to the start of the disk", but the "start" field for 
the empty extended partitions that together form the logical partition list 
are relative not to the previous one in the list, but all to this outermost 
extended partition.

> Why would anyone do that?  I normally have /dev/hda1 at the beginning of
> the disk, and I normally make /dev/hda4 my extended, and place it *after*
> partitions at /dev/hda2, /dev/hda3, etc.

... but having said that, I do actually have an extended partition as my 
/dev/hda1 at the beginning of the disk. This is the current layout on my 
main system:

    Device Boot    Start       End   #sectors  Id  System
/dev/sda1             1 231733119  231733119  85  Linux extended
/dev/sda2   * 231733120 240121727    8388608   c  W95 FAT32 (LBA)
/dev/sda3             0         -          0   0  Empty
/dev/sda4             0         -          0   0  Empty
/dev/sda5             2   2097153    2097152  82  Linux swap
/dev/sda6       2097155  18874370   16777216  83  Linux
/dev/sda7      18874372  35651587   16777216  83  Linux
/dev/sda8      35651589 231733119  196081531  83  Linux

As you can see, everything neatly non-cylinder-aligned, with not a single 
sector wasted ;-) Table sectors at 0 (MBR), 1 (outer extended), 2097154, 
18874371 and 35651588 (list-extendeds).

/dev/sda2 used to be a FreeBSD install (partition type 0xa5), /dev/sda3 a 
MINIX install (type 0x81) and /dev/sda4 the still present FAT32 Windows 98 
partition at the very end of the disk. I removed FreeBSD and MINIX due to 
space shortage...

The reason that I use the first entry for an extended is that I view the 
type "Linux Extended" simply as "Linux": That is, I see 0x85 simply as the 
one and only Linux type with all my Linux data partitions on the logicals 
inside -- very much like 0xa5 is the one FreeBSD type with all its data 
partitions on the slices inside, and 0x81 the one MINIX partition with its 
data partitions on the subpartitions inside.

That is, I've been using a "Linux native partitioning scheme" where the 
Linux native layout just happens to coincide with a DOS/Windows native layout.

My Linux partition is at the start of the disk since it's the system I use. 
The others are/were there just to boot perhaps a few times a year to check 
some things -- and the start of the disk is the fastest bit, so I certainly 
want my main system to use that.

Anyone find my "Native Linux Partitioning Scheme" interesting? Designing and 
using a better way than regular logicals to carve up the space inside (such 
as something designed after BSD slices) would work for me as well ;-)

> It would be interesting to see how badly modern Windows systems breaks
> on this.  If Windows 2000 and above works, and Linux works, then if
> other things break it might be quite sufficient to consider them
> "broken software" that we don't need to worry about.

Googling for it, the 2TB limit of DOS partitioning is widely known and there 
would be no point worrying even about the single-bit overflow possibly of 
the list of extendeds...

>> With 32-bit values (and 512-byte sectors) you can service 2TB -- anything 
>> above that requires something better than MS-DOS partition tables. 
> 
> Well, in about 2-3 years or so we'll seeing having singleton disks
> bigger 2TB.  I'm not terribly sanguine about BIOS vendors and OS
> providers migrating to something better by then, alas.  Life is sure
> going to be interesting.  :-)

And sectors probably larger than 512 bytes. I hope they'll not do _that_ 
until plain old partitions are truly abandoned since before you know it 
someone going to view it as an excuse to keep using this fragile mess ;-)

Rene.

