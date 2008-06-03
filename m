Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYFCWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYFCWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYFCWZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:25:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:19854 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbYFCWZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=a2VDBHDyOmIXBdmzlpzDgL3bFPXvHTKu/YRTE4pF28ZzcnQy8EVDikfi0N9i+LhzPMpfsl1vMU/AdJ634e/UOflCzk4vBXimUnxBcQ/mW2N4kOY4Yyu7SmNTy9Mf1aES4wv2nRMzvIQg0SiQDLloevPUaYPEnk/tXuDsQbyy6y4=
Message-ID: <4845C4B4.8040706@gmail.com>
Date: Wed, 04 Jun 2008 00:24:52 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [parch 1/4] vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT
 or UTIME_NOW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX.1 draft spec for utimensat() says that if a times[n].tv_nsec
field is UTIME_OMIT or UTIME_NOW, then the value in the corresponding
tv_sec field is ignored.  However the current Linux implementation
requires the tv_sec value to be zero (or the EINVAL error results).
This requirement should be removed.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 22:43:15.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 22:41:50.000000000 +0200
@@ -169,14 +169,6 @@
 	if (utimes) {
 		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
 			return -EFAULT;
-		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
-		     tstimes[0].tv_nsec == UTIME_NOW) &&
-		    tstimes[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
-		     tstimes[1].tv_nsec == UTIME_NOW) &&
-		    tstimes[1].tv_sec != 0)
-			return -EINVAL;

 		/* Nothing to do, we must not even check the path.  */
 		if (tstimes[0].tv_nsec == UTIME_OMIT &&

