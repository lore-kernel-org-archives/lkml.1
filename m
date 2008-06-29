Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYF2Lbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYF2Lbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYF2Lb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 07:31:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43074 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbYF2Lb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 07:31:27 -0400
Date: Sun, 29 Jun 2008 12:31:23 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc7-mmotd-0626 ext3-validate-directory-entry-data-before-use.patch
In-Reply-To: <26368.1214720749@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0806291218390.30797@blonde.site>
References: <26368.1214720749@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1511822721-1214739083=:30797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1511822721-1214739083=:30797
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 29 Jun 2008, Valdis.Kletnieks@vt.edu wrote:
> I'm seeing some ext3 errors, and I'm suspecting the patch
> ext3-validate-directory-entry-data-before-use.patch is causing them
> (since it seems to be the only thing in rc7-mmotd at the moment that
> touches make_indexed_dir, and -rc5-mm3 works OK).
>=20
> Jun 28 21:50:29 turing-police kernel: [  240.784199] EXT3-fs error (devic=
e dm-7): make_indexed_dir: bad entry in directory #9894: directory entry ac=
ross blocks - offset=3D0, inode=3D10144, rec_len=3D32, name_len=3D22
> Jun 28 21:50:29 turing-police kernel: [  240.784214] Aborting journal on =
device dm-7.
> Jun 28 21:50:29 turing-police kernel: [  240.784597] Remounting filesyste=
m read-only
> Jun 28 21:50:29 turing-police kernel: [  240.785616] EXT3-fs error (devic=
e dm-7): do_split: bad entry in directory #9894: rec_len is smaller than mi=
nimal - offset=3D0, inode=3D2553887680, rec_len=3D0, name_len=3D0
> Jun 28 21:50:29 turing-police kernel: [  240.785616] EXT3-fs error (devic=
e dm-7) in ext3_reserve_inode_write: Journal has aborted
> Jun 28 21:50:29 turing-police kernel: [  241.027111] __journal_remove_jou=
rnal_head: freeing b_committed_data
>=20
> Jun 28 23:09:54 turing-police kernel: [ 5026.698415] EXT3-fs error (devic=
e dm-2): make_indexed_dir: bad entry in directory #369136: directory entry =
across blocks - offset=3D0, inode=3D369138, rec_len=3D20, name_len=3D11
> Jun 28 23:09:54 turing-police kernel: [ 5026.698415] Aborting journal on =
device dm-2.
> Jun 28 23:09:54 turing-police kernel: [ 5026.698519] Remounting filesyste=
m read-only
> Jun 28 23:09:54 turing-police kernel: [ 5026.702730] EXT3-fs error (devic=
e dm-2): do_split: bad entry in directory #369136: directory entry across b=
locks - offset=3D0, inode=3D106647, rec_len=3D12, name_len=3D1
> Jun 28 23:09:54 turing-police kernel: [ 5026.702730] EXT3-fs error (devic=
e dm-2) in ext3_reserve_inode_write: Journal has aborted
>=20
> I believe I have a reasonably good replicator for the error on dm-7, that=
's my /usr/share
> and trying to 'rpm -Fvh' one specific RPM has caused it twice (in two tri=
es).
>=20
> The file systems appear to be OK (or at least the fsck.ext3 in Fedora's
> e2fsprogs-1.41-0.WIP.0617.1.fc10.x86_64 says both file systems are in fac=
t OK).
>=20
> Any comments/suggestions?  Any testing/debugging you'd like,
> or should I just revert it and move on?

Thanks for the warning, yes, me too.  All I have to do is boot up and
cp -al a kernel source tree: that starts generating lots of these errors,
I Ctrl-C out, unmount the filesystem, then fsck -f has lots of work to do.

So not only does the patch find directory entries invalid which have
given no trouble in the past, it handles them in such a way as to
leave the filesystem messed up where it wasn't before.

And build even gives a compile warning, haven't looked if it's significant:
fs/ext3/namei.c: In function =E2=80=98make_indexed_dir=E2=80=99:
fs/ext3/namei.c:1435: warning: comparison of distinct pointer types lacks a=
 cast

I think I don't want to investigate this one!  I've hurriedly reverted

ext3-validate-directory-entry-data-before-use-checkpatch-fixes.patch
ext3-validate-directory-entry-data-before-use.patch

, checked that cp -al on the kernel source tree now gives me no errors,
checked that fsck -f is happy with the resultant filesystem,
now moving on.

Hugh
--8323584-1511822721-1214739083=:30797--
