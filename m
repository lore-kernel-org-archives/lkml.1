Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYIINT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYIINT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYIINTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:19:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43072 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751569AbYIINTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:19:51 -0400
Date: Tue, 9 Sep 2008 14:19:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-ID: <20080909141932.2f9832bd@lxorguk.ukuu.org.uk>
In-Reply-To: <48C676E0.1080600@skyrush.com>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
	<20080908173250.2452c5b8.akpm@linux-foundation.org>
	<48C67374.1000108@skyrush.com>
	<20080909141210.4fd546a1@lxorguk.ukuu.org.uk>
	<48C676E0.1080600@skyrush.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Now that column state is confined to the process_out/echo funcs in
> n_tty, would using tty_write_lock() (the defined atomic write lock
> mutex) be a good replacement for lock_kernel(), even though interruptible?

That lock orders writes to the ldisc so you would often be called with it
held anyway.

> 2) To protect echo buffer operations, I would lean toward using a
> separate echo lock mutex so it does not lock against non-echo-buffer
> output.  Would nesting this with #1 be advisable?  Should it be
> interruptable?

I would start with a lock for each object you need to get the locking
right for. If you ever take more than one at once it must be in the same
order (a lock heirarchy) to avoid deadlocks.

After that works then worry about whether you have too many locks.

> 3) tty_write() mentions refers to ldisc use of the BKL.  If we change
> this, are there any considerations for the tty_io or driver code?

Shouldn't be. n_tty is the last real user of the BKL in the ldisc layer.
I've been over the driver write methods already and they *should* now be
sorted and safe.

Alan
