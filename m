Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZHCNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZHCNjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZHCNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:39:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:51241 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbZHCNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:39:20 -0400
Subject: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 15:39:15 +0200
Message-Id: <1249306755.8358.8.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proposal of a new generic kernel FIFO implementation.

The current kernel fifo API is not very widely used, because it has to many
constrains. Only 13 files in the current 2.6.30 used it. FIFO's are
like list are a very basic thing and a kfifo API which handles the most use
case would save a lot of time and memory resources.

I think there are the following reasons why kfifo is not in use.

- There is a need of a spinlock despite you need it or not
- A fifo can only allocated dynamically
- There is no support for data records inside a fifo
- The FIFO size can only a power of two
- The API is to tall, some important functions are missing

So i decided to extend the kfifo in a more generic way without blowing up
the API to much. This was my design goals:

- Generic usage: For kernel internal use or device driver
- Provide an API for the most use case
- Preserve memory resource
- Linux style habit: DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros
- Slim API: The whole API provides 13 functions.
- Ability to handle variable length records. Three type of records are
  supported:
  - Records between 0-255 bytes, with a record size field of 1 bytes
  - Records between 0-65535 bytes, with a record size field of 2 bytes
  - Byte stream, which no record size field
  Inside a fifo this record types it is not a good idea to mix them together.
- Direct copy_to_user from the fifo and copy_from_user into the fifo.
- Single structure: The fifo structure contains the management variables and
  the buffer. No extra indirection is needed to access the fifo buffer.
- Lockless access: if only one reader and one writer is active on the fifo,
  which is the common use case, there is no additional locking necessary.
- Performance
- Easy to use

The API:
--------

struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask)
 Dynamically allocates a new fifo and returns the address
 @size: the size of the internal buffer to be allocated.
 @gfp_mask: get_free_pages mask, passed to kmalloc()

void kfifo_free(struct kfifo *fifo)
 frees a dynamic allocated FIFO
 @fifo: the fifo to be freed.

void kfifo_reset(struct kfifo *fifo)
 removes the entire FIFO contents
 @fifo: the fifo to be emptied.

unsigned long kfifo_used(struct kfifo *fifo)
 * kfifo_used - returns the number of bytes currently used in the FIFO
 * @fifo: the fifo to be used.

unsigned long kfifo_size(struct kfifo *fifo)
 returns the size of the fifo in bytes
 @fifo: the fifo to be used.

kfifo_empty(struct kfifo *fifo)
 returns true if the fifo is empty
 @fifo: the fifo to be used.

kfifo_is_full(struct kfifo *fifo)
 returns true if the fifo is full
 @fifo: the fifo to be used.

unsigned long kfifo_avail(struct kfifo *fifo)
 returns the number of bytes available in the FIFO
 @fifo: the fifo to be used.

unsigned long kfifo_put(struct kfifo *fifo,
	unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
 puts some data into the FIFO without locking

 This function copies at most @n bytes from the @from into
 the FIFO depending @flags argument, and returns the number of
 bytes which cannot be copied.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @from: the data to be added.
 @n: the length of the data to be added.
 @recsize: size of record field
 @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 @total: pointer where the total number of copied bytes should stored or NULL

unsigned long kfifo_get(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
 Gets some data from the FIFO without locking.

 This function copies at most @n bytes from the @to into the FIFO depending
 on @flags argument, and returns the number of bytes which cannot be copied.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.
 @recsize: size of record field
 @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 @total: pointer where the total number of copied bytes should stored or NULL

unsigned long kfifo_from_user(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
 Puts some data from user space into the FIFO.

 This function copies at most @n bytes from the @from into the FIFO depending
 on @flags argument, and returns the number of bytes which cannot be copied.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @from: pointer to the data to be added.
 @n: the length of the data to be added.
 @recsize: size of record field
 @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 @total: pointer where the total number of copied bytes should stored or NULL

unsigned long kfifo_to_user(struct kfifo *fifo,
		void __user *to, unsigned long n, unsigned long recsize,
		unsigned long flags, unsigned long *total)
 Gets data from the FIFO and write it to user space.

 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.
 @recsize: size of record field
 @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 @total: pointer where the total number of copied bytes should stored or NULL

 This function copies at most @n bytes from the FIFO into the @to depending
 on @flags argument.
 In case of an error, the function returns the number of bytes which cannot
 be copied.
 - If the flags KFIFO_F_NOTRIM is set and the returned value is greater than
   the n parameter this means that there is not enough space to copy the
   whole record
 - Otherwise this means that the copy_to_user() functions has failed.

 Note that with only one concurrent reader and one concurrent writer, you don't
 need extra locking to use these functions.

unsigned long kfifo_peek(struct kfifo *fifo, unsigned long recsize)
 Gets the size of the next FIFO record data.

 This function returns the size of the next FIFO record in number of bytes
 @fifo: the fifo to be used.
 @recsize: size of record field


Macros defined for kernel FIFO:
-------------------------------

KFIFO_F_NOTRIM 
	flags argumet: do not cut of the record

DECLARE_KFIFO(name, size)
	declare a kernel fifo (can be used inside a struct declaration)

DEFINE_KFIFO(name, size)
	define a kernel fifo

INIT_KFIFO(name)
	initialize a FIFO


One thing is that the new API is not compatible with the old one. I had
a look at the current user of the old kfifo API and it is easy to adapt it to
the new API. These are the files which use currently the kfifo API:

/usr/src/linux/./drivers/char/nozomi.c
/usr/src/linux/./drivers/char/sonypi.c
/usr/src/linux/./drivers/infiniband/hw/cxgb3/cxio_resource.c
/usr/src/linux/./drivers/media/video/meye.c
/usr/src/linux/./drivers/net/wireless/libertas/main.c
/usr/src/linux/./drivers/platform/x86/fujitsu-laptop.c
/usr/src/linux/./drivers/platform/x86/sony-laptop.c
/usr/src/linux/./drivers/scsi/libiscsi.c
/usr/src/linux/./drivers/scsi/libiscsi_tcp.c
/usr/src/linux/./drivers/scsi/libsrp.c
/usr/src/linux/./drivers/usb/host/fhci.h
/usr/src/linux/./net/dccp/probe.c

I will do this job if there is a tendency for substitute the old API. So i ask
for comments....

Greetings,
Stefani



