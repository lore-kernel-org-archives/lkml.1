Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXEFXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXEFXnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXEFXnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:43:21 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3256 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbXEFXnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:43:20 -0400
Date: Sun, 6 May 2007 19:43:01 -0400
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Quentin Godfroy <godfroy@clipper.ens.fr>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
Message-ID: <20070506234301.GA29699@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr> <463BC265.7050507@goop.org> <20070505032348.GA30453@goelette.ens.fr> <463C06E5.8050201@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463C06E5.8050201@goop.org>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 07 May 2007 01:43:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 09:24:05PM -0700, Jeremy Fitzhardinge wrote:
> > Indeed, I haven't seen that. For ET_DYN executables, it could be done a
> > thing like load_addr+elf_ppnt->p_vaddr (in the function that creates the
> > auxv, as ity has access to the elf header), and for ET_EXEC do what I
> > propose. I think this is trivial to do. I'll do it as soon as I come back
> > in front of my machine.
> >   
> 
> I don't think you need to special-case it.  You can compute the offset
> between the linked address and the load address (first
> PT_LOAD[0]->p_vaddr - load_addr) and use that to offset all the other
> addresses.

Indeed. And it has the advantage to work for prelinked objects. (but I
have to understand anyway how does the kernel handles prelinked (or not) pie
executables)

> 
> 
> > I don't understand. Yes it is what it is supposed to be, and the kernel
> > is supposed to give the vaddr of the phdr table to the interpreter and
> > not load addr + offset of phdr in file, which is sometimes wrong.
> >   
> 
> How can it be wrong?  Does the PT_PHDR point to a different array of
> Phdr entries?

No, of course, but in my case I wanted to build an executable with a
modified rpath. I had to add a new PT_LOAD segment. To do so, as the
program header is generally located at the very beginning of the
executable, I had to copy it to the end, and so the address where it was
loaded was completely different.

The load address was typically 0x08048000, and the phdr location was
0x0804a570. But the kernel gave to the ld.so in the auxv the addr
0x08048570 for the phdr. And it provoked a segfault because of the .bss
which was between the segments. (and even if there was no .bss, it would
have worked only by chance because the segments could all fit in a page
of 4kb)

Quentin
