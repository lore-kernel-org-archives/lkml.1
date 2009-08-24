Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZHXWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZHXWhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZHXWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:37:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbZHXWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:37:51 -0400
Date: Mon, 24 Aug 2009 15:34:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000008
In-Reply-To: <m1skfnggrb.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Aug 2009, Eric W. Biederman wrote:
> 
> I was looking into a change in behavior on 2.6.31-rc6 where
> data was being lost, and it appears one variant of my test program
> kills the kernel.
> 
> The following program run as an unprivileged user causes a kernel
> panic in about a minute:
> 
> aka
> 
> while :; do ./KernelTtyTest ; done

Ok, so I got back to this one after having worked on other regressions, 
and I'm not seeing anything really obvious. But it does look like we may 
have a situation where we're resetting the ldisc due to hangup at the same 
time as the writer is still active in the flushing on another CPU.

When we halt the lfisc, we cancel the delayed work, but we do it without 
the "non-sync" version that only removes the timer. If the timer just 
triggered, the delayed work might be busy running on another CPU.

Does changing the "cancel_delayed_work()" to "cancel_delayed_work_sync()" 
as in the patch below help your case? Oh, and I noticed that there was a 
stale comment lying around, so the patch removes that one too.

Untested. VERY untested. Just going by "that looks odd".

		Linus

---

 drivers/char/tty_ldisc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 1733d34..658638f 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -507,15 +507,12 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
  *	The TTY_LDISC flag being cleared ensures no further references can
  *	be obtained while the delayed work queue halt ensures that no more
  *	data is fed to the ldisc.
- *
- *	In order to wait for any existing references to complete see
- *	tty_ldisc_wait_idle.
  */
 
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_delayed_work(&tty->buf.work);
+	return cancel_delayed_work_sync(&tty->buf.work);
 }
 
 /**
