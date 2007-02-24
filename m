Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXBXWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXBXWgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXBXWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:36:52 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:34478 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbXBXWgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:36:51 -0500
Date: Sat, 24 Feb 2007 17:35:13 -0500
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       "Juan Piernas Canovas" <piernas@ditec.um.es>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
From: "Sorin Faibish" <sfaibish@emc.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org> <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es> <20070222162547.GB7149@lazybastard.org> <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es> <20070223132645.GB11653@lazybastard.org>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tn9yczjerwwil4@usenlvincenl3e.eng.emc.com>
In-Reply-To: <20070223132645.GB11653@lazybastard.org>
User-Agent: Opera Mail/9.00 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.24.141434
X-PerlMx-Spam: Gauge=, SPAM=2%, Reasons='EMC_FROM_0+ -2, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jorg,

I am very found of all your comments and your positive attitude
on DualFS. I also understand that you have much more experience
than us in regard to GC and "cleaners". DualFS implementation is
using maybe old technology that can be definetly improved. Although
we understand the value of DualFS I don't believe we had the
intention to solve all the file systems issues but to address
some that are critical for the Linux users. We would be very
happy to improve DualFS cleaner based on your experience. So,
if you are interested we can rewrite/rearchitect the cleaner
using your ideas. After all we all want to have better FSs
for Linux and we believe that there is goodness in DualFS.

On Fri, 23 Feb 2007 08:26:45 -0500, Jörn Engel <joern@lazybastard.org>  
wrote:

> On Thu, 22 February 2007 20:57:12 +0100, Juan Piernas Canovas wrote:
>>
>> I do not agree with this picture, because it does not show that all the
>> indirect blocks which point to a direct block are along with it in the
>> same segment. That figure should look like:
>>
>> Segment 1: [some data] [ DA D1' D2' ] [more data]
>> Segment 2: [some data] [ D0 D1' D2' ] [more data]
>> Segment 3: [some data] [ DB D1  D2  ] [more data]
>>
>> where D0, DA, and DB are datablocks, D1 and D2 indirect blocks which
>> point to the datablocks, and D1' and D2' obsolete copies of those
>> indirect blocks. By using this figure, is is clear that if you need to
>> move D0 to clean the segment 2, you will need only one free segment at
>> most, and not more. You will get:
>>
>> Segment 1: [some data] [ DA D1' D2' ] [more data]
>> Segment 2: [                free                ]
>> Segment 3: [some data] [ DB D1' D2' ] [more data]
>> ......
>> Segment n: [ D0 D1 D2 ] [         empty         ]
>>
>> That is, D0 needs in the new segment the same space that it needs in the
>> previous one.
>>
>> The differences are subtle but important.
>
> Ah, now I see.  Yes, that is deadlock-free.  If you are not accounting
> the bytes of used space but the number of used segments, and you count
> each partially used segment the same as a 100% used segment, there is no
> deadlock.
>
> Some people may consider this to be cheating, however.  It will cause
> more than 50% wasted space.  All obsolete copies are garbage, after all.
> With a maximum tree height of N, you can have up to (N-1) / N of your
> filesystem occupied by garbage.
>
> It also means that "df" will have unexpected output.  You cannot
> estimate how much data can fit into the filesystem, as that depends on
> how much garbage you will accumulate in the segments.  Admittedly this
> is not a problem for DualFS, as the uncertainty only exists for
> metadata, do "df" for DualFS still makes sense.
>
> Another downside is that with large amounts of garbage between otherwise
> useful data, your disk cache hit rate goes down.  Read performance is
> suffering.  But that may be a fair tradeoff and will only show up in
> large metadata reads in the uncached (per Linux) case.  Seems fair.
>
> Quite interesting, actually.  The costs of your design are disk space,
> depending on the amount and depth of your metadata, and metadata read
> performance.  Disk space is cheap and metadata reads tend to be slow for
> most filesystems, in comparison to data reads.  You gain faster metadata
> writes and loss of journal overhead.  I like the idea.
>
> Jörn
>

/Sorin


