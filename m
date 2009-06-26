Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZFZMBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZFZMBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbZFZMA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:00:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47172 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZFZMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:00:58 -0400
Message-ID: <4A44B86D.6010301@novell.com>
Date: Fri, 26 Jun 2009 08:00:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: dhowells@redhat.com
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] slow-work: add (module*)work->owner to fix races with
 module clients
References: <20090625014520.449.98923.stgit@dev.haskins.net>
In-Reply-To: <20090625014520.449.98923.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC57083DD7A8B3524F16917D4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC57083DD7A8B3524F16917D4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Try 3: applies to Linus' git master:626f380d)
>
> [ Changelog:
>
>     v3:
>         *) moved (module*)owner to slow_work_ops=20
>         *) removed useless barrier()
> 	*) updated documentation/comments=20
>
>     v2:
> 	*) cache "owner" value to prevent invalid access after put_ref
>
>     v1:
> 	*) initial release
> ]
>
>  =20

(I know there were several versions of this patch floating around.  This
was compounded by the fact that I had also originally submitted it as
part of a larger series against KVM and those problems I had with my
mailer.  But FWIW: This is the latest version to consider for merging to
mainline.  I've CC'd Michael Tsirkin who has reviewed this patch.=20
Perhaps I can prod an Acked-by/Reviewed-by tag out of him ;) )

Kind Regards,
-Greg

> -------------------------
>
> slow-work: add (module*)work->owner to fix races with module clients
>
> The slow_work facility was designed to use reference counting instead o=
f
> barriers for synchronization.  The reference counting mechanism is
> implemented as a vtable op (->get_ref, ->put_ref) callback.  This is
> problematic for module use of the slow_work facility because it is
> impossible to synchronize against the .text installed in the callbacks:=

> There is no way to ensure that the slow-work threads have completely
> exited the .text in question and rmmod may yank it out from under the
> slow_work thread.
>
> This patch attempts to address this issue by mapping "struct module* ow=
ner"
> to the slow_work_ops item, and maintaining a module reference
> count coincident with the more externally visible reference count.  Sin=
ce
> the slow_work facility is resident in kernel, it should be a race-free
> location to issue a module_put() call.  This will ensure that modules
> can properly cleanup before exiting.
>
> A module_get()/module_put() pair on slow_work_enqueue() and the subsequ=
ent
> dequeue technically adds the overhead of the atomic operations for ever=
y
> work item scheduled.  However, slow_work is designed for deferring
> relatively long-running and/or sleepy tasks to begin with, so this
> overhead will hopefully be negligible.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: David Howells <dhowells@redhat.com>
> ---
>
>  Documentation/slow-work.txt |    6 +++++-
>  include/linux/slow-work.h   |    3 +++
>  kernel/slow-work.c          |   20 +++++++++++++++++++-
>  3 files changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
> index ebc50f8..2a38878 100644
> --- a/Documentation/slow-work.txt
> +++ b/Documentation/slow-work.txt
> @@ -80,6 +80,7 @@ Slow work items may then be set up by:
>   (2) Declaring the operations to be used for this item:
> =20
>  	struct slow_work_ops myitem_ops =3D {
> +	        .owner   =3D THIS_MODULE,
>  		.get_ref =3D myitem_get_ref,
>  		.put_ref =3D myitem_put_ref,
>  		.execute =3D myitem_execute,
> @@ -102,7 +103,10 @@ A suitably set up work item can then be enqueued f=
or processing:
>  	int ret =3D slow_work_enqueue(&myitem);
> =20
>  This will return a -ve error if the thread pool is unable to gain a re=
ference
> -on the item, 0 otherwise.
> +on the item, 0 otherwise.  Loadable modules may only enqueue work if a=
t least
> +one reference to the module is known to be held.  The slow-work infras=
tructure
> +will acquire a reference to the module and hold it until after the ite=
m's
> +reference is dropped, assuring the stability of the callback.
> =20
> =20
>  The items are reference counted, so there ought to be no need for a fl=
ush
> diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
> index b65c888..1382918 100644
> --- a/include/linux/slow-work.h
> +++ b/include/linux/slow-work.h
> @@ -17,6 +17,7 @@
>  #ifdef CONFIG_SLOW_WORK
> =20
>  #include <linux/sysctl.h>
> +#include <linux/module.h>
> =20
>  struct slow_work;
> =20
> @@ -24,6 +25,8 @@ struct slow_work;
>   * The operations used to support slow work items
>   */
>  struct slow_work_ops {
> +	struct module *owner;
> +
>  	/* get a ref on a work item
>  	 * - return 0 if successful, -ve if not
>  	 */
> diff --git a/kernel/slow-work.c b/kernel/slow-work.c
> index 09d7519..18dee34 100644
> --- a/kernel/slow-work.c
> +++ b/kernel/slow-work.c
> @@ -145,6 +145,15 @@ static unsigned slow_work_calc_vsmax(void)
>  	return min(vsmax, slow_work_max_threads - 1);
>  }
> =20
> +static void slow_work_put(struct slow_work *work)
> +{
> +	/* cache values that are needed during/after pointer invalidation */
> +	struct module *owner =3D work->ops->owner;
> +
> +	work->ops->put_ref(work);
> +	module_put(owner);
> +}
> +
>  /*
>   * Attempt to execute stuff queued on a slow thread.  Return true if w=
e managed
>   * it, false if there was nothing to do.
> @@ -219,7 +228,7 @@ static bool slow_work_execute(void)
>  		spin_unlock_irq(&slow_work_queue_lock);
>  	}
> =20
> -	work->ops->put_ref(work);
> +	slow_work_put(work);
>  	return true;
> =20
>  auto_requeue:
> @@ -299,6 +308,14 @@ int slow_work_enqueue(struct slow_work *work)
>  		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
>  			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
>  		} else {
> +			/*
> +			 * Callers must ensure that their module has at least
> +			 * one reference held while the work is enqueued.  We
> +			 * will acquire another reference here and drop it
> +			 * once we do the last ops->put_ref()
> +			 */
> +			__module_get(work->ops->owner);
> +
>  			if (work->ops->get_ref(work) < 0)
>  				goto cant_get_ref;
>  			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
> @@ -313,6 +330,7 @@ int slow_work_enqueue(struct slow_work *work)
>  	return 0;
> =20
>  cant_get_ref:
> +	module_put(work->ops->owner);
>  	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
>  	return -EAGAIN;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>  =20



--------------enigC57083DD7A8B3524F16917D4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpEuG0ACgkQlOSOBdgZUxnLXACgi02Ox3pcdYe2SXvITMboXoMF
MWcAn2efVqSaDTAuiWrll0/5b0Jvzyqe
=303j
-----END PGP SIGNATURE-----

--------------enigC57083DD7A8B3524F16917D4--
