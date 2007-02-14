Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXBNW56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXBNW56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbXBNW55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:57:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:55975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbXBNW54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:57:56 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Wed, 14 Feb 2007 14:57:50 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       walt <wa1ter@myrealbox.com>
References: <200702021923.02491.agruen@suse.de> <Pine.LNX.4.64.0702140730350.3604@woody.linux-foundation.org> <200702141139.41465.agruen@suse.de>
In-Reply-To: <200702141139.41465.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200702141457.51218.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 11:39, Andreas Gruenbacher wrote:
> On Wednesday 14 February 2007 07:37, Linus Torvalds wrote:
> > We could prepend another '/' (so that you'd have a path that starts with
> > "//"). That's still a legal path, but it's also somethign that even POSIX
> > says is valid to mean something else (eg "//ftp/.." or "//socket/.." to
> > escape into another namespace).
>
> This sounds good enough to me. My main point is that users that care should
> be able to tell the difference.

Looking some more into it, appending another slash doesn't look like the best 
solution after all. Here is a more elaborate description of the cases we have 
to deal with:

 * Regular paths that lead up to the root we are interested in. These should
   obviously be reported as "/dir/file", so I won't mention them any further.

 * Files on pseudo filesystems such as pipefs. Historically, we are
   reporting them as "pipe:[439336]" or similar, where "pipe:" is the name of
   the root dentry, and "[439336]" is the name of the child; no slash between
   them.

 * Lazily unmounted directories. Currently, we report them as "dirfile", where
   "dir" is the name of the directory dentry, and "file" is the name of the
   child dentry. That's the obvious bug.

 * Lazily unmounted filesystems. Currently, they and up as "/file", where
   "/" is the name of the root dentry, and "file" is the name of the
   child dentry.

 * Unreachable paths. Currently, we report them as absolute paths, so there
   is no way to tell the one from the other.

What I'm after here is two things:

 (1) fix the bug with the lazily unmounted dirs, and

 (2) allow to tell when a path is unreachable.

The key problem is that we know when we hit a disconnected path, but it's hard 
to tell the pseudo filesystem case from the root filesystem case because 
rootfs also is a pseudo filesystem.

Let's look at a few choices we have:

[0] Now:
--------
pipe:			"pipe:[439336]"
lazily umounted dir:	"dirfile"		<==  bug
lazily unmounted fs:	"/file"			<== ambiguous
path on rootfs:		"/file"			<== ambiguous
rootfs root:		"/"			<== ambiguous

[1] Always make disconnected paths relative:
--------------------------------------------
pipe:			"pipe:[439336]" (or "pipe/[439336]")
lazily umounted dir:	"dir/file"
lazily unmounted fs:	"file"
path on rootfs:		"file"
rootfs root:		"."

[2] Make disconnected pseudo-fs paths relative and others absolute;
    special case the rootfs:
    ------------------------
pipe:			"pipe:[439336]" (or "pipe/[439336]")
lazily umounted dir:	"//dir/file"
lazily unmounted fs:	"//file"
path on rootfs:		"//file"
rootfs root:		"//"

[3] Always make disconnected paths double-slashed:
--------------------------------------------------
pipe:			"//pipe/[439336]"
lazily umounted dir:	"//dir/file"
lazily unmounted fs:	"//file"
unreachable root:	"//"


>From all these choices, I actually like [1] best, together with hiding 
unreachable mount points in /proc/$pid/mounts and /proc/$pid/mountstats: 
there is no real point in pretending that unreachable paths are reachable; 
whichever process uses these paths is just as much in error when trying from 
the pwd as when trying from the chroot.

Hiding unreachable mount points has the benefits that processes will not get 
to see relative paths in /proc/$pid/mounts and /proc/$pid/mountstats. Those 
paths are irrelevant to them anyway; just consider a chroot()ed process that 
currently sees all sorts of crap.

A process that hasn't been chroot()ed will still see all filesystems except 
the rootfs, so no problem there. Hiding the rootfs by virtue of it being 
unreachable is actually be a good thing: nobody is actually going to be able 
to do anything with it anyway; it's just confusing, and adds unnecessary 
special cases to scripts like mkinitrd.

I would actually also prefer to see the hack go that leaves out the slash 
between pathame components (so "pipe:[439336]" would just 
become "pipe/[439336]") -- it's good for nothing other than backward 
compatibility.

Opinions?

Thanks,
Andreas
