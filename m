Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYLRXgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYLRXgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYLRXgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:36:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:60932 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYLRXgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tW9L1qKksQJsPHol5e7YzzFfCKYxnI+1SlSy4EBJLwkf7tP+8LWiFcPdvKmIorcSFn
         08VAcpQzYKvAujXEDaUb3/GHhwiA9nU81ACNnG5P4fdRgB0c8tsdAZK7Ynlso0ayM88W
         PEEUZdsMTyUfNv5zAsl26O/NuFrYVgsiJ6nxY=
Message-ID: <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
Date: Thu, 18 Dec 2008 18:36:36 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Eric Paris" <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
X-Google-Sender-Auth: 02b8e57adc3702a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 4:51 PM, Eric Paris <eparis@redhat.com> wrote:
> The following series implements a new generic in kernel filesystem
> notification system, fsnotify.  On top of fsnotify I reimplement dnotify and
> inotify.  I have not finished with the change from inotify although I think
> inotify_user should be completed.  In kernel inotify users (aka audit) still
> (until I get positive feedback) relay on the old inotify backend.  This can be
> 'easily' fixed.
> All of this is in preperation for fanotify and using fanotify as an on access
> file scanner.   So you better know it's coming.
> Why is this useful?  Because I actually shrank the struct inode.  That's
> right, my code is smaller and faster.  Eat that.

As a desktop-search-and-indexing developer, it doesn't seem like
fanotify is going to give me anything I want.  The inotify/dnotify
restructuring to fsnotify seems reasonable, but not exciting (to me).

>From a desktop search perspective, my wishlist reads like this:
 1) An 'autoadd' option added to inotify directory watches, so that
newly-created subdirectories get atomically added to the watch.  That
would prevent missed IN_MOVED_FROM and IN_MOVED_TO in a newly created
directory.
 2) A reasonable interface to map inode #s to "the current path to
this inode" -- or failing that, an iopen or ilink syscall.  This would
allow the search index to maintain inode #s instead of path names for
files, which saves a lot of IN_MOVE processing and races (especially
for directory moves, which require recursive path renaming).
 3) Dream case: in-kernel dirty bits.  I don't *really* want to know
all the details; I just want to know which inotify watches are dirty,
so I can rescan them.  To avoid races, the query should return a dirty
watch and atomically clear its dirty flag, so that if it is updated
again during my indexing, I'd be told to scan it again.

>From the indexing perspective, dealing with a sequence of operations like:
   1) mkdir -p abc/def
   2) echo "foo" > abc/def/ghi
   3) mv abc xyz
   4) mv xyz/def/ghi jkl
is entirely too much "fun".  Depending on the races between kernel and
user space, I might get only:
   CREATE abc
   IN_MOVED_TO jkl
and if I do get my watches put in place after step (1) I've still got
to deal with a recursive rename in step (3), the possibility of
getting notification of (2) after the rename in (3) (so abc/def/ghi no
longer exists), and other delights.

As far as I can tell, fanotify only helps with the 'recursive watch'
problem (which could be solved with 'autoadd' or just using the
algorithm in http://mail.gnome.org/archives/dashboard-hackers/2004-October/msg00022.html
), and doesn't give me any tools to deal with the actual hard races or
path-maintenance problems.
  --scott

-- 
                         ( http://cscott.net/ )
