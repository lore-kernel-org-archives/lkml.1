Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXBVQ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXBVQ3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXBVQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:29:05 -0500
Received: from lazybastard.de ([212.112.238.170]:47494 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXBVQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:29:04 -0500
Date: Thu, 22 Feb 2007 16:25:48 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070222162547.GB7149@lazybastard.org>
References: <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org> <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 February 2007 05:30:03 +0100, Juan Piernas Canovas wrote:
> 
> DualFS writes meta-blocks in variable-sized chunks that we call partial 
> segments. The meta-data device, however, is divided into segments, which 
> have the same size. A partial segment can be as large a a segment, but a 
> segment usually has more that one partial segment. Besides, a partial 
> segment can not cross a segment boundary.

Sure, that's a fairly common approach.

> A partial segment is a transaction unit, and contains "all" the blocks 
> modified by a file system operation, including indirect blocks and i-nodes 
> (actually, it contains the blocks modified by several file system 
> operations, but let us assume that every partial segment only contains the 
> blocks modified by a single file system operation).
> 
> So, the above figure is as follows in DualFS:
> 
>  Before:
>  Segment 1: [some data] [ D0 D1 D2 I ] [more data]
>  Segment 2: [             some data              ]
>  Segment 3: [               empty                ]
> 
> If the datablock D0 is modified, what you get is:
> 
>  Segment 1: [some data] [  garbage   ] [more data]
>  Segment 2: [             some data              ]
>  Segment 3: [ D0 D1 D2 I ] [       empty         ]

You have fairly strict assumptions about the "Before:" picture.  But
what happens if those assumptions fail.  To give you an example, imagine
the following small script:

$ for i in `seq 1000000`; do touch $i; done

This will create a million dentries in one directory.  It will also
create a million inodes, but let us ignore those for a moment.  It is
fairly unlikely that you can fit a million dentries into [D0], so you
will need more than one block.  Let's call them [DA], [DB], [DC], etc.
So you have to write out the first block [DA].

 Before:
Segment 1: [some data] [ DA D1 D2 I ] [more data]
Segment 2: [             some data              ]
Segment 3: [               empty                ]

If the datablock D0 is modified, what you get is:

Segment 1: [some data] [  garbage   ] [more data]
Segment 2: [             some data              ]
Segment 3: [ DA D1 D2 I ] [       empty         ]

That is exactly your picture.  Fine.  Next you write [DB].

Before: see above
After:
Segment 1: [some data] [  garbage   ] [more data]
Segment 2: [             some data              ]
Segment 3: [ DA][garbage] [ DB D1 D2 I ] [ empty]

You write [DC].  Note that Segment 3 does not have enough space for
another partial segment:

Segment 1: [some data] [  garbage   ] [more data]
Segment 2: [             some data              ]
Segment 3: [ DA][garbage] [ DB][garbage] [wasted]
Segment 4: [ DC D1 D2 I ] [       empty         ]

You write [DD] and [DE]:
Segment 1: [some data] [  garbage   ] [more data]
Segment 2: [             some data              ]
Segment 3: [ DA][garbage] [ DB][garbage] [wasted]
Segment 4: [ DC][garbage] [ DD][garbage] [wasted]
Segment 5: [ DE D1 D2 I ] [       empty         ]

And some time later you even have to switch to a new indirect block, so
you get before:

Segment n  : [ DX D1 D2 I ] [       empty         ]

After:

Segment n  : [ DX D1][garb] [ DY DI D2 I ] [ empty]

What you end up with after all this is quite unlike you "Before"
picture.  Instead of this:

>  Segment 1: [some data] [ D0 D1 D2 I ] [more data]

You may have something closer to this:

> >Segment 1: [some data] [   D1  ] [more data]
> >Segment 2: [some data] [   D0  ] [more data]
> >Segment 3: [some data] [   D2  ] [more data]

You should try the testcase and look at a dump of your filesystem
afterwards.  I usually just read the raw device in a hex editor.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
