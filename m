Return-Path: <linux-kernel-owner+w=401wt.eu-S1422830AbXBUT2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422830AbXBUT2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXBUT2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:28:34 -0500
Received: from lazybastard.de ([212.112.238.170]:53529 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422830AbXBUT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:28:33 -0500
Date: Wed, 21 Feb 2007 19:25:23 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070221192523.GG3219@lazybastard.org>
References: <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 February 2007 19:31:40 +0100, Juan Piernas Canovas wrote:
> 
> I do not understand. Do you mean that if I have 10 segments, 5 busy and 5 
> free, after cleaning I could need 6 segments? How? Where the extra blocks 
> come from?

This is a fairly complicated subject and I have trouble explaining it to
people - even though I hope that maybe one or two dozen understand it by
now.  So let me try to give you an example:

In LogFS, inodes are stored in an inode file.  There are no B-Trees yet,
so the regular unix indirect blocks are used.  My example will be
writing to a directory, so that should only involve metadata by your
definition and be a valid example for DualFS as well.  If it is not,
please tell me where the difference lies.

The directory is large, so appending to it involves writing a datablock
(D0), and indirect block (D1) and a doubly indirect block (D2).

Before:
Segment 1: [some data] [   D1  ] [more data]
Segment 2: [some data] [   D0  ] [more data]
Segment 3: [some data] [   D2  ] [more data]
Segment 4: [             empty             ]
...

After:
Segment 1: [some data] [garbage] [more data]
Segment 2: [some data] [garbage] [more data]
Segment 3: [some data] [garbage] [more data]
Segment 4: [D0][D1][D2][      empty        ]
...

Ok.  After this, the position of D2 on the medium has changed.  So we
need to update the inode and write that as well.  If the inode number
for this directory is high, we will need to write the inode (I0), an
indirect block (I1) and a doubly indirect block (I2).  The picture
becomes a bit more complicates.

Before:
Segment 1: [some data] [   D1  ] [more data]
Segment 2: [some data] [   D0  ] [more data]
Segment 3: [some data] [   D2  ] [more data]
Segment 4: [             empty             ]
Segment 5: [some data] [   I1  ] [more data]
Segment 6: [some data] [   I0  ] [more data]
Segment 7: [some data] [   I2  ] [more data]
...

After:
Segment 1: [some data] [garbage] [more data]
Segment 2: [some data] [garbage] [more data]
Segment 3: [some data] [garbage] [more data]
Segment 4: [D0][D1][D2][I0][I1][I2][ empty ]
Segment 5: [some data] [garbage] [more data]
Segment 6: [some data] [garbage] [more data]
Segment 7: [some data] [garbage] [more data]
...

So what has just happened?  The user did a single "touch foo" in a large
directory and has caused six objects to move.  Unless some of those
objects were in the same segment before, we now have six segments
containing a tiny amount of garbage.

And there is almost no way how you can squeeze that garbage back out.
The cleaner will fundamentally do the same thing as a regular write - it
will move objects.  So if you want to clean a segment containing the
block of a different directory, you may again have to move five
additional objects, the indirect blocks, inode and ifile indirect
blocks.

At this point, your cleaner is becoming a threat.  There is a real
danger that it will create more garbage in unrelated segments than it
frees up.  I claim that you cannot keep 50% clean segments, unless you
move away from the simplistic cleaner I described above.

Jörn

-- 
If you're willing to restrict the flexibility of your approach,
you can almost always do something better.
-- John Carmack
