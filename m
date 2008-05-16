Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbYEPVHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbYEPVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYEPVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:06:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33528 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226AbYEPVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:06:57 -0400
Date: Fri, 16 May 2008 21:55:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill empty chardev open/release methods
Message-ID: <20080516215517.30101a39@core>
In-Reply-To: <20080516160306.GA9103@infradead.org>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org>
	<16082.1210952646@vena.lwn.net>
	<20080516154922.GA25412@infradead.org>
	<20080516160306.GA9103@infradead.org>
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

> > If they literaly are 'return 0' you can just remove them, as a
> > non-existing open op will just be fine.
> 
> And here's a patch to do just that:  remove all empty chardev
> open/release methods.  Based on the list compiled by Jonathan.

Actually it turns out you can introduce bugs doing this when the BKL is
pushed down.

The problem is the methods are not NULL, they (with the lock pushed down
are)

{
	lock_kernel();
	unlock_kernel();
}

And we have drivers with setup code that does things in the wrong order
but under the BKL. eg one I just fixed did

	misc_register()
	init locks
	allocate memory
	do stuff
	return 0;

The lock/unlock in the open happens to save your butt against the wrong
order of intialisation because the open cannot occur before the lock is
taken, and thanks to the BKL it cannot make any progress until the setup
is completed. Fun too - udev loves opening things as they appear so in
some cases we might actually trigger them too.

So when you remove the _open() empty methods *please* make sure you have
verified the correctness and ordering of the entire registration path.
I've found three examples of this so far just cleaning up
drivers/watchdog.

Alan
