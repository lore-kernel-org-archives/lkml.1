Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbZFXTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbZFXTde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFXTd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:33:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43395 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZFXTd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:33:27 -0400
Message-ID: <4A427F83.8010404@novell.com>
Date: Wed, 24 Jun 2009 15:33:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: [RFC PATCH] slow-work: add (module*)work->owner to fix races with
 module clients
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4288D2E4CF7B575D66B0567A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4288D2E4CF7B575D66B0567A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

(Applies to Linus' git master:626f380d)

Hi All,
  I found this while working on KVM.  I actually posted this patch with
a KVM
series yesterday and standalone earlier today, but neither seems to have
made it to the lists.  I suspect there is an issue with git-mail/postfix
on my system.

I digress. This is a repost with the patch by itself, and rebased to
Linus' tree instead of kvm.git.  Apologies if the system finally
corrects itself and the others show up.

Thoughts?

Regards,
-Greg

-----------------------------

slow-work: add (module*)work->owner to fix races with module clients

The slow_work facility was designed to use reference counting instead of
barriers for synchronization.  The reference counting mechanism is
implemented as a vtable op (->get_ref, ->put_ref) callback.  This is
problematic for module use of the slow_work facility because it is
impossible
to synchronize against the .text installed in the callbacks: There is
no way to ensure that the slow-work threads have completely exited the
=2Etext in question and rmmod may yank it out from under the slow_work th=
read.

This patch attempts to address this issue by transparently mapping "struc=
t
module* owner" to the slow_work item, and maintaining a module reference
count coincident with the more externally visible reference count.  Since=

the slow_work facility is resident in kernel, it should be a race-free
location to issue a module_put() call.  This will ensure that modules
can properly cleanup before exiting.

A module_get()/module_put() pair on slow_work_enqueue() and the subsequen=
t
dequeue technically adds the overhead of the atomic operations for every
work item scheduled.  However, slow_work is designed for deferring
relatively long-running and/or sleepy tasks to begin with, so this
overhead will hopefully be negligible.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: David Howells <dhowells@redhat.com>
---

 include/linux/slow-work.h |    4 ++++
 kernel/slow-work.c        |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b65c888..9f48dab 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_SLOW_WORK
=20
 #include <linux/sysctl.h>
+#include <linux/module.h>
=20
 struct slow_work;
=20
@@ -42,6 +43,7 @@ struct slow_work_ops {
  *   queued
  */
 struct slow_work {
+    struct module          *owner;
     unsigned long        flags;
 #define SLOW_WORK_PENDING    0    /* item pending (further) execution */=

 #define SLOW_WORK_EXECUTING    1    /* item currently executing */
@@ -61,6 +63,7 @@ struct slow_work {
 static inline void slow_work_init(struct slow_work *work,
                   const struct slow_work_ops *ops)
 {
+    work->owner =3D THIS_MODULE;
     work->flags =3D 0;
     work->ops =3D ops;
     INIT_LIST_HEAD(&work->link);
@@ -78,6 +81,7 @@ static inline void slow_work_init(struct slow_work *wor=
k,
 static inline void vslow_work_init(struct slow_work *work,
                    const struct slow_work_ops *ops)
 {
+    work->owner =3D THIS_MODULE;
     work->flags =3D 1 << SLOW_WORK_VERY_SLOW;
     work->ops =3D ops;
     INIT_LIST_HEAD(&work->link);
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 09d7519..1dc3486 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -220,6 +220,8 @@ static bool slow_work_execute(void)
     }
=20
     work->ops->put_ref(work);
+    barrier(); /* ensure that put_ref is not re-ordered with module_put =
*/
+    module_put(work->owner);
     return true;
=20
 auto_requeue:
@@ -299,6 +301,8 @@ int slow_work_enqueue(struct slow_work *work)
         if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
             set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
         } else {
+            if (!try_module_get(work->owner))
+                goto cant_get_mod;
             if (work->ops->get_ref(work) < 0)
                 goto cant_get_ref;
             if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
@@ -313,6 +317,8 @@ int slow_work_enqueue(struct slow_work *work)
     return 0;
=20
 cant_get_ref:
+    module_put(work->owner);
+cant_get_mod:
     spin_unlock_irqrestore(&slow_work_queue_lock, flags);
     return -EAGAIN;
 }



--------------enig4288D2E4CF7B575D66B0567A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpCf4MACgkQlOSOBdgZUxlhCgCfawXYS5v7GVTNUuSSHQLs9X+I
DGAAn0esJBFBqEZZyQESSUffieBSFbKl
=WG+O
-----END PGP SIGNATURE-----

--------------enig4288D2E4CF7B575D66B0567A--
