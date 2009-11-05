Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZKEQ2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZKEQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZKEQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:28:15 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:33962 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZKEQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:28:14 -0500
Message-ID: <4AF2FD04.4030306@gmail.com>
Date: Thu, 05 Nov 2009 17:27:48 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Max Kellermann <max@duempel.org>
CC: linux-kernel@vger.kernel.org, mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
In-Reply-To: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 05 Nov 2009 17:27:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann a écrit :
> According to the select() / poll() documentation, a write operation on
> a file descriptor which is "ready for writing" must not block.  Linux
> violates this rule: if you pass a very large buffer to write(), the
> system call will not return until everything is written, or an error
> occurs.
> 
> This patch adds a simple check: if at least one byte has already been
> written, break from the loop, instead of calling pipe_wait().
> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
> 
>  fs/pipe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index ae17d02..9d84f0b 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -582,7 +582,7 @@ redo2:
>  		}
>  		if (bufs < PIPE_BUFFERS)
>  			continue;
> -		if (filp->f_flags & O_NONBLOCK) {
> +		if (filp->f_flags & O_NONBLOCK || ret > 0) {
>  			if (!ret)
>  				ret = -EAGAIN;
>  			break;
> 

Then select()/poll() documentation is wrong, please correct documentation ?

http://www.opengroup.org/onlinepubs/000095399/functions/write.html

	ssize_t write(int fildes, const void *buf, size_t nbyte);

	If the O_NONBLOCK flag is clear, a write request may cause the thread to block,
	but on normal completion it shall return nbyte.

Every Unix I know behaves the same when writing to a pipe.


Your patch breaks many programs, that dont use poll()/select()

char result[1000000];
main()
{
	computethings();
	write(1, buffer, 1000000);
}


$ ./program | more

Please learn how useful O_NDELAY can be in a poll()/select() environment.

Thanks
