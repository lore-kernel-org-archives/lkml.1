Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXBBK6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXBBK6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933316AbXBBK6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:58:50 -0500
Received: from ns.suse.de ([195.135.220.2]:57822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbXBBK6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:58:50 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Oleg Verych <olecom@flower.upol.cz>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, lirc@bartelmus.de
Subject: Re: lirc: igorplususb error handling cleanup
Date: Fri, 2 Feb 2007 11:58:19 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702021113160.22862@sbz-30.cs.Helsinki.FI> <slrnes64tk.m64.olecom@flower.upol.cz>
In-Reply-To: <slrnes64tk.m64.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702021158.19514.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > -	/* allocate kernel memory */
> > -	mem_failure = 0;
> > -	if (!(ir = kmalloc(sizeof(struct irctl), GFP_KERNEL))) {
> > -		mem_failure = 1;
> > -	} else {
> > -		memset(ir, 0, sizeof(struct irctl));
> > -
> > -		if (!(plugin = kmalloc(sizeof(struct lirc_plugin), GFP_KERNEL))) {
> > -			mem_failure = 2;
> > -		} else if (!(rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL))) {
> > -			mem_failure = 3;
> 
> If size of all structs, allocated here is 3-4 pages (say, 4096 bytes
> one), then, i think something like, allocating all at once may be
> utilized:
> 
> ,-*-
> |struct ir_stuff_t {
> |       struct irctl *ir;
> |       struct lirc_plugin *plugin;
> |       struct lirc_buffer *rbuf;

I guess you mean 
struct lirc_buffer rbuf;
without the "*"

> |} ir_stuff;
> |
> |ir_stuff = kzalloc(...);
> |
> |if(!ir_stuff)
> |       error;
> `-*-       
> 
> then join buffer init, usb init together and final register, after
> it. Thus to have second erroneous path.

If I understand this code correctly the allocated buffers end up as
buffers used in URBs. If that is the case you must allocate each of
them separately with kmalloc() or usb_alloc_buffer() or you violate
DMA constraints on non-coherent architectures (eg. ppc)

	Regards
		Oliver
