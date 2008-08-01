Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYHARcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYHARcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYHARcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:32:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40835 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYHARck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:32:40 -0400
Date: Fri, 1 Aug 2008 18:31:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ryan Hope <rmh3093@gmail.com>
cc: Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND] mm: fix uninitialized variables for find_vma_prepare
 callers
In-Reply-To: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808011749040.15379@blonde.site>
References: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-717760152-1217611897=:15379"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-717760152-1217611897=:15379
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 1 Aug 2008, Ryan Hope wrote:
> This was submitted for 2.6.26-rc8-mm1 but it must have gotten overlooked:

True, thanks, I guess that's my fault: it got stalled by me, because I
found it unsatisfying to fix the uninitialization from a compiler point
of view, whilst leaving it in an undefined state from a usability point
of view.  But since nothing does use those fields in this case, and my
amateurish treephobic experiments didn't find a quick solution to that,
I guess this is an improvement which should go in.

But please, let's credit Benny who posted it, and give his explanation
of what the patch is for, with some additional comment from me.  Which
leaves you out - "Reminded-by: Ryan Hope <rmh3093@gmail.com>"?

From: Benny Halevy <bhalevy@panasas.com>

gcc 4.3.0 correctly emits the following warnings.
When a vma covering addr is found, find_vma_prepare indeed returns without
setting pprev, rb_link, and rb_parent.

/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function =E2=
=80=98insert_vm_struct=E2=80=99:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: =
=E2=80=98rb_parent=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: =
=E2=80=98rb_link=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2084: warning: =
=E2=80=98prev=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function =E2=
=80=98copy_vma=E2=80=99:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: =
=E2=80=98rb_parent=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: =
=E2=80=98rb_link=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2123: warning: =
=E2=80=98prev=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function =E2=
=80=98do_brk=E2=80=99:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: =
=E2=80=98rb_parent=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: =
=E2=80=98rb_link=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1949: warning: =
=E2=80=98prev=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function =E2=
=80=98mmap_region=E2=80=99:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: =
=E2=80=98rb_parent=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: =
=E2=80=98rb_link=E2=80=99 may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1089: warning: =
=E2=80=98prev=E2=80=99 may be used uninitialized in this function

Hugh adds: in fact, none of find_vma_prepare's callers use those values
when a vma is found to be already covering addr, it's either an error
or an occasion to munmap and repeat.  Okay, let's quieten the compiler
(but I would prefer it if pprev, rb_link and rb_parent were meaningful
in that case, rather than whatever's in them from descending the tree).

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/mmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--- 2.6.27-rc1/mm/mmap.c
+++ linux/mm/mmap.c
@@ -370,7 +370,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long ad=
dr,
 =09=09if (vma_tmp->vm_end > addr) {
 =09=09=09vma =3D vma_tmp;
 =09=09=09if (vma_tmp->vm_start <=3D addr)
-=09=09=09=09return vma;
+=09=09=09=09break;
 =09=09=09__rb_link =3D &__rb_parent->rb_left;
 =09=09} else {
 =09=09=09rb_prev =3D __rb_parent;
--8323584-717760152-1217611897=:15379--
