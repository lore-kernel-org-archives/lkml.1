Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbXBWO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbXBWO2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXBWO2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:28:18 -0500
Received: from lazybastard.de ([212.112.238.170]:43537 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbXBWO2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:28:17 -0500
Date: Fri, 23 Feb 2007 13:26:45 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070223132645.GB11653@lazybastard.org>
References: <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org> <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es> <20070222162547.GB7149@lazybastard.org> <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 February 2007 20:57:12 +0100, Juan Piernas Canovas wrote:
> 
> I do not agree with this picture, because it does not show that all the 
> indirect blocks which point to a direct block are along with it in the 
> same segment. That figure should look like:
> 
> Segment 1: [some data] [ DA D1' D2' ] [more data]
> Segment 2: [some data] [ D0 D1' D2' ] [more data]
> Segment 3: [some data] [ DB D1  D2  ] [more data]
> 
> where D0, DA, and DB are datablocks, D1 and D2 indirect blocks which 
> point to the datablocks, and D1' and D2' obsolete copies of those 
> indirect blocks. By using this figure, is is clear that if you need to 
> move D0 to clean the segment 2, you will need only one free segment at 
> most, and not more. You will get:
> 
> Segment 1: [some data] [ DA D1' D2' ] [more data]
> Segment 2: [                free                ]
> Segment 3: [some data] [ DB D1' D2' ] [more data]
> ......
> Segment n: [ D0 D1 D2 ] [         empty         ]
> 
> That is, D0 needs in the new segment the same space that it needs in the 
> previous one.
> 
> The differences are subtle but important.

Ah, now I see.  Yes, that is deadlock-free.  If you are not accounting
the bytes of used space but the number of used segments, and you count
each partially used segment the same as a 100% used segment, there is no
deadlock.

Some people may consider this to be cheating, however.  It will cause
more than 50% wasted space.  All obsolete copies are garbage, after all.
With a maximum tree height of N, you can have up to (N-1) / N of your
filesystem occupied by garbage.

It also means that "df" will have unexpected output.  You cannot
estimate how much data can fit into the filesystem, as that depends on
how much garbage you will accumulate in the segments.  Admittedly this
is not a problem for DualFS, as the uncertainty only exists for
metadata, do "df" for DualFS still makes sense.

Another downside is that with large amounts of garbage between otherwise
useful data, your disk cache hit rate goes down.  Read performance is
suffering.  But that may be a fair tradeoff and will only show up in
large metadata reads in the uncached (per Linux) case.  Seems fair.

Quite interesting, actually.  The costs of your design are disk space,
depending on the amount and depth of your metadata, and metadata read
performance.  Disk space is cheap and metadata reads tend to be slow for
most filesystems, in comparison to data reads.  You gain faster metadata
writes and loss of journal overhead.  I like the idea.

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
