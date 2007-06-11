Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXFKV0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXFKV0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXFKV0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:26:25 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:28453 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFKV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:x-gpg-fingerprint:x-gpg-key:user-agent;
        b=Kzj2mzapmVGx7y3x1vUVs/oRiIRo5TQv2AKWkcrMh3g1v+uP4o2G5uqaVmhyg35V3YkoYEpE92lZfoQKyKbJpAsadZ1IkfLbLCDRQ2H8Rt3F6k7q2sBWLI5hiK51DJGUeDuEbNbpTuLq7hDrPvFYzA+RnGj9fi81sTUf5Ao91aE=
Date: Mon, 11 Jun 2007 16:26:14 -0500
From: Nelson Castillo <nelsoneci@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Subject: [RFC][PATCH 1/1] support for user-space buffers in kfifo
Message-ID: <20070611212614.GB21025@emqbit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
X-GPG-Fingerprint: 58DC 33B3 A518 C0DB 1ED1  926D D913 5E8A C74A CF0B
X-GPG-Key: http://www.geocities.com/arhuaco/public-key.txt
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I just added support for user space buffers in kfifo. I found useful
__kfifo_get_user to copy data to a user buffer in a read call. I didn't
like the idea of having an extra buffer.

* Is it ok to add this support?
* Am I missing something?

I expect to fill the fifo using __kfifo_put in interrupt context.
If I understand correctly, I won't need extra locking if I have a
single interrupt handler filling this buffer and all the readers use a
semaphore.

This is how I'm using it now:

static ssize_t device_read(struct file *filep, char __user *buffer,
			   size_t length, loff_t * offset)
{
	struct sarpic_dev *dev =3D filep->private_data;
	int ret_val;

	if (down_interruptible (&dev->sem))
		return -ERESTARTSYS;

	while (__kfifo_len(dev->fifo) =3D=3D 0) {
		up(&dev->sem);

		if (filep->f_flags & O_NONBLOCK)
			return -EAGAIN;

		if (wait_event_interruptible(dev->readq, (__kfifo_len(dev->fifo) !=3D 0)))
			return -ERESTARTSYS;

		if (down_interruptible(&dev->sem))
			return -ERESTARTSYS;
	}

	ret_val =3D __kfifo_get_user(dev->fifo, buffer, length);

	up(&dev->sem);

	return ret_val;
}

static ssize_t
device_write(struct file *filep,
             const char __user *buffer, size_t length, loff_t *offset)
{
	struct sarpic_dev *dev =3D filep->private_data;
	int ret_val;

  if (down_interruptible (&dev->sem))
    return -ERESTARTSYS;

  ret_val =3D __kfifo_put_user(dev->fifo, buffer, length);

  up(&dev->sem);

  wake_up_interruptible(&dev->readq);

  return ret_val;
}

Regards,
Nelson.-


Signed-off-by: Nelson Castillo <nelson@emqbit.com>
---
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 404f446..4568285 100644
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
@@ -94,6 +99,32 @@ static inline unsigned int kfifo_put(struct kfifo *fifo,
 }
=20
 /**
+ * kfifo_put_user - puts some user data into the FIFO
+ * @fifo: the fifo to be used.
+ * @buffer: the user-space data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function copies at most @len bytes from the @buffer into
+ * the FIFO depending on the free space, and returns the number of
+ * bytes copied.
+ */
+static inline int kfifo_put_user(struct kfifo *fifo,
+				 const unsigned char __user *buffer,
+			         unsigned int len)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(fifo->lock, flags);
+
+	ret =3D __kfifo_put_user(fifo, buffer, len);
+
+	spin_unlock_irqrestore(fifo->lock, flags);
+
+	return ret;
+}
+
+/**
  * kfifo_get - gets some data from the FIFO
  * @fifo: the fifo to be used.
  * @buffer: where the data must be copied.
@@ -125,6 +156,34 @@ static inline unsigned int kfifo_get(struct kfifo *fif=
o,
 }
=20
 /**
+ * kfifo_get_user - gets some data from the FIFO an user buffer
+ * @fifo: the fifo to be used.
+ * @buffer: user buffer where the data must be copied
+ * @len: the size of the destination buffer.
+ *
+ * This function copies at most @len bytes from the FIFO into the
+ * @buffer and returns the number of copied bytes.
+ */
+
+static inline int kfifo_get_user(struct kfifo *fifo,
+				     unsigned char __user *buffer, unsigned int len)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(fifo->lock, flags);
+
+	ret =3D __kfifo_get_user(fifo, buffer, len);
+
+	if (fifo->in =3D=3D fifo->out)
+		fifo->in =3D fifo->out =3D 0;
+
+	spin_unlock_irqrestore(fifo->lock, flags);
+
+	return ret;
+}
+
+/**
  * __kfifo_len - returns the number of bytes available in the FIFO, no loc=
king version
  * @fifo: the fifo to be used.
  */
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index cee4191..e95ab37 100644
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
@@ -150,6 +151,59 @@ unsigned int __kfifo_put(struct kfifo *fifo,
 EXPORT_SYMBOL(__kfifo_put);
=20
 /**
+ * __kfifo_put_user - puts some data into the FIFO, from userspace
+ *		       no locking version
+ * @fifo: the fifo to be used.
+ * @buffer: the user space data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function copies at most @len bytes from the @buffer into
+ * the FIFO depending on the free space, and returns the number of
+ * bytes copied.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+int __kfifo_put_user(struct kfifo *fifo, const unsigned char __user *buffe=
r,
+	        unsigned int len)
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
+	if(copy_from_user(fifo->buffer + (fifo->in & (fifo->size - 1)),
+			  buffer, l))
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
@@ -193,4 +247,58 @@ unsigned int __kfifo_get(struct kfifo *fifo,
=20
 	return len;
 }
+
 EXPORT_SYMBOL(__kfifo_get);
+
+/**
+ * __kfifo_get_user - gets some data from the FIFO to userspace
+ *		      no blocking version
+ * @fifo: the fifo to be used.
+ * @buffer: user space buffer where the data must be copied.
+ * @len: the size of the destination buffer.
+ *
+ * This function copies at most @len bytes from the FIFO into the
+ * @buffer and returns the number of copied bytes.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+
+int __kfifo_get_user(struct kfifo *fifo,
+			 unsigned char __user *buffer, unsigned int len)
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
+
+EXPORT_SYMBOL(__kfifo_get_user);
+

--=20

http://arhuaco.org
http://emQbit.com

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGbb322RNeisdKzwsRAu0rAKCMXEZ/08owDkaP50cf5OvSOXlniwCg53rt
oAYgpb6TC/aq8u786rtS9r0=
=FI4j
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
