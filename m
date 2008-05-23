Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYEWTRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYEWTRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYEWTRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:17:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39455 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754277AbYEWTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:17:31 -0400
Date: Fri, 23 May 2008 20:04:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: fix vcs* sysfs file creation race [v2]
Message-ID: <20080523200440.1f3efa62@core>
In-Reply-To: <20080523161434.GE5713@cathedrallabs.org>
References: <20080501192131.GA4662@jake.ruivo.org>
	<20080513204241.559b772f.akpm@linux-foundation.org>
	<20080523161434.GE5713@cathedrallabs.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But this isn't the only problem.  Currently release_dev() checks for
> tty->count without holding any locks but BKL that is acquired on tty_release()
> and several tty drivers also check tty->count and some of them without even

Yes - the old stable branches were fixed to used atomic_t but for some
reason this never ended up in 2.5/2.6.

> 1) We get rid of tty->count usage on drivers by implementing internal
>    counters.  This solution would allow us to fix each driver before
>    converting tty->count into a kref and only be used by tty layer.  This
>    proposed patch does eliminate tty->count usage on vt.

We need to do this anyway because of the race between an interrupt on one
processor and a hangup/close on another. So tty needs a kref and if tty
has a kref count it might as well be the tty->count replacement. It's on
my todo list but feel free to beat me to it.

> 2) We kill the current one open/close for each tty_open, only calling
>    driver's open and close on the first open and last close.  By looking on
>    the tty drivers, none of them do anything important with multiple opens
>    anyway (but I might be wrong on this).

Several use it to track things like board use counters. I'd prefer to
avoid that change, especially as it isn't needed long term. Also long
term tty->open is moving towards standardised library code - thats where
having tty_port leads.

kref the tty not the vty would be my suggestion.

Alan
