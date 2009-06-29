Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZF2TaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZF2TaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZF2TaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:30:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39132 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZF2TaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:30:11 -0400
Message-ID: <4A491640.9070206@novell.com>
Date: Mon, 29 Jun 2009 15:30:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dhowells@redhat.com, mst@redhat.com, swhiteho@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix races
 with module clients
References: <20090629191653.14240.44995.stgit@dev.haskins.net>
In-Reply-To: <20090629191653.14240.44995.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE5BC12E408F1E1BC0425DB71"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE5BC12E408F1E1BC0425DB71
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to Linus' linux-2.6.git/master:626f380d)
>
> [ Changelog:
>
>     v4:
> 	*) added ".owner =3D THIS_MODULE" fields to all current slow-work
> 	   clients (fscache, gfs2).
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
> I've retained Michael's "Reviewed-by:" tag from v3 since v4 is identica=
l
> in every way except the new hunks added to gfs2/fscache that he asked f=
or.
>
> Michael, if you want to recind your tag, please speak up.
>  =20

Or rescind it even.  What a dope I am.  <sighs>

-Greg
> Otherwise, please consider for inclusion.
>
> Regards,
> -Greg
>
> ---------------------------------
>
> slow-work: add (module*)work->ops->owner to fix races with module clien=
ts
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
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> CC: David Howells <dhowells@redhat.com>
> CC: Steven Whitehouse <swhiteho@redhat.com>
> ---
>
>  Documentation/slow-work.txt |    6 +++++-
>  fs/fscache/object.c         |    1 +
>  fs/fscache/operation.c      |    1 +
>  fs/gfs2/recovery.c          |    1 +
>  include/linux/slow-work.h   |    3 +++
>  kernel/slow-work.c          |   20 +++++++++++++++++++-
>  6 files changed, 30 insertions(+), 2 deletions(-)
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
> diff --git a/fs/fscache/object.c b/fs/fscache/object.c
> index 392a41b..d236eb1 100644
> --- a/fs/fscache/object.c
> +++ b/fs/fscache/object.c
> @@ -45,6 +45,7 @@ static void fscache_enqueue_dependents(struct fscache=
_object *);
>  static void fscache_dequeue_object(struct fscache_object *);
> =20
>  const struct slow_work_ops fscache_object_slow_work_ops =3D {
> +	.owner		=3D THIS_MODULE,
>  	.get_ref	=3D fscache_object_slow_work_get_ref,
>  	.put_ref	=3D fscache_object_slow_work_put_ref,
>  	.execute	=3D fscache_object_slow_work_execute,
> diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
> index e7f8d53..f1a2857 100644
> --- a/fs/fscache/operation.c
> +++ b/fs/fscache/operation.c
> @@ -453,6 +453,7 @@ static void fscache_op_execute(struct slow_work *wo=
rk)
>  }
> =20
>  const struct slow_work_ops fscache_op_slow_work_ops =3D {
> +	.owner		=3D THIS_MODULE,
>  	.get_ref	=3D fscache_op_get_ref,
>  	.put_ref	=3D fscache_op_put_ref,
>  	.execute	=3D fscache_op_execute,
> diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
> index 59d2695..0c2a6aa 100644
> --- a/fs/gfs2/recovery.c
> +++ b/fs/gfs2/recovery.c
> @@ -593,6 +593,7 @@ fail:
>  }
> =20
>  struct slow_work_ops gfs2_recover_ops =3D {
> +	.owner   =3D THIS_MODULE,
>  	.get_ref =3D gfs2_recover_get_ref,
>  	.put_ref =3D gfs2_recover_put_ref,
>  	.execute =3D gfs2_recover_work,
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



--------------enigE5BC12E408F1E1BC0425DB71
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpJFkMACgkQlOSOBdgZUxk4NACcC2P2Jt/hGuUChSKWEcOOh04p
AGwAnR3MW6F0O9hEg0qWxhYBj69KfVlw
=ndVc
-----END PGP SIGNATURE-----

--------------enigE5BC12E408F1E1BC0425DB71--
