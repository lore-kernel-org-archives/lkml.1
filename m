Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZIXT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZIXT67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZIXT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:58:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63571 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZIXT65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Zdega5bzYI1nT4EhT8afnD1c6nZ6K1yTdx16C2N3K4wm+hgh7vaVaujvAy+LObmWYs
         MJoOcz04FLDUOIidZKbEcawOvuydXvjEZsOetN0rMKCzI5KaciPNyaB8pfHAqpLwaQv4
         r1FpKeANVngQPvkWHmbMqScDwvcntnJWJcwvo=
MIME-Version: 1.0
In-Reply-To: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
References: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
Date: Thu, 24 Sep 2009 22:59:00 +0300
X-Google-Sender-Auth: 7a6a2f4bdc7475e7
Message-ID: <84144f020909241259p1912bfcn8085f6670a97970e@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data 
	can be mapped directly
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Mel Gorman <mel@csn.ul.ie>, Greg Ungerer <gerg@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Sep 24, 2009 at 5:13 PM, David Howells <dhowells@redhat.com> wrote:
> Fix MAP_PRIVATE mmap() of files and devices where the data in the backing store
> might be mapped directly.  Use the BDI_CAP_MAP_DIRECT capability flag to govern
> whether or not we should be trying to map a file directly.  This can be used to
> determine whether or not a region has been filled in at the point where we call
> do_mmap_shared() or do_mmap_private().
>
> The BDI_CAP_MAP_DIRECT capability flag is cleared by validate_mmap_request() if
> there's any reason we can't use it.  It's also cleared in do_mmap_pgoff() if
> f_op->get_unmapped_area() fails.
>
>
> Without this fix, attempting to run a program from a RomFS image on a
> non-mappable MTD partition results in a BUG as the kernel attempts XIP, and
> this can be caught in gdb:
>
> Program received signal SIGABRT, Aborted.
> 0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> (gdb) bt
> #0  0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> #1  0xc005f168 in do_mmap_pgoff (file=0xc31a6620, addr=<value optimized out>, len=3808, prot=3, flags=6146, pgoff=0) at mm/nommu.c:1373
> #2  0xc00a96b8 in elf_fdpic_map_file (params=0xc33fbbec, file=0xc31a6620, mm=0xc31bef60, what=0xc0213144 "executable") at mm.h:1145
> #3  0xc00aa8b4 in load_elf_fdpic_binary (bprm=0xc316cb00, regs=<value optimized out>) at fs/binfmt_elf_fdpic.c:343
> #4  0xc006b588 in search_binary_handler (bprm=0x6, regs=0xc33fbce0) at fs/exec.c:1234
> #5  0xc006c648 in do_execve (filename=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460, regs=0xc33fbce0) at fs/exec.c:1356
> #6  0xc0008cf0 in sys_execve (name=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460) at arch/frv/kernel/process.c:263
> #7  0xc00075dc in __syscall_call () at arch/frv/kernel/entry.S:897

I have no idea about the BDI_CAP_MAP_DIRECT bits but...

> Note that this fix does the following commit differently:
>
>        commit a190887b58c32d19c2eee007c5eb8faa970a69ba
>        Author: David Howells <dhowells@redhat.com>
>        Date:   Sat Sep 5 11:17:07 2009 -0700
>        nommu: fix error handling in do_mmap_pgoff()

...changes to this part of the code look like nice cleanup to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
