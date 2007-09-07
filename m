Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbXIGSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbXIGSw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 14:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXIGSwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 14:52:51 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:53618 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXIGSwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 14:52:50 -0400
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2][RESEND] improve generic_file_buffered_write()
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Date: Fri, 7 Sep 2007 20:52:38 +0200
Content-Type: multipart/signed;
  boundary="nextPart3767951.2T59TqgXrx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709072052.48396.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3767951.2T59TqgXrx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

No further response to our patches yet, so we are sending them again,=20
re-diffed against 2.6.23-rc5

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

Some statistics:

num_writes =3D 4669440, bytes_total =3D 20231249633, segs_total =3D 5738644=
,=20
commit_loops =3D 7697604, commits_total =3D 6628750

commit_loops is the number commits without the patch and commits_total the=
=20
number of commits we actually have now. This shows a saving of nearly 14% o=
f=20
prepare, commit, cond_sched calls.

<       1:      Write size =3D        0,  Num segs =3D        0
<       2:      Write size =3D    20244,  Num segs =3D  4455583
<       4:      Write size =3D     6722,  Num segs =3D       24
<       8:      Write size =3D    19653,  Num segs =3D   213842
<      16:      Write size =3D    31778,  Num segs =3D        0
<      32:      Write size =3D    73395,  Num segs =3D        0
<      64:      Write size =3D   148840,  Num segs =3D        0
<     128:      Write size =3D   310178,  Num segs =3D        0
<     256:      Write size =3D    89027,  Num segs =3D        0
<     512:      Write size =3D   111903,  Num segs =3D        0
<    1024:      Write size =3D   140509,  Num segs =3D        0
<    2048:      Write size =3D   244052,  Num segs =3D        0
<    4096:      Write size =3D   217164,  Num segs =3D        0
<    8192:      Write size =3D  2784875,  Num segs =3D        0
<   16384:      Write size =3D   433506,  Num segs =3D        0
<   32768:      Write size =3D    11742,  Num segs =3D        0
<   65536:      Write size =3D    15783,  Num segs =3D        0
<  131072:      Write size =3D     6851,  Num segs =3D        0
<  262144:      Write size =3D     1562,  Num segs =3D        0
<  524288:      Write size =3D      755,  Num segs =3D        0
< 1048576:      Write size =3D      531,  Num segs =3D        0
< 2097152:      Write size =3D      272,  Num segs =3D        0
< 4194304:      Write size =3D      107,  Num segs =3D        0
< 8388608:      Write size =3D        0,  Num segs =3D        0

Write size shows the number of writes with the total size smaller than deno=
ted=20
in the first column. Num segs shows the number of writes with less segments=
=20
than denoted in the first column. Most writes (~95%) only have one segment.=
=20
However, no nfs activity has been done, which is actually the case we made=
=20
the patches for.

size\num        1       2       3       4       5       6       7+      =20
<       1:      0       24      0       0       0       0       0      =20
<       2:      20244   0       0       0       0       641526  0      =20
<       4:      6722    0       0       0       0       0       0      =20
<       8:      19653   0       0       0       0       213842  0      =20
<      16:      31778   0       0       0       0       213856  0      =20
<      32:      73395   0       0       0       0       590     0      =20
<      64:      147730  0       0       0       0       93626   0      =20
<     128:      100888  0       0       0       0       119597  0      =20
<     256:      85588   0       0       0       0       12      0      =20
<     512:      111900  0       0       0       0       3       0      =20
<    1024:      140509  0       0       0       0       0       0      =20
<    2048:      244052  0       0       0       0       0       0      =20
<    4096:      217160  4       0       0       0       0       0      =20
<    8192:      2784855 20      0       0       0       0       0      =20
<   16384:      433506  0       0       0       0       0       0      =20
<   32768:      11742   0       0       0       0       0       0      =20
<   65536:      15783   0       0       0       0       0       0      =20
<  131072:      6851    0       0       0       0       0       0      =20
<  262144:      1562    0       0       0       0       0       0      =20
<  524288:      755     0       0       0       0       0       0      =20
< 1048576:      531     0       0       0       0       0       0      =20
< 2097152:      272     0       0       0       0       0       0      =20
< 4194304:      107     0       0       0       0       0       0      =20
< 8388608:      0       0       0       0       0       0       0      =20

This table shows the number of segments smaller than denoted in the first=20
column within a vector of sizes 1 to 7 segments. This shows that without nf=
s=20
only 1, 2 and 6 segment vectors appear to happen. Depending on wsize nfs wi=
ll=20
have a lot more segments (129 for 512kiB wsize).

Btw, whats the cause of the 24 vectors with 2 segments, one of them being s=
ize=20
zero?


Signed-off-by: Bernd Schubert <bs@q-leap.de>
Signed-off-by: Goswin von Brederlow <goswin@vonbrederlow.de>


Cheers,
Goswin and Bernd


 mm/filemap.c |  139 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 95 insertions(+), 44 deletions(-)

=20
Index: linux-2.6.23-rc5/mm/filemap.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux-2.6.23-rc5.orig/mm/filemap.c	2007-09-06 18:33:11.000000000 +0200
+++ linux-2.6.23-rc5/mm/filemap.c	2007-09-06 18:33:15.000000000 +0200
@@ -1834,6 +1834,21 @@
 }
 EXPORT_SYMBOL(generic_file_direct_write);
=20
+/**
+ * generic_file_buffered_write - handle iov'ectors
+ * @iob:	file operations
+ * @iov:	vector of data to write
+ * @nr_segs:	number of iov segments
+ * @pos:	position in the file
+ * @ppos:	position in the file after this function
+ * @count:	number of bytes to write
+ * written:	offset in iov->base (data to skip on write)
+ *
+ * This function will do 3 main tasks for each iov:
+ * - prepare a write
+ * - copy the data from iov into a new page
+ * - commit this page
+ */
 ssize_t
 generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos, loff_t *ppos,
@@ -1851,6 +1866,11 @@
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
@@ -1864,9 +1884,15 @@
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
@@ -1897,11 +1923,6 @@
 			 */
 			fault_in_pages_readable(buf, bytes);
 		}
=2D		page =3D __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
=2D		if (!page) {
=2D			status =3D -ENOMEM;
=2D			break;
=2D		}
=20
 		if (unlikely(bytes =3D=3D 0)) {
 			status =3D 0;
@@ -1909,22 +1930,26 @@
 			goto zero_length_segment;
 		}
=20
=2D		status =3D a_ops->prepare_write(file, page, offset, offset+bytes);
=2D		if (unlikely(status)) {
=2D			loff_t isize =3D i_size_read(inode);
+		data_end =3D offset + bytes;
=20
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
 		if (likely(nr_segs =3D=3D 1))
 			copied =3D filemap_copy_from_user(page, offset,
@@ -1932,60 +1957,86 @@
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
+			if (!status) {
+				count -=3D copied;
+				pos +=3D copied;
+				buf +=3D copied;
 				if (unlikely(nr_segs > 1)) {
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

--nextPart3767951.2T59TqgXrx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG4Z4AwjTa7Az61ZsRAjXYAJwI5vcFVtxX+jD24yxgYVvSjH54NACgl2jF
EanG3OwTxcUFF+HK8FnjpA8=
=863D
-----END PGP SIGNATURE-----

--nextPart3767951.2T59TqgXrx--
