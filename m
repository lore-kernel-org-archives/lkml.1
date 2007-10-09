Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXJILPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXJILPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXJILOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:14:54 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10399 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbXJILOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:14:53 -0400
Subject: Re: [PATCH] lockdep: Avoid /proc/lockdep & lock_stat infinite
	output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071009013011.GV8181@ftp.linux.org.uk>
References: <20071009011551.GA3592@tpepper-t42p.dolavim.us>
	 <20071009013011.GV8181@ftp.linux.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Hs2QzEOBrukxEdd9+gU"
Date: Tue, 09 Oct 2007 13:14:49 +0200
Message-Id: <1191928489.6848.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Hs2QzEOBrukxEdd9+gU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 02:30 +0100, Al Viro wrote:
> On Mon, Oct 08, 2007 at 06:15:51PM -0700, Tim Pepper wrote:
> >=20
> > When a read() requests an amount of data smaller than the amount of dat=
a
> > that the seq_file's foo_show() outputs, the output starts looping and
> > outputs the "stuck" element's data infinitely.  There may be multiple
> > sequential calls to foo_start(), foo_next()/foo_show(), and foo_stop()
> > for a single open with sequential read of the file.  The _start() does =
not
> > have to start with the 0th element and _show() might be called multiple
> > times in a row for the same element for a given open/read of the seq_fi=
le.
> > =20
> >  static void *l_start(struct seq_file *m, loff_t *pos)
> >  {
> > -	struct lock_class *class =3D m->private;
> > +	struct lock_class *class;
> > +	loff_t i =3D 0;
> > =20
> > -	if (&class->lock_entry =3D=3D all_lock_classes.next)
> > +	if (*pos =3D=3D 0)
> >  		seq_printf(m, "all lock classes:\n");
>=20
> Do not generate output outside of ->show() and you won't have these
> problems.  That's where your infinite output crap comes from.
>=20
> IOW, NAK - fix the underlying problem.


FWIW I had to do Tim's bits too. Just moving all output from the start
into the show method didn't fix it.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_proc.c |   69 +++++++++++++++++++++++----------------------=
-----
 1 file changed, 33 insertions(+), 36 deletions(-)

Index: linux-2.6/kernel/lockdep_proc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -23,32 +23,25 @@
=20
 #include "lockdep_internals.h"
=20
-static void *l_next(struct seq_file *m, void *v, loff_t *pos)
+static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	struct lock_class *class =3D v;
-
-	(*pos)++;
-
-	if (class->lock_entry.next !=3D &all_lock_classes)
-		class =3D list_entry(class->lock_entry.next, struct lock_class,
-				  lock_entry);
-	else
-		class =3D NULL;
-	m->private =3D class;
+	struct lock_class *class;
+	int i =3D 0;
=20
-	return class;
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		if (i++ =3D=3D *pos)
+			return class;
+	}
+	return NULL;
 }
=20
-static void *l_start(struct seq_file *m, loff_t *pos)
+static void *l_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_class *class =3D m->private;
-
-	if (&class->lock_entry =3D=3D all_lock_classes.next)
-		seq_printf(m, "all lock classes:\n");
-
-	return class;
+	(*pos)++;
+	return l_start(m, pos);
 }
=20
+
 static void l_stop(struct seq_file *m, void *v)
 {
 }
@@ -101,10 +94,16 @@ static void print_name(struct seq_file *
 static int l_show(struct seq_file *m, void *v)
 {
 	unsigned long nr_forward_deps, nr_backward_deps;
-	struct lock_class *class =3D m->private;
+	struct lock_class *class =3D v;
 	struct lock_list *entry;
 	char c1, c2, c3, c4;
=20
+	if (WARN_ON(class =3D=3D NULL))
+		return 0;
+
+	if (&class->lock_entry =3D=3D all_lock_classes.next)
+		seq_printf(m, "all lock classes:\n");
+
 	seq_printf(m, "%p", class->key);
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
@@ -522,28 +521,19 @@ static void seq_header(struct seq_file *
 static void *ls_start(struct seq_file *m, loff_t *pos)
 {
 	struct lock_stat_seq *data =3D m->private;
+	struct lock_stat_data *iter;
=20
-	if (data->iter =3D=3D data->stats)
-		seq_header(m);
-
-	if (data->iter =3D=3D data->iter_end)
-		data->iter =3D NULL;
+	iter =3D data->iter + *pos;
+	if (iter >=3D data->iter_end)
+		iter =3D NULL;
=20
-	return data->iter;
+	return iter;
 }
=20
 static void *ls_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_stat_seq *data =3D m->private;
-
 	(*pos)++;
-
-	data->iter =3D v;
-	data->iter++;
-	if (data->iter =3D=3D data->iter_end)
-		data->iter =3D NULL;
-
-	return data->iter;
+	return ls_start(m, pos);
 }
=20
 static void ls_stop(struct seq_file *m, void *v)
@@ -553,8 +543,15 @@ static void ls_stop(struct seq_file *m,=20
 static int ls_show(struct seq_file *m, void *v)
 {
 	struct lock_stat_seq *data =3D m->private;
+	struct lock_stat_data *iter =3D v;
+
+	if (WARN_ON(iter =3D=3D NULL))
+		return 0;
+
+	if (iter =3D=3D data->iter)
+		seq_header(m);
=20
-	seq_stats(m, data->iter);
+	seq_stats(m, iter);
 	return 0;
 }
=20


--=-3Hs2QzEOBrukxEdd9+gU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHC2KpXA2jU0ANEf4RAhswAKCA/FyWorav5yS7yCIH431QLXV3agCcD/sC
S67HxHB56erI7asFl2PgLmY=
=GiCk
-----END PGP SIGNATURE-----

--=-3Hs2QzEOBrukxEdd9+gU--

