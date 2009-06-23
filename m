Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZFWRwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZFWRwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZFWRwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:52:01 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39938 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZFWRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:51:58 -0400
Message-ID: <4A411636.3010903@novell.com>
Date: Tue, 23 Jun 2009 13:51:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
       kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] eventfd - revised interface and cleanups
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3E6467474E1CE9C8E97CEA85"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3E6467474E1CE9C8E97CEA85
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> The following patch changes the eventfd interface to de-couple the even=
tfd=20
> memory context, from the file pointer instance.
> Without such change, there is no clean way to racely free handle the=20
> POLLHUP event sent when the last instance of the file* goes away.
> Also, now the internal eventfd APIs are using the eventfd context inste=
ad=20
> of the file*.
> Another cleanup this patch does, is making AIO select EVENTFD, instead =
of=20
> adding a bunch of empty function stubs inside eventfd.h.
>
> Andrew, this better go via Avi and the KVM tree, since they have patche=
s=20
> that will be based on the new interface.
>
>
>
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>
>
> - Davide
>
>
> ---
>  drivers/lguest/lg.h          |    2=20
>  drivers/lguest/lguest_user.c |    4 -
>  fs/aio.c                     |   24 ++--------
>  fs/eventfd.c                 |  101 ++++++++++++++++++++++++++++++++++=
++++-----
>  include/linux/aio.h          |    4 -
>  include/linux/eventfd.h      |   17 ++-----
>  init/Kconfig                 |    1=20
>  7 files changed, 108 insertions(+), 45 deletions(-)
>
> Index: linux-2.6.mod/fs/eventfd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/fs/eventfd.c	2009-06-21 16:54:15.000000000 -0700=

