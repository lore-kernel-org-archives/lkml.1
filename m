Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZHYBHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZHYBHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZHYBHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:07:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:54290 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZHYBHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Iwxl1hOGeXtZUfgGYRard4dS3m+XK3/rOwJMU8aXMbFKbpMGE5tbXtvWwUd2BWGTEN
         U0lN2+etcHXU3SvEDpkbpdlyRD2sAEr4HPABvooeqiWWy4JNqo7fB4ge0pMcvVHqSb5V
         me3h77hG9k6HRgAz20gYQ+rU6NDd07IwNwAQU=
MIME-Version: 1.0
In-Reply-To: <4A93284C.7060604@earthlink.net>
References: <4A93284C.7060604@earthlink.net>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 24 Aug 2009 20:59:33 -0400
Message-ID: <3e8340490908241759j2636ac99s48db5aa94b7cf519@mail.gmail.com>
Subject: Re: Starting a grad project that may change kernel VFS. Early 
	research
To: Jeff Shanab <jshanab@earthlink.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 7:54 PM, Jeff Shanab<jshanab@earthlink.net> wrote:
> Title: "Pay it forward patch set"
> Goal: Desire to change the dentry and inode functionality so commands
> like du -s appear to have greatly improved performance.
> How: TBD? 2 phase ubdate walking up the tree to root.
>
>   Prior to actually starting my Grad Project in Computer science, I am
> taking 1 semester to do research for it at the recommendation of my
> advisory.  I need to of course make sure it doesn't already exist.  It
> may be that all the changes end up in a file system and the kernel will
> be left alone, just one of the things I want help determining.
>
> 1) First question, where to put this functionality?
>    I originally thought to put my functionality in the VFS so that all
> mounted file systems could share it, but after reading fs.h, and
> inode.c, it looks like the VFS is purely an abstract interface and
> functionality at that level may not be wanted? Also I guess certain file
> systems may not have needed on disk structures to save the info (ie
> VFAT,NFS, etc)

VFS has a lot of generic functionality that filesystems can opt into -
but see below about your specific proposals...

> 2) Second Question. The two part idea.
>    I was thinking that a good way to handle this is that it starts with
> a file change in a directory. The directory entry contains a sum already
> for itself and all the subdirs and an adjustment is made immediately to
> that, it should be in the cache. Then we queue up the change to be sent
> to the parent(s?). These queued up events should be a low priority at a
> more human time like 1 second. If a large number of changes come to a
> directory, multiple adjustments hit the queue with the same (directory
> name, inode #?) and early ones are thrown out. So levels above would see
> at most a 1 per second low priority update.

As I understand it, you want to tag each directory with the total size
of its contents. There are a few problems with this:
1) A metadata change is required for a filesystem to use this. It
would be prohibitively expensive to cache all directories in memory to
remember their sizes, and we can't just traverse a directory and all
of its contents to find its disk space usage just because someone
touched it. So the size has to be remembered on disk.
2) Hard links break this scheme rather badly. Consider if /foo/x is
hardlinked to /bar/x. Then something modifies /bar/x. The kernel
cannot find all other hardlinks to /bar/x, so /foo's disk usage
estimate is not updated. Moreover /'s disk space usage would have
twice the actual size used by /{foo,bar}/x.

You can't just call it a rough estimate to get around 2), as the error
can build up without bounds, until you have directories apparently
taking 10x the size of your actual hard disk. That said, for
filesystems without hardlinks this is doable, but most Linux
filesystems support hardlinks. Heck, even NTFS supports hardlinks. So
it's unlikely to be useful in Linux...

>    I have a second set of changes I am considering and I think would
> fit more completely in a file system, but I bring them up here in case
> it influences the above.
> title: "User Metadata" aka "pet peeve reduction"
>    I would like to maintain a few classifications of metadata, most
> optional and configurable.
[snip details]

This is already supported through user xattrs. It just needs more
application support (good luck getting flash to use them for temp
files though ;)
