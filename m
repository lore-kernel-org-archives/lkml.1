Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZHTOcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZHTOcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZHTOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:32:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:49124 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZHTOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=htswGBx04JTXZY/bvoxIOCt4AvhsjjUYltPLKKC2jg0vhgdlBXUOfipY7a7w39B+sL
         8luLMMmLDBBh34oaZNOEsQvV27pkrjNb0eHM4u6kPJ24RkwwJJicfAxa/ZNaSbkwvVge
         n6L74wOh5PKEB3X2z51F/Eql8pXXhEONAJ71E=
Date: Thu, 20 Aug 2009 16:32:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-next: reiserfs lockout with xattr ?
Message-ID: <20090820143207.GB6389@nowhere>
References: <4A79CA90.8080101@free.fr> <20090808002726.GI4999@nowhere> <4A7E9C63.4090400@free.fr> <20090809233302.GD6089@nowhere> <4A807E3A.8050703@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A807E3A.8050703@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:08:26PM +0200, Laurent Riffard wrote:
> Le 10/08/2009 01:33, Frederic Weisbecker a écrit :
> > 
> > Thanks a lot for this report. Reiserfs xattrs are definetly paths I
> > haven't tested deeply.
> > 
> > I'm trying to reproduce these issues and will let you know once I get
> > a fix.
> > 
> > (Btw, if you're still running this tree, you should update with the
> > latest patch I just pushed, it's a very important fix).
> > 
> > Thanks,
> > 
> > Frederic.
> 
> I tried with your lastest patch (git head is at "kill-the-bkl/reiserfs: 
> fix early readdir offset increment"), and the lockout still happens.
> 
> ~~
> laurent


Ok, it looks like the last two patches in my tree have introduced a locking
inversion dependency between the reiserfs write lock and mm->mmap_sem.

In filldir, we take the reiserfs lock and we might take mm->mmap_sem if
we fault while copying the dir entry to the user.

In mmap, the mm->mmap_sem is taken before the call to the fs mmap callback
and there we take the reiserfs lock.

Locking inversion: AB - BA

What is really sad here is that I have no choice: I can't take the reiserfs lock
while filling a dir entry to the user.
This part, introduced in the last two patches of the tree optimized a lot
the throughput, and now I have to revert them :-(

