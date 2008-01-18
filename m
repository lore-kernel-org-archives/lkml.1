Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYARUzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYARUzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763547AbYARUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:55:25 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1621 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763257AbYARUzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:55:24 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <torvalds@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <clameter@sgi.com>, <penberg@cs.helsinki.fi>
Subject: RE: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 12:55:09 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEPKJJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.LFD.1.00.0801180754050.2957@woody.linux-foundation.org>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 18 Jan 2008 12:56:37 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 18 Jan 2008 12:56:38 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 17 Jan 2008, David Schwartz wrote:

> > Nonsense. The 'kfree' function *destroys* the object pointer to by the
> > pointer. How can you describe that as not doing anything to the object?
>
> Here's an idea. Think it through.
>
> Why don't we need write permissions to a file to unlink it?

You cannot unlink a file. Given a file, if you were to attempt to unlink it,
what directory would you remove it from?

Unlinking a file is an operation on the directory the file is in, not on the
directory itself. We do need write permissions to the directory.

If you had only a const pointer to the data in the file, you should
definitely not be able to use that pointer to find a directory the file is
in and remove it without clearly indicating you know *exactly* what you're
doing. Given just that 'const' pointer, you're not supposed to be modifying
the data and certainly using that pointer to modify anything logically above
it.

> Here's a hint: because unlinking doesn't *write* to it. In fact, it
> doesn't read from it either. It doesn't do any access at all to that
> object, it just *removes* it.

Right. It's an operation on the directory the file is in that might have
consequences for the file.

> Is the file gone after you unlink it? Yes (modulo refcounting for
> aliasing
> "pointers" aka filenames, but that's the same for any memory manager -
> malloc/free just doesn't have any, so you could think of it as a
> non-hardlinking filesystem).

The file is gone if and only if the directory was the only thing that needed
the file to exist. A file that is only on one directory "belongs to" that
directory. So write permission to the directory is all that is needed.

What you are arguing is essentially that you should be able to remove a file
from any directory it is in just because you have write access to the file's
data.

> So you're the one who are speaking nonsense. Making something "not exist"
> is not at all the same thing as accessing it for a write (or a read). It
> is a metadata operation that doesn't conceptually change the data in any
> way, shape or form - it just makes it go away.

Making something "not exist" is a modification operation on that thing.

> And btw, exactly as with kfree(), a unlink() may well do something like
> "disk scrubbing" for security purposes, or cancel pending writes to the
> backing store. But even though it may write (or, by undoing a pending
> write, effectively "change the state") to the disk sectors that used to
> contain the file data, ONLY AN IDIOT would call it "writing to the file".
> Because "the file" is gone. Writing to the place where the file
> used to be
> is a different thing.

I agree with you about that part. I can't understand why you keep thinking
this is where our disagreement lies when I've stated at least three times
that I agree about this. The issue has nothing to do with whether or not
'kfree' modifies the particular bytes pointed to. It has to do with whether
or not 'kfree' is the kind of operation one would normally want to allow on
a 'const' object.

> So give it up. You're wrong. Freeing a memory area is not "writing to it"
> or accessing it in *any* manner, it's an operation on another level
> entirely.

Nevertheless, it's a modification operation on an object that's not supposed
to be modified.

By the way, I did think of one argument that supports your position: Suppose
you have a reference counted object. You have a 'release reference and free
if zero' function. Should it be 'const'? If not, how can a 'lookup and
reference for read' function return a const pointer to the object?

However, on balance, I think a 'release reference and free if zero' function
that operates on a const pointer is sufficiently unusual that a cast to show
you know what you're doing is not a bad thing. In this case, you know it's
safe to destroy the object through a const pointer because you *know* nobody
gave you the 'const' pointer trusting you not to destroy the object. A cast
to show you have that special knowledge is, IMO, reasonable.

DS


