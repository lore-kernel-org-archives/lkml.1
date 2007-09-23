Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbXIWGW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbXIWGW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXIWGWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:22:20 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:45602 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbXIWGWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:22:19 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: mel@skynet.ie (Mel Gorman)
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070916181313.GA16406@skynet.ie>
	<87k5qq5l36.fsf@informatik.uni-tuebingen.de>
	<20070917100350.GC25706@skynet.ie>
Date: Sun, 23 Sep 2007 08:22:12 +0200
In-Reply-To: <20070917100350.GC25706@skynet.ie> (Mel Gorman's message of "Mon,
	17 Sep 2007 11:03:50 +0100")
Message-ID: <87r6kp7vfv.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mel@skynet.ie (Mel Gorman) writes:

> On (16/09/07 23:58), Goswin von Brederlow didst pronounce:
>> But when you already have say 10% of the ram in mixed groups then it
>> is a sign the external fragmentation happens and some time should be
>> spend on moving movable objects.
>> 
>
> I'll play around with it on the side and see what sort of results I get.
> I won't be pushing anything any time soon in relation to this though.
> For now, I don't intend to fiddle more with grouping pages by mobility
> for something that may or may not be of benefit to a feature that hasn't
> been widely tested with what exists today.

I watched the videos you posted. A ncie and quite clear improvement
with and without your logic. Cudos.

When you play around with it may I suggest a change to the display of
the memory information. I think it would be valuable to use a Hilbert
Curve to arange the pages into pixels. Like this:

# #  0  3
# #
###  1  2

### ###  0 1 E F
  # #
### ###  3 2 D C
#     #
# ### #  4 7 8 B
# # # #
### ###  5 6 9 A
                +-----------+-----------+
# ##### ##### # |00 03 04 05|3A 3B 3C 3F|
# #   # #   # # |           |           |
### ### ### ### |01 02 07 06|39 38 3D 3E|
    #     #     |           |           |
### ### ### ### |0E 0D 08 09|36 37 32 31|
# #   # #   # # |           |           |
# ##### ##### # |0F 0C 0B 0A|35 34 33 30|
#             # +-----+-----+           |
### ####### ### |10 11|1E 1F|20 21 2E 2F|
  # #     # #   |     |     |           |
### ### ### ### |13 12|1D 1C|23 22 2D 2C|
#     # #     # |     +-----+           |
# ### # # ### # |14 17|18 1B|24 27 28 2B|
# # # # # # # # |     |     |           |
### ### ### ### |15 16|19 1A|25 26 29 2A|
                +-----+-----+-----------+

I've drawn in allocations for 16, 8, 4, 5, 32 pages in that order in
the last one. The idea is to get near pages visually near in the
output and into an area instead of lines. Easier on the eye. It also
manages to always draw aligned order(x) blocks as squares or rectanges
(even or odd order).

>> Maybe instead of reserving one could say that you can have up to 6
>> groups of space
>
> And if the groups are 1GB in size? I tried something like this already.
> It didn't work out well at the time although I could revisit.

You adjust group size with the number of groups total. You would not
use 1GB Huge Pages on a 2GB ram system. You could try 2MB groups. I
think for most current systems we are lucky there. 2MB groups fit
hardware support and give a large but not too large number of groups
to work with.

But you only need to stick to hardware suitable group sizes for huge
tlb support right? For better I/O and such you could have 512Kb groups
if that size gives a reasonable number of groups total.

>> not used by unmovable objects before aggressive moving
>> starts. I don't quite see why you NEED reserving as long as there is
>> enough space free alltogether in case something needs moving.
>
> hence, increase min_free_kbytes.

Which is different from reserving a full group as it does not count
fragmented space as lost.

>> 1 group
>> worth of space free might be plenty to move stuff too. Note that all
>> the virtual pages can be stuffed in every little free space there is
>> and reassembled by the MMU. There is no space lost there.
>> 
>
> What you suggest sounds similar to having a type MIGRATE_MIXED where you
> allocate from when the preferred lists are full. It became a sizing
> problem that never really worked out. As I said, I can try again.

Not realy. I'm saying we should actively defragment mixed groups
during allocation and always as little as possible when a certain
level of external fragmentation is reached. A MIGRATE_MIXED sounds
like giving up completly if things get bad enough. Compare it to a
cheap network switch going into hub mode when its arp table runs full.
If you ever had that then you know how bad that is.

>> But until one tries one can't say.
>> 
>> MfG
>>         Goswin
>> 
>> PS: How do allocations pick groups?
>
> Using GFP flags to identify the type.

That is the type of group, not which one.

>> Could one use the oldest group
>> dedicated to each MIGRATE_TYPE?
>
> Age is difficult to determine so probably not.

Put the uptime as sort key into each group header on creation or type
change. Then sort the partialy used groups by that key. A heap will do
fine and be fast.

>> Or lowest address for unmovable and
>> highest address for movable? Something to better keep the two out of
>> each other way.
>
> We bias the location of unmovable and reclaimable allocations already. It's
> not done for movable because it wasn't necessary (as they are easily
> reclaimed or moved anyway).

Except that is never done so doesn't count.

MfG
        Goswin
