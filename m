Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZIRLWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZIRLWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZIRLWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:22:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54718 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZIRLWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:22:41 -0400
Subject: Re: 2.6.31 regression: system hang after pptp connection
 established
From: Peter Volkov <pva@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0909171359210.4950@localhost.localdomain>
References: <1253217553.3271.77.camel@tablet>
	 <alpine.LFD.2.01.0909171327230.4950@localhost.localdomain>
	 <alpine.LFD.2.01.0909171359210.4950@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Sep 2009 15:20:18 +0400
Message-Id: <1253272818.3327.161.camel@tablet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the problem here. Thank you very much.

--
Peter.

В Чтв, 17/09/2009 в 14:12 -0700, Linus Torvalds пишет:
> 
> On Thu, 17 Sep 2009, Linus Torvalds wrote:
> > 
> > What's interesting about it is that it shows a problem, but the problem it 
> > shows would seem to have nothing at all to do with ppp or networking or 
> > pty's. The problem seems to be processes stuck in disk-wait:
> 
> Ahh. I think I see what may be going on.
> 
> Somebody got a filesystem mutex, and then went to sleep due to IO. Then 
> pptp comes in, and seems to be stuck in a loop in kernel space, and 
> it seems to be stuck with preemption off.
> 
> So one CPU is stuck, and the thing that we want to run is on the same 
> run-queue, and not preempting. An looking at your CPU#1 trace, it's likely 
> looping in ppp_async_push().
> 
> And that whole loop is insane (and very prone to infinite loops), but it 
> also depends on that tty wakeup() thing.
> 
> Does this patch make a difference? Make sure to _not_ try to do the whole 
> wakeup thing if we couldn't actually insert anything into the tty buffers.
> 
> 		Linus
> ---
>  drivers/char/pty.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/pty.c b/drivers/char/pty.c
> index b33d668..53761ce 100644
> --- a/drivers/char/pty.c
> +++ b/drivers/char/pty.c
> @@ -120,8 +120,10 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
>  		/* Stuff the data into the input queue of the other end */
>  		c = tty_insert_flip_string(to, buf, c);
>  		/* And shovel */
> -		tty_flip_buffer_push(to);
> -		tty_wakeup(tty);
> +		if (c) {
> +			tty_flip_buffer_push(to);
> +			tty_wakeup(tty);
> +		}
>  	}
>  	return c;
>  }