> +++ linux-2.6.mod/fs/eventfd.c	2009-06-23 09:34:42.000000000 -0700
> @@ -17,32 +17,38 @@
>  #include <linux/eventfd.h>
>  #include <linux/syscalls.h>
>  #include <linux/module.h>
> +#include <linux/kref.h>
> =20
>  struct eventfd_ctx {
> +	struct kref kref;
>  	wait_queue_head_t wqh;
>  	/*
>  	 * Every time that a write(2) is performed on an eventfd, the
>  	 * value of the __u64 being written is added to "count" and a
>  	 * wakeup is performed on "wqh". A read(2) will return the "count"
>  	 * value to userspace, and will reset "count" to zero. The kernel
> -	 * size eventfd_signal() also, adds to the "count" counter and
> +	 * side eventfd_signal() also, adds to the "count" counter and
>  	 * issue a wakeup.
>  	 */
>  	__u64 count;
>  	unsigned int flags;
>  };
> =20
> -/*
> - * Adds "n" to the eventfd counter "count". Returns "n" in case of
> - * success, or a value lower then "n" in case of coutner overflow.
> - * This function is supposed to be called by the kernel in paths
> - * that do not allow sleeping. In this function we allow the counter
> - * to reach the ULLONG_MAX value, and we signal this as overflow
> - * condition by returining a POLLERR to poll(2).
> +/**
> + * eventfd_signal - Adds @n to the eventfd counter. This function is
> + *                  supposed to be called by the kernel in paths that =
do not
> + *                  allow sleeping. In this function we allow the coun=
ter
> + *                  to reach the ULLONG_MAX value, and we signal this =
as
> + *                  overflow condition by returining a POLLERR to poll=
(2).
> + *
> + * @ctx: [in] Pointer to the eventfd context.
> + * @n: [in] Value of the counter to be added to the eventfd internal c=
ounter.
> + *
> + * Returns: In case of success, it returns @n, otherwise (in case of o=
verflow
> + *          of the eventfd 64bit internal counter) a value lower than =
@n.
>   */
> -int eventfd_signal(struct file *file, int n)
> +int eventfd_signal(struct eventfd_ctx *ctx, int n)
>  {
> -	struct eventfd_ctx *ctx =3D file->private_data;
>  	unsigned long flags;
> =20
>  	if (n < 0)
> @@ -59,9 +65,49 @@ int eventfd_signal(struct file *file, in
>  }
>  EXPORT_SYMBOL_GPL(eventfd_signal);
> =20
> +static void eventfd_free(struct kref *kref)
> +{
> +	struct eventfd_ctx *ctx =3D container_of(kref, struct eventfd_ctx, kr=
ef);
> +
> +	kfree(ctx);
> +}
> +
> +/**
> + * eventfd_ctx_get - Acquires a reference to the internal eventfd cont=
ext.
> + *
> + * @ctx: [in] Pointer to the eventfd context.
> + *
> + * Returns: In case of success, returns a pointer to the eventfd conte=
xt,
> + *          otherwise a proper error code.
> + */
> +struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
> +{
> +	kref_get(&ctx->kref);
> +	return ctx;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_get);
> +
> +/**
> + * eventfd_ctx_put - Releases a reference to the internal eventfd cont=
ext
> + *                   (previously acquired either with eventfd_ctx_get(=
) or
> + *                   eventfd_ctx_fdget()).
> + *
> + * @ctx: [in] Pointer to eventfd context.
> + *
> + * Returns: Nothing.
> + */
> +void eventfd_ctx_put(struct eventfd_ctx *ctx)
> +{
> +	kref_put(&ctx->kref, eventfd_free);
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_put);
> +
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	wake_up_poll(&ctx->wqh, POLLHUP);
> +	eventfd_ctx_put(ctx);
>  	return 0;
>  }
> =20
> @@ -185,6 +231,14 @@ static const struct file_operations even
>  	.write		=3D eventfd_write,
>  };
> =20
> +/**
> + * eventfd_fget - Acquire a reference of an eventfd file descriptor.
> + *
> + * @fd: [in] Eventfd file descriptor.
> + *
> + * Returns: A pointer to the eventfd file structure in case of success=
, or a
> + *          proper error pointer in case of failure.
> + */
>  struct file *eventfd_fget(int fd)
>  {
>  	struct file *file;
> @@ -201,6 +255,30 @@ struct file *eventfd_fget(int fd)
>  }
>  EXPORT_SYMBOL_GPL(eventfd_fget);
> =20
> +/**
> + * eventfd_ctx_fdget - Acquires a reference to the internal eventfd co=
ntext
> + *                     given an eventfd file descriptor.
> + *
> + * @fd: [in] Eventfd file descriptor.
> + *
> + * Returns: In case of success, it returns a pointer to the internal e=
ventfd
> + *          context, otherwise a proper error code.
> + */
> +struct eventfd_ctx *eventfd_ctx_fdget(int fd)
> +{
> +	struct file *file;
> +	struct eventfd_ctx *ctx;
> +
> +	file =3D eventfd_fget(fd);
> +	if (IS_ERR(file))
> +		return (struct eventfd_ctx *) file;
> +	ctx =3D eventfd_ctx_get(file->private_data);
> +	fput(file);
> +
> +	return ctx;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_fdget);
> +
>  SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
>  {
>  	int fd;
> @@ -217,6 +295,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int,=20
>  	if (!ctx)
>  		return -ENOMEM;
> =20
> +	kref_init(&ctx->kref);
>  	init_waitqueue_head(&ctx->wqh);
>  	ctx->count =3D count;
>  	ctx->flags =3D flags;
> Index: linux-2.6.mod/include/linux/eventfd.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-21 16:54:15.0000=
00000 -0700
> +++ linux-2.6.mod/include/linux/eventfd.h	2009-06-23 08:54:43.000000000=
 -0700
> @@ -8,10 +8,8 @@
>  #ifndef _LINUX_EVENTFD_H
>  #define _LINUX_EVENTFD_H
> =20
> -#ifdef CONFIG_EVENTFD
> -
> -/* For O_CLOEXEC and O_NONBLOCK */
>  #include <linux/fcntl.h>
> +#include <linux/file.h>
> =20
>  /*
>   * CAREFUL: Check include/asm-generic/fcntl.h when defining
> @@ -28,15 +26,10 @@
>  #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> =20
>  struct file *eventfd_fget(int fd);
> -int eventfd_signal(struct file *file, int n);
> -
> -#else /* CONFIG_EVENTFD */
> -
> -#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
> -static inline int eventfd_signal(struct file *file, int n)
> -{ return 0; }
> -
> -#endif /* CONFIG_EVENTFD */
> +struct eventfd_ctx *eventfd_ctx_fdget(int fd);
> +struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx);
> +void eventfd_ctx_put(struct eventfd_ctx *ctx);
> +int eventfd_signal(struct eventfd_ctx *ctx, int n);
>  =20

