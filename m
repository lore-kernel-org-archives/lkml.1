Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZFUBOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZFUBOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 21:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZFUBOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 21:14:11 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38699 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZFUBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 21:14:09 -0400
Message-ID: <4A3D895C.7020605@novell.com>
Date: Sat, 20 Jun 2009 21:14:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig524785C19E706AE49BD3C34E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig524785C19E706AE49BD3C34E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Sat, 20 Jun 2009, Davide Libenzi wrote:
>
>  =20
>> On Sat, 20 Jun 2009, Davide Libenzi wrote:
>>
>>    =20
>>> How about the one below?
>>>      =20
>> Maybe with an interface that can be undone w/out a file* :)
>>    =20
>
> This is another alternative, based on a low-carb diet of your notifier =

> patch.
>  =20
Ah, I should always check if I have more mail before responding to a now
stale patch ;)

Will review this version at the next chance I get.

Thanks again, Davide,
-Greg

> Same concept of de-coupling VFS refcount from eventfd memory context, a=
nd=20
> allowing a poll callback register/unregister.
> AFAICS, based on my limited knowledge of the IRQfd policies, your=20
> ->release() path needs to eventfd_pollcb_unregister() and wait for all =

> pending works to be done.
>
>
>
>
> - Davide
>
>
>
> ---
>  fs/eventfd.c            |   69 +++++++++++++++++++++++++++++++++++++++=
++++++++-
>  include/linux/eventfd.h |   23 ++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.mod/fs/eventfd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/fs/eventfd.c	2009-06-20 16:25:45.000000000 -0700=

> +++ linux-2.6.mod/fs/eventfd.c	2009-06-20 16:35:22.000000000 -0700
> @@ -17,8 +17,10 @@
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
> @@ -59,9 +61,29 @@ int eventfd_signal(struct file *file, in
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
> +static void eventfd_get(struct eventfd_ctx *ctx)
> +{
> +	kref_get(&ctx->kref);
> +}
> +
> +static void eventfd_put(struct eventfd_ctx *ctx)
> +{
> +	kref_put(&ctx->kref, eventfd_free);
> +}
> +
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	wake_up_poll(&ctx->wqh, POLLHUP);
> +	eventfd_put(ctx);
>  	return 0;
>  }
> =20
> @@ -217,6 +239,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int,=20
>  	if (!ctx)
>  		return -ENOMEM;
> =20
> +	kref_init(&ctx->kref);
>  	init_waitqueue_head(&ctx->wqh);
>  	ctx->count =3D count;
>  	ctx->flags =3D flags;
> @@ -237,3 +260,47 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
>  	return sys_eventfd2(count, 0);
>  }
> =20
> +static void eventfd_pollcb_ptqueue(struct file *file, wait_queue_head_=
t *wqh,
> +				   poll_table *pt)
> +{
> +	struct eventfd_pollcb *ecb;
> +
> +	ecb =3D container_of(pt, struct eventfd_pollcb, pt);
> +
> +	add_wait_queue(wqh, &ecb->wait);
> +}
> +
> +int eventfd_pollcb_register(struct file *file, struct eventfd_pollcb *=
ecb,
> +			    wait_queue_func_t cbf)
> +{
> +	struct eventfd_ctx *ctx;
> +	unsigned int events;
> +
> +	if (file->f_op !=3D &eventfd_fops)
> +		return -EINVAL;
> +
> +	ctx =3D file->private_data;
> +
> +	/*
> +	 * Install our own custom wake-up handling so we are notified via
> +	 * a callback whenever someone signals the underlying eventfd.
> +	 */
> +	init_waitqueue_func_entry(&ecb->wait, cbf);
> +	init_poll_funcptr(&ecb->pt, eventfd_pollcb_ptqueue);
> +
> +	events =3D file->f_op->poll(file, &ecb->pt);
> +
> +	eventfd_get(ctx);
> +	ecb->ctx =3D ctx;
> +
> +	return (events & POLLIN) ? 1 : 0;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_pollcb_register);
> +
> +void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb)
> +{
> +	remove_wait_queue(&ecb->ctx->wqh, &ecb->wait);
> +	eventfd_put(ecb->ctx);
> +}
> +EXPORT_SYMBOL_GPL(eventfd_pollcb_unregister);
> +
> Index: linux-2.6.mod/include/linux/eventfd.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-20 16:25:45.0000=
00000 -0700
> +++ linux-2.6.mod/include/linux/eventfd.h	2009-06-20 16:38:20.000000000=
 -0700
> @@ -8,6 +8,20 @@
>  #ifndef _LINUX_EVENTFD_H
>  #define _LINUX_EVENTFD_H
> =20
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/file.h>
> +#include <linux/list.h>
> +#include <linux/kref.h>
> +
> +struct eventfd_ctx;
> +
> +struct eventfd_pollcb {
> +	poll_table pt;
> +	struct eventfd_ctx *ctx;
> +	wait_queue_t wait;
> +};
> +
>  #ifdef CONFIG_EVENTFD
> =20
>  /* For O_CLOEXEC and O_NONBLOCK */
> @@ -29,12 +43,21 @@
> =20
>  struct file *eventfd_fget(int fd);
>  int eventfd_signal(struct file *file, int n);
> +int eventfd_pollcb_register(struct file *file, struct eventfd_pollcb *=
ecb,
> +			    wait_queue_func_t cbf);
> +void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb);
> =20
>  #else /* CONFIG_EVENTFD */
> =20
>  #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
>  static inline int eventfd_signal(struct file *file, int n)
>  { return 0; }
> +static inline int eventfd_pollcb_register(struct file *file,
> +					  struct eventfd_pollcb *ecb,
> +					  wait_queue_func_t cbf)
> +{ return -ENOSYS; }
> +static inline void eventfd_pollcb_unregister(struct eventfd_pollcb *ec=
b)
> +{ }
> =20
>  #endif /* CONFIG_EVENTFD */
> =20
>  =20



--------------enig524785C19E706AE49BD3C34E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko9iVwACgkQlOSOBdgZUxmL4wCdGWGEcFIslHpbQXsVgSmQCtHO
0gsAn1h/uTCSpw+goXvTkrKVfd7BAtl2
=RMHc
-----END PGP SIGNATURE-----

--------------enig524785C19E706AE49BD3C34E--
