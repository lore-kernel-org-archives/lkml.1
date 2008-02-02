Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYBBQOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYBBQOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYBBQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:14:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35778 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYBBQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:14:13 -0500
To: Laurent.Vivier@bull.net
CC: pavel@ucw.cz, Paul.Clements@steeleye.com,
       nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <1201965971.4591.13.camel@frecb07144> (message from Laurent
	Vivier on Sat, 02 Feb 2008 16:26:11 +0100)
Subject: Re: [PATCH] Allow NBD to be used locally
References: <1201872332265-git-send-email-Laurent.Vivier@bull.net>
	 <20080202112336.GB5362@elf.ucw.cz> <1201965971.4591.13.camel@frecb07144>
Message-Id: <E1JLKzk-0007jY-H5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 02 Feb 2008 17:13:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > It creates a kthread to avoid the deadlock described in NBD
> > > tools documentation.  So, if nbd-client hangs waiting pages, the
> > > kblockd thread can continue its work and free pages.
> > 
> > Hmm, and if there are no other pages that can be freed? Unlikely,
> > but can happen AFAICT.
> 
> Correct. The patch improves the NBD behavior even if it is not
> perfect.  And I think if no other page can be freed your system is
> in very bad move ;-)

Not necessarily.  Problems start when the system wants to free memory
by writing out pages through NBD, and the userspace process servicing
it tries to allocate some memory in order to accomplish this.

Recent kernels have gotten much better at coping with this, so it
might not be easy to make local NBD deadlock under normal
circumstances.  But if you try hard enough, it's not impossible:
throttle_vm_writeout() can stall an allocation until pending writes
have completed, all with plenty of memory available in the system.

BTW, you can basically substitute local NBD with fuse-over-loop, and
get a similar kind of service, with similar problems.

Miklos
