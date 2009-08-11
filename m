Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZHKWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZHKWbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZHKWbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:31:17 -0400
Received: from www84.your-server.de ([213.133.104.84]:36376 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZHKWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:31:16 -0400
Subject: [PATCH 0/7] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 00:31:13 +0200
Message-Id: <1250029873.17599.98.camel@wall-e>
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
- Slim API: The whole API provides 21 functions.
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

int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 Allocates a new FIFO internal buffer
 @fifo: the fifo to assign then new buffer
 @size: the size of the internal buffer to be allocated.
 @gfp_mask: get_free_pages mask, passed to kmalloc()


void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
 Initialize a FIFO using a preallocated buffer

 The buffer will be release with kfifo_free().

 @fifo: the fifo to assign the buffer
 @buffer: the preallocated buffer to be used.
 @size: the size of the internal buffer, this have to be a power of 2.


void kfifo_free(struct kfifo *fifo)
 frees a dynamic allocated FIFO
 @fifo: the fifo to be freed.


void kfifo_reset(struct kfifo *fifo)
 removes the entire FIFO contents
 @fifo: the fifo to be emptied.


void kfifo_reset_in(struct kfifo *fifo)
 Skip input FIFO contents
 @fifo: the fifo to be emptied.


void kfifo_reset_out(struct kfifo *fifo)
 Skip output FIFO contents
 @fifo: the fifo to be emptied.


unsigned int kfifo_len(struct kfifo *fifo)
 Returns the number of used bytes in the FIFO
 @fifo: the fifo to be used.


unsigned int kfifo_size(struct kfifo *fifo)
 returns the size of the fifo in bytes
 @fifo: the fifo to be used.


kfifo_is_empty(struct kfifo *fifo)
 returns true if the fifo is empty
 @fifo: the fifo to be used.


kfifo_is_full(struct kfifo *fifo)
 Returns true if the fifo is full
 @fifo: the fifo to be used.


unsigned int kfifo_avail(struct kfifo *fifo)
 Returns the number of bytes available in the FIFO
 @fifo: the fifo to be used.


unsigned int kfifo_in(struct kfifo *fifo, unsigned char *from, unsigned int n)
 Puts some data into the FIFO.

 This function copies at most @n bytes from @from into
 the FIFO depending on the free space, and returns the number of
 bytes copied.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @from: the data to be added.
 @n: the length of the data to be added.


unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int n)
 Gets some data from the FIFO.

 This function copies at most @n bytes from the FIFO into
 @to and returns the number of copied bytes.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.

 
unsigned int kfifo_from_user(struct kfifo *fifo, const void __user *from, unsigned int n)
 Puts some data from user space into the FIFO.

 This function copies at most @n bytes from the @from into the FIFO
 and returns the number of copied bytes.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.

 @fifo: the fifo to be used.
 @from: pointer to the data to be added.
 @n: the length of the data to be added.


unsigned int kfifo_to_user(struct kfifo *fifo, void __user *to, unsigned int n)
 Gets data from the FIFO and write it to user space.

 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.

 This function copies at most @n bytes from the FIFO into @to
 and returns the number of copied bytes.

 Note that with only one concurrent reader and one concurrent writer, you don't
 need extra locking to use these functions.


These are the functions for handling records:
---------------------------------------------

unsigned int kfifo_in_rec(struct kfifo *fifo,
	unsigned char *from, unsigned int n, unsigned int recsize)
 Puts some record data into the FIFO.

 This function copies @n bytes from the @from into
 the FIFO and returns the number of bytes which cannot be copied.
 A returned value greater than the @n value means that the record doesn't
 fit into the buffer.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.
 @fifo: the fifo to be used.
 @from: the data to be added.
 @n: the length of the data to be added.
 @recsize: size of record field


unsigned int kfifo_out_rec(struct kfifo *fifo,
	unsigned char *to, unsigned int n, unsigned int recsize,
	unsigned int *total)
 Gets some record data from the FIFO.
 
 This function copies at most @n bytes from the @to into
 the FIFO and returns the number of bytes which cannot be copied.

 A returned value greater than the @n value means that the record doesn't
 fit into the @to buffer.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.
 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.
 @recsize: size of record field
 @total: pointer where the total number of to copied bytes should stored


unsigned int kfifo_from_user_rec(struct kfifo *fifo,
	const void __user *from, unsigned int n, unsigned int recsize)
 Puts some data from user space into the FIFO
 
 This function copies @n bytes from the @from into the
 FIFO and returns the number of bytes which cannot be copied. If the 
 returned value is equal or less the @n value, the copy_from_user() functions has 
 failed. Otherwise the record doesn't fit into the buffer.
 
 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.
 @fifo: the fifo to be used.
 @from: pointer to the data to be added.
 @n: the length of the data to be added.
 @recsize: size of record field


unsigned int kfifo_to_user_rec(struct kfifo *fifo,
		void __user *to, unsigned int n, unsigned int recsize,
		unsigned int *total)
 Gets data from the FIFO and write it to user space

 This function copies at most @n bytes from the FIFO into @to.
 In case of an error, the function returns the number of bytes which cannot
 be copied. If the returned value is equal or less the @n value, the
 copy_to_user() functions has failed. Otherwise the record doesn't fit into
 the @to buffer.

 Note that with only one concurrent reader and one concurrent
 writer, you don't need extra locking to use these functions.
 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @n: the size of the destination buffer.
 @recsize: size of record field
 @total: pointer where the total number of to copied bytes should stored


unsigned long kfifo_peek_rec(struct kfifo *fifo, unsigned long recsize)
 Gets the size of the next FIFO record data.

 This function returns the size of the next FIFO record in number of bytes
 @fifo: the fifo to be used.
 @recsize: size of record field


unsigned int kfifo_skip_rec(struct kfifo *fifo,	unsigned int recsize)
 Skip the next output record

 This function skips the next FIFO record

 @fifo: the fifo to be used.
 @recsize: size of record field


Macros defined for kernel FIFO:
-------------------------------

DECLARE_KFIFO(name, size)
	declare a kernel fifo (can be used inside a struct declaration)

DEFINE_KFIFO(name, size)
	define a kernel fifo

INIT_KFIFO(name)
	initialize a FIFO


One thing is that the new API is not compatible with the old one. I had
a look at the current user of the old kfifo API and it is was easy to adapt it to
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

The patch is splitted into 7 parts:
 Part 1: Code reorganization, no functional change
 Part 2: Move out spinlock
 Part 3: Cleanup namespace
 Part 4: rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...
 Part 5: add DEFINE_KFIFO and friends, add very tiny functions
 Part 6: add kfifo_from_user and kfifo_to_user
 Part 7: add record handling functions (does some reorg)

Greetings,
Stefani


