Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXHQPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXHQPT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXHQPTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:19:20 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:17963 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753192AbXHQPTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:19:18 -0400
Message-ID: <46C5BC79.9090204@cfl.rr.com>
Date: Fri, 17 Aug 2007 11:19:21 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com> <46C4689C.8020702@cfl.rr.com> <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com>
In-Reply-To: <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2007 15:19:28.0361 (UTC) FILETIME=[00C6D590:01C7E0E2]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15368.000
X-TM-AS-Result: No--12.922100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Problem 1: "updating cached acls of descendent objects":  How do you 
> find out what a 'descendent object' is?  Answer:  You can't without 
> recursing through the entire in-memory dentry tree.  Such recursion is 
> lock-intensive and has poor performance.  Furthermore, you have to do 
> the entire recursion as an atomic operation; other cross-directory 
> renames or ACL changes would invalidate your results halfway through and 
> cause race conditions.

Yes, it would take some cpu time, and yes, it would have to use a lock 
to protect the acl which would also lock out moves.  Is that such a high 
cost?  Changing acls and moving whole directory trees around is not THAT 
common of an operation... if it takes a wee bit more cpu time, I doubt 
anyone will complain.

> Oh, and by the way, the kernel has no real way to go from a dentry to a 
> (process, fd) pair.  That data simply is not maintained because it is 
> unnecessary and inefficent to do so.  Without that data you *can't* 

What would you need (process,fd) for?  You just need to walk the tree of 
dentries and update them.

> determine what is "dependent".  Furthermore, even if you could it still 
> wouldn't work because you can't even tell which path the file was 
> originally opened via.  Say you run:
>   mount --bind /mnt/cdrom /cdrom
>   umount /mnt/cdrom
> 
> Now any process which had a cwd or open directory handle in "/cdrom" is 
> STILL USING THE ACLs from when it was mounted as "/mnt/cdrom".  If you 
> have the same volume bind-mounted in two places you can't easily 
> distinguish between them.  Caching permission data at the vfsmount won't 
> even help you because you can move around vfsmounts as long as they are 
> in subdirectories:
>   mkdir -p /a/b/foo
>   mount -t tmpfs tmpfs /a/b/foo
>   mv /a/b /quux
>   umount /quux/foo
> 
> At this point you would also have to look at vfsmounts during your 
> recursive traversal and update their cached ACLs too.

Each bind mount point would need its own dentry so it could have its own 
acl and parent pointer.

> Problem 2:  "Some other directory that you have a handle to":  When you 
> are given this relative path and this cwd ACL, how do you determine the 
> total ACL of the parent directory:
> path: ../foo/bar
> cached cwd total-ACL:
>   root rwx (inheritable)
>   bob rwx (inheritable)
>   somegroup rwx (inheritable)
>   jane rwx
> ".." partial-ACL
>   root +rwx (inheritable)
>   somegroup +rx (inheritable)
> 
> Answer:  you can't.  For example, if "/" had the permission 'root +rwx 
> (inheritable)', and nothing else had subtractive permissions, then the 
> "root +rwx (inheritable)" in the parent dir would be a no-op, but you 
> can't tell that without storing a complete parent directory history.

What?  The total acl of the parent directory is in its dentry.

> Now assume that I "mkdir /foo && set-some-inheritable-acl-on /foo && mv 
> /home /foo/home".  Say I'm running all sorts of X apps and GIT and a 
> number of other programs and have some conservative 5k FDs open on 
> /home.  This is actually something I've done before (without the ACLs), 
> albeit accidentally.  With your proposal, the kernel would first have to 
> identify all of the thousands of FDs with cached ACL data across a very 
> large cache-hot /home directory.  For each FD, it would have to store an 
> updated copy of the partial-ACL states down its entire path.  Oh, and 
> you can't do any other ACL or rename operations in the entire subtree 
> while this is going on, because that would lead to the first update 
> reporting incorrect results and racing with the second.  You are also 
> extremely slow, deadlock-prone, and memory hungry, since you have to 
> take an enormous pile of dentry locks while doing the recursion.  Nobody 
> can even open files with relative paths while this is going on because 
> the cached ACLs are in an intermediate and inconsistent state: they're 
> updated but the directory isn't in its new position yet.

