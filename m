Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZFUBFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZFUBFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 21:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZFUBFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 21:05:37 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47924 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZFUBFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 21:05:36 -0400
Message-ID: <4A3D875A.9040101@novell.com>
Date: Sat, 20 Jun 2009 21:05:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE485F4445B2EBE6246A5DC7E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE485F4445B2EBE6246A5DC7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Fri, 19 Jun 2009, Gregory Haskins wrote:
>
>  =20
>>> In the POLLIN event, you schedule_work(&irqfd->inject) and there are =
no=20
>>> races there AFAICS (you basically do not care of anything eventfd mem=
ory=20
>>> related at all).
>>> For POLLHUP, you do:
>>>
>>> 	spin_lock(irqfd->slock);
>>> 	if (irqfd->wqh)
>>> 		schedule_work(&irqfd->inject);
>>> 	irqfd->wqh =3D NULL;
>>> 	spin_unlock(irqfd->slock);
>>>
>>> In your work function you notice the POLLHUP condition and take prope=
r=20
>>> action (dunno what it is in your case).
>>> In your kvm_irqfd_release() function:
>>>
>>> 	spin_lock(irqfd->slock);
>>> 	if (irqfd->wqh)
>>> 		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>> 	irqfd->wqh =3D NULL;
>>> 	spin_unlock(irqfd->slock);
>>>
>>> Any races in there?
>>>  =20
>>>      =20
>> Yes, for one you have an ABBA deadlock on the irqfd->slock and wqh->lo=
ck
>> (recall wqh has to be locked to fix that other race I mentioned).
>>    =20
>
> Yep, true. How about we go in little steps?
> How about the one below?
> When you register your poll callback, you get a reference with=20
> eventfd_refget().
>  =20

I was thinking about this last night/this morning and that was
essentially what I was going to propose next as a more palatable+simpler
solution.

> At that point we have no more worries about the eventfd memory (namely =

> "wqh") going away.
> Symmetrically, you use eventfd_refput() once you done with it.
> So we basically de-couple the internal VFS refcount, from the eventfd=20
> context memory refcount.
> Where are the non-solveable races on the IRQfd side, of an approach lik=
e=20
> this one?
>  =20
None... I think that can work.  The core requirements boil down to: 1)
locking the POLLHUP (as we already discussed), and 2) holding a kref (or
equivelent) to the eventfd_ctx that the client can release once they are
fully out.  After that, it looks like any vanilla wait-queue in the kerne=
l.


>
>
>  =20
>> Yes, understood.  What I was trying to gently say is that the one-line=
r
>> proposal alone is still broken afaict.  However, if there is another
>> solution that works that you like better than 133-liner I posted, I am=

>> more than willing to help analyze it.  In the end, I only care that th=
is
>> is fixed.
>>    =20
>
> Is it so?
> What I noticed here, is that you went from "Detailed Mode" (in the emai=
ls=20
> where you were pushing the new bits), to "Hint Mode" (as below) when it=
=20
> was time to see if there were simpler solutions to the problem.
>  =20

I wasn't being purposely coy.  It was late friday and I was getting
pressure from the wife to get off the computer ;)  Plus, all the details
were in my patch, so I figured there wasn't a giant need to rehash since
it could just be gleened.  In any case, based on this current reply I
think we are on the same page now.

>  =20
>> (As a hint, I think I fixed 4-5 races with these patches, so there are=
 a
>> few others still lurking as well)
>>    =20
>
> Not knowing the details of IRQfd, hinting only is not going to help=20
> anything in this case.
>
>
>
> - Davide
>
>
>
> ---
>  fs/eventfd.c            |   37 ++++++++++++++++++++++++++++++++++++-
>  include/linux/eventfd.h |    6 ++++++
>  2 files changed, 42 insertions(+), 1 deletion(-)
>  =20

I haven't had a chance to go over the patch below in detail, but the
30,000 foot view is that it is in line with what I was thinking this
morning.  So, its a preliminary "looks good".  I'll take a closer look AS=
AP

Thanks Davide,
-Greg

> Index: linux-2.6.mod/fs/eventfd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/fs/eventfd.c	2009-06-20 13:08:22.000000000 -0700=

> +++ linux-2.6.mod/fs/eventfd.c	2009-06-20 14:00:23.000000000 -0700
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
> @@ -59,9 +61,19 @@ int eventfd_signal(struct file *file, in
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
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	wake_up_poll(&ctx->wqh, POLLHUP);
> +	kref_put(&ctx->kref, eventfd_free);
>  	return 0;
>  }
> =20
> @@ -201,6 +213,28 @@ struct file *eventfd_fget(int fd)
>  }
>  EXPORT_SYMBOL_GPL(eventfd_fget);
> =20
> +int eventfd_refget(struct file *file)
> +{
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	if (file->f_op !=3D &eventfd_fops)
> +		return -EINVAL;
> +	kref_get(&ctx->kref);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_refget);
> +
> +int eventfd_refput(struct file *file)
> +{
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	if (file->f_op !=3D &eventfd_fops)
> +		return -EINVAL;
> +	kref_put(&ctx->kref, eventfd_free);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_refput);
> +
>  SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
>  {
>  	int fd;
> @@ -217,6 +251,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int,=20
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
> --- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-20 13:08:22.0000=
00000 -0700
> +++ linux-2.6.mod/include/linux/eventfd.h	2009-06-20 13:59:09.000000000=
 -0700
> @@ -29,12 +29,18 @@
> =20
>  struct file *eventfd_fget(int fd);
>  int eventfd_signal(struct file *file, int n);
> +int eventfd_refget(struct file *file);
> +int eventfd_refput(struct file *file);
> =20
>  #else /* CONFIG_EVENTFD */
> =20
>  #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
>  static inline int eventfd_signal(struct file *file, int n)
>  { return 0; }
> +static inline int eventfd_refget(struct file *file)
> +{ return -ENOSYS; }
> +static inline int eventfd_refput(struct file *file)
> +{ return -ENOSYS; }
> =20
>  #endif /* CONFIG_EVENTFD */
> =20
>  =20



--------------enigE485F4445B2EBE6246A5DC7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko9h1oACgkQlOSOBdgZUxmC3ACeI/FGv1k+guJRl0mnFakYitDH
FKEAn10Slele58syoWQNLAxuKfVIUREg
=viJv
-----END PGP SIGNATURE-----

--------------enigE485F4445B2EBE6246A5DC7E--
