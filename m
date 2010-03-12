Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0CLQAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 11:00:07 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51511 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0CLQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 11:00:01 -0500
X-Greylist: delayed 1171 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2010 11:00:01 EST
Message-ID: <4B9A6033.8010705@s5r6.in-berlin.de>
Date: Fri, 12 Mar 2010 16:39:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, sgruszka@redhat.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
References: <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> +============================
> +MEASURING POWER-OF-2 BUFFERS
> +============================
> +
> +Circular buffers that are of a size that is an exact power of two can have
> +their item count and buffer space assessed really quickly through the use of a
> +bitwise-AND instruction.  Non-power-of-2 sized buffers must use a modulus
> +(divide) instruction instead which is likely to be very slow.
> +
> +There are a set of macros to do this in Linux, that can be made use of by:

"...do this" could be misunderstood as "use a modulus instruction",
although the heading says that this section is about 2^n sized buffers.
How about reversing the leading paragraph?

    Calculating the occupied or free space of a circular buffer involves
    a somewhat slow modulus operation.  But if the buffer size is an
    exact power of 2, a quick bitwise AND can be used instead.

    There is a set of macros which do the latter, that can be made use
    of by [...]

[...]
> + [2] CIRC_CNT*() are intended to be used in the consumer.  To the consumer they
> +     will return a lower bound as the consumer controls the tail index, but the
> +     producer may still be filling the buffer on andother CPU and moving the
> +     head index.
                                                    ^^^^^^^^
                                                    another

[...]
> +The producer will look something like this:
> +
> +	spin_lock(&producer_lock);
> +
> +	unsigned long head = buffer->head;
> +	unsigned long tail = ACCESS_ONCE(buffer->tail);
> +
> +	if (CIRC_SPACE(head, tail, buffer->size) >= 1) {
> +		/* insert one item into the buffer */
> +		struct item *item = buffer[head];
> +
> +		produce_item(item);
> +
> +		smp_wmb(); /* commit the item before incrementing the head */
> +
> +		buffer->head = (head + 1) & (buffer->size - 1);
> +
> +		/* wake_up() will make sure that the head is committed before
> +		 * waking anyone up */
> +		wake_up(consumer);
> +	}
> +
> +	spin_unlock(&producer_lock);
> +
[...]
> +The consumer will look something like this:
> +
> +	spin_lock(&consumer_lock);
> +
> +	unsigned long head = ACCESS_ONCE(buffer->head);
> +	unsigned long tail = buffer->tail;
> +
> +	if (CIRC_CNT(head, tail, buffer->size) >= 1) {
> +		/* read index before reading contents at that index */
> +		smp_read_barrier_depends();
> +
> +		/* extract one item from the buffer */
> +		struct item *item = buffer[tail];
> +
> +		consume_item(item);
> +
> +		smp_mb(); /* finish reading descriptor before incrementing tail */
> +
> +		buffer->tail = (tail + 1) & (buffer->size - 1);
> +	}
> +
> +	spin_unlock(&consumer_lock);
> +
[...]
> +Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
> +This prevents the compiler from discarding and reloading its cached value -
> +which some compilers will do, even after an implied compiler barrier.

I don't understand why ACCESS_ONCE is needed here.  The CIRC_SPACE and
CIRC_CNT macros do not look at head and tail more than once.

CIRC_CNT_TO_END and CIRC_SPACE_TO_END might do that.  (In
CIRC_CNT_TO_END, tail is in danger to be loaded more than once.  In
CIRC_SPACE_TO_END, head is in danger to be loaded more than once.)
-- 
Stefan Richter
-=====-==-=- --== -==--
http://arcgraph.de/sr/
