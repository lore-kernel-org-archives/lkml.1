Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbXIEOP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbXIEOP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXIEOPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:15:16 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:57217 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbXIEOPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:15:14 -0400
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 10:15:14 EDT
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org
Subject: patch: improve generic_file_buffered_write()
Date: Wed, 5 Sep 2007 15:45:36 +0200
User-Agent: KMail/1.9.6
Cc: "J. Bruce Fields" <bfields@fieldses.org>, brian@clusterfs.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3120075.GMIO4ZoJon";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709051546.06224.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3120075.GMIO4ZoJon
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

recently we discovered writing to a nfs-exported lustre filesystem is rathe=
r=20
slow (20-40 MB/s writing, but over 200 MB/s reading).

As I already explained on the nfs mailing list, this happens since there is=
 an=20
offset on the very first page due to the nfs header.

http://sourceforge.net/mailarchive/forum.php?thread_name=3D200708312003.304=
46.bernd-schubert%40gmx.de&forum_name=3Dnfs

While this especially effects lustre, Olaf Kirch also noticed it on another=
=20
filesystem before and wrote a nfs patch for it. This patch has two=20
disadvantages  - it requires to move all data within the pages, IMHO rather=
=20
cpu time consuming, furthermore, it presently causes data corruption when=20
more than one nfs thread is running.

After thinking it over and over again we (Goswin and I) believe it would be=
=20
best to improve generic_file_buffered_write().
If there is sufficient data now, as it is usual for aio writes,=20
generic_file_buffered_write() will now fill each page as much as possible a=
nd=20
only then prepare/commit it. Before generic_file_buffered_write() commited=
=20
chunks of pages even though there were still more data.

The attached patch still has two FIXMEs, both for likely()/unlikely()=20
conditions which IMHO don't reflect the likelyhood for the new aio data=20
functions.

filemap.c |  144=20
+++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 96 insertions(+), 48 deletions(-)

Signed-off-by: Bernd Schubert <bs@q-leap.de>
Signed-off-by: Goswin von Brederlow <goswin@vonbrederlow.de>


Cheers,
Goswin and Bernd


Index: linux-2.6.20.3/mm/filemap.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux-2.6.20.3.orig/mm/filemap.c	2007-09-04 13:43:04.000000000 +0200
+++ linux-2.6.20.3/mm/filemap.c	2007-09-05 12:39:23.000000000 +0200
@@ -2057,6 +2057,19 @@
 }
 EXPORT_SYMBOL(generic_file_direct_write);
=20
+/**
+ * This function will do 3 main tasks for each iov:
+ * - prepare a write
+ * - copy the data from iov into a new page
+ * - commit this page
+ * @iob:	file operations
+ * @iov:	vector of data to write
+ * @nr_segs:	number of iov segments
+ * @pos:	position in the file
+ * @ppos:	position in the file after this function
+ * @count:	number of bytes to write
+ * written:	offset in iov->base (data to skip on write)
+ */
 ssize_t
 generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos, loff_t *ppos,
@@ -2074,6 +2087,11 @@
 	const struct iovec *cur_iov =3D iov; /* current iovec */
 	size_t		iov_base =3D 0;	   /* offset in the current iovec */
 	char __user	*buf;
+	unsigned long	data_start =3D (pos & (PAGE_CACHE_SIZE -1)); /* Within page=
 */
+	loff_t		wpos =3D pos; /* the position in the file we will return */
+
+	/* position in file as index of pages */
+	unsigned long	index =3D pos >> PAGE_CACHE_SHIFT;
=20
 	pagevec_init(&lru_pvec, 0);
=20
@@ -2087,9 +2105,15 @@
 		buf =3D cur_iov->iov_base + iov_base;
 	}
