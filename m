Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZL0Vss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZL0Vss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZL0Vsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:48:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:42651 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZL0Vsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:48:47 -0500
Subject: Re: [PATCH] [1/6] kfifo: Use void * pointers for user buffers
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227210311.A3629B17C5@basil.firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210311.A3629B17C5@basil.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:48:40 +0100
Message-ID: <1261950520.25298.31.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> The pointers to user buffers are currently unsigned char *, which requires
> a lot of casting in the caller for any non-char typed buffers. Use 
> void * instead.
> 

Agree. But this has gone in the macro version of the kfifo
implementation, which is type safe.

Stefani

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/kfifo.h |   10 +++++-----
>  kernel/kfifo.c        |    8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> Index: linux/include/linux/kfifo.h
> ===================================================================
> --- linux.orig/include/linux/kfifo.h
> +++ linux/include/linux/kfifo.h
> @@ -105,15 +105,15 @@ union { \
>  
>  #undef __kfifo_initializer
>  
> -extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
> +extern void kfifo_init(struct kfifo *fifo, void *buffer,
>  			unsigned int size);
>  extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
>  			gfp_t gfp_mask);
>  extern void kfifo_free(struct kfifo *fifo);
>  extern unsigned int kfifo_in(struct kfifo *fifo,
> -				const unsigned char *from, unsigned int len);
> +				const void *from, unsigned int len);
>  extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
> -				unsigned char *to, unsigned int len);
> +				void *to, unsigned int len);
>  
>  /**
>   * kfifo_reset - removes the entire FIFO contents
> @@ -195,7 +195,7 @@ static inline __must_check unsigned int
>   * bytes copied.
>   */
>  static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
> -		const unsigned char *from, unsigned int n, spinlock_t *lock)
> +		const void *from, unsigned int n, spinlock_t *lock)
>  {
>  	unsigned long flags;
>  	unsigned int ret;
> @@ -220,7 +220,7 @@ static inline unsigned int kfifo_in_lock
>   * @to buffer and returns the number of copied bytes.
>   */
>  static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
> -	unsigned char *to, unsigned int n, spinlock_t *lock)
> +	void *to, unsigned int n, spinlock_t *lock)
>  {
>  	unsigned long flags;
>  	unsigned int ret;
> Index: linux/kernel/kfifo.c
> ===================================================================
> --- linux.orig/kernel/kfifo.c
> +++ linux/kernel/kfifo.c
> @@ -28,7 +28,7 @@
>  #include <linux/log2.h>
>  #include <linux/uaccess.h>
>  
> -static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
> +static void _kfifo_init(struct kfifo *fifo, void *buffer,
>  		unsigned int size)
>  {
>  	fifo->buffer = buffer;
> @@ -44,7 +44,7 @@ static void _kfifo_init(struct kfifo *fi
>   * @size: the size of the internal buffer, this have to be a power of 2.
>   *
>   */
> -void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
> +void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)
>  {
>  	/* size must be a power of 2 */
>  	BUG_ON(!is_power_of_2(size));
> @@ -235,7 +235,7 @@ EXPORT_SYMBOL(__kfifo_in_n);
>   * Note that with only one concurrent reader and one concurrent
>   * writer, you don't need extra locking to use these functions.
>   */
> -unsigned int kfifo_in(struct kfifo *fifo, const unsigned char *from,
> +unsigned int kfifo_in(struct kfifo *fifo, const void *from,
>  				unsigned int len)
>  {
>  	len = min(kfifo_avail(fifo), len);
> @@ -277,7 +277,7 @@ EXPORT_SYMBOL(__kfifo_out_n);
>   * Note that with only one concurrent reader and one concurrent
>   * writer, you don't need extra locking to use these functions.
>   */
> -unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int len)
> +unsigned int kfifo_out(struct kfifo *fifo, void *to, unsigned int len)
>  {
>  	len = min(kfifo_len(fifo), len);
>  


