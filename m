Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbZKZAkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbZKZAkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbZKZAkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:40:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965046AbZKZAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:40:42 -0500
Date: Wed, 25 Nov 2009 16:40:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
Message-Id: <20091125164033.655810b7.akpm@linux-foundation.org>
In-Reply-To: <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
	<1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Nov 2009 10:06:17 +0000
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> modpost of vmlinux.o now extracts the ksymtab sections and outputs
> sorted versions of them as .tmp_exports-asm.S.  These sorted sections
> are linked into vmlinux and the original unsorted sections are
> discarded.
> 
> This will allow modules to be loaded faster, resolving symbols using
> binary search, without any increase in the memory needed for the
> symbol tables.
> 
> This does not affect the building of modules, so hopefully it won't
> affect compile times too much.
> 
> Minimally tested on ARM under QEMU emulator.
> Build tested on blackfin; output of "size -A" unchanged.

I'm getting a segfault from write_exports().  

(gdb) bt
#0  0x0000003e5f075510 in strlen () from /lib64/libc.so.6
#1  0x0000003e5f045cb8 in vfprintf () from /lib64/libc.so.6
#2  0x0000003e5f06683a in vsnprintf () from /lib64/libc.so.6
#3  0x0000000000401897 in buf_printf (buf=0x7fff5514f5e0, 
    fmt=0x7fff5514f4e0 "0x%02x ") at scripts/mod/modpost.c:1692
#4  0x00000000004042c8 in main (argc=1024, argv=0x7fff5514f5e0)
    at scripts/mod/modpost.c:2063
(gdb) f 4
#4  0x00000000004042c8 in main (argc=1024, argv=0x7fff5514f5e0)
    at scripts/mod/modpost.c:2063
2063                    buf_printf(&buf, "__EXPORT_%s_SYMBOL(%s,"
(gdb) p sym
$1 = (struct symbol *) 0x65c9f0
(gdb) p *sym
$2 = {next = 0x64c3a0, module = 0x610010, crc = 4077789248, crc_valid = 1, 
  weak = 0, vmlinux = 0, kernel = 0, preloaded = 0, function = 1, 
  export = export_unknown, name = 0x65ca10 "simple_prepare_write"}
(gdb) p sym->export
$3 = export_unknown
(gdb) p/d sym->export
$4 = 5

but section_names[] (which could be static in write_exports() btw) has
only five entries.
