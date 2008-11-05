Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYKEQNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYKEQNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYKEQND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:13:03 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48675 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYKEQNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:13:01 -0500
Date: Wed, 5 Nov 2008 16:12:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/pid/maps containg anonymous maps that have PROT_NONE
In-Reply-To: <49118010.20202@gmail.com>
Message-ID: <Pine.LNX.4.64.0811051541470.19714@blonde.site>
References: <49118010.20202@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2056438757-1225901577=:19714"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2056438757-1225901577=:19714
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 5 Nov 2008, T=C3=B6r=C3=B6k Edwin wrote:
>=20
> I noticed that there are (quite large) entries in /proc/pid/maps that
> have PROT_NONE, right after an existing mapping:
> 7fffe4000000-7fffe406a000 rw-p 7fffe4000000 00:00 0
> 7fffe406a000-7fffe8000000 ---p 7fffe406a000 00:00 0
> 7ffff76d1000-7ffff76e0000 r-xp 00000000 09:03 260750                   =
=20
> /lib/libbz2.so.1.0.4
> 7ffff76e0000-7ffff78df000 ---p 0000f000 09:03 260750                   =
=20
> /lib/libbz2.so.1.0.4
>=20
> I don't mind that 2Mb map, but what is 7fffe406a000-7fffe8000000 ---p ?
> (63M)
>=20
> Is it coming from glibc mapping memory as PROT_NONE, and using
> mprotect/madvise to make it writable, and then
> caching the mappings for future use, rather than freeing them?

mmap PROT_NONE to reserve an arena, munmap to trim off top and bottom,
mprotect to make areas read+writable, madvise 0x4 to say MADV_DONTNEED
on some parts.  gcc?  Or the application itself (clamd) and its libs?

> I straced the program creating these, and I couldn't find anything with
> 7fffe406a000, but only before that address:
>=20
> [pid 31928] mprotect(0x7fffe4000000, 135168, PROT_READ|PROT_WRITE) =3D 0
[snipped]
> [pid 31928] madvise(0x7fffe4021000, 4096, 0x4 /* MADV_??? */) =3D 0
>=20
> There is an mprotect and madvise that end at 0x7fffe406a000.
> Those mprotects and madvise are coming from glibc. Its strange that I
> don't see the mmap only the mprotect, but I used strace -f.
>=20
> This happens on:
> Linux debian 2.6.26-1-amd64 #1 SMP Thu Oct 9 14:16:53 UTC 2008 x86_64
> GNU/Linux
>=20
> strace is here:
> http://edwintorok.googlepages.com/log2.bz2

Just before your first mprotect above there's:

[pid 31928] mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_=
NORESERVE, -1, 0 <unfinished ...>
[pid 31938] futex(0x7ffff6e489e0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 31928] <... mmap resumed> )        =3D 0x7fffe2bd3000

  which maps 7fffe2bd3000-7fffeabd3000; then

[pid 31928] munmap(0x7fffe2bd3000, 21155840 <unfinished ...>
[pid 31938] <... futex resumed> )       =3D 0
[pid 31928] <... munmap resumed> )      =3D 0

  which unmaps 7fffe2bd3000-7fffe4000000; and then

[pid 31928] munmap(0x7fffe8000000, 45953024) =3D 0

  which unmaps 7fffe8000000-7fffeabd3000.

So it's trimming off the rough edges to leave 7fffe4000000-7fffe8000000
mapped PROT_NONE, then mprotecting what it needs of that.

Why does it mmap too much then trim it down?  Perhaps it's trying to
minimize pagetable usage, perhaps it's internally convenient to base
on rounded addresses, I don't know.

But the mmap is there: just easily overlooked because of the way it
munmaps too (with strace showing hex addresses but decimal sizes).

Hugh
--8323584-2056438757-1225901577=:19714--
