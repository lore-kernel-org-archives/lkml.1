Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbYEWLWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbYEWLWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbYEWLWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:22:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34493 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754800AbYEWLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:22:45 -0400
Date: Fri, 23 May 2008 12:09:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: Push the BKL down into the drivers
Message-ID: <20080523120948.4b992d67@core>
In-Reply-To: <200805221740.51016.david-b@pacbell.net>
References: <20080522224509.29ede566@core>
	<200805221740.51016.david-b@pacbell.net>
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

On Thu, 22 May 2008 17:40:50 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 22 May 2008, Alan Cox wrote:
> > Another step to removing ->ioctl and to removing the BKL
> 
> This happens to not apply with the latest patches; I'll
> address that.
> 
> Where is the writeup about exactly what lock_kernel() is
> supposed to have been protecting against in ioctl code?

There isn't one. The big problem we have is that the ioctl methods were
implicitly called under the big kernel lock. Without pushing them down
into drivers we can't take the step of actually thinking at the driver
level "is this needed". Historically therefore we've never documented
*why* or *if* it was needed - it's just there. Pushing them into the
driver means the subsystem owner gets to see the implicit locking and can
actually ask the right questions with internal driver knowledge.

Whether it is needed is dependant on the internal locking model of the
driver - does it handle parallel ioctls correctly, are there races
against other functions in the driver (eg hot unplugs). That can't be
evaluated at a high level.

It's also made harder by the fact lots of drivers have buggy assumptions
about ioctl locking (watchdog was a fine example).

Alan
