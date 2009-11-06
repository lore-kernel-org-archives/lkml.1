Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZKFBko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZKFBko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbZKFBko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:40:44 -0500
Received: from mail2.shareable.org ([80.68.89.115]:43381 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbZKFBkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:40:40 -0500
Date: Fri, 6 Nov 2009 01:40:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091106014020.GE21630@shareable.org>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu> <20091105131545.72b4e319@lxorguk.ukuu.org.uk> <E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091105145054.11f36b35@lxorguk.ukuu.org.uk> <E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>   "A file descriptor opened with O_NODE | O_NOACCESS may be used to
>    re-open the same file later with increased permissions
>    (e.g. O_RDWR) if the access mode allows.  This is true even if the
>    permissions on the path leading up to the file would prevent it"

It isn't just "the path".

The same issues apply to a file which has been deleted.  Having been
passed a file handle from some other process, you are granted greater
access to a file which has no path at all and no other handles open to
it, which it's reasonable unix security tradition to assume can't be
done.

It's not quite the same issue as /proc/PID/fd.  Someone must have
explicitly used O_NODE, which means they intend for access to be
upgradable later; they won't be surprised by it happening.

But I still think the re-open access should be limited to whatever was
the original access mode, in the same way as has been discussed for
/proc/PID/fd.

So you'd use O_NODE|O_RDWR if you want someone to be able to re-open
the file itself later with O_RDWR acces.  Use O_NODE|O_RDONLY if you
want them to be only able to re-open the file itself with O_RDONLY
access.  That would limit O_NODE|O_NOACCESS to only being able to
re-open with O_NODE|O_NOACCESS again (because O_NOACCESS by itself
isn't allowed).

Is there any reason why O_NODE|O_RDWR cannot be used for that purpose?

> Why would the server need to know anything about that?  O_NODE is
> similar to a chdir() in this respect, and chdir doesn't have a handler
> either.

chdir() needs execute access.

Note we're a bit broken w.r.t. current POSIX regarding fchdir() and
execute-only directories.  It would be good to fix that.

However, it might be possible to craft a "non-pinning inode reference"
in a similar way to inotify.  Either by not referencing the inode
directly (like inotify), or by creating a weak reference method, which
would be more reliable on filesystems without stable inode numbers.

Actually a non-pinning inode reference would be handy for other things
too.  *Must resist temptation to implement O_NOPIN option for open
files generally ;-)*

> However, there's not all that much difference between the above and
> doing "stat()" on the mountpoint in a tight loop, except the former is
> a more reliable way to prevent unmounting.

Are you sure that stops unmounting?  Doesn't unmounting just sit in a
lock waitqueue somewhere like a regular rwlock writer, until it's time
comes?

-- Jamie
