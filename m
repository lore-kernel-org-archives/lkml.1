Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZFZHP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZFZHP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZFZHPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:15:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57497 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZFZHPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:15:18 -0400
Date: Fri, 26 Jun 2009 08:15:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc1 crashes randomly on my Machine.
Message-ID: <20090626071520.GC8633@ZenIV.linux.org.uk>
References: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 08:56:52AM +0200, Zeno Davatz wrote:

> Jun 25 21:19:12 zenogentoo Code: 00 00 00 c7 47 20 00 00 00 00 c7 47
> 24 00 00 00 00 c7 47 10 00 00 00 00 c7 47 14 00 00 00 00 c7 47 0c 00
> 00 00 00 e9 27 ff ff ff <ff> 89 e5 57 56 53 83 ec 34 89 45 d0 89 55 cc
> 89 4d c8 8b 70 6c
> Jun 25 21:19:12 zenogentoo EIP: [<c10d1d35>] seq_read+0x0/0x3a5 SS:ESP
> 0068:f4b01f44
> Jun 25 21:19:12 zenogentoo CR2: 0000000053565be5
> Jun 25 21:19:12 zenogentoo ---[ end trace 6254fef9dc80950b ]---
> Jun 25 21:19:12 zenogentoo BUG: unable to handle kernel paging request
> at 53565be5

Real cute...  Disassembly of that sucker:
	decl   0x535657e5(%ecx)
which matches nicely the address in page fault.  However, that doesn't
look even remotely plausible for a beginning of function.  OTOH,
disassembly at one byte offset from that gives
	mov    %esp,%ebp
	push   %edi
	push   %esi
	push   %ebx
which is exactly what you'd expect to see in such place.  IOW, you've
got an off-by-one - it had jumped at one byte before the actual entry
point of seq_read().

The interesting question is whether that's a memory corruption of some
kind or a linker fuckup.  Check what does System.map have for
seq_read; if it's that address (c10d1d35), the odds are that you've
got something fishy going on with linking.  Do objdump of vmlinux and
check the functions nearby; ditto for fs/seq_file.o.
