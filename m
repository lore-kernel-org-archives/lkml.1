Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783Ab0AHPTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0AHPTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514Ab0AHPTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:19:22 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:58600 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753247Ab0AHPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:19:21 -0500
Date: Sat, 9 Jan 2010 02:19:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
Message-ID: <20100108151915.GC8654@discord.disaster>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp> <20100108123641.GB8654@discord.disaster> <201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 10:15:10PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > On Fri, Jan 08, 2010 at 11:54:24AM +0900, Tetsuo Handa wrote:
> > > I'm experiencing file corruption problem.
> > > Can somebody reproduce below result?
> > > 
> > > My environment:
> > >   VMware Workstation 6.5.3 with 2CPUs / 512MB RAM.
> > >   ext3 filesystem ( /dev/sda1 ) mounted on / .
> > > 
> > >   2.6.33-rc3 ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.33-rc3-ext3 )
> > >   2.6.32.3   ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.32.3-ext3 )
> > >   2.6.31.11  ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.31.11-ext3 )
> > >   2.6.30.10
> > > 
> > >   So far, I haven't succeeded to reproduce this problem for 2.6.29 and earlier.
> > >   Maybe this problem exists in only 2.6.30 and later.
> > 
> > Isn't that when the default mount options  changed from data=ordered to
> > data=writeback?
> Ah, indeed. 2.6.31 mounts data=writeback whereas 2.6.29 mounts data=ordered.
> 
> In my Ubuntu 9.10 environment, it is using data=writeback mode, and therefore
> I got garbage data taken from other deleted files.
> 
> > You didn't fsync() it, so there is no reason for the kernel
> > to have ever written it to disk. Therefore the result after powerfail
> > is completely undefined - you data may be there, it may not...
> 
> I didn't call fsync(). Thus, I don't mind if the data I wrote is not written
> to disk.

Ok, I was making sure you weren't misunderstanding what the fflush()
is supposed to guarantee - many people do, but you're not one of
them :)

> However, I feel something is very wrong because the file got data which I
> didn't write. The file gets data from deleted files. Imagine that unprivileged
> user can get the content of /etc/shadow if power failure occurred when the user
> was running ./a.out .

Ah, so it was stale data you were seeing.

> The file should not get data from deleted files, but I can read the data from
> deleted files by "cat /testfile". I feel something is very wrong.

I agree that it is very wrong, but it's a known problem with writeback
mode in ext3:

http://thread.gmane.org/gmane.linux.kernel/818044/focus=819977

More info as to how this change came about and the proposed but not
yet realised fixes:

http://lwn.net/Articles/328363/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
