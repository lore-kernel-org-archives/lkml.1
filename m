Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYEKQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYEKQmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYEKQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:42:27 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53216 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYEKQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:42:26 -0400
Date: Sun, 11 May 2008 22:12:14 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       Morten Welinder <mwelinder@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080511164214.GA8091@skywalker>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com> <20080508081906.GY3700@mea-ext.zmailer.org> <20080511111652.GA2323@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511111652.GA2323@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 07:16:53AM -0400, Christoph Hellwig wrote:
> On Thu, May 08, 2008 at 11:19:06AM +0300, Matti Aarnio wrote:
> > This very question has troubled SQUID developers.  Whatever the system, unlink()
> > that really does free diskspace does so with unbound timelimit and in services
> > where one millisecond is long wait time, the solution has been to run separate
> > subprocess that actually does the unlinks.
> > 
> > Squid is not threaded software, and it was created long ago when threads were
> > rare and implementations were different in subtle details --> no threads at all.
> 
> I'd call long times for the final unlink a bug in the filesystem.
> There's not all that much to do when deleting a file.   What you need to
> do is basically return the allocated space to the free space allocator
> and mark the inode as unused and return it to the inode allocator.  The
> first one may take quite a while with a indirect block scheme, but with
> an extent based filesystem it shouldn't be a problem.  The latter
> shouldn't take too long either, and with a journaling filesystem it's
> even easier because you can intent-log the inode deletion first and then
> perform it later e.g. as part of a batched write-back of the inode
> cluster.

The problem with journalling file system like ext3 is that the credits
available in the journal may not be sufficient for full truncate. In
that case we will have to commit the journal. And that means we will
have to zero fill some of the indirect blocks so that when the
transaction is committed the inode format is a valid one.

For ext3 there are patches from abhishek that actually speed up
meta-data intensive operation. Eric Sandeen did some measurements
here.

http://people.redhat.com/esandeen/rm_test/

I have patches for Ext4 based on top of the new block allocator for
Ext4. There is some improvment with Ext3 mode.

http://www.radian.org/~kvaneesh/ext4/meta-group/

-aneesh
