Return-Path: <linux-kernel-owner+w=401wt.eu-S935322AbZLGPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbZLGPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935235AbZLGPmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:42:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347AbZLGPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:42:19 -0500
Date: Mon, 7 Dec 2009 15:42:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 13/19] Unify sys_mmap*
Message-ID: <20091207154224.GG14381@ZenIV.linux.org.uk>
References: <E1NHUfg-0007xZ-R1@ZenIV.linux.org.uk> <10f740e80912070032j3ef3e9b2n55199d38abf710d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e80912070032j3ef3e9b2n55199d38abf710d2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 09:32:05AM +0100, Geert Uytterhoeven wrote:
> On Mon, Dec 7, 2009 at 04:54, Al Viro <viro@ftp.linux.org.uk> wrote:

> > ??asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
> > ?? ?? ?? ??unsigned long prot, unsigned long flags,
> > ?? ?? ?? ??unsigned long fd, unsigned long pgoff)
> > ??{
> > - ?? ?? ?? return do_mmap2(addr, len, prot, flags, fd, pgoff);
> > + ?? ?? ?? /* this is wrong for sun3, BTW */
> 
> Can you please add the why part to the comment?
> Thanks!

Try libc mmap64() with e.g. 65536 as the last argument.  On mac and sun3.
Compare the results...

Basically, sun3 has larger pages and forgets to compensate.  Corresponding
part in libc (actual libc6 m68k binary) is
	movel %d6,%d2
	moveq #20,%d0
	lsll %d0,%d2
	movel %d7,%d1
	moveq #12,%d3
	lsrl %d3,%d1
	orl %d2,%d1
	moveal %d1,%a0		/* a0 = d6d7 >> 12 */
	movel %a3,%d5
	movel %a4,%d4
	movel %a5,%d3
	movel %a2,%d2
	%fp@(8),%d1
 	moveq #63,%d0
	notb %d0		/* 256 ^ 63, i.e. 192, i.e. __NR_mmap2 */
	trap #0

It does the last argument of mmap2 in 4Kb units (as on almost all
targets; ia64 is the exception, but it's actually not used by libc -
they have mmap64 aliased to mmap and using sys_mmap, not sys_mmap2).

So sun3 ought to shift the argument down by 1 before passing it to
do_mmap_pgoff() (or sys_mmap_pgoff() with these patches) - mm/mmap.c
stuff really expects the argument in PAGE_SIZE units.

Generally I'd agree that existing behaviour is a part of ABI, however
weird it might be, but since it's actually wrong for the only libc user
of the syscall *and* differs from the behaviour on other subarchitectures...
