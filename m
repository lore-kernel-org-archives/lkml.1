Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYL0VXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYL0VXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYL0VXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:23:37 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:62690 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYL0VXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=q1frn30p5DGSjH5dl31rBy8Fnhb72/bl7tdFuTB0N4BB/raqhCxzK0oH/50kdTo6/N
         7AYDihnqNPs6ofn8QC4UxDOsFaXdCkRAr2e3jSvlPLWVZw/uE0sxyPyCzk+YbrsVTKcu
         w2qPx35MueKvsmENaAz0jbqZnDgGTvCSpnkHY=
Message-ID: <c6d9bea0812271323n1d85b699l6328e12686123695@mail.gmail.com>
Date: Sat, 27 Dec 2008 16:23:33 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Cc: "Eric Paris" <eparis@redhat.com>, "Christoph Hellwig" <hch@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081226014401.GT28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
	 <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
	 <20081222210410.GL28946@ZenIV.linux.org.uk>
	 <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
	 <20081222232125.GA25334@infradead.org>
	 <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com>
	 <20081225203302.GS28946@ZenIV.linux.org.uk>
	 <c6d9bea0812251658o4710f761j113fbeec9e5e1c97@mail.gmail.com>
	 <20081226014401.GT28946@ZenIV.linux.org.uk>
X-Google-Sender-Auth: 6ebdc0429b272e05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 8:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> As far as I can tell, none of the existing Linux desktop search tools
>> attempt to deal with these races.  (Beagle handles the 'mkdir' race,
>> but not the other rename races.)  This is acceptable only if an
>> unreliable file index is acceptable.
>
> ... and inotify is unreliable by design, or what passes for it anyway.

Really?  I don't see that in the documentation anywhere (except as an
aside in a comment you added to inotify's pin-to-kill method).  Nor do
I find it supported by code review.  Sure, the queue is limited size,
but you are guaranteed an overflow event when messages are dropped;
that's all that's needed for reliability.  Can you provide some
specific example where events are lost "by design"?  There are
userland races in inotify, but they are all solvable, and I've
described above how to do so.  The problem is that the workarounds
make practical programming with inotify very cumbersome, and the
result is that most implementors haven't bothered to make things
correct (ie, moving a directory breaks all search tools I've looked
at).  I'm interested in determining whether there are minor tweaks
which can make correct userlands easier to write.  That's why I've
been beating the "autoadd" drum in this thread: it's a very small
patch would would remove one category of race entirely (leaving only
the rename races for userland to deal with).

>>   b) use inode numbers rather than path names uniformly, in both
>> inotify and the userland search index, along with an iopen() syscall,
>> as in Mach.  This decouples path maintenance from indexing.  This was
>> discussed in (for example)
>> http://www.coda.cs.cmu.edu/maillists/codalist/codalist-1998/0217.html
>> by Peter J. Braam and Ted Ts'o, but Al Viro has been objecting to the
>> idea here.  (If all you need to do is open found files after a search,
>> you can skip path maintenance entirely.)
>
>        For one thing, opened directory can be fchdir'ed to.  Or passed to
> openat() et.al.

You seem to be confusing inotify watch descriptors with file
descriptors.  Directories are not held open in inotify, as you should
know.

Adding an inotify_open_wd() syscall would indeed eliminate the last of
the 3 races I described above (a/b/c rename to a/d/c).  It wouldn't do
anything about a/b -> a/c rename races.

>  For another, go ahead, show me how to implement that
> sucker for something like NFS.  Or CIFS.  Or FAT, while we are at it.
> Or anything that does have stable numbers identifying fs objects, but where those numbers are huge.

Sure.  Because not all filesystems support xattr (say) we should
refuse to add it to any?  As you know well, The standard solution to
the inode problem (in NFS or FUSE, say) is to synthesize stable inode
numbers in the kernel (or in metadata in something like vfat), with
the understanding that these numbers will be different on every mount.
 For the purposes of race-avoidance in inotify, transient inode
numbers are acceptable.  And we can always fall back to "old racy
inotify" or manual filesystem scans for minority filesystems.

>>  c) Pass file descriptors in the notification API from the kernel.
>> This solves the races associated with renames before indexing.
>> Userland still has to maintain its own copy of all the direntries for
>> indexed content, but at least this task is decoupled.  (The proposed
>> fanotify API passes file descriptors, but provides no mechanism (yet)
>> for path maintenance.)

You didn't comment on this alternative, but as I've continued thinking
about the problem, this alternative has seemed best.

> e) start with providing a higher-level description of what you want to
> achieve.  While we are at it, is it supposed to be fs-agnostic?  What
> kinds of filesystems could in principle be used with that?

The high level problem should be obvious, but I'll restate it for you anyway:

  * Maintain a auxiliary set of content-derived metadata for each file
in some subset (under a directory, mount-point, matching a wildcard,
etc).  This metadata must be updated whenever the content changes, and
must include/maintain some stable reference to the file so that
searches on the metadata can be mapped back to their corresponding
files later.

Implementors vary on the definition of 'content' (do file permissions
count? xattrs? etc),  the best "update" API (is notify-on-close and
reindexing entire files sufficient, or do we want to do incremental
updates on each dirty block/byte), and whether the notification is
synchronous or asynchronous (eg: Eric Paris wants to act on 'bad'
content, so he needs a synchronous interface to prevent races from
acting on bad content).  In Linux search tools I've looked at, the
'stable reference' notion has usually been kept as a file:// URL (ie,
absolute path), but Mac OS X has file handles closer to inode numbers
(although I'm not positive that's what they are using).

Filesystem-agnostic tools are preferable, but "works best on
filesystem X" search tools are already common.  The BeFS was an
example of non-agnostic search, and Beagle "works best" on filesystems
that support xattrs.  The i_version field will also be useful for
search tools, for filesystems which support it (only ext4 so far?).
So give me filesystem-specific search if it is compelling, or agnostic
search where possible.

> So far you've mentioned use of blatantly inadequate tool and far too
> low-level description of changes that might possibly make it more
> tolerable for unspecified use you have in mind.  I'm sorry, but that's
> exactly how a bunch of bad APIs (including inotify) got pushed into the
> tree and I would rather not repeat the experience.

So, you don't understand the problem, and you'd rather not have
inotify in tree because you think it is "blatantly inadequate" -- yet
you are using inotify in your audit subsystem?  I think I am beginning
to get the impression that you're just not going to be much help.

> Interfaces must make sense.  And "we need <list of things> for our project,
> nevermind what are they for, here's what we would like to see" is a recipe
> for kludges.  Inotify, dnotify, F_SETLEASE, etc.  Sigh...

I don't think this is a sound technical argument.  We've got at least
two different APIs on the table (fanotify and inotify), a
well-understood problem description, *and* I've made at least 4
different proposals for how the current situation might be improved.
Please feel free to suggest concrete alternatives, but I don't plan to
continue this thread while you are just taking bogus potshots.
 --scott

-- 
                         ( http://cscott.net/ )
