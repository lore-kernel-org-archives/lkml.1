Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZJ2Hxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZJ2Hxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZJ2Hxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:53:54 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:34241 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZJ2Hxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:53:53 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: symlinks with permissions
Date: Thu, 29 Oct 2009 07:53:58 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hcbhmm$qm4$1@taverner.cs.berkeley.edu>
References: <20091025062953.GC1391@ucw.cz> <4AE87292.20802@schaufler-ca.com> <hcahnb$mgp$1@taverner.cs.berkeley.edu> <4AE91658.9090105@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1256802838 27332 128.32.168.222 (29 Oct 2009 07:53:58 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 29 Oct 2009 07:53:58 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
>David Wagner wrote:
>> Suppose I open a file in read-only mode.  Suppose moreover I only
>> have permission to read the file but not write it (given the full
>> permissions on the path to the file).
>
> Ok. The parenthetical clause is a problem. Once you have the file
> descriptor the path that you used to get it is completely irrelevant.
> [... rest of argument about how the system *has* to work ...]

Are you trying to infer how Linux *does* work, based on how
it *could possibly* work?  If so, why not just check directly
how it does work?

Are you trying to argue how Linux *should* work, based upon limits
on how it *could* work?  If so, you've missed an option: Linux could
refuse to expose a way to upgrade a read-only file descriptor to
a read-write file descriptor through /proc.

Suppose I have a read-only file descriptor, and the file that I originally
opened is now writeable.  Are you assuming that Linux provides some
mechanism to turn this into a read-write file descriptor (regardless of
permissions on the rest of the path to that file; and apart from the /proc
mechanism Pavel identifies)?  If so, what mechanism did you have in mind?

I don't know of any mechanism that provides this functionality.

For example, as far as I know, fcntl(fd, F_SETFL) does not allow you
to change an existing file descriptor from O_RDONLY mode to O_WRONLY or
O_RDWR, regardless of filesystem permission bits.

Put another way, I think you are right that it is not possible for
Linux to look at the path permissions after the file has been opened.
The conclusion you draw is that therefore Linux does or should provide
some way to upgrade a O_RDONLY file descriptor into O_RDWR mode based on
looking only at the file (but not path) permissions.  But I don't think
that follows.  I think the real situation is that Linux doesn't provide
any such way to upgrade a O_RDONLY file descriptor into O_RDWR mode (well,
except through the problematic /proc interface that Pavel describes,
which is exactly the problem).

Put yet another way, if Linux *can't* look at the path permissions, then
it *had better not* expose a way to turn a O_RDONLY file descriptor into
a O_RDWR file descriptor; anything else is a security violation.

> No, I don't believe that is correct. Unless I read the discussion
> incorrectly, the file has to be writeable for the "exploit" to
> work. The reason that it looks like an exploit is that the mode bits
> on the containing directory "should" prevent the requested access,
> but in reality /proc/8675309/fs/3 provides an alternative pathname
> to the object, just as having a hard link or an alternative mount
> point might. Neither of those cases is an "exploit", although I can
> easily understand how they might appear to be to those who are
> unfamiliar with the acyclic graph that is the Linux (Unix) file
> system name space.

I am familiar with the acylic graph that is, etc., etc.  Nonetheless
I still consider Pavel's attack a security violation.  Before the
/proc interface in question was introduced, it was an invariant that
nothing a malicious user could do would enable it to access the file.
Programs could rely upon this invariant.  The /proc interface breaks
this invariant and creates a sneaky way that a malicious user could
access files that he couldn't have accessed in the absence of the /proc
mechanism.  That's not something application writers can reasonably
be expected to expect.  That makes it a security violation.  /proc
shouldn't be providing backdoors: ways to access files that you could
not have accessed in the absence of /proc.

> The only access that really matters is that of the object itself.
> The path you use to get to it only matters during the resolution
> of the path, after which it is, and must be, irrelevant. If there
> is a path that leads to the object that is constructed some other
> way, as the "fd" bit of /proc is, then the semantics of that path's
> construction are what matter for the resolution of that path. Since
> they have no way or reason to determine what the original
> resolution path might have been there is no point in whinging
> that the access of the /proc/8675309/fd/3 path is different from
> the /a/foo path any more than there is that /b/bar might be
> different.

I'm not convinced.  Your reasoning seems to be "Since we can't look
at the path, therefore Linux has to look at only the file and allow
upgrading a read-only file descriptor to a read-write file descriptor
if the permission bits on the file allow it, without regard to the path
permissions".  My position is "If we can't look at the path, then Linux
can't tell whether it is safe to upgrade a read-only file descriptor to a
read-write file descriptor, so in this case Linux must not provide a way
to upgrade a read-only file descriptor to a read-write file descriptor
when the filepath might have been unopenable for writing (e.g., due to
path permissions)".  See the difference?  You assume, in case of doubt,
upgrading has to be allowed.  I say, that's not the only possibility.
I say, in case of doubt, upgrading can -- and should -- be denied.

> Yeah, I did that. It still looks like the complaint is that
> /proc/8675309/fd/3 gives you the ability to gain RW access to
> an object for which you have RW access.

Nope.  The complaint is that /proc gives me a sneaky way to gain RW
access to an object for which I otherwise would not have been able to
gain RW access.  In the absence of the /proc mechanism and Pavel's sneaky
attack, I would not have been able to gain write access to the object.

> Look, with hard links and the various mount options available
> today you just can't count on setting the mode on a directory
> to completely protect the files that it references.

Hard links: Yes you can count on this to protect files, if you set up
the directory yourself and set it up properly.  Pavel's attack protects
against hard links.  Read his attack script more carefully.

Mount options: Care to explain further?  I don't immediately see the
relevance.