=20
+	page =3D __grab_cache_page(mapping, index, &cached_page, &lru_pvec);
+	if (!page) {
+		status =3D -ENOMEM;
+		goto out;
+	}
+
 	do {
=2D		unsigned long index;
 		unsigned long offset;
+		unsigned long data_end; /* end of data within the page */
 		size_t copied;
=20
 		offset =3D (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
@@ -2106,6 +2130,8 @@
 		 */
 		bytes =3D min(bytes, cur_iov->iov_len - iov_base);
=20
+		data_end =3D offset + bytes;
+
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
@@ -2114,95 +2140,117 @@
 		 */
 		fault_in_pages_readable(buf, bytes);
=20
=2D		page =3D __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
=2D		if (!page) {
=2D			status =3D -ENOMEM;
=2D			break;
=2D		}
=2D
 		if (unlikely(bytes =3D=3D 0)) {
 			status =3D 0;
 			copied =3D 0;
 			goto zero_length_segment;
 		}
=20
=2D		status =3D a_ops->prepare_write(file, page, offset, offset+bytes);
=2D		if (unlikely(status)) {
=2D			loff_t isize =3D i_size_read(inode);
=2D
=2D			if (status !=3D AOP_TRUNCATED_PAGE)
=2D				unlock_page(page);
=2D			page_cache_release(page);
=2D			if (status =3D=3D AOP_TRUNCATED_PAGE)
=2D				continue;
+		if (data_end =3D=3D PAGE_CACHE_SIZE || count =3D=3D bytes) {
 			/*
=2D			 * prepare_write() may have instantiated a few blocks
=2D			 * outside i_size.  Trim these off again.
+			 * Only prepare a write if its an entire page or if
+			 * we don't have more data
 			 */
=2D			if (pos + bytes > isize)
=2D				vmtruncate(inode, isize);
=2D			break;
+			status =3D a_ops->prepare_write(file, page, data_start, data_end);
+			if (unlikely(status)) {
+				loff_t isize =3D i_size_read(inode);
+
+				if (status =3D=3D AOP_TRUNCATED_PAGE)
+					continue;
+				/*
+				* prepare_write() may have instantiated a few blocks
+				* outside i_size.  Trim these off again.
+				*/
+				if (pos + bytes > isize)
+					vmtruncate(inode, isize);
+			}
 		}
=2D		if (likely(nr_segs =3D=3D 1))
+		if (likely(nr_segs =3D=3D 1)) /* FIXME: really likely with aio? */
 			copied =3D filemap_copy_from_user(page, offset,
 							buf, bytes);
 		else
 			copied =3D filemap_copy_from_user_iovec(page, offset,
 						cur_iov, iov_base, bytes);
=2D		flush_dcache_page(page);
=2D		status =3D a_ops->commit_write(file, page, offset, offset+bytes);
=2D		if (status =3D=3D AOP_TRUNCATED_PAGE) {
+
+		if (data_end =3D=3D PAGE_CACHE_SIZE || count =3D=3D bytes) {
+			/*
+			 * Same as above, always try fill pages up to
+			 * PAGE_CACHE_SIZE if possible (sufficient data)
+			 */
+			flush_dcache_page(page);
+			status =3D a_ops->commit_write(file, page,
+						     data_start, data_end);
+			if (status =3D=3D AOP_TRUNCATED_PAGE) {
+				continue;
+			}
+			unlock_page(page);
+			mark_page_accessed(page);
 			page_cache_release(page);
=2D			continue;
+			balance_dirty_pages_ratelimited(mapping);
+			cond_resched();
+			if (bytes < count) { /* still more iov data to write */
+				page =3D __grab_cache_page(mapping, index + 1,
+							 &cached_page, &lru_pvec);
+				if (!page) {
+					status =3D -ENOMEM;
+					goto out;
+				}
+			} else {
+				page =3D NULL;
+			}
+			written +=3D data_end - data_start;
+			wpos    +=3D data_end - data_start;
+			data_start =3D 0; /* correct would be data_end % PAGE_SIZE
+			                 * but if this would be !=3D 0, we don't
+			                 * have more data
+			                 */
 		}
 zero_length_segment:
 		if (likely(copied >=3D 0)) {
=2D			if (!status)
=2D				status =3D copied;
=2D
=2D			if (status >=3D 0) {
=2D				written +=3D status;
=2D				count -=3D status;
=2D				pos +=3D status;
=2D				buf +=3D status;
=2D				if (unlikely(nr_segs > 1)) {
+			if (!status) {
+				count -=3D copied;
+				pos +=3D copied;
+				buf +=3D copied;
+				if (unlikely(nr_segs > 1)) { /* FIXME: really unlikely with aio? */
 					filemap_set_next_iovec(&cur_iov,
=2D							&iov_base, status);
+							&iov_base, copied);
 					if (count)
 						buf =3D cur_iov->iov_base +
 							iov_base;
 				} else {
=2D					iov_base +=3D status;
+					iov_base +=3D copied;
 				}
 			}
 		}
 		if (unlikely(copied !=3D bytes))
=2D			if (status >=3D 0)
+			if (!status)
 				status =3D -EFAULT;
=2D		unlock_page(page);
=2D		mark_page_accessed(page);
=2D		page_cache_release(page);
=2D		if (status < 0)
+		if (status)
 			break;
=2D		balance_dirty_pages_ratelimited(mapping);
=2D		cond_resched();
 	} while (count);
=2D	*ppos =3D pos;
+
+out:
+	*ppos =3D wpos;
=20
 	if (cached_page)
 		page_cache_release(cached_page);
=20
+	if (page) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
 	/*
 	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
 	 */
=2D	if (likely(status >=3D 0)) {
+	if (likely(!status)) {
 		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 			if (!a_ops->writepage || !is_sync_kiocb(iocb))
 				status =3D generic_osync_inode(inode, mapping,
 						OSYNC_METADATA|OSYNC_DATA);
 		}
=2D  	}
=2D=09
+	}
+
 	/*
 	 * If we get here for O_DIRECT writes then we must have fallen through
 	 * to buffered writes (block instantiation inside i_size).  So we sync


=2D-=20
Bernd Schubert
Q-Leap Networks GmbH

--nextPart3120075.GMIO4ZoJon
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG3rMewjTa7Az61ZsRAs6PAJ49RboWVO0Y3Ty7aH1d/wSdgrW7cwCgmgsD
+Hym5fI8aiWQPOY+moomn7A=
=2lMI
-----END PGP SIGNATURE-----

--nextPart3120075.GMIO4ZoJon--
