Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXD0JXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXD0JXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbXD0JXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:23:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:54807 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755519AbXD0JXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:23:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nOgAQynYnnh1WbCd5NNCYIyGuOR5HCuIxHOpHQT
	2/CxyRKxgQ2Tx3
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 11:23:41 +0200
Message-Id: <1177665821.6462.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 01:33 -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 09:59:27 +0200 Mike Galbraith <efault@gmx.de> wrote:
> 
> > Greetings,
> > 
> > As subject states, my GUI is going away for extended periods of time
> > when my very full and likely highly fragmented (how to find out)
> > filesystem is under heavy write load.  While write is under way, if
> > amarok (mp3 player) is running, no song change will occur until write is
> > finished, and the GUI can go _entirely_ comatose for very long periods.
> > Usually, it will come back to life after write is finished, but
> > occasionally, a complete GUI restart is necessary.
> 
> I'd be suspecting a GUI bug if a restart is necessary.  Perhaps it went to
> lunch for so long in the kernel that some time-based thing went bad.

Yeah, there have been some KDE updates, maybe something went south.  I
know for sure that nothing this horrible used to happen during IO.  But
then when I used to regularly test IO, my disk heads didn't have to
traverse nearly as much either.

> Right.  One possibility here is that bonnie is stuffing new dirty blocks
> onto the committing transaction's ordered-data list and JBD commit is
> livelocking.  Only we're not supposed to be putting those blocks on that
> list.
> 
> Another livelock possibility is that bonnie is redirtying pages faster than
> commit can write them out, so commit got livelocked:
> 
> When I was doing the original port-from-2.2 I found that an application
> which does
> 
> 	for ( ; ; )
> 		pwrite(fd, "", 1, 0);
> 
> would permanently livelock the fs.  I fixed that, but it was six years ago,
> and perhaps we later unfixed it.

I'll try that.

> It would be most interesting to try data=writeback.

Seems somewhat better, but nothing close to tolerable.  I still had to
hot-key to a VT and kill the bonnie.

> hm, fsync.
> 
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.

I thought unkind thoughts when I saw those traces :)

	Thanks,

	-Mike

