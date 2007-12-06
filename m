Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXLFRzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXLFRzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXLFRzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:55:01 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53644 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLFRzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:55:00 -0500
Subject: Re: [RFC PATCH 0/5] Union Mount: A Directory listing approach with
	lseek support
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071206100118.GA19903@hasse.suse.de>
References: <20071205143718.GC2471@in.ibm.com>
	 <1196875318.18685.24.camel@localhost>
	 <20071206100118.GA19903@hasse.suse.de>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 09:54:43 -0800
Message-Id: <1196963684.18685.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 11:01 +0100, Jan Blunck wrote:
> > Rather than give each _dirent_ an offset, could we give each sub-mount
> > an offset?  Let's say we have three members comprising a union mount
> > directory.  The first has 100 dirents, the second 200, and the third
> > 10,000.  When the first readdir is done, we populate the table like
> > this:
> > 
> >       mount_offset[0] = 0;
> >       mount_offset[1] = 100;
> >       mount_offset[2] = 300;
> > 
> > If someone seeks back to 150, then we subtrack the mount[1]'s offset
> > (100), and realize that we want the 50th dirent from mount[1].
> 
> Yes, that is a nice idea and it is exactly what I have implemented in my patch
> series. But you forgot one thing: directories are not flat files. The dentry
> offset in a directory is a random cookie. Therefore it is not possible to have
> a linear mapping without allocating memory.

Is is truly a random cookie where the fs gets to put anything in there
that it can fit in a long?  Isn't that an advantage?  Being a random
cookie, we can encode anything we want in there.  We could encode the
"mount index" (or whatever you want to call it) in high or low bits and
have the rest store the fs-specific offset.  The only problem there
would be running out of storage space in long.

But, what do people expect when they have huge directories (or huge
directory offsets)?  Surely, if their fs is already pressing the fs's
directory data types to the limits, they can't simply union mount a
couple of those directories together and expect magic.  Union mounts
also can't be expected to compress these directory positions to fit.

So, I think it's reasonable behavior to readdir() until the sum of the
highest position seen on each mount would overflow the off_t that we
have to store it in.  

-- Dave

