Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYFDNNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYFDNNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYFDNNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:13:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:63502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbYFDNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=uTxfMaWSVJaxOpuuAlFdGxkatbSamjDAT0Ac++9dNJVJpAndEsUVsqI/T+DjhUfZo1
         Ed6hWGPCembdZ9ftl3e88wubWyvboauOf+MeQzfhyDrx0gdhHgy4cG1AsOhIjWGdworR
         whbEKc8mlb2vCoa/LgYnNaWmUFCMul0oj2sGs=
Message-ID: <484694CD.5020107@gmail.com>
Date: Wed, 04 Jun 2008 15:12:45 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [patch 1/4 v2] vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT
 or UTIME_NOW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX.1 draft spec for utimensat() says that if a times[n].tv_nsec
field is UTIME_OMIT or UTIME_NOW, then the value in the corresponding
tv_sec field is ignored.  See the last sentence of this para, from
the spec:

    If the tv_nsec field of a timespec structure has
    the special value UTIME_NOW, the file's relevant
    timestamp shall be set to the greatest value
    supported by the file system that is not greater than
    the current time. If the tv_nsec field has the
    special value UTIME_OMIT, the file's relevant
    timestamp shall not be changed. In either case,
    the tv_sec field shall be ignored.

However the current Linux implementation requires the tv_sec value to be
zero (or the EINVAL error results). This requirement should be removed.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-06-04 13:23:38.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-04 13:22:44.000000000 +0200
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


