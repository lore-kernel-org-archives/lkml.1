Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXEQROy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXEQROy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXEQROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:14:46 -0400
Received: from lazybastard.de ([212.112.238.170]:48163 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbXEQROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:14:45 -0400
Date: Thu, 17 May 2007 19:10:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070517171017.GB15676@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070517160308.GA26643@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 20:03:11 +0400, Evgeniy Polyakov wrote:
> 
> Is logfs 32bit fs or 674bit, since although you use 64bit values for
> offsets, area management and strange converstions like described below 
> from offset into segment number are performed in 32bit?
> Is it enough for SSD for example to be 32bit only? Or if it is 64bit,
> could you please explain logic behind area management?

Ignoring bugs and signed return values for error handling, it is either
64bit or 32+32bit.

Inode numbers and file positions are 64bit.  Offsets are 64bit as well.
In a couple of places, offsets are also 32+32bit.  Basically the high
bits contain the segment number, the lower bits the offset within a
segment.

Side note: It would be nicer if the high 32bit were segment number.
Instead the number of bits depends on segment size.  Guess I should
change that while the format isn't fixed yet.

An "area" is a segment that is currently being written.  Data is
appended to this segment as it comes in, until the segment is full.  Any
functions dealing with areas only need a 32bit offset, which is the
offset within the area, not the absolute device offset.

Writes within an area are also buffered.  New data first goes into the
write buffer (wbuf) and only when this is full is it flushed to the
device.  NAND flash and some NOR flashes require such buffering.  When
writing to the device, the 32bit segno and the 32bit in-segment offset
need to get converted back to a 64bit device offset.

> I've found that you store segment numbers as 32bit values (for example
> in prepare_write()), and convert requested 64bit offset into segment
> number via superblock's s_segshift.

Yes, as described above.

> This conversation seems confusing to me in case of real 64bit offsets.
> For example this one obtained via prepare_write:
> 
> 7  1 logfs_prepare_write    78  fs/logfs/file.c
> 8  2 logfs_readpage_nolock    20  fs/logfs/file.c
> 9  1 logfs_read_block   351  fs/logfs/readwrite.c
> 10  1 logfs_read_loop   139  fs/logfs/readwrite.c
> 11  2 logfs_segment_read   108  fs/logfs/readwrite.c
> 12  1 wbuf_read         289 
> 
> u32 segno = ofs >> super->s_segshift;
> 
> ofs is originally obtained from inode's li_data array, which is filled
> with raw segment numbers which can be 64bit (here is another issue,
> since logfs_segment_write() returns signed, so essentially logfs is
> 63bit filesystem).

The filesystem format is 64bit.  The current code can only deal with
63bit.  Eric Sandeen just fixed ext2 to actually deal with 32bit
numbers and the same is possible for logfs.  If anyone ever cares...

> But here I've came to area management in logfs, and found that it is
> 32bit only, for example __logfs_segment_write()/__logfs_get_free_bytes() 
> returns signed 32 bit value (so it is reduced to 31 bit), which is then 
> placed into li_data as 64bit value. The latter
> (__logfs_get_free_bytes()) truncates 64bit data value obtained via
> dev_ofs() into signed 32 bit value.

That indeed is a bug.  __logfs_get_free_bytes() should return s64
instead of s32.  Will fix immediatly.

If anyone can find similar bugs, the bounty is a beer or non-alcoholic
beverage of choice. :)

Jörn

-- 
To announce that there must be no criticism of the President, or that we
are to stand by the President, right or wrong, is not only unpatriotic
and servile, but is morally treasonable to the American public.
-- Theodore Roosevelt, Kansas City Star, 1918
