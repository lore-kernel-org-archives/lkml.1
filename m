Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFERlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFERlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZFERkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:40:53 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:54838 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZFERkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:40:52 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Date: Fri, 5 Jun 2009 12:40:50 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200906051143.06119.lkml@morethan.org> <ada63fawq7y.fsf@cisco.com>
In-Reply-To: <ada63fawq7y.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051240.52615.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Roland Dreier wrote:
>  > To my reading of the function, I think gcc has a point:
>  > 
>  > drivers/serial/8250.c: In function 'serial8250_shutdown':
>  > drivers/serial/8250.c:1685: warning: 'i' may be used uninitialized in this function
>  > 
>  > It does read as if the code might try to initialize
>  > the 'lock' field of a null pointer.
> 
> The code in question is:
> 
> 	static void serial_unlink_irq_chain(struct uart_8250_port *up)
> 	{
> 		struct irq_info *i;
> 		struct hlist_node *n;
> 		struct hlist_head *h;
> 	
> 		mutex_lock(&hash_mutex);
> 	
> 		h = &irq_lists[up->port.irq % NR_IRQ_HASH];
> 	
> 		hlist_for_each(n, h) {
> 			i = hlist_entry(n, struct irq_info, node);
> 			if (i->irq == up->port.irq)
> 				break;
> 		}
> 	
> 		BUG_ON(n == NULL);
> 		BUG_ON(i->head == NULL);
> 	
> 		if (list_empty(i->head))
> 			free_irq(up->port.irq, i);
> 
> and if the hlist_for_each() doesn't find a matching irq_info to put in
> i, then the BUG_ON(n == NULL) will kill the system.  So there's no bug
> although it is understandable that gcc can't see that.
> 
> (Not sure why you talk about "the 'lock' field of a null pointer" -- I
> assume your gcc warns about the function serial8250_shutdown() because
> it is inlining a function only called from a single location)
>

Later in the code that gcc thought had the problem - -
where it tries to do a spinlock_init(i->lock).

Of course, I, just like gcc, did not know the machine had already died.
I'll stick an "i = something" at the top (NULL?) just to shut up gcc.

Mike 
>  - R.
> 
> 


