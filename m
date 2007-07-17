Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbXGQLk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbXGQLk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbXGQLkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:40:11 -0400
Received: from haxent.com ([65.99.219.155]:1635 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbXGQLkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:40:09 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 07:40:09 EDT
Message-ID: <469CA887.1080801@haxent.com.br>
Date: Tue, 17 Jul 2007 08:31:19 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: timerfd read only gets single byte?
References: <469C6F81.7070600@gmx.net> <750c918d0707170424v5e4187dducb1dcaeea5ad9db7@mail.gmail.com>
In-Reply-To: <750c918d0707170424v5e4187dducb1dcaeea5ad9db7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
 >
> Hi Davide,
> 
> While writing a test program to incorporate into the timerfd.2 man page, I
> think I've found a bug.  It looks like only the least significant byte of
> ticks is being returned from read(2), even though I am providing a 4 byte
> buffer.
> 
> The test program takes 3 command line arguments:
> 
> 1) seconds for the initial expiration
> 2) seconds for the timer interval
> 3) number of timer expirations to catch before terminating
> 
> I tried running this program and suspending it for a few minutes, to see if
> I could get a large overrun value.  When I do this on 2.6.22-rc4 (the built
> kernel I have to hand), I see the following:
> 
> ============
> $ ./timerfd_demo 1 1 500
> 0.000: timer started
> 1.005: read: 1; total=1
> 2.005: read: 1; total=2
> 3.005: read: 1; total=3
> 4.005: read: 1; total=4
> 5.006: read: 1; total=5
> ^Z
> [1]+  Stopped                 ./timerfd_demo 1 1 500
> $ date
> Tue Jul 17 09:18:11 CEST 2007
> $ date
> Tue Jul 17 09:23:40 CEST 2007
> $ fg
> ./timerfd_demo 1 1 500
> 339.769: read: 78; total=83
> 340.004: read: 1; total=84
> 341.004: read: 1; total=85
> ^C
> ==============
> 
> The after bringing the program back into the foreground, I would have
> expected to get an overrun count of 334 or thereabouts, but it looks as
> though I'm only getting the least significant byte from read(2).
> 
> Cheers,
> 
> Michael
> 
> [...]

put_user copies sizeof(*ptr) bytes to user space.

Signed-off-by: Davi Arnaut <davi@haxent.com.br


diff --git a/fs/timerfd.c b/fs/timerfd.c
index af9eca5..e9f73f5 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -140,7 +140,8 @@ static ssize_t timerfd_read(struct file *file, char
__user *buf, size_t count,
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
-		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+		res = put_user(ticks, ((u32 __user *)buf)) ? -EFAULT :
+							      sizeof(ticks);
 	return res;
 }

