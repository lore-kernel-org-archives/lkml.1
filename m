Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbYGFUsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbYGFUsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYGFUs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:48:27 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39175 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757319AbYGFUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:48:26 -0400
Date: Sun, 6 Jul 2008 22:48:19 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH] scatterlist: add iteration helper
Message-ID: <20080706224819.1755f495@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2076-1215377304-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2076-1215377304-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Iteration over a sg list is not that trivial when you take into
account that memory pages might have to be mapped before being used.
Unfortunately, that means that some parts of the kernel restrict
themselves to directly accesible memory just to not have to deal with
the mess.

This patch adds a simple iterator system that allows any code to
easily traverse an sg list and not have to deal with all the details.
The caller provided callback will be invoked once for each chunk that
can be processed in one go.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---

I'd like to use this to get highmem support into sdhci for 2.6.26, so if
you could have a look at this soon I'd appreciate it.

The only wart I see is the fact that "page" needs to be given to the caller
for the dcache stuff to work. Not a biggie, but it would be nice to get
rid off.

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 71fc813..93411a1 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -13,6 +13,12 @@ struct sg_table {
 	unsigned int orig_nents;	/* original size of list */
 };
=20
+struct sg_iterator {
+	struct scatterlist *sg;		/* current entry */
+	unsigned int nents;		/* number of remaining entries */
+	unsigned int offset;		/* offset within sg */
+};
+
 /*
  * Notes on SG table design.
  *
@@ -213,6 +219,12 @@ int __sg_alloc_table(struct sg_table *, unsigned int, =
unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
=20
+typedef size_t (sg_iter_fn)(void *, size_t, struct page *, void *);
+
+void sg_iter_init(struct sg_iterator *iter, struct scatterlist *sgl,
+		  unsigned int nents);
+size_t sg_iterate(struct sg_iterator *iter, sg_iter_fn *fn, void *priv);
+
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b80c211..ea8c3a1 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -295,6 +295,117 @@ int sg_alloc_table(struct sg_table *table, unsigned i=
nt nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
=20
 /**
+ * sg_iter_init - Initialize/reset an sg iterator structure
+ * @iter:	The sg iterator structure
+ * @sgl:	The sg list to iterate over
+ * @nents:	Number of sg entries
+ *
+ *  Description:
+ *    Sets up the internal state of the sg iterator structure
+ *    to the beginning of the given sg list.
+ */
+void sg_iter_init(struct sg_iterator *iter, struct scatterlist *sgl,
+		  unsigned int nents)
+{
+	memset(iter, 0, sizeof(struct sg_iterator));
+
+	iter->sg =3D sgl;
+	iter->nents =3D nents;
+	iter->offset =3D 0;
+}
+EXPORT_SYMBOL(sg_iter_init);
+
+/**
+ * sg_iterate - Process the next chunk of the sg list
+ * @iter:	The sg iterator structure
+ * @fn:		Function that will process the data
+ * @priv:	Private data passed on to @fn@
+ *
+ *  Description:
+ *    The main worker of sg list iteration. Each invokation will
+ *    call @fn@ with a chunk of data that has been mapped into
+ *    kernel reachable virtual memory. The function must return
+ *    the number of bytes processed, which may be less than the
+ *    total size of the current chunk.
+ *
+ *    It is not required that @fn@ and @priv@ are identical between
+ *    each invokation, allowing separate processing of different
+ *    sections of the sg list.
+ *
+ *    The return value is that given by @fn@, or 0 if the end of
+ *    the sg list has been reached.
+ */
+size_t sg_iterate(struct sg_iterator *iter, sg_iter_fn *fn, void *priv)
+{
+	struct page *page;
+	int n;
+	size_t buflen;
+	unsigned int sg_offset, sg_remain;
+
+	void *buf;
+	size_t result;
+
+	WARN_ON(!irqs_disabled());
+
+	if (iter->nents =3D=3D 0)
+		return 0;
+
+	sg_offset =3D iter->sg->offset + iter->offset;
+	sg_remain =3D iter->sg->length - iter->offset;
+
+	n =3D sg_offset / PAGE_SIZE;
+	page =3D nth_page(sg_page(iter->sg), n);
+
+	buflen =3D PAGE_SIZE - (sg_offset % PAGE_SIZE);
+	if (buflen > sg_remain)
+		buflen =3D sg_remain;
+
+	buf =3D kmap_atomic(page, KM_BIO_SRC_IRQ);
+	result =3D fn(buf, buflen, page, priv);
+	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
+
+	WARN_ON(result > buflen);
+
+	iter->offset +=3D result;
+
+	if (iter->offset =3D=3D iter->sg->length) {
+		iter->nents--;
+		if (iter->nents)
+			iter->sg =3D sg_next(iter->sg);
+		iter->offset =3D 0;
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(sg_iterate);
+
+struct sg_copy_state {
+	void *buf;
+	size_t offset, buflen;
+	int to_buffer;
+};
+
+static size_t sg_copy_worker(void *buf, size_t buflen,
+			     struct page *page, void *priv)
+{
+	struct sg_copy_state *st =3D priv;
+
+	if (buflen > (st->buflen - st->offset))
+		buflen =3D st->buflen - st->offset;
+
+	if (st->to_buffer)
+		memcpy(st->buf + st->offset, buf, buflen);
+	else {
+		memcpy(buf, st->buf + st->offset, buflen);
+		flush_kernel_dcache_page(page);
+	}
+
+	st->offset +=3D buflen;
+
+	return buflen;
+}
+
+/**
  * sg_copy_buffer - Copy data between a linear buffer and an SG list
  * @sgl:		 The SG list
  * @nents:		 Number of SG entries
@@ -309,56 +420,19 @@ EXPORT_SYMBOL(sg_alloc_table);
 static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 			     void *buf, size_t buflen, int to_buffer)
 {
-	struct scatterlist *sg;
-	size_t buf_off =3D 0;
-	int i;
+	struct sg_iterator iter;
+	struct sg_copy_state state;
=20
-	WARN_ON(!irqs_disabled());
+	sg_iter_init(&iter, sgl, nents);
=20
-	for_each_sg(sgl, sg, nents, i) {
-		struct page *page;
-		int n =3D 0;
-		unsigned int sg_off =3D sg->offset;
-		unsigned int sg_copy =3D sg->length;
-
-		if (sg_copy > buflen)
-			sg_copy =3D buflen;
-		buflen -=3D sg_copy;
-
-		while (sg_copy > 0) {
-			unsigned int page_copy;
-			void *p;
-
-			page_copy =3D PAGE_SIZE - sg_off;
-			if (page_copy > sg_copy)
-				page_copy =3D sg_copy;
-
-			page =3D nth_page(sg_page(sg), n);
-			p =3D kmap_atomic(page, KM_BIO_SRC_IRQ);
-
-			if (to_buffer)
-				memcpy(buf + buf_off, p + sg_off, page_copy);
-			else {
-				memcpy(p + sg_off, buf + buf_off, page_copy);
-				flush_kernel_dcache_page(page);
-			}
-
-			kunmap_atomic(p, KM_BIO_SRC_IRQ);
-
-			buf_off +=3D page_copy;
-			sg_off +=3D page_copy;
-			if (sg_off =3D=3D PAGE_SIZE) {
-				sg_off =3D 0;
-				n++;
-			}
-			sg_copy -=3D page_copy;
-		}
+	state.buf =3D buf;
+	state.offset =3D 0;
+	state.buflen =3D buflen;
+	state.to_buffer =3D to_buffer;
=20
-		if (!buflen)
-			break;
-	}
+	while (sg_iterate(&iter, sg_copy_worker, &state));
=20
-	return buf_off;
+	return state.offset;
 }
=20
 /**


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2076-1215377304-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhxL5cACgkQ7b8eESbyJLjT+gCgxf4VZ38bbz0L6V5NRZUeSREC
CDQAn0v8s4iIp6E48PfSNnn/c212UI1U
=o2Gx
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2076-1215377304-0001-2--
