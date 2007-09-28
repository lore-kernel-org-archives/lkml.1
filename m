Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbXI1MOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbXI1MOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXI1MOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:14:16 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:43498 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752208AbXI1MOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:14:15 -0400
Subject: Re: [PATCH 01/12] lockdep: syscall exit check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
In-Reply-To: <20070928120331.GC25726@osiris.boeblingen.de.ibm.com>
References: <20070928074200.436463000@chello.nl>
	 <20070928080040.893443000@chello.nl>
	 <20070928120331.GC25726@osiris.boeblingen.de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E7nKGG+LonFD9TJBpAwI"
Date: Fri, 28 Sep 2007 14:14:11 +0200
Message-Id: <1190981651.13204.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E7nKGG+LonFD9TJBpAwI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 14:03 +0200, Heiko Carstens wrote:
> > +void lockdep_sys_exit(void)
> > +{
> > +	struct task_struct *curr =3D current;
> > +
> > +	if (unlikely(curr->lockdep_depth)) {
> > +		if (!debug_locks_off())
> > +			return;
> > +		printk("\n=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D\n");
> > +		printk(  "[ BUG: lock held at syscall exit time! ]\n");
> > +		printk(  "----------------------------------------\n");
> > +		printk("%s/%d is leaving the kernel with locks still held!\n",
> > +				curr->comm, curr->pid);
> > +		lockdep_print_held_locks(curr);
> > +	}
> > +}
>=20
> By the way, the s390 patch I just posted also checks if we hold any locks
> when returning from interrupt context to user space. Maybe the above text
> could be changed to "lock held when returning to user space" ?

Good idea, I'll look at doing the same for i386/x86_64. Traps (page
faults) would also make sense I guess.

---

Subject: lockdep: syscall exit check

Provide a check to validate that we do not hold any locks when switching
back to user-space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    2 ++
 kernel/lockdep.c        |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -238,6 +238,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
+extern void lockdep_sys_exit(void);
=20
 extern void lockdep_off(void);
 extern void lockdep_on(void);
@@ -317,6 +318,7 @@ static inline void lockdep_on(void)
 # define INIT_LOCKDEP
 # define lockdep_reset()		do { debug_locks =3D 1; } while (0)
 # define lockdep_free_key_range(start, size)	do { } while (0)
+# define lockdep_sys_exit() 			do { } while (0)
 /*
  * The class key takes no space if lockdep is disabled:
  */
Index: linux-2.6/kernel/lockdep.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -3199,3 +3199,19 @@ void debug_show_held_locks(struct task_s
 }
=20
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
+
+void lockdep_sys_exit(void)
+{
+	struct task_struct *curr =3D current;
+
+	if (unlikely(curr->lockdep_depth)) {
+		if (!debug_locks_off())
+			return;
+		printk("\n=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D\n");
+		printk(  "[ BUG: lock held when returning to user space! ]\n");
+		printk(  "------------------------------------------------\n");
+		printk("%s/%d is leaving the kernel with locks still held!\n",
+				curr->comm, curr->pid);
+		lockdep_print_held_locks(curr);
+	}
+}


--=-E7nKGG+LonFD9TJBpAwI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG/PATXA2jU0ANEf4RAphOAJ4komItPOy//HU5gT0OL3a7BvieMwCeJn9U
h4iVTAhiK8VUCs1zBZC9v0g=
=oNON
-----END PGP SIGNATURE-----

--=-E7nKGG+LonFD9TJBpAwI--

