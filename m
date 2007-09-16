Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXIPT3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXIPT3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXIPT24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:28:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:11585 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXIPT2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qiHGuADIR2RupbdhXiE20fZba4yD2bgCShpxmVUmn8206Y40JES2RmTKSeLtcSzgww++FHWgbG0lpBVqPJP/CyiCLQcVXoM95MSJh/89tLGTUpuf/moeCQtQLlW9z5pQSWcDxTpw8G51fvYLkbL5zhBqYwdCvCiHa0WkhcgqaJs=
Message-ID: <a781481a0709161228t216322dcq5dfd60062bb825be@mail.gmail.com>
Date: Mon, 17 Sep 2007 00:58:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: iunique() fails to return ino_t (after commit 866b04fccbf125cd)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I think commit 866b04fccbf125cd39f2bdbcfeaa611d39a061a8 was wrong, and
introduced a regression.

The "relevant" changelog [*] of that patch says:


>  on filesystems w/o permanent inode numbers, i_ino values can be larger
>  than 32 bits, which can cause problems for some 32 bit userspace programs
>  on a 64 bit kernel.  We can't do anything for filesystems that have
>  actual >32-bit inode numbers, but on filesystems that generate i_ino
>  values on the fly, we should try to have them fit in 32 bits.  We could
>  trivially fix this by making the static counters in new_inode and iunique
>  32 bits [...]
>
> [...]
> When a 32-bit program that was not compiled with large file offsets does a
> stat and gets a st_ino value back that won't fit in the 32 bit field, glibc
> (correctly) generates an EOVERFLOW error.  We can't do anything about fs's
> with larger permanent inode numbers, but when we generate them on the fly,
> we ought to try and have them fit within a 32 bit field.
>
> This patch takes the first step toward this by making the static counters
> in these two functions be 32 bits.


1. First and foremost, there was nothing wrong with the existing code that
   needed to be "fixed" at all, i.e. there was no "problem" to be solved in
   the first place. As was said, glibc *correctly* returns EOVERFLOW when a
   userspace application built *without* _FILE_OFFSET_BITS == 64 (i.e.
   ino_t != __ino64_t) tries to stat(2) a file whose serial number does not
   fit in the "st_ino" member of struct stat. This behaviour is (1) correct,
   (2) explicitly mandated by the Single UNIX Specification, and, (3) all
   userspace programs *must* be prepared to deal with it. [ Should probably
   mention here that other implementations, such as Solaris, do conform with
   SUS here. ]

2. The patch has nothing to do with "32-bit userspace on 64-bit kernels" or
   compatibility modes whatsoever. It is unrelated and tangential that this
   behaviour is easy to reproduce on the above mentioned setup. Simply put,
   the issue is that a userspace program built *without* LFS tried to
   stat(2) a file with serial number > 2**32. Needless to say, this issue
   must be solved in the userspace program itself (either by (1) defining
   LFS, or, (2) making it aware of EOVERFLOW), and not in the kernel.

3. Solving a problem at a place where it does not exist naturally leads to
   other breakage. After 866b04fccbf125cd, iunique() no longer returns an
   ino_t, but only values <= 2**32, which limits the number of inodes on
   all filesystems that use that function. Needless to say, this is a
   *regression* w.r.t. previous kernels before that commit went in.

4. Last but not the least, the sample testcase program that was discussed
   on LKML last year to show this "problem" was buggy and wrong. A program
   built without LFS will also suffer EOVERFLOW when stat(2)'ing a file
   due to other reasons, such as filesize not fitting inside the "st_size"
   member. Do we propose to "fix" that "problem" in the kernel too ?
   Of course not!


IMHO it's bad to change the kernel's behaviour to avoid buggy userspace
programs from seeing standard-mandated errors being returned from stat(2).

So please reconsider that patch -- IMHO it clearly wasn't correct.


Satyam


[*] BTW, the changelog/patch description of this commit demonstrates
why it is a Bad Thing (tm) to have lengthy [PATCH 0/x] kind of mails
(containing important technical details) preceding a patchset.

I can only guess as to what happened, but reading the archives of the
original submission of this patchset on LKML, I think Andrew had to
append the contents of the [0/3] mail to the git commit of the [1/3]
patch (so as to not lose all those details and ensure that they got saved
in the git history), with the result that most of the changelog of commit
866b04fccbf1 has nothing to do with that particular patch at all, but
instead with other commits, that do not even touch that same file (!)

So guys, please keep "[0/x]" mails short and only as a non-technical
introduction of the patchset. All relevant discussion must come in the
other mails that contain the *real* patches.
