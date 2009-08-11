Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZHKLyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZHKLyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZHKLyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:54:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbZHKLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:42 -0400
Date: Mon, 10 Aug 2009 23:05:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] kfifo reorganization for a generic interface
Message-Id: <20090810230543.1a8a0dba.akpm@linux-foundation.org>
In-Reply-To: <1249829760.2085.23.camel@wall-e>
References: <1249829760.2085.23.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Aug 2009 16:56:00 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> as promised: this is the first part of the new generic kfifo interfaces.
> 
> The current kernel fifo API is not very widely used, because it has to
> many constrains. Only 13 files in the current 2.6.31 used it. FIFO's are
> like list are a very basic thing and a kfifo API which handles the most
> use case would save a lot of time and memory resources.
> 
> This is a series of patches which makes the kfifo API more generic.
> 
> This patch does reorganize the current kfifo to be ready for extensions.
> The following changes are applied:
> 
> - move out spinlock of the struct kfifo because most users don't need it
> - struct kfifo not longer be dynamically allocated. 
> - replace kfifo_put() by kfifo_put_locked() which need an additional
>   spinlock parameter.
> - replace kfifo_get() by kfifo_get_locked() which need an additional 
>   spinlock parameter.
> - removed no longer needed __kfifo_len()
> - removed no longer needed __kfifo_reset()
> - kfifo_alloc() and kfifo_init() gets an additional parameter fifo, which
>   is the address of the associated stuct kfifo_fifo.
> - fix all users of the kfifo API:

Seems reasonable.

It would be nice to just get all the locking out of the kfifo code. 
Make the whole thing unlocked and require that callers provide suitable
locking.  Because embeddeding the need for a spinlock_t in the code is
restrictive and unneeded - what if the caller wants to use
mutex_lock()?


Extra marks for working out which API functions need read-only locking
and add comments which can be used by callers who wish to use
rwsems/rwlocks, too.

And extra extra marks for working out how callers should use RCU
locking too ;)

But I think it would be sufficient to assume that callers are holding
either spin_lock() or mutex_lock() for now.  This would mean that all
those callsites would need to newly instantiate a lock of some form. 
Perhaps it would be better to avoid doing all that in the initial
patch.  So we could do it your way for now.  In which case we'd never
get around to converting all callers.  Oh well.


The patch clashes a bit with a change which someone added to
linux-next.  I dunno what tree added that change - it seems a bit
random:


commit 01711d972d6ec8096a571b07a92ae48889b9dbd3
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Mon Aug 10 10:16:25 2009 +1000
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Mon Aug 10 10:16:25 2009 +1000

    kfifo: Use "const" definitions
    
    Currently kfifo cannot be used by parts of the kernel that use "const"
    properly as kfifo itself does not use const for passed data blocks which
    are indeed const.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 29f62e1..ad6bdf5 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -38,7 +38,7 @@ extern struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask,
 				 spinlock_t *lock);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
-				unsigned char *buffer, unsigned int len);
+				const unsigned char *buffer, unsigned int len);
 extern unsigned int __kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
 
@@ -77,7 +77,7 @@ static inline void kfifo_reset(struct kfifo *fifo)
  * bytes copied.
  */
 static inline unsigned int kfifo_put(struct kfifo *fifo,
-				     unsigned char *buffer, unsigned int len)
+				const unsigned char *buffer, unsigned int len)
 {
 	unsigned long flags;
 	unsigned int ret;
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 26539e3..3765ff3 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(kfifo_free);
  * writer, you don't need extra locking to use these functions.
  */
 unsigned int __kfifo_put(struct kfifo *fifo,
-			 unsigned char *buffer, unsigned int len)
+			const unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
 

