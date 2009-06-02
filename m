Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZFBIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZFBIWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbZFBIW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:22:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43548 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759093AbZFBIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:22:28 -0400
Date: Tue, 2 Jun 2009 09:21:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090602092119.1a12a356@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601223241.GA26788@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
	<20090601203845.B010DFC3C7@magilla.sf.frob.com>
	<20090601223241.GA26788@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps it is easier to change dump_write() to clear TIF_SIGPENDING
> unless fatal_signal_pending(),

If you are receiving a continuous stream of SIGIO's say then how do you
guarantee the code below will make progress ?

> 
> 	int coredump_file_write(struct file *file, const void *addr, int nr)
> 	{
> 		while (nr > 0) {
> 			int res = file->f_op->write(file, addr, nr, &file->f_pos);
> 
> 			if (res > 0) {
> 				nr -= res;
> 				continue;
> 			}
> 
> 			if (!signal_pending(current))
> 				break;
> 			if (__fatal_signal_pending(current))
> 				break;
> 			clear_thread_flag(TIF_SIGPENDING);
> 		}
> 
> 		return !nr;
> 	}
> 

> Of course, this all assumes f_op->write() does not do recalc_sigpending().

Which is itself a dangerous assumption that shouldn't be propogated.
