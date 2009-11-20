Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZKTIP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZKTIP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZKTIP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:15:56 -0500
Received: from www84.your-server.de ([213.133.104.84]:46923 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZKTIPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:15:55 -0500
Subject: [PATCH 0/7] kfifo: new API v0.7
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 Nov 2009 09:15:42 +0100
Message-ID: <1258704942.4426.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the last version was corrupted by the mail client.

This is a new generic kernel FIFO implementation.

The current kernel fifo API is not very widely used, because it has to many
constrains. Only 17 files in the current 2.6.31-rc5 used it. FIFO's are
like list's a very basic thing and a kfifo API which handles the most use
case would save a lot of development time and memory resources.

I think this are the reasons why kfifo is not in use:

- The API is to simple, important functions are missing
- A fifo can be only allocated dynamically
- There is a need of a spinlock despite you need it or not
- There is no support for data records inside a fifo

So i decided to extend the kfifo in a more generic way without blowing up
the API to much. The new API has the following benefits:

- Generic usage: For kernel internal use and/or device driver.
- Provide an API for the most use case.
- Slim API: The whole API provides 25 functions.
- Linux style habit.
- DECLARE_KFIFO, DEFINE_KFIFO and INIT_KFIFO Macros
- Direct copy_to_user from the fifo and copy_from_user into the fifo.
- The kfifo itself is an in place member of the using data structure, this save an 
  indirection access and does not waste the kernel allocator. 
- Lockless access: if only one reader and one writer is active on the fifo,
  which is the common use case, no additional locking is necessary.
- Remove spinlock - give the user the freedom of choice what kind of locking to use if 
  one is required.
- Ability to handle records. Three type of records are supported:
  - Variable length records between 0-255 bytes, with a record size field of 1 bytes.
  - Variable length records between 0-65535 bytes, with a record size field of 2 bytes.
  - Fixed size records, which no record size field.
- Preserve memory resource.
- Performance!
- Easy to use!

ChangeLog:

v.0 03.08.2009
 First proposal, post a draft
v.1 04.08.2009
 add kfifo_init()
 kfifo_put() and kfifo_get() restored to the original behavior (but without locking)
 introduce new kfifo_put_rec() and kfifo_put_rec() for FIFO record handling
 kfifo_alloc() does only allocate the FIFO buffer
 kfifo_free() does only release the FIFO buffer
 revert to power of two buffer sizes
v.2 12.08.2009
 simplify record handling
 add new kfifo_reset_out() function
 rename kfifo_put_* into kfifo_in_* to prevent miss-use by non in-kernel-tree drivers
 rename kfifo_get_* into kfifo_out_* to prevent miss-use by non in-kernel-tree drivers
 split it into separated patches
v.3 14.08.2009
 fix documentation
 fix some issues
 refactorized code
 refactorized patches
v.4 16.08.2009
 kfifo_in_rec(): change @from type into a void pointer  
 kfifo_out_rec(): change @to type into a void pointer
 rename internal used KFIFO_INIT() macro into  __kfifo_initializer()
 fix bug in record handling - sorry, i posted an intermediate version
 fix bug in kfifo_in() - sorry, i posted an intermediate version 
 renamed the buffer used by the macros into name##kfifo_buffer (was name##_buffer)
 fix source comments
 cleanup and fix proposal document
v.5 19.08.2009
 Cleaned up record functionality
 Add mini "how to porting to the new API" guide
 Update some inline comments
v.6 24.10.2009
 Synchronized with kernel 2.6.32-rc5
 New function kfifo_avail_rec
v.7 20.11.2009
 Fix typos (thanks to Roger Quadros)
 Fix tab's

The API:
--------

int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 Allocates a new FIFO internal buffer
 The size will be rounded-up to a power of 2.
 The buffer will be release with kfifo_free().
 Return 0 if no error, otherwise the an error code.

 @fifo: the fifo to assign then new buffer
 @size: the size of the internal buffer to be allocated.
 @gfp_mask: get_free_pages mask, passed to kmalloc()


void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
 Initialize a FIFO using a preallocated buffer

 @fifo: the fifo to assign the buffer
 @buffer: the preallocated buffer to be used.
 @size: the size of the internal buffer, this have to be a power of 2.


void kfifo_free(struct kfifo *fifo)
 frees a dynamic allocated FIFO
 @fifo: the fifo to be freed.


void kfifo_reset(struct kfifo *fifo)
 removes the entire FIFO contents
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


void kfifo_skip(struct kfifo *fifo, unsigned int len)
 Skip output data
 @fifo: the fifo to be used.
 @len: number of bytes to skip


Functions for simplify porting:
-------------------------------

unsigned int kfifo_in_locked(struct kfifo *fifo,
	const unsigned char *from, unsigned int n, spinlock_t *lock)
 Puts some data into the FIFO using a spinlock for locking
 @fifo: the fifo to be used.
 @from: the data to be added.
 @len: the length of the data to be added.
 @lock: pointer to the spinlock to use for locking.

 This function copies at most @len bytes from the @from buffer into
 the FIFO depending on the free space, and returns the number of
 bytes copied.


unsigned int kfifo_out_locked(struct kfifo *fifo,
	unsigned char *to, unsigned int n, spinlock_t *lock)
 Gets some data from the FIFO using a spinlock for locking
 @fifo: the fifo to be used.
 @to: where the data must be copied.
 @len: the size of the destination buffer.
 @lock: pointer to the spinlock to use for locking.

 This function copies at most @len bytes from the FIFO into the
 @to buffer and returns the number of copied bytes.


These are the functions for handling records:
---------------------------------------------

The functions supports three different kinds of records:

- Fix size records.
  The @recsize parameter is 0 and exactly @len bytes will be copied
- Varible size records with 1 byte length field
  The @recsize parameter is 1 and a record of 0-255 bytes will be copied
- Varible size records with 2 byte length field
  The @recsize parameter is 2 and a record of 0-65535 bytes will be copied


unsigned int kfifo_in_rec(struct kfifo *fifo,
	void *from, unsigned int n, unsigned int recsize)
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
	void *to, unsigned int n, unsigned int recsize,
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

unsigned int kfifo_avail_rec(struct kfifo *fifo, unsigned int recsize)
 Returns the number of bytes available in a record FIFO

 @fifo: the fifo to be used
 @recsize: size of record field


Macros defined for kernel FIFO:
-------------------------------

DECLARE_KFIFO(name, size)
 Macro to declare a kfifo and the associated buffer

 Note: the macro can be used inside struct or union declaration

 @name: name of the declared kfifo datatype
 @size: size of the fifo buffer


INIT_KFIFO(name)
 Macro to initialize a with DECLARE_KFIFO declared kfifo
 @name: name of the declared kfifo datatype
 @size: size of the fifo buffer


DEFINE_KFIFO(name, size)
 Macro to define and initialize a kfifo

 Note: the macro can be used for global and local kfifo data type variables

 @name: name of the declared kfifo datatype
 @size: size of the fifo buffer

<End of API Documentation>

One thing is that the new API is not compatible with the old one. I had
a look at the current user of the old kfifo API and it is was easy to adapt it to
the new API. These are the files which currently use the kfifo API:

drivers/char/nozomi.c
drivers/char/sonypi.c
drivers/infiniband/hw/cxgb3/cxio_resource.c
drivers/media/video/meye.c
drivers/net/wireless/libertas/main.c
drivers/platform/x86/fujitsu-laptop.c
drivers/platform/x86/sony-laptop.c
drivers/scsi/libiscsi.c
drivers/scsi/libiscsi_tcp.c
drivers/scsi/libsrp.c
drivers/usb/host/fhci.h
net/dccp/probe.c
drivers/usb/serial/usb-serial.c
drivers/usb/serial/generic.c

The patch is splitted into 7 parts:

 Part 1: move struct kfifo in place
 Part 2: move out spinlock
 Part 3: Cleanup namespace
 Part 4: rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...
 Part 5: add DEFINE_KFIFO and friends, add very tiny functions
 Part 6: add kfifo_skip, kfifo_from_user and kfifo_to_user (does some reorg)
 Part 7: add record handling functions (does some reorg)

The patch-set is against linux-2.6.32-rc5.

Greetings,
Stefani



