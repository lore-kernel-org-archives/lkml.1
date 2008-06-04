Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYFDNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYFDNNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYFDNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:13:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:9877 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYFDNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=TSIZCTTGImdZY0NMfGOWty7yrUmP7ErAFJuFIl/jbfEz0DmPSEfhUhbRO2pjFKSx7x
         oqo4cWtralVaAr16XyayuyUsxtMRCcyuzGMBQUACWCTvFsobfHPeQxie6rGIurCHOQpm
         zUT9KdF3/zcX7A/6/IUjRmSZsF2rZecmYbJis=
Message-ID: <484694C1.7030603@gmail.com>
Date: Wed, 04 Jun 2008 15:12:33 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [patch 0/4 v2] vfs: fix utimensat() non-conformances to spec
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patch series is a revised version of the patch series
that I sent yesterday to fix various utimensat()
non-conformances.  Patches 1 and 2 are unchanged (and were
Acked by Miklos); patches 3 and 4 are revised following
comments by Miklos.

As requested I've split the original patch
("utimensat() non-conformances and fixes [v4] (patch)";
http://article.gmane.org/gmane.linux.file-systems/24325 )
into four parts.  Ideally, these should be applied for
2.6.26-rc, for the reasons outlined in my earlier mail
"utimensat() non-conformances and fixes [v4] (test results)",
http://article.gmane.org/gmane.linux.kernel/689411/ .

The four patches can be applied independently, except that
patch 3 needs patch 2 to be applied first.

I've run my test suite
(http://article.gmane.org/gmane.linux.file-systems/24327 )
against this version of the patches, and all tests pass.

Cheers,

Michael

PS Just for reference, I'll include my earlier "overview"
message here:

-------- Original Message --------
Subject: utimensat() non-conformances and fixes [v4] (overview)
Date: Tue, 03 Jun 2008 22:13:32 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,  Miklos Szeredi <miklos@szeredi.hu>, Al Viro
<viro@zeniv.linux.org.uk>,  jamie@shareable.org,  Ulrich Drepper <drepper@redhat.com>,  linux-fsdevel@vger.kernel.org,
Subrata Modak <subrata@linux.vnet.ibm.com>

Andrew,

A follow-on to this mail is a patch (against 2.6.26-rc4) for -mm.  The
patch fixes several problems in the utimensat() system call.

I would like to see this patch get into mainline ASAP.  If you don't want
to push it for .26, I can understand that, since we are late in the cycle.
 Nevertheless, I will provide some arguments in favor of doing so, in a
follow-on mail.  (I'll also provide a fairly comprehensive test suite, and
test results, which may make you feel fairly confident of the patch.)

==

In an earlier mail I described four problems with the utimensat()
implementation, and attempted a clumsy fix,
http://thread.gmane.org/gmane.linux.man/129

Miklos pointed out a number of problems in my attempted fix, and pushed a
fix into .26-rc for one of the problems (number 3 in the mail), which was a
security-related issue (http://thread.gmane.org/gmane.linux.kernel/678130).
 He also gave me a couple of clues along the way about how to fix the
remaining problems.

In this mail, I will explain the remaining problems from the beginning.
(Although Miklos pushed a fix for one of the problems, there still remain
four problems, because I found another one in the meantime.)

==

While writing a man page for utimensat(2) and futimens(3), I found a few
bugs in the utimensat() system call (i.e., non-conformances with either
the specification in the draft POSIX.1-200x revision or traditional Linux
behavior).

       int futimens(inf fd, const struct timespec times[2]);

       int utimensat(int dirfd, const char *pathname,
                     const struct timespec times[2], int flags);

1. The POSIX.1 draft says that to do anything other than setting both
   timestamps to a time other than the current time (i.e., times is
   not NULL, and both tv_nsec fields are not UTIME_NOW and both
   tv_nsec fields are not UTIME_OMIT), either:
   a) the caller's effective user ID must match the file owner; or
   b) the caller must have appropriate privileges.
   If this condition is violated, then the error EPERM should result.
   However, the current implementation does not generate EPERM if
   one tv_nsec field is UTIME_NOW while the other is TIME_OMIT -- it
   should give this error for that case.

2. The POSIX.1 draft says:

        Only a process with the effective user ID equal to the
        user ID of the file, *or with write access to the file*,
        or with appropriate privileges may use futimens() or
        utimensat() with a null pointer as the times argument
        or with both tv_nsec fields set to the special value
        UTIME_NOW.

   The important piece here is "with write access to the file", and
   this matters for futimens(), which deals with an argument that
   is a file descriptor referring to the file whose timestamps are
   being updated,  The standard is saying that the "writability"
   check is based on the file permissions, not the access mode with
   which the file is opened.  (This behavior is consistent with the
   semantics of FreeBSD's futimes().)  However, Linux is currently
   doing the latter -- futimens(fd, times) is implemented as

       utimensat(fd, NULL, times, 0)

   and within the utimensat() implementation we have the code:

                f = fget(dfd);  // dfd is 'fd'
                ...
                if (f) {
                        if (!(f->f_mode & FMODE_WRITE))
                                goto mnt_drop_write_and_out;

   The check should instead be based on the file permissions.

3. The POSIX.1 draft says that if a times[n].tv_nsec field is
   UTIME_OMIT or UTIME_NOW, then the value in the corresponding tv_sec
   field is ignored.  However the current Linux implementation
   requires the tv_sec value to be zero (or the EINVAL error results).
   This requirement should be removed.

4. A further bug relates to traditional Linux behavior.  Traditionally
   (i.e., utime(2) and utimes(2)), the EPERM error could also occur if
   the 'times' argument was non-NULL (i.e., we are setting the
   timestamps to a value other than the current time) and the file is
   marked as immutable or append-only.  The current implementation
   also returns this error if 'times' is non-NULL and the tv_nsec
   fields are both UTIME_NOW.  For consistency, the

   (times != NULL && times[0].tv_nsec == UTIME_NOW &&
                     times[1].tv_nsec == UTIME_NOW)

   case should be treated like the traditional utimes() case where
   'times' is NULL.  That is, the call should succeed for a file
   marked append-only and should give the error EACCES if the file
   is marked as immutable.

Cheers,

Michael


PS For completeness, here are the expected results from various cases of
calls to utime() and utimensat().

                |   utime[s]() |     utimensat() 'times' argument
                | NULL   non-  | NULL   .       non-NULL arg
                | arg    NULL  | arg    . 2*NOW  2*OMIT  OMIT   {x,y}
                |        arg   |        .                +NOW
----------------+--------------+-------------------------------------
file owned by/  |              |        .
permissions     |              |        .
                |              |        .
caller     400  | succ   succ  | succ   . succ   succ    succ   succ
                |              |        .
not-caller 644  | EACCES EPERM | EACCES . EACCES succ    EPERM  EPERM
                |              |        .
not-caller 666  | succ   EPERM | succ   . succ   succ    EPERM  EPERM
----------------+--------------+-------------------------------------
ext2 attributes |              |        .
append-only     | succ   EPERM | succ   . succ   succ    EPERM  EPERM
                |              |        .
immutable       | EACCES EPERM | EACCES . EACCES succ    EPERM  EPERM



