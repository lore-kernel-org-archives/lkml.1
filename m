Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZL2IlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZL2IlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 03:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZL2IlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 03:41:08 -0500
Received: from www84.your-server.de ([213.133.104.84]:39153 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZL2IlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 03:41:07 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091228204003.GH4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e>  <20091228204003.GH4994@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Dec 2009 09:40:56 +0100
Message-ID: <1262076056.23095.21.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 21:40 +0100 schrieb Andi Kleen:


> OK i checked and they all use power-of-two currently so by sheer
> luck (I doubt it is by design) they work. Still I think that
> open deathtrap should be fixed.
> 

It is fixed, and i hope it will be included in 2.6.34.

> I also don't understand how that patch "breaks your future work"
> Please elaborate on that.
> 

Very difficult to explain in a email, but i will try it:

The new macro based kfifo API handles everything as elements of a given
type. So you can have the old "unsigned char"-fifo, but also fifo of
every other type like int's, struct's and so on. The kfifo_in() and
kfifo_out() len parameter is than in the meaning of elements not bytes.
So you are able to process more than one value at a time and the macros
will return the number of processed elements (not bytes). 

kfifo_in(), kfifo_out() and kfifi_out_peek() are more in a meaning of a
max. memcpy(). For a single value it is better to use new introduced
macros kfifo_put(), kfifo_get() and kfifo_peek(), which doesn't require
the len parameter and are faster pod data types.

With this solution i have full compatibility to the orig kfifo
implementation, i can fill a fifo with a minimum of operations, and   
the desynchronization problem is also gone.

Have a look at example:

#include "kfifo.h"

#define FIFO_ELEMS	32

// declare a fifo named test with 32 int's
static DECLARE_KFIFO(test, int, FIFO_ELEMS);

void testfunc(void)
{
	int		i;
	int		buf[6];
	unsigned int 	ret;

	INIT_KFIFO(test);

	for(i = 20; i != 30; i++)
		kfifo_put(&test, &i);

	// show the number of elements in the fifo
	printk("queue len: %u\n", kfifo_len(&test)); 

	// get max. two int elements from the fifo
	ret = kfifo_out(&test, buf, 2);

	// show the number of processed elements
	printk("ret: %d\n", ret);

	// put max. two int elements in the fifo
	ret = kfifo_in(&test, buf, 2);

	// show the number of processed elements
	printk("ret: %d\n", ret);

	if (kfifo_peek(&test, &i))
		printk("%d\n", i);

	while(kfifo_get(&test, &i))
		printk("%d\n", i);
}

> -Andi
> 
> P.S.: I must say you make it really hard to use kfifos.
> 

Sorry, that was not my intention. But the old API was much harder to
use ;-)

Stefani


