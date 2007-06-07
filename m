Return-Path: <linux-kernel-owner+w=401wt.eu-S937301AbXFGVyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937301AbXFGVyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764995AbXFGVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:54:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33224 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933357AbXFGVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:54:43 -0400
Date: Thu, 7 Jun 2007 22:59:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miloslav Trmac <mitr@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
Message-ID: <20070607225945.1aa71a93@the-village.bc.nu>
In-Reply-To: <46681417.5050200@redhat.com>
References: <4666832D.8080603@redhat.com>
	<46668814.7080404@redhat.com>
	<20070606174113.b7fc31da.akpm@linux-foundation.org>
	<20070607111034.18bf68b6@the-village.bc.nu>
	<46681417.5050200@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 16:20:07 +0200
Miloslav Trmac <mitr@redhat.com> wrote:

> Alan Cox napsal(a):
> >>> +			if (filp->f_op->read == tty_read) {
> >>> +				disable = 0;
> >>> +				break;
> > Why says a tty will always have f->op->read == tty_read ?
> AFAICS from tty_io.c, it will always be tty_read or hung_up_tty_read.
> Normal user processes would exit after SIGHUP and not reopen a TTY.
> 
> (I have copied the condition from __do_SAK().  That of course doesn't
> mean it's correct.)
> 	Mirek

Right it may be hung_up_tty_read that was what bothered me. I've had a
think through the different scenarios and I can't think of a simple one
where I can abuse this as the vhangup() path is current root triggered
and loses the tty (so I can't reopen on it)

There are more complex questions - what happens when the much needed
revoke() goes mainstream [and we fix all the security issues its lack
causes], and the case where I do

	login on tty1
	login on tty2

On tty1 run a process which sets nohup and causes a vhangup then opens
tty2 while tty2 command line is running some long running program that
doesn't take input that I could plausibly run legitimately (eg a long
complex sql query, or a slow security check etc)

Alan