I think the lack of a way to got from a file* to a ctx* (or back) might
be a problem.  I am not an expert, but if I understood the gist of what
Al Viro (cc'd) was saying early on, an fd can change meaning out from
under you without warning.

With the code the way it is now, I would need to call both
eventfd_fget() and eventfd_ctx_fdget() to fully acquire state (unless I
am missing something).  I would think that is a race and I am not
guaranteed to get the same object.  Can we also have a way to convert
one reference to the other?  I am thinking

struct eventfd_ctx *eventfd_ctx_fget(struct file *)

(or similar) would be sufficient.

-Greg

> =20
>  #endif /* _LINUX_EVENTFD_H */
> =20
> Index: linux-2.6.mod/fs/aio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/fs/aio.c	2009-06-21 16:54:15.000000000 -0700
> +++ linux-2.6.mod/fs/aio.c	2009-06-22 10:54:13.000000000 -0700
> @@ -485,6 +485,8 @@ static inline void really_put_req(struct
>  {
>  	assert_spin_locked(&ctx->ctx_lock);
> =20
> +	if (req->ki_eventfd !=3D NULL)
> +		eventfd_ctx_put(req->ki_eventfd);
>  	if (req->ki_dtor)
>  		req->ki_dtor(req);
>  	if (req->ki_iovec !=3D &req->ki_inline_vec)
> @@ -509,8 +511,6 @@ static void aio_fput_routine(struct work
>  		/* Complete the fput(s) */
>  		if (req->ki_filp !=3D NULL)
>  			__fput(req->ki_filp);
> -		if (req->ki_eventfd !=3D NULL)
> -			__fput(req->ki_eventfd);
> =20
>  		/* Link the iocb into the context's free list */
>  		spin_lock_irq(&ctx->ctx_lock);
> @@ -528,8 +528,6 @@ static void aio_fput_routine(struct work
>   */
>  static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>  {
> -	int schedule_putreq =3D 0;
> -
>  	dprintk(KERN_DEBUG "aio_put(%p): f_count=3D%ld\n",
>  		req, atomic_long_read(&req->ki_filp->f_count));
> =20
> @@ -549,24 +547,16 @@ static int __aio_put_req(struct kioctx *
>  	 * we would not be holding the last reference to the file*, so
>  	 * this function will be executed w/out any aio kthread wakeup.
>  	 */
> -	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
> -		schedule_putreq++;
> -	else
> -		req->ki_filp =3D NULL;
> -	if (req->ki_eventfd !=3D NULL) {
> -		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
> -			schedule_putreq++;
> -		else
> -			req->ki_eventfd =3D NULL;
> -	}
> -	if (unlikely(schedule_putreq)) {
> +	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
>  		get_ioctx(ctx);
>  		spin_lock(&fput_lock);
>  		list_add(&req->ki_list, &fput_head);
>  		spin_unlock(&fput_lock);
>  		queue_work(aio_wq, &fput_work);
> -	} else
> +	} else {
> +		req->ki_filp =3D NULL;
>  		really_put_req(ctx, req);
> +	}
>  	return 1;
>  }
> =20
> @@ -1622,7 +1612,7 @@ static int io_submit_one(struct kioctx *
>  		 * an eventfd() fd, and will be signaled for each completed
>  		 * event using the eventfd_signal() function.
>  		 */
> -		req->ki_eventfd =3D eventfd_fget((int) iocb->aio_resfd);
> +		req->ki_eventfd =3D eventfd_ctx_fdget((int) iocb->aio_resfd);
>  		if (IS_ERR(req->ki_eventfd)) {
>  			ret =3D PTR_ERR(req->ki_eventfd);
>  			req->ki_eventfd =3D NULL;
> Index: linux-2.6.mod/include/linux/aio.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/include/linux/aio.h	2009-06-21 16:54:15.00000000=
0 -0700
> +++ linux-2.6.mod/include/linux/aio.h	2009-06-23 09:19:11.000000000 -07=
00
> @@ -121,9 +121,9 @@ struct kiocb {
> =20
>  	/*
>  	 * If the aio_resfd field of the userspace iocb is not zero,
> -	 * this is the underlying file* to deliver event to.
> +	 * this is the underlying eventfd context to deliver events to.
>  	 */
> -	struct file		*ki_eventfd;
> +	struct eventfd_ctx	*ki_eventfd;
>  };
> =20
>  #define is_sync_kiocb(iocb)	((iocb)->ki_key =3D=3D KIOCB_SYNC_KEY)
> Index: linux-2.6.mod/init/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/init/Kconfig	2009-06-21 16:54:15.000000000 -0700=

> +++ linux-2.6.mod/init/Kconfig	2009-06-22 10:54:13.000000000 -0700
> @@ -925,6 +925,7 @@ config SHMEM
> =20
>  config AIO
>  	bool "Enable AIO support" if EMBEDDED
> +	select EVENTFD
>  	default y
>  	help
>  	  This option enables POSIX asynchronous I/O which may by used
> Index: linux-2.6.mod/drivers/lguest/lg.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/drivers/lguest/lg.h	2009-06-21 16:54:15.00000000=
0 -0700
> +++ linux-2.6.mod/drivers/lguest/lg.h	2009-06-23 08:55:34.000000000 -07=
00
> @@ -82,7 +82,7 @@ struct lg_cpu {
> =20
>  struct lg_eventfd {
>  	unsigned long addr;
> -	struct file *event;
> +	struct eventfd_ctx *event;
>  };
> =20
>  struct lg_eventfd_map {
> Index: linux-2.6.mod/drivers/lguest/lguest_user.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/drivers/lguest/lguest_user.c	2009-06-21 16:54:15=
=2E000000000 -0700
> +++ linux-2.6.mod/drivers/lguest/lguest_user.c	2009-06-22 10:54:13.0000=
00000 -0700
> @@ -50,7 +50,7 @@ static int add_eventfd(struct lguest *lg
> =20
>  	/* Now append new entry. */
>  	new->map[new->num].addr =3D addr;
> -	new->map[new->num].event =3D eventfd_fget(fd);
> +	new->map[new->num].event =3D eventfd_ctx_fdget(fd);
>  	if (IS_ERR(new->map[new->num].event)) {
>  		kfree(new);
>  		return PTR_ERR(new->map[new->num].event);
> @@ -357,7 +357,7 @@ static int close(struct inode *inode, st
> =20
>  	/* Release any eventfds they registered. */
>  	for (i =3D 0; i < lg->eventfds->num; i++)
> -		fput(lg->eventfds->map[i].event);
> +		eventfd_ctx_put(lg->eventfds->map[i].event);
>  	kfree(lg->eventfds);
> =20
>  	/* If lg->dead doesn't contain an error code it will be NULL or a
>  =20



--------------enig3E6467474E1CE9C8E97CEA85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpBFjYACgkQlOSOBdgZUxkleACeLS4tmxQfLL9nHg42/RYhx2i8
8MUAni0HX+L/S8TYd/o8+pGhG5fwqiLt
=Mspn
-----END PGP SIGNATURE-----

--------------enig3E6467474E1CE9C8E97CEA85--
