Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYKJWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYKJWbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYKJWay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:30:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbYKJWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:30:52 -0500
Date: Mon, 10 Nov 2008 14:30:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
Message-Id: <20081110143039.6f21fdc3.akpm@linux-foundation.org>
In-Reply-To: <20081104174142.360a964a@lxorguk.ukuu.org.uk>
References: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081104174142.360a964a@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 17:41:42 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 5 Nov 2008 02:26:00 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > fix following warnings.
> > 
> > drivers/serial/8250.c: In function ___serial8250_shutdown___:
> > drivers/serial/8250.c:1612: warnings: ___i___ may be used uninitialized in this function
> 
> NAK
> 
> This is an incorrect compiler warning. It's also one that current gcc
> does not emit warnings for.
> 

That's a regression in current gcc, surely?

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

	BUG_ON(n == NULL);
	BUG_ON(i->head == NULL);


#define hlist_for_each(pos, head) \
	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
	     pos = pos->next)

hlist_for_each() can execute that loop zero times, in which case
serial_unlink_irq_chain will dereference an uninitialised variable.

Presumably the list shouldn't be empty at this stage, but this
is not particularly robust behaviour if that should happen..
