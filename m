Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYLVXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYLVXOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYLVXN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:13:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37655 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbYLVXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LndqCPZ/GOZ34lv+HxldHuvAyy73gX8lF6KMAgBpwK28NLUmIEi5kXDGojrsqqbKfT
         qjF+DfFZbS58RPhks2C0+3MCBvUX1HTt+FVvie2k1gpywdYb12Sw5eTSfKc4h0x00YmS
         n2wTWpSSWSPHNaXCjWHFaHB9rpgxen95V2vvs=
Message-ID: <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
Date: Mon, 22 Dec 2008 18:08:08 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Cc: "Eric Paris" <eparis@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081222210410.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
	 <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
	 <20081222210410.GL28946@ZenIV.linux.org.uk>
X-Google-Sender-Auth: a1efc60cf37f26a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Dec 22, 2008 at 02:59:37PM -0500, C. Scott Ananian wrote:
>> > 2) major vfs and every FS redesign me thinks.
>>
>> I'm not convinced of that.  I'm pretty certain one could export
>> symlinks /proc/<pid>/mountinfo/<dev>/<inode> -> <absolute path in
>> processes' namespace> with very little trouble, and no violence done
>> to the VFS, which already has an iget() function which does the heavy
>> lifting.
>
> There is no such thing as absolute path of inode *anywhere*, process
> namespace or not.  Not on any UNIX.  Period.  End of story.

That's not correct, as /proc/self/fd/<num> and the getcwd syscall make
clear.  struct inode has a i_dentry member, and via its d_parent links
you can reconstruct the path, as __d_path in fs/dcache.c does.

Of course, this only works as long as the inode is in the kernel's
cache (which implies all the appropriate dentry items are there, too).
 For an open file descriptor, this works well.  If you index the open
file now and then return sometime later to try to open it, there's no
guarantee.

If the inode represents a directory, we *could* use the magic '..' and
'.' entries to reconstruct its path, even without its being in the
cache.  I haven't looked hard, but that might involve VFS violence.
But having to manually track what directory inode a given file was in
is still an improvement over having to duplicate the entire directory
tree.

We can also debate whether finding *a* name for the inode if
sufficient, or if you really need to know *all* names for the inode.
One is plenty if you're just looking for a path to give on the command
line to (say) emacs to open the file after a successful search.  But
then emacs may not be happy when it tries to write a backup file to an
arbitrarily chosen directory.

> Al, once again astonished by the ability of desktop developers to post from the alternative realities they apparently inhabit...

I think you're prejudging.  I'm certainly posting from a weird twisted
alternate reality, but by and large it's not the "desktop developer"
one. ;-)

There are a paucity of good solutions.  We can follow the example of
old-school UNIX dump and open the filesystem's block device directly
to map inodes to paths.  Or we can use 'find' over the entire
filesystem.  Or we can duplicate the filesystem's directory structure
in userspace so that we can correctly associate index information with
the current path to the given file?

inotify *almost* lets us do that last thing (though the code
duplication pains me) but is too racy for reliable use. Give me a
kernel interface without races and I'll call it a good start.  If you
can save me the trouble of duplicating all of the filesystem's
directory information in my userspace database in order to handle
directory moves, I'll actually grin a little.
 --scott

-- 
                         ( http://cscott.net/ )
