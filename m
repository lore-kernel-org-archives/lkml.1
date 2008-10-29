Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYJ2GjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYJ2GjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ2GjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:39:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYJ2GjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:39:11 -0400
From: "Li Xiaodong" <lixd@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH]swap-zero-page-bug
Date: Wed, 29 Oct 2008 14:31:18 +0800
Message-ID: <2C69C7D31680437FB174C65D043E2455@fujitsulixd>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0011_01C939D3.01849A80"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ack5j/Mjp5MenFDFS0adHjELXF2A+Q==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0011_01C939D3.01849A80
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

According to Documentation/filesystems/proc.txt, kernel should swap one page
as vm.page-cluster is 0, while it seems not like so in mm/swapfile.c:
     ...
	int our_page_cluster = page_cluster;
	...
	if (!our_page_cluster)  /* no readahead */
                return 0;
	...

It is better to remove that checkpoint.

Signed-off-by: Li Xiaodong<lixd@cn.fujitsu.com>
--- swapfile.c.orig	2008-10-29 21:29:36.000000000 +0800
+++ swapfile.c	2008-10-29 21:59:49.000000000 +0800
@@ -1810,9 +1810,6 @@
 	pgoff_t base, end;
 	int nr_pages = 0;
 
-	if (!our_page_cluster)	/* no readahead */
-		return 0;
-
 	si = &swap_info[swp_type(entry)];
 	target = swp_offset(entry);
 	base = (target >> our_page_cluster) << our_page_cluster; @@ -1847,5
+1844,5 @@
 	 * if only 1, say 0, since there's then no readahead to be done.
 	 */
 	*offset = ++toff;
-	return nr_pages? ++nr_pages: 0;
+	return nr_pages ? ++nr_pages : nr_pages;
 }


------=_NextPart_000_0011_01C939D3.01849A80
Content-Type: application/octet-stream;
	name="[PATCH]swap-zero-page-bug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="[PATCH]swap-zero-page-bug.patch"

Signed-off-by: Li Xiaodong<lixd@cn.fujitsu.com>=0A=
--- swapfile.c.orig	2008-10-29 21:29:36.000000000 +0800=0A=
+++ swapfile.c	2008-10-29 21:59:49.000000000 +0800=0A=
@@ -1810,9 +1810,6 @@=0A=
 	pgoff_t base, end;=0A=
 	int nr_pages =3D 0;=0A=
 =0A=
-	if (!our_page_cluster)	/* no readahead */=0A=
-		return 0;=0A=
-=0A=
 	si =3D &swap_info[swp_type(entry)];=0A=
 	target =3D swp_offset(entry);=0A=
 	base =3D (target >> our_page_cluster) << our_page_cluster;=0A=
@@ -1847,5 +1844,5 @@=0A=
 	 * if only 1, say 0, since there's then no readahead to be done.=0A=
 	 */=0A=
 	*offset =3D ++toff;=0A=
-	return nr_pages? ++nr_pages: 0;=0A=
+	return nr_pages ? ++nr_pages : nr_pages;=0A=
 }=0A=

------=_NextPart_000_0011_01C939D3.01849A80--


