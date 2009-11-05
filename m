Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbZKEQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbZKEQUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZKEQUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:20:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:32976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZKEQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IbiSYkfTBCSmrigiSck3W8fUHUSpMplfV+GIfX5hGOiiLsbehF3OGK5V4t8v+cM1GQ
         iKV7moc1ivoDY1zZB0eWE2E0015/pxU86VgslT1VFOwYAE9rWbtf6ndLkYENCUj/OiYl
         1isyWjWwwlIM8jhM0DNm/x3s+Ow7V7hZjYlH0=
Date: Fri, 6 Nov 2009 00:20:44 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
Message-ID: <20091105162043.GA2611@hack>
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 04:31:47PM +0100, Max Kellermann wrote:
>According to the select() / poll() documentation, a write operation on
>a file descriptor which is "ready for writing" must not block.  Linux
>violates this rule: if you pass a very large buffer to write(), the
>system call will not return until everything is written, or an error
>occurs.
>
>This patch adds a simple check: if at least one byte has already been
>written, break from the loop, instead of calling pipe_wait().

Do you have any working test-case for this?

Thanks.

>
>Signed-off-by: Max Kellermann <max@duempel.org>
>---
>
> fs/pipe.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/pipe.c b/fs/pipe.c
>index ae17d02..9d84f0b 100644
>--- a/fs/pipe.c
>+++ b/fs/pipe.c
>@@ -582,7 +582,7 @@ redo2:
> 		}
> 		if (bufs < PIPE_BUFFERS)
> 			continue;
>-		if (filp->f_flags & O_NONBLOCK) {
>+		if (filp->f_flags & O_NONBLOCK || ret > 0) {
> 			if (!ret)
> 				ret = -EAGAIN;
> 			break;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
