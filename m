Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZFYN3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZFYN3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZFYN3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:29:08 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47212 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219AbZFYN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:29:05 -0400
Subject: Re: Possible memory leak via tty_ldisc_try_get
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090612112222.6a8138dd@lxorguk.ukuu.org.uk>
References: <1244798508.26670.20.camel@pc1117.cambridge.arm.com>
	 <20090612112222.6a8138dd@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 25 Jun 2009 14:29:00 +0100
Message-Id: <1245936541.26218.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 13:29:01.0833 (UTC) FILETIME=[E7216790:01C9F598]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, 2009-06-12 at 11:22 +0100, Alan Cox wrote:
> On Fri, 12 Jun 2009 10:21:48 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > I noticed you pushed some changes to drivers/char/tty_ldisc.c recently.
> > I now get about 12 kmemleak reports like below (on an ARM platform):
> 
> Thanks I'll review that next week. Chances are we've sprung a real leak
> somewhere as I updated the allocation logic for ldiscs.

The fix of adding kfree() on the error path in tty_ldisc_try_get()
didn't solve the leak report (though that's needed as well). The error
path isn't triggered on my system and I still get several reports like
this:

kmemleak: unreferenced object 0xdf13b720 (size 32):                             
kmemleak:   comm "getty", pid 1349, jiffies 4294943346                          
kmemleak:   backtrace:                                                          
kmemleak:     [<c0022849>] save_stack_trace+0x15/0x18                           
kmemleak:     [<c006496f>] kmemleak_alloc+0xf3/0x1d0                            
kmemleak:     [<c0062f61>] kmem_cache_alloc+0x91/0x9c                           
kmemleak:     [<c00f6b51>] tty_ldisc_try_get+0xd/0x84                           
kmemleak:     [<c00f6d27>] tty_ldisc_get+0x13/0x54                              
kmemleak:     [<c00f6ec3>] tty_ldisc_reinit+0x27/0x64                           
kmemleak:     [<c00f6f1d>] tty_ldisc_release+0x1d/0x28                          
kmemleak:     [<c00f3ddd>] tty_release_dev+0x2e1/0x320                          
kmemleak:     [<c00f3e25>] tty_release+0x9/0xc                                  
kmemleak:     [<c0066c57>] __fput+0xa7/0x12c                                    
kmemleak:     [<c0066cfb>] fput+0x1f/0x20                                       
kmemleak:     [<c0064bd5>] filp_close+0x39/0x40                                 
kmemleak:     [<c0064c41>] sys_close+0x65/0x98                                  
kmemleak:     [<c001fc01>] ret_fast_syscall+0x1/0x40                            
kmemleak:     [<ffffffff>] 0xffffffff                                           

My understanding is that tty->ldisc should be released via
tty_ldisc_release() called just before release_tty(). The
tty_ldisc_release() calls tty_ldisc_reinit() which allocates a new
ldisc. Before commit c65c9bc3, the new ldisc was allocated on the stack
but now it is kmalloc'ed and never freed. The tty that owns it is freed
shortly afterwards and the ldisc not reachable.

The patch below fixes the leak but I haven't fully understood the logic
behind this tty_ldisc_reinit() call to be sure it is correct:


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index a19e935..fbf4b68 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -873,6 +873,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_ldisc_reinit(tty);
+	tty_ldisc_put(tty->ldisc);
 	/* This will need doing differently if we need to lock */
 	if (o_tty)
 		tty_ldisc_release(o_tty, NULL);


-- 
Catalin

