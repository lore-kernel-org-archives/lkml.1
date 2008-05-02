Return-Path: <linux-kernel-owner+w=401wt.eu-S935802AbYEBUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935802AbYEBUWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764806AbYEBUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:22:11 -0400
Received: from lazybastard.de ([212.112.238.170]:49199 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764798AbYEBUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:22:10 -0400
Date: Fri, 2 May 2008 22:21:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502202151.GB24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 10:17:28 -0700, Linus Torvalds wrote:
> On Fri, 2 May 2008, Jörn Engel wrote:
> > 
> > not being familiar with either maintaining my own git tree or the -next
> > process, I'd still like to get logfs into mainline.  It has gone through
> > six rounds of reviews and the last has been mostly about crossing some
> > i's here and dotting some t's there.
> 
> The thing I'd like to see is:
> 
>  - a more recent description of file system layout
> 
>    I've read the original paper, and I assume things have changed when 
>    implementing stuff. They always do.

The big picture has largely stayed the same, but many details haven't.
Will do.

>  - some benchmarks and/or comments about regular usage (ie fragmentation 
>    etc). Yeah, it doesn't need to be all that extensive, but quite 
>    frankly, it sounds like this is meant to be at least a partial 
>    replacement for a GP filesystem (considering that seek/rotational 
>    delay are going away) and people are working on it with USB memory 
>    sticks etc, wouldn't it make sense to talk about disk usage (how much 
>    the GC wants free etc) and everyday performance?

Currently performance sucks badly on block device flashes (usb stick,
etc.) when creating/removing/renaming files.  The combination of logfs
and the built-in logic can result in 1-2MB of data written to create a
single empty file.  Yuck!

"Real" block devices or real flash suffer a lot less and writing large
amounts of data to existing files doesn't have this problem either.

Fragmentation is neither actively avoided nor actively enforced.  If the
workload writes files single-threaded, it will initially be fairly good.
Over time GC will stir the soup and fragmentation grows.  Several
parallel writers give a pretty bad result for seek-bound devices, even
initially.

GC wants 4095 + 28 bytes per segment (128KiB by default) to deal with
not-quite-100% filled segments plus one free segment per level (12 by
default, could become an mkfs option).  Add the journal and superblock
for about 2MiB minimum overhead.  Some embedded people with 32MiB
devices worry about that, although arguably they should still use jffs2
if minimal space overhead is a big issue.

I guess the above could go into Documentation/filesystems/logfs.txt.
And some more.

Jörn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
