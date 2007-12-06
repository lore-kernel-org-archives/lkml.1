Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbXLFKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbXLFKBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXLFKB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:01:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:33614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbXLFKBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:01:25 -0500
Date: Thu, 6 Dec 2007 11:01:18 +0100
From: Jan Blunck <jblunck@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/5] Union Mount: A Directory listing approach with
	lseek support
Message-ID: <20071206100118.GA19903@hasse.suse.de>
References: <20071205143718.GC2471@in.ibm.com> <1196875318.18685.24.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196875318.18685.24.camel@localhost>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, Dave Hansen wrote:

> I think the key here is what kind of consistency we're trying to
> provide.  If a directory is being changed underneath a reader, what
> kinds of guarantees do they get about the contents of their directory
> read?  When do those guarantees start?  Are there any at open() time?

But we still want to be compliant to what POSIX defines. The problem isn't the
consistency of the readdir result but the seekdir/telldir interface. IMHO that
interface is totally broken: you need to be able to find every offset given by
telldir since the last open. The problem is that seekdir isn't able to return
errors. Otherwise you could just forbid seeking on union directories.

> Rather than give each _dirent_ an offset, could we give each sub-mount
> an offset?  Let's say we have three members comprising a union mount
> directory.  The first has 100 dirents, the second 200, and the third
> 10,000.  When the first readdir is done, we populate the table like
> this:
> 
> 	mount_offset[0] = 0;
> 	mount_offset[1] = 100;
> 	mount_offset[2] = 300;
> 
> If someone seeks back to 150, then we subtrack the mount[1]'s offset
> (100), and realize that we want the 50th dirent from mount[1].

Yes, that is a nice idea and it is exactly what I have implemented in my patch
series. But you forgot one thing: directories are not flat files. The dentry
offset in a directory is a random cookie. Therefore it is not possible to have
a linear mapping without allocating memory.

> I don't know whether we're bound to this:
> 
> http://www.opengroup.org/onlinepubs/007908775/xsh/readdir.html
>         
>         "If a file is removed from or added to the directory after the
>         most recent call to opendir() or rewinddir(), whether a
>         subsequent call to readdir() returns an entry for that file is
>         unspecified."
> 
> But that would seem to tell me that once you populate a table such as
> the one I've described and create it at open(dir) time, you don't
> actually ever need to update it.

Yes, I'm using such a patch on our S390 buildservers to work around some
readdir/seek/rm problem with old glibc versions. It seems to work but on the
other hand this are really huge systems and I haven't run out of memory while
doing a readdir yet ;)

The proper way to implement this would be to cache the offsets on a per inode
base. Otherwise the user could easily DoS this by opening a number of
directories and never close them.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
