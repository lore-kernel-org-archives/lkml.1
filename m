Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZFEV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZFEV6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZFEV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:58:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbZFEV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:58:31 -0400
Date: Fri, 5 Jun 2009 14:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml@morethan.org, linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Message-Id: <20090605145756.ed566f48.akpm@linux-foundation.org>
In-Reply-To: <20090605190138.5ac32f94@lxorguk.ukuu.org.uk>
References: <200906051143.06119.lkml@morethan.org>
	<20090605190138.5ac32f94@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 19:01:38 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 5 Jun 2009 11:43:03 -0500
> "Michael S. Zick" <lkml@morethan.org> wrote:
> 
> > Group,
> > 
> > To my reading of the function, I think gcc has a point:
> > 
> > drivers/serial/8250.c: In function 'serial8250_shutdown':
> > drivers/serial/8250.c:1685: warning: 'i' may be used uninitialized in this function
> > 
> > It does read as if the code might try to initialize
> > the 'lock' field of a null pointer.
> > 
> > Suggestions?
> 
> Newer gcc ? At least current gcc appears to correctly deduce the code is
> safe.

That's a gcc regression isn't it?


	static void serial_unlink_irq_chain(struct uart_8250_port *up)
	{
		struct irq_info *i;
		struct hlist_node *n;
		struct hlist_head *h;
	
		mutex_lock(&hash_mutex);
	
		h = &irq_lists[up->port.irq % NR_IRQ_HASH];
	
		hlist_for_each(n, h) {
			i = hlist_entry(n, struct irq_info, node);
			if (i->irq == up->port.irq)
				break;
		}

#define hlist_for_each(pos, head) \
	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
	     pos = pos->next)

I don't think there's any way in which gcc can deduce that h->first is
non-zero on entry to that loop.  Even if it inlines
serial_unlink_irq_chain() into serial8250_shutdown().
