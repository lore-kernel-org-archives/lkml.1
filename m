Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZF0NFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZF0NFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZF0NFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 09:05:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48281 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883AbZF0NFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 09:05:21 -0400
Date: Sat, 27 Jun 2009 14:06:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
In-Reply-To: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009 13:10:23 +0200
Michael Guntsche <mike@it-loops.com> wrote:

> Hello list, Alan,
> 
> I got the same error  with pptpgw as Sergey after switching form  
> 2.6.30 to recent git (rc1).

Yes - I've no idea what is going on with the pptpgw traces at the moment.

The path is

	pptpgw reads from the tty side (it uses a pty/tty pair and runs
	ppp over it)

	This calls the ldisc n_tty_read
		We copy some data and this makes room in the buffers
	ww call check_unthrottle (with no spinlocks held)
		This decides that thre is now room to ask the other end
		to send more
	which calls tty_unthrottle (which takes only a mutex)
	which calls pty_unthrottle
		which wakes the other side of the pty/tty pair for writing
	this calls the ppp ldisc wakeup handler for the other side
	which blows up somewhere around the tasklet code for no reason I
		can make sense of yet


and all of this should be (and seems to be) getting called with sleeping
allowed and no spinlocks taken in error.

You could stuff calls to might_sleep() in pty_unthrottle and
check_unthrottle and see which ones are triggered if any.

