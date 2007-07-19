Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbXGSDrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbXGSDrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbXGSDrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:47:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758209AbXGSDrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:47:17 -0400
Date: Wed, 18 Jul 2007 20:47:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070718204706.42a02272.akpm@linux-foundation.org>
In-Reply-To: <200707182337.34767.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707181939.46910.rgetz@blackfin.uclinux.org>
	<8bd0f97a0707181653j3d44aab2tf8b6d24689458023@mail.gmail.com>
	<200707182337.34767.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 23:37:34 -0400 Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Wed 18 Jul 2007 19:53, Mike Frysinger pondered:
> > On 7/18/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > > On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
> > > > I'd suggest that any interface into here should be via function calls,
> > > > not via direct access to printk internals: think up some nice
> > > > copy_me_some_of_the_log_buffer() interface.
> > >
> > > If so - I would still like to put it in:
> > >  - ifdef CONFIG_EARLY_PRINTK
> > >  - and define as __init
> > >
> > > so that people don't use it when they shouldn't (when the kernel is up an
> > > running).
> > >
> > > Something simple like - early_copy_log_buff(void *dest, size_t n)
> > >
> > > copies n bytes from log_buf to memory area dest. Returns number of bytes that
> > > could not be copied. Can find out how many bytes are in the log_buff by
> > > calling with zero size.
> > >
> > > This is not destructive to existing interfaces (log_start and con_start are
> > > not updated/used). This should ensure that if booting does work - that normal
> > > messages come out the standard method.
> > >
> > > Any other suggestions?
> > 
> > maybe something as cheesy as early_get_log_buf() ?  that way you dont
> > have to do any buffer management, you can just operate read-only on
> > the string ...
> 
> I actually thought I might just do something like:
> 
>   char *c;
>   while (early_copy_log_buff(c, 1))
> 	out_early_serial_byte(c);
> 
> that way - I don't need to be very complex in the arch code.
> 
> That is about as cheesy/easy as I could think of...
> 

Let's forget the "early" stuff - there are applications of this at
oops-time as well, and that's as late as it gets ;)


How about

	int log_buf_read(int index, char *my_char);

You pass it a zero to start off, and it returns 0 or -1 if `index' is out
of bounds.

Probably we'd also need a log_buf_size(int) to find out how much is in there
at present (for people who want to read the last 1000 bytes).


Something simple and general, anyway.

