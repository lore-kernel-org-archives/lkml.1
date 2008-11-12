Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYKLUxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYKLUxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYKLUxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:53:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbYKLUxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:53:15 -0500
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in
 core inodes
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, viro@zeniv.linux.org.uk,
       arjan@infradead.org, greg@kroah.com, tytso@mit.edu,
       akpm@linux-foundation.org
In-Reply-To: <20081112165820.GA26217@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	 <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
	 <20081112165055.GB19669@infradead.org>
	 <20081112165638.54c38c5c@lxorguk.ukuu.org.uk>
	 <20081112165820.GA26217@infradead.org>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 15:52:29 -0500
Message-Id: <1226523149.3353.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:58 -0500, Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 04:56:38PM +0000, Alan Cox wrote:
> > Sounds a good way of ruining the performance.
> 
> I don't think you can ruine performance of a system with AV systems
> running even more.  While bloating the inode does cause enormous
> problems in file serving or other extremly metadata intensive workloads.

Kernel Build on a 32 way machine:
Stock kernel: 9 minutes 12 seconds
fanotify no in kernel fastpath: 95 minutes 12 seconds
Only events AV wants with in kernel fastpath: 10 minutes 35 seconds

Now I could probably redo the in kernel cache as some sort of per group
inode hash table of entries which wouldn't have to bloat the inode but
it would be much more expensive in terms of performance.  A lock and an
list if you want to use fanotify is as small as it can be made an is
exactly the same method taken by inotify.

************

I probably should have put this up in the patch description rather than
burried down in the Documentation directory but here it is:

The need for fastpaths (or calling what it really is, an in kernel
cache) has been questioned.  I decided to include a little unscientific data
here.  On a 32 way machine a make -j 32 took about 9 minutes 12 seconds.
With that same machine running having one group and 32 listeners receiving
every fanotify event that the kernel could send to userspace while the 
listeners were responding to accesses as fast as they could (just a very tight get
event, allow loop) it took 95 minutes 12 seconds.  Same process with in kernel
fastpaths/cache results took 19 minutes 5 seconds.  More reasonable event
requirements and a single listener took 10 minutes 35 sec.  So about a 15%
perf hit to do any kind of permission checking to userspace.  Anyway, the need
for fastpaths is quite clear.




