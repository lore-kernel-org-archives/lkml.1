Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXLFPLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXLFPLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXLFPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:11:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39138 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbXLFPLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:11:37 -0500
Date: Thu, 6 Dec 2007 20:40:12 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/5] Union Mount: A Directory listing approach with
	lseek support
Message-ID: <20071206151012.GA30922@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071205143718.GC2471@in.ibm.com> <1196875318.18685.24.camel@localhost> <20071206100118.GA19903@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206100118.GA19903@hasse.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 11:01:18AM +0100, Jan Blunck wrote:
> On Wed, Dec 05, Dave Hansen wrote:
> 
> > I think the key here is what kind of consistency we're trying to
> > provide.  If a directory is being changed underneath a reader, what
> > kinds of guarantees do they get about the contents of their directory
> > read?  When do those guarantees start?  Are there any at open() time?
> 
> But we still want to be compliant to what POSIX defines. The problem isn't the
> consistency of the readdir result but the seekdir/telldir interface. IMHO that
> interface is totally broken: you need to be able to find every offset given by
> telldir since the last open. The problem is that seekdir isn't able to return
> errors. Otherwise you could just forbid seeking on union directories.

Also, what kind of consistency is expected when a directory is open(2)ed
and readdir(2) and lseek(2) are applied to it when the directory gets
changed underneath the reader. From this:
http://www.opengroup.org/onlinepubs/009695399/functions/lseek.html
the behaviour/guarantees wasn't apparent to me.

> 
> > Rather than give each _dirent_ an offset, could we give each sub-mount
> > an offset?  Let's say we have three members comprising a union mount
> > directory.  The first has 100 dirents, the second 200, and the third
> > 10,000.  When the first readdir is done, we populate the table like
> > this:
> > 
> > 	mount_offset[0] = 0;
> > 	mount_offset[1] = 100;
> > 	mount_offset[2] = 300;
> > 
> > If someone seeks back to 150, then we subtrack the mount[1]'s offset
> > (100), and realize that we want the 50th dirent from mount[1].
> 
> Yes, that is a nice idea and it is exactly what I have implemented in my patch
> series. But you forgot one thing: directories are not flat files. The dentry
> offset in a directory is a random cookie. Therefore it is not possible to have
> a linear mapping without allocating memory.

And I defined this linear behaviour on the cache of dirents we maintain
in the approach I posted. And the main reason we maintain cache of
dirents in memory is for duplicate elimination.

> 
> > I don't know whether we're bound to this:
> > 
> > http://www.opengroup.org/onlinepubs/007908775/xsh/readdir.html
> >         
> >         "If a file is removed from or added to the directory after the
> >         most recent call to opendir() or rewinddir(), whether a
> >         subsequent call to readdir() returns an entry for that file is
> >         unspecified."
> > 
> > But that would seem to tell me that once you populate a table such as
> > the one I've described and create it at open(dir) time, you don't
> > actually ever need to update it.
> 
> Yes, I'm using such a patch on our S390 buildservers to work around some
> readdir/seek/rm problem with old glibc versions. It seems to work but on the
> other hand this are really huge systems and I haven't run out of memory while
> doing a readdir yet ;)
> 
> The proper way to implement this would be to cache the offsets on a per inode
> base. Otherwise the user could easily DoS this by opening a number of
> directories and never close them.
> 

You mean cache the offsets or dirents ? How would that solve
the seek problem ? How would it enable you to define a seek behaviour
for the entire union of directories ?

Regards,
Bharata.