Again, such a move would take some cpu time but the locks would not 
block file opens, just other moves and permission changes.  I don't 
think this burden is terribly high for what is a relatively rare 
operation.

> This is completely opposite the way that permissions currently operate 
> in Linux.  When I am chrooted, I don't care about the permissions of 
> *anything* outside of the chroot, because it simply doesn't exist.  

Yes, it is different... if it wasn't we wouldn't be talking about it.

> Furthermore you still don't answer the "computing ACL of parent 
> directory requires lots of space" problem.

What problem?

> No, you aren't getting it:  YOUR CWD DOES NOT GO AWAY WHEN YOU MOVE IT 
> OR UMOUNT -L IT.  NEITHER DO OPEN DIRECTORY HANDLES.  Sorry for yelling 

It effectively does if you chmod 000 it.  Same idea.  You yank 
permissions to cwd, then you can't access cwd anymore.

> but this is the crux of the point I am trying to make.  Any permissions 
> system which cannot handle a *completely* discontiguous filesystem space 
> cannot work on Linux; end of story.  The primary reason behind that is 
> all sorts of filesystem operations are internally discontiguous because 
> it makes them much more efficient.  By attempting to "force" the VFS to 
> pretend like everything is contiguous you are going to break horribly in 
> a thousand different corner cases that simply don't exist at the moment.

Not sure what you mean here.

> No, your cwd still exists and is full of files.  You can still navigate 
> around in it (same with any open directory handle).  You can still open 
> files, chdir, move files, etc.  There isn't even a way for the process 
> in NS1 to tell the processes in NS2 that its directories were 
> rearranged, so even a simple "NS1# mv /mnt/bar/a/somedir 
> /mnt/bar/b/somedir" is not going to work.

No, like above, your example is equivalent to either an rm -fr or a 
chmod 000 of cwd.  That means you either no longer can use cwd, or it is 
now empty.

Whether it is with chmod or by moving changing the inherited acls, if 
you loose access to cwd, then you can no longer access cwd.

> But you said above  "Yes, if /foo/quux is not already cached in memory, 
> then you would have to walk the tree to build it's ACL".  Now assume 
> that instead of "/foo/quux", you are one directory deep in the 
> now-unmounted CDROM and you try to open "../baz/quux".  In order to get 
> at the ACL of the parent directory it has to have an absolute path 
> somewhere, but at that point it doesn't.

It isn't unmounted yet, it is just disconnected from the tree, so it 
would still be using the same acl it had prior to the disconnect.

> What it "has to do" is it is part of the Linux ABI and as such you can't 
> just break it because it's "inconvenient" for inheritable ACLs.  You 
> also can't make a previously O(1) operation take lots of time, as that's 
> also considered "major breakage".

It isn't inconvenient at all for inheritable acls, nor would chroot or 
chdir be any slower.

> "Pedantic corner case"?  You could do the same thing even *WITHOUT* all 
> the processes holding open FDs, you would still have to iterate over the 
> entire in-cache portion of the subtree in order to verify that there are 
> no open FDs on it.  Yet again you would also run into the problem that 
> we don't have *ANY* dentry-to-filehandle mapping in the kernel.

Again, don't care about filehandles.  The only thing you have to do is 
walk the dentries and update them.  No different than a chmod -R or 
setfacl -R, except of course, you only have to walk the dentries already 
in memory, not update anything on disk.

> Converting a previously O(1) operation into an O(number-of-subdirs) 
> operation is also known as "a major regression which we don't do a 
> release till we get it fixed".  For boxes where O(number-of-subdirs) 
> numbers in the millions that would make it slow to a painful crawl.

We aren't talking about the scheduler or something here.  We are talking 
about an optional feature that doesn't slow things down if you don't 
bother using it.  If you aren't trying to move a super massive directory 
tree which inherits permissions ( you can flag objects to NOT inherit 
from their parent ) and has millions of cached dentries, then there is 
no slowdown.

> By the way, I'm done with this discussion since you don't seem to be 
> paying attention at all.  Don't bother replying unless you've actually 
> written testable code you want people on the list to look at.  I'll eat 
> my own words if you actually come up with an algorithm which works 
> efficiently without introducing regressions.

Testy testy... and why is it that the standard cop out on this list is 
"code up or shut up"?  If you don't want to discuss the idea, then don't...

