Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0BSPBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:01:33 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:52207 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0BSPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:01:31 -0500
Date: Fri, 19 Feb 2010 08:55:06 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm: Make copy_from_user() in migrate.c statically
 predictable
In-Reply-To: <4B7DD89F.4050003@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1002190854420.7486@router.home>
References: <1266533033-24457-1-git-send-email-hpa@linux.intel.com> <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain> <4B7DD89F.4050003@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------050706080602000605020904
Content-ID: <alpine.DEB.2.00.1002190854421.7486@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--------------050706080602000605020904
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1002190854422.7486@router.home>

On Thu, 18 Feb 2010, H. Peter Anvin wrote:

> Updated patch, which compile-tests for me, attached.

Looks ok.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

--------------050706080602000605020904
Content-Type: TEXT/X-PATCH; NAME=0001-mm-Make-copy_from_user-in-migrate.c-statically-predi.patch
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1002190854423.7486@router.home>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME*0=0001-mm-Make-copy_from_user-in-migrate.c-statically-predi.pa; FILENAME*1=tch

>From 90585838c29ef62fd80e776d0985c40bbffd852a Mon Sep 17 00:00:00 2001=0D
From: H. Peter Anvin <hpa@zytor.com>=0D
Date: Thu, 18 Feb 2010 16:13:40 -0800=0D
Subject: [PATCH] mm: Make copy_from_user() in migrate.c statically predicta=
ble=0D
MIME-Version: 1.0=0D
Content-Type: text/plain; charset=3DUTF-8=0D
Content-Transfer-Encoding: 8bit=0D
=0D
x86-32 has had a static test for copy_on_user() overflow for a while.=0D
This test currently fails in mm/migrate.c resulting in an=0D
allyesconfig/allmodconfig build failure on x86-32:=0D
=0D
In function =E2=80=98copy_from_user=E2=80=99,=0D
    inlined from =E2=80=98do_pages_stat=E2=80=99 at=0D
    /home/hpa/kernel/git/mm/migrate.c:1012:=0D
/home/hpa/kernel/git/arch/x86/include/asm/uaccess_32.h:212: error:=0D
    call to =E2=80=98copy_from_user_overflow=E2=80=99 declared=0D
=0D
Make the logic more explicit and therefore easier for gcc to=0D
understand.=0D
=0D
v2: rewrite the loop entirely using a more normal structure for a=0D
    chunked-data loop (Linus Torvalds)=0D
=0D
Reported-by: Len Brown <lenb@kernel.org>=0D
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>=0D
Signed-off-by: H. Peter Anvin <hpa@zytor.com>=0D
Cc: Arjan van de Ven <arjan@linux.kernel.org>=0D
Cc: Andrew Morton <akpm@linux-foundation.org>=0D
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>=0D
Cc: Christoph Lameter <cl@linux-foundation.org>=0D
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>=0D
Cc: Rik van Riel <riel@redhat.com>=0D
---=0D
 mm/migrate.c |   36 +++++++++++++++---------------------=0D
 1 files changed, 15 insertions(+), 21 deletions(-)=0D
=0D
diff --git a/mm/migrate.c b/mm/migrate.c=0D
index 9a0db5b..880bd59 100644=0D
--- a/mm/migrate.c=0D
+++ b/mm/migrate.c=0D
@@ -1002,33 +1002,27 @@ static int do_pages_stat(struct mm_struct *mm, unsi=
gned long nr_pages,=0D
 #define DO_PAGES_STAT_CHUNK_NR 16=0D
 =09const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];=0D
 =09int chunk_status[DO_PAGES_STAT_CHUNK_NR];=0D
-=09unsigned long i, chunk_nr =3D DO_PAGES_STAT_CHUNK_NR;=0D
-=09int err;=0D
=20=0D
-=09for (i =3D 0; i < nr_pages; i +=3D chunk_nr) {=0D
-=09=09if (chunk_nr > nr_pages - i)=0D
-=09=09=09chunk_nr =3D nr_pages - i;=0D
+=09while (nr_pages) {=0D
+=09=09unsigned long chunk_nr;=0D
=20=0D
-=09=09err =3D copy_from_user(chunk_pages, &pages[i],=0D
-=09=09=09=09     chunk_nr * sizeof(*chunk_pages));=0D
-=09=09if (err) {=0D
-=09=09=09err =3D -EFAULT;=0D
-=09=09=09goto out;=0D
-=09=09}=0D
+=09=09chunk_nr =3D nr_pages;=0D
+=09=09if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)=0D
+=09=09=09chunk_nr =3D DO_PAGES_STAT_CHUNK_NR;=0D
+=0D
+=09=09if (copy_from_user(chunk_pages, pages, chunk_nr * sizeof(*chunk_page=
s)))=0D
+=09=09=09break;=0D
=20=0D
 =09=09do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);=0D
=20=0D
-=09=09err =3D copy_to_user(&status[i], chunk_status,=0D
-=09=09=09=09   chunk_nr * sizeof(*chunk_status));=0D
-=09=09if (err) {=0D
-=09=09=09err =3D -EFAULT;=0D
-=09=09=09goto out;=0D
-=09=09}=0D
-=09}=0D
-=09err =3D 0;=0D
+=09=09if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))=
=0D
+=09=09=09break;=0D
=20=0D
-out:=0D
-=09return err;=0D
+=09=09pages +=3D chunk_nr;=0D
+=09=09status +=3D chunk_nr;=0D
+=09=09nr_pages -=3D chunk_nr;=0D
+=09}=0D
+=09return nr_pages ? -EFAULT : 0;=0D
 }=0D
=20=0D
 /*=0D
--=20=0D
1.6.5.2=0D
=0D
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00
--------------050706080602000605020904--
