Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZDCAfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZDCAfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZDCAfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:35:05 -0400
Received: from cmpxchg.org ([85.214.51.133]:38173 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZDCAfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:35:04 -0400
Date: Fri, 3 Apr 2009 02:33:02 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Christophe Lermytte <christophe.lermytte@thomson.net>,
       linux-kernel@vger.kernel.org
Subject: Re: mutex_lock_slowpath warning using mxser tty driver (input/output error)
Message-ID: <20090403003302.GB9052@cmpxchg.org>
References: <1238689565.14822.99.camel@thom> <1238696349.5133.25.camel@laptop> <20090402194401.154bbc36@lxorguk.ukuu.org.uk> <49D51EDD.4060902@gmail.com> <20090402235508.31c7f2b6@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402235508.31c7f2b6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:55:08PM +0100, Alan Cox wrote:
> On Thu, 02 Apr 2009 22:23:57 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 04/02/2009 08:44 PM, Alan Cox wrote:
> > >> It appears to want to lock a mutex in interrupt context, something
> > >> that's a definite no-no.
> > >>
> > >> CCed the folks who might know a thing or two about the driver.
> > > 
> > > Moxa is not a USB driver so the USB trace at the end makes no sense at
> > > all.
> > 
> > Yes, unreliable stack entries, but echo_set_canon_col is called from irq
> > context and locks mutex.
> 
> Which means that either the driver is calling the ldisc receive handlers
> from an IRQ directly (not allowed) or calling the tty_flip_buffer_push
> paths and set tty->low_latency
> 
> 2.6.29 is the first kernel that catches this bug with warnings.

It sets tty->low_latency = 1 on ->open(), unconditionally, and does
tty_flip_buffer_push() from the interrupt handler.

Both things seem to have been there for a very long time (git-blame
says longer than git).
