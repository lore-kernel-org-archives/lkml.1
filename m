Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab0CKSLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:11:01 -0500
Received: from xenotime.net ([72.52.64.118]:50623 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933867Ab0CKSKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:10:51 -0500
Message-ID: <4B993229.7090302@xenotime.net>
Date: Thu, 11 Mar 2010 10:10:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, sgruszka@redhat.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
References: <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/10 09:20, David Howells wrote:
> Document the circular buffering capabilities available in Linux.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  Documentation/circular-buffers.txt |  231 ++++++++++++++++++++++++++++++++++++
>  Documentation/memory-barriers.txt  |   20 +++
>  include/linux/circ_buf.h           |    4 +
>  3 files changed, 255 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/circular-buffers.txt
> 
> 
> diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
> new file mode 100644
> index 0000000..cde764c
> --- /dev/null
> +++ b/Documentation/circular-buffers.txt
> @@ -0,0 +1,231 @@
> +			       ================
> +			       CIRCULAR BUFFERS
> +			       ================
> +
> +By: David Howells <dhowells@redhat.com>
> +    Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> +
> +
> +Linux provides a number of features that can be used to implement circular
> +buffering.  There are two sets of such features:
> +
> + (1) Convenience functions for determining information about power-of-2 sized
> +     buffers.
> +
> + (2) Memory barriers for when the producer and the consumer of objects in the
> +     buffer don't want to share a lock.
> +
> +To use these facilities, as discussed below, there needs to be just one
> +producer and just one consumer.  It is possible to handle multiple producers by
> +serialising them, and to handle multiple consumers by serialising them.
> +
> +
> +Contents:
> +
> + (*) What is a circular buffer?
> +
> + (*) Measuring power-of-2 buffers.
> +
> + (*) Using memory barriers with circular buffers.
> +     - The producer.
> +     - The consumer.
> +
> +
> +==========================
> +WHAT IS A CIRCULAR BUFFER?
> +==========================
> +
> +First of all, what is a circular buffer?  A circular buffer is a buffer of
> +fixed, finite size into which there are two indices:
> +
> + (1) A 'head' index - the point at which the producer inserts items into the
> +     buffer.
> +
> + (2) A 'tail' index - the point at which the consumer finds the next item in
> +     the buffer.
> +
> +Typically when the tail pointer is equal to the head pointer, the buffer is
> +empty; and the buffer is full when the head pointer is one less than the tail
> +pointer.
> +
> +The head index is incremented when items are added, and the tail index when
> +items are removed.  The tail index should never jump the head index, and both
> +indices should be wrapped to 0 when they reach the end of the buffer, thus
> +allowing an infinite amount of data to flow through the buffer.
> +
> +Typically, items will all be of the same unit size, but this isn't strictly
> +required to use the techniques below.  The indices can be increased by more
> +than 1 if multiple items or variable-sized items are to be included in the
> +buffer, provided that neither index overtakes the other.  The implementer must
> +be careful, however, as a region more than one unit in size may wrap the end of
> +the buffer and be broken into two segments.
> +
> +
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
> +
> +	#include <linux/circ_buf.h>
> +
> +These are:
> +
> + (*) Measure the remaining capacity of a buffer:
> +
> +	CIRC_SPACE(head_index, tail_index, buffer_size);
> +
> +     This returns the amount of space left in the buffer[1] into which items can
> +     be inserted.
> +
> +
> + (*) Measure the maximum consecutive immediate space in a buffer:
> +
> +	CIRC_SPACE_TO_END(head_index, tail_index, buffer_size);
> +
> +     This returns the amount of consecutive space left in the buffer[1] into which

Do the "[1]" here and in the previous section refer to note [1] below?
If so, then the CIRC_CNT*() paragraphs below could use "[2]" for consistency.

> +     items can be immediately inserted without having to wrap back to the
> +     beginning of the buffer.
> +
> +
> + (*) Measure the occupancy of a buffer:
> +
> +	CIRC_CNT(head_index, tail_index, buffer_size);
> +
> +     This returns the number of items currently occupying a buffer.
> +
> +
> + (*) Measure the non-wrapping occupancy of a buffer:
> +
> +	CIRC_CNT_TO_END(head_index, tail_index, buffer_size);
> +
> +     This returns the number of consecutive items that can be extracted from
> +     the buffer without having to wrap back to the beginning of the buffer.
> +
> +
> +Each of these macros will nominally return a value between 0 and buffer_size-1,
> +however:
> +
> + [1] CIRC_SPACE*() are intended to be used in the producer.  To the producer
> +     they will return a lower bound as the producer controls the head index,
> +     but the consumer may still be depleting the buffer on another CPU and
> +     moving the tail index.
> +
> +     To the consumer it will show an upper bound as the producer may be busy
> +     depleting the space.
> +
> + [2] CIRC_CNT*() are intended to be used in the consumer.  To the consumer they
> +     will return a lower bound as the consumer controls the tail index, but the
> +     producer may still be filling the buffer on andother CPU and moving the
> +     head index.
> +
> +     To the producer it will show an upper bound as the consumer may be busy
> +     emptying the buffer.
> +
> + [3] To a third party, the order in which the writes to the indices by the
> +     producer and consumer become visible cannot be guaranteed as they are
> +     independent and may be made on different CPUs - so the result in such a
> +     situation will merely be a guess, and may even be negative.
> +
> +
> +===========================================
> +USING MEMORY BARRIERS WITH CIRCULAR BUFFERS
> +===========================================
> +
> +By using memory barriers in conjunction with circular buffers, you can avoid
> +the need to:
> +
> + (1) use a single lock to govern access to both ends of the buffer, thus
> +     allowing the buffer to be filled and emptied at the same time; and
> +
> + (2) use atomic counter operations.
> +
> +There are two sides to this: the producer that fills the buffer, and the
> +consumer that empties it.  Only one thing should be filling a buffer at any one
> +time, and only one thing should be emptying a buffer at any one time, but the
> +two sides can operate simultaneously.
> +
> +
> +THE PRODUCER
> +------------
> +
> +The producer will look something like this:

   (requires [or assumes] power-of-2 sized buffers -- same for consumer)

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
> +This will instruct the CPU that the contents of the new item must be written
> +before the head index makes it available to the consumer and then instructs the
> +CPU that the revised head index must be written before the consumer is woken.
> +
> +Note that wake_up() doesn't have to be the exact mechanism used, but whatever
> +is used must guarantee a (write) memory barrier between the update of the head
> +index and the change of state of the consumer, if a change of state occurs.
> +
> +
> +THE CONSUMER
> +------------
> +
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
> +This will instruct the CPU to make sure the index is up to date before reading
> +the new item, and then it shall make sure the CPU has finished reading the item
> +before it writes the new tail pointer, which will erase the item.
> +
> +
> +Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
> +This prevents the compiler from discarding and reloading its cached value -
> +which some compilers will do, even after an implied compiler barrier.
> +
> +
> +===============
> +FURTHER READING
> +===============
> +
> +See also Documentation/memory-barriers.txt for a description of Linux's memory
> +barrier facilities.


-- 
~Randy
