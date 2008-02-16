Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYBPMMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYBPMMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 07:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYBPMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 07:12:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:56643 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYBPMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 07:12:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DH12FRsU+3nwHmpWl6Oh0K5eQ3SWFsxz5eY3dSsEzD1geewFi6h6RUtDn0pQ5RYTF8/S2EtC0WdfNv6tvyuhlEIRRDwstVOnXWeV/V9PueTP3pDooxb/naCrs6i7NHPXKaPA1XBIsT7U2wu+s+8G19wW3rQQeFGEfeSC1avjktg=
Message-ID: <8bd0f97a0802160412ve49103cya446b89d8560458b@mail.gmail.com>
Date: Sat, 16 Feb 2008 07:12:01 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: [PATCH] procfs task exe symlink
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "David Howells" <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Christoph Hellwig" <chellwig@de.ibm.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Hugh Dickins" <hugh@veritas.com>,
       "Bryan Wu" <Bryan.Wu@analog.com>
In-Reply-To: <1202348669.9062.271.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202348669.9062.271.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 8:44 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> The kernel implements readlink of /proc/pid/exe by getting the file from the
> first executable VMA. Then the path to the file is reconstructed and reported as
> the result.
>
> Because of the VMA walk the code is slightly different on nommu systems. This
> patch avoids separate /proc/pid/exe code on nommu systems. Instead of walking
> the VMAs to find the first executable file-backed VMA we store a reference to
> the exec'd file in the mm_struct.
>
> That reference would prevent the filesystem holding the executable file from
> being unmounted even after unmapping the VMAs. So we track the number of
> VM_EXECUTABLE VMAs and drop the new reference when the last one is unmapped.
> This avoids pinning the mounted filesystem.
>
> Andrew, these are the updates I promised. Please consider this patch for
> inclusion in -mm.

mm/nommu.c wasnt compiled tested, it's trivially broken:

> --- linux-2.6.24.orig/mm/nommu.c
> +++ linux-2.6.24/mm/nommu.c
> @@ -960,12 +960,15 @@ unsigned long do_mmap_pgoff(struct file
>         if (!vma)
>                 goto error_getting_vma;
>
>         INIT_LIST_HEAD(&vma->anon_vma_node);
>         atomic_set(&vma->vm_usage, 1);
> -       if (file)
> +       if (file) {
>                 get_file(file);
> +               if (vm_flags & VM_EXECUTABLE)
> +                       added_exe_file_vma(mm);
> +       }
>         vma->vm_file    = file;
>         vma->vm_flags   = vm_flags;
>         vma->vm_start   = addr;
>         vma->vm_end     = addr + len;
>         vma->vm_pgoff   = pgoff;

this function has no variable named "mm"

mm/nommu.c: In function 'do_mmap_pgoff':
mm/nommu.c:968: error: 'mm' undeclared (first use in this function)
mm/nommu.c:968: error: (Each undeclared identifier is reported only once
mm/nommu.c:968: error: for each function it appears in.)
make[1]: *** [mm/nommu.o] Error 1
-mike
