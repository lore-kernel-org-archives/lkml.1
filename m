Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYBJMXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYBJMXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYBJMXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:23:13 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:36293 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbYBJMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:23:13 -0500
Date: Sun, 10 Feb 2008 13:22:50 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Niki Denev <ndenev@gmail.com>, Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Message-ID: <20080210122250.GA24048@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Niki Denev <ndenev@gmail.com>, Willy Tarreau <w@1wt.eu>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com> <20080210063247.GQ8953@1wt.eu> <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com> <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 04:40:53AM -0500, Niki Denev wrote:
> this fixed the problem for me (kernel 2.6.24.1) :
> It appears that the initial patch checked the input to vmsplice_to_user,
> but the exploit used vmsplice_to_pipe which remained open to the attack.

This patch is broken. It opens the old hole again.

> @@ -1450,6 +1454,31 @@
>  		.ops = &user_page_pipe_buf_ops,
>  	};
> 
> +	error = ret = 0;
> +
> +	/*
> +	 * Get user address base and length for this iovec.
> +	 */
> +	error = get_user(base, &iov->iov_base);
> +	if (unlikely(error))
> +		return error;
> +	error = get_user(len, &iov->iov_len);
> +	if (unlikely(error))
> +		return error;

iov is unchecked.

> +	if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
> +		return -EFAULT;
> +	}

Use VERIFY_READ and this only checks the first entry.

I checked the following patch and it at least fixes the known exploit.

diff --git a/fs/splice.c b/fs/splice.c
index 14e2262..80beb2b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1237,6 +1237,11 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 		if (unlikely(!base))
 			break;
 
+		if (!access_ok(VERIFY_READ, base, len)) {
+			error = -EFAULT;
+			break;
+		}
+
 		/*
 		 * Get this base offset and number of pages, then map
 		 * in the user pages.
-- 
Even historians fail to learn from history -- they repeat the same mistakes.
		-- John Gill, "Patterns of Force", stardate 2534.7
