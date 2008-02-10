Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYBJJlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYBJJlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYBJJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:40:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:25834 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYBJJky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u78nCFwVc70bxKuAHIQbwII2kk9BvovN0VLEqpF3YN48ZjOf4GkfFS3HCiR3OwybgmJ0Iq+6e0M6+9VsrAn0eMiRF+wYAi/kZaPVhw0Pr/Xht2dW15AAtYkLWMBqW5+418O2vUyZQcPF4fJQyaSMlmdUZd3ApQRylYvkD+BYal0=
Message-ID: <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
Date: Sun, 10 Feb 2008 04:40:53 -0500
From: "Niki Denev" <ndenev@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 1:38 AM, Niki Denev <ndenev@gmail.com> wrote:
>
> On Feb 10, 2008 8:32 AM, Willy Tarreau <w@1wt.eu> wrote:
> > On Sun, Feb 10, 2008 at 08:04:35AM +0200, Niki Denev wrote:
> > > Hi,
> > >
> > > As the subject says the 2.6.24.1 is still vulnerable to the vmsplice
> > > local root exploit.
> >
> > Yes indeed, that's quite bad. 2.6.24-git is still vulnerable too, and
> > also contains the fix :-(
> >
> > CC'd Jens as he worked on the fix.
> >
> > Willy
> >
> >
>
> I was unable to gain root on 2.6.24-git20
> but after several segfaults when executing the exploit continously
> the machine crashes.
>
> --Niki
>

this fixed the problem for me (kernel 2.6.24.1) :
It appears that the initial patch checked the input to vmsplice_to_user,
but the exploit used vmsplice_to_pipe which remained open to the attack.

--- fs/splice.c.orig	2008-02-08 21:55:30.000000000 +0200
+++ fs/splice.c	2008-02-10 11:32:50.000000000 +0200
@@ -1443,6 +1443,10 @@
 	struct pipe_inode_info *pipe;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
+	int error;
+	long ret;
+	void __user *base;
+	size_t len;
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
@@ -1450,6 +1454,31 @@
 		.ops = &user_page_pipe_buf_ops,
 	};

+	error = ret = 0;
+
+	/*
+	 * Get user address base and length for this iovec.
+	 */
+	error = get_user(base, &iov->iov_base);
+	if (unlikely(error))
+		return error;
+	error = get_user(len, &iov->iov_len);
+	if (unlikely(error))
+		return error;
+
+	/*
+	 * Sanity check this iovec. 0 read succeeds.
+	 */
+	if (unlikely(!len))
+		return 0;
+	if (unlikely(!base)) {
+		return -EFAULT;	
+	}
+
+	if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
+		return -EFAULT;
+	}
+
 	pipe = pipe_info(file->f_path.dentry->d_inode);
 	if (!pipe)
 		return -EBADF;
