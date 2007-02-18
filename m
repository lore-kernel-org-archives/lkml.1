Return-Path: <linux-kernel-owner+w=401wt.eu-S965479AbXBRGLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965479AbXBRGLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965561AbXBRGLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:11:24 -0500
Received: from lazybastard.de ([212.112.238.170]:37222 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965479AbXBRGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:11:23 -0500
Date: Sun, 18 Feb 2007 05:59:37 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Sorin Faibish <sfaibish@emc.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070218055936.GF301@lazybastard.org>
References: <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 February 2007 15:47:01 -0500, Sorin Faibish wrote:
>
> DualFS can probably get around this corner case as it is up to the user
> to select the size of the MD device size. If you want to prevent this
> corner case you can always use a device bigger than 10% of the data device
> which is exagerate for any FS assuming that the directory files are so
> large (this is when you have billions of files with long names).
> In general the problem you mention is mainly due to the data blocks
> filling the file system. In DualFS case you have the choice of selecting
> different sizes for the MD and Data volume. When Data volume gets full
> the GC will have a problem but the MD device will not have a problem.
> It is my understanding that most of the GC problem you mention is
> due to the filling of the FS with data and the result is a MD operation
> being disrupted by the filling of the FS with data blocks. As about the
> performance impact on solving this problem, as you mentioned all
> journal FSs will have this problem, I am sure that DualFS performance
> impact will be less than others at least due to using only one MD
> write instead of 2.

You seem to make the usual mistakes when people start to think about
this problem.  But I could misinterpret you, so let me paraphrase your
mail in questions and answer what I believe you said.

Q: Are journaling filesystems identical to log-structured filesystems?

Not quite.  Journaling filesystems usually have a very small journal (or
log, same thing) and only store the information necessary for atomic
transactions in the journal.  Not sure what a "journal FS" is, but the
name seems closer to a journaling filesystem.

Q: DualFS seperates Data and Metadata.  Does that make a difference?

Not really.  What I called "data" in my previous mail is a
log-structured filesystems view of data.  DualFS stored file content
seperately, so from an lfs view, that doesn't even exist.  But directory
content exists and behaves just like file content wrt. the deadlock
problem.  Any data or metadata that cannot be GC'd by simply copying but
requires writing further information like indirect blocks, B-Tree nodes,
etc. will cause the problem.

Q: If the user simply reserves some extra space, does the problem go
away?

Definitely not.  It will be harder to hit, but a rare deadlock is still
a deadlock.  Again, this is only concerned with the log-structured part
of DualFS, so we can ignore the Data volume.

When data is spread perfectly across all segments, the best segment one
can pick for GC is just as bad as the worst.  So let us take some
examples.  If 50% of the lfs is free, you can pick a 50% segment for GC.
Writing every single block in it may require writing one additional
indirect block, so GC is required to write out a 100% segment.  It
doesn't make any progress at 50% (in a worst case scenario) and could
deadlock if less than 50% were free.

If, however, GC has to write out a singly and a doubly indirect block,
67% of the lfs need to be free.  In general, if the maximum height of
your tree is N, you need (N-1)/N * 100% free space.  Most people refer
to that as "too much".

If you have less free space, the filesystem will work just fine "most of
the time".  That is nice and cool, but it won't help your rare user that
happens to hit the rare deadlock.  Any lfs needs a strategy to prevent
this deadlock for good, not just make it mildly unlikely.

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
