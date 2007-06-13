Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXFMCVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXFMCVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 22:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXFMCVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 22:21:32 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:46394 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXFMCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 22:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:x-gpg-fingerprint:x-gpg-key:user-agent;
        b=YhjUEYcTba/H2e/uNfN6ig7VzJsue+Ez3/Anc4xiLzbPfpA5IrpuRhYtRyPRmPHOjHyZZcszU3ifQiKx9Jq7p34HuU4Nz1Zwfo3FQ+p/AF2Zw7S7r3sWfpL/AhdLEWFIFvKL6Y7DnfLqyCf4RjnvOmqwvUbmpciWhnbBxJjybRw=
Date: Tue, 12 Jun 2007 21:21:24 -0500
From: Nelson Castillo <nelsoneci@gmail.com>
To: Stelian Pop <stelian@popies.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/1] support for user-space buffers in kfifo
Message-ID: <20070613022124.GA31974@emqbit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
X-GPG-Fingerprint: 58DC 33B3 A518 C0DB 1ED1  926D D913 5E8A C74A CF0B
X-GPG-Key: http://www.geocities.com/arhuaco/public-key.txt
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> Le mardi 12 juin 2007 =E0 11:24 -0500, Nelson Castillo a =E9crit :
> > On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> > (cut)
> > > accessing userspace memory with a spinlock taken (moreover an
> > > irqsave()
> > > one) is bad bad bad.
> >
> > Hi Stelian.
> >
> > I'm sending the new patch without kfifo_put_user and kfifo_get_user.
>=20
> Ok, I have a few formatting/documentation comments:

Applied, thanks.

> Other than that I'm ok with this patch.

Submitting.

Regards, Nelson.-

Signed-off-by: Nelson Castillo <nelson@emqbit.com>
---
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 404f446..5c4c416 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -41,8 +41,13 @@ extern struct kfifo *kfifo_alloc(unsigned int size, gfp_=
t gfp_mask,
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
+extern int __kfifo_put_user(struct kfifo *fifo,
+			    const unsigned char __user *buffer,
+			    unsigned int len);
 extern unsigned int __kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
+extern int __kfifo_get_user(struct kfifo *fifo,  unsigned char __user *buf=
fer,
+			    unsigned int len);
=20
 /**
  * __kfifo_reset - removes the entire FIFO contents, no locking version
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index cee4191..b11024e 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <asm/uaccess.h>
 #include <linux/kfifo.h>
=20
 /**
@@ -150,6 +151,61 @@ unsigned int __kfifo_put(struct kfifo *fifo,
 EXPORT_SYMBOL(__kfifo_put);
=20
 /**
+ * __kfifo_put_user - puts some data into the FIFO, from userspace
+ *		      We don't have a locking version because copy_from_user
+ *		      might sleep and you must not sleep holding a spinlock.
+ *
+ * @fifo: the fifo to be used.
+ * @buffer: the user space data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function copies at most @len bytes from the @buffer into
+ * the FIFO depending on the free space, and returns the number of
+ * bytes copied or -EFAULT if copy_from_user fails.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+int __kfifo_put_user(struct kfifo *fifo, const unsigned char __user *buffe=
r,
+		     unsigned int len)
+{
+	unsigned int l;
+
+	len =3D min(len, fifo->size - fifo->in + fifo->out);
+
+	/*
+	 * Ensure that we sample the fifo->out index -before- we
+	 * start putting bytes into the kfifo.
+	 */
+
+	smp_mb();
+
+	/* first put the data starting from fifo->in to buffer end */
+	l =3D min(len, fifo->size - (fifo->in & (fifo->size - 1)));
+
+	if (copy_from_user(fifo->buffer + (fifo->in & (fifo->size - 1)),
+			   buffer, l))
+		return  -EFAULT;
+
+
+	/* then put the rest (if any) at the beginning of the buffer */
+	if (copy_from_user(fifo->buffer, buffer + l, len - l))
+		return  -EFAULT;
+
+	/*
+	 * Ensure that we add the bytes to the kfifo -before-
+	 * we update the fifo->in index.
+	 */
+
+	smp_wmb();
+
+	fifo->in +=3D len;
+
+	return (int)len;
+}
+EXPORT_SYMBOL(__kfifo_put_user);
+
+/**
  * __kfifo_get - gets some data from the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @buffer: where the data must be copied.
@@ -194,3 +250,57 @@ unsigned int __kfifo_get(struct kfifo *fifo,
 	return len;
 }
 EXPORT_SYMBOL(__kfifo_get);
+
+/**
+ * __kfifo_get_user - gets some data from the FIFO to userspace
+ *		      We don't have a locking version because copy_to_user
+ *		      might sleep and you must not sleep holding a spinlock.
+ * @fifo: the fifo to be used.
+ * @buffer: user space buffer where the data must be copied.
+ * @len: the size of the destination buffer.
+ *
+ * This function copies at most @len bytes from the FIFO into the
+ * @buffer and returns the number of bytes copied or -EFAULT if
+ * copy_to_user fails.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+
+int __kfifo_get_user(struct kfifo *fifo,
+		     unsigned char __user *buffer, unsigned int len)
+{
+	unsigned int l;
+
+	len =3D min(len, fifo->in - fifo->out);
+
+	/*
+	 * Ensure that we sample the fifo->in index -before- we
+	 * start removing bytes from the kfifo.
+	 */
+
+	smp_rmb();
+
+	/* first get the data from fifo->out until the end of the buffer */
+	l =3D min(len, fifo->size - (fifo->out & (fifo->size - 1)));
+
+	if (copy_to_user(buffer, fifo->buffer + (fifo->out & (fifo->size - 1)), l=
))
+		return -EFAULT;
+
+	/* then get the rest (if any) from the beginning of the buffer */
+	if (copy_to_user(buffer + l, fifo->buffer, len - l))
+		return -EFAULT;
+
+	/*
+	 * Ensure that we remove the bytes from the kfifo -before-
+	 * we update the fifo->out index.
+	 */
+
+	smp_mb();
+
+	fifo->out +=3D len;
+
+	return (int)len;
+}
+EXPORT_SYMBOL(__kfifo_get_user);
+

--=20

http://arhuaco.org
http://emQbit.com

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGb1Sk2RNeisdKzwsRAlReAJ0ax70Iwf7yrHQidwsApC+5A0CHAQCgi/uL
RL8eYW4E369dVcmQXurbVro=
=WPaZ
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
