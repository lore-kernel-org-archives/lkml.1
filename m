Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZFERWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZFERWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZFERWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:22:09 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:3057 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZFERWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:22:08 -0400
X-IronPort-AV: E=Sophos;i="4.41,312,1241395200"; 
   d="scan'208";a="317705220"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
References: <200906051143.06119.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 05 Jun 2009 10:22:09 -0700
In-Reply-To: <200906051143.06119.lkml@morethan.org> (Michael S. Zick's message
	of "Fri, 5 Jun 2009 11:43:03 -0500")
Message-ID: <ada63fawq7y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Jun 2009 17:22:09.0758 (UTC) FILETIME=[28525FE0:01C9E602]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > To my reading of the function, I think gcc has a point:
 > 
 > drivers/serial/8250.c: In function 'serial8250_shutdown':
 > drivers/serial/8250.c:1685: warning: 'i' may be used uninitialized in this function
 > 
 > It does read as if the code might try to initialize
 > the 'lock' field of a null pointer.

The code in question is:

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
	
		if (list_empty(i->head))
			free_irq(up->port.irq, i);

and if the hlist_for_each() doesn't find a matching irq_info to put in
i, then the BUG_ON(n == NULL) will kill the system.  So there's no bug
although it is understandable that gcc can't see that.

(Not sure why you talk about "the 'lock' field of a null pointer" -- I
assume your gcc warns about the function serial8250_shutdown() because
it is inlining a function only called from a single location)

 - R.
