Return-Path: <linux-kernel-owner+w=401wt.eu-S937705AbZDDAgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937705AbZDDAgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937656AbZDDAfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:35:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:27143 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937646AbZDDAfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CW00/lpsp9fTk2DST0fcXwFKkjwP54aBto3FpsJSJMMCfP1Z//dCfRdhKxe1jM3MIJ
         zhlxAxNBOA2POrP2WJIUL/FB+nopUlKskiOcCyhfSjvnSMKlgrL2ZRD3zKi0LRPYrJ3H
         CVXRMf/nnP4l/DWnAtwLliW1DwNqV9nPSGmwE=
MIME-Version: 1.0
In-Reply-To: <20090331153223.74b177bd@skybase>
References: <20090331153223.74b177bd@skybase>
Date: Sat, 4 Apr 2009 09:35:30 +0900
Message-ID: <28c262360904031735k76443b5ye1c1239443b865@mail.gmail.com>
Subject: Re: [PATCH] do_xip_mapping_read: fix length calculation
From: Minchan Kim <minchan.kim@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jared Hulbert <jaredeh@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice catch!

I tested this patch on ext2's ramdisk with xip.
It fixed following bug.

*** stack smashing detected ***: <unknown> terminated
======= Backtrace: =========
/lib/tls/i686/cmov/libc.so.6(__fortify_fail+0x48)[0xb7fe5138]
/lib/tls/i686/cmov/libc.so.6(__fortify_fail+0x0)[0xb7fe50f0]
[0x80485f8]
[0x0]
======= Memory map: ========
08048000-08049000 r-xp 00000000 01:00 12         /mnt/xip_test
08049000-0804a000 rw-p 00000000 01:00 12         /mnt/xip_test
0804a000-0806b000 rw-p 0804a000 00:00 0          [heap]
b7ef7000-b7ef8000 rw-p b7ef7000 00:00 0
b7ef8000-b8041000 r-xp 00000000 08:03 4219915    /lib/tls/i686/cmov/libc-2.7.so
b8041000-b8042000 r--p 00149000 08:03 4219915    /lib/tls/i686/cmov/libc-2.7.so
b8042000-b8044000 rw-p 0014a000 08:03 4219915    /lib/tls/i686/cmov/libc-2.7.so
b8044000-b8047000 rw-p b8044000 00:00 0
b8047000-b8051000 r-xp 00000000 08:03 4202508    /lib/libgcc_s.so.1
b8051000-b8052000 rw-p 0000a000 08:03 4202508    /lib/libgcc_s.so.1
b8052000-b8055000 rw-p b8052000 00:00 0
b8055000-b8056000 r-xp b8055000 00:00 0          [vdso]
b8056000-b8070000 r-xp 00000000 08:03 4202565    /lib/ld-2.7.so
b8070000-b8072000 rw-p 00019000 08:03 4202565    /lib/ld-2.7.so
bf95c000-bf971000 rw-p bffeb000 00:00 0          [stack]
Aborted


Reviewed-by: Minchan kim <minchan.kim@gmail.com>
Tested-by: Minchan kim <minchan.kim@gmail.com>


On Tue, Mar 31, 2009 at 10:32 PM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> The calculation of the value nr in do_xip_mapping_read is incorrect. If
> the copy required more than one iteration in the do while loop the
> copies variable will be non-zero. The maximum length that may be passed
> to the call to copy_to_user(buf+copied, xip_mem+offset, nr) is len-copied
> but the check only compares against (nr > len).
>
> This bug is the cause for the heap corruption Carsten has been chasing
> for so long:
>
> *** glibc detected *** /bin/bash: free(): invalid next size (normal): 0x00000000800e39f0 ***
> ======= Backtrace: =========
> /lib64/libc.so.6[0x200000b9b44]
> /lib64/libc.so.6(cfree+0x8e)[0x200000bdade]
> /bin/bash(free_buffered_stream+0x32)[0x80050e4e]
> /bin/bash(close_buffered_stream+0x1c)[0x80050ea4]
> /bin/bash(unset_bash_input+0x2a)[0x8001c366]
> /bin/bash(make_child+0x1d4)[0x8004115c]
> /bin/bash[0x8002fc3c]
> /bin/bash(execute_command_internal+0x656)[0x8003048e]
> /bin/bash(execute_command+0x5e)[0x80031e1e]
> /bin/bash(execute_command_internal+0x79a)[0x800305d2]
> /bin/bash(execute_command+0x5e)[0x80031e1e]
> /bin/bash(reader_loop+0x270)[0x8001efe0]
> /bin/bash(main+0x1328)[0x8001e960]
> /lib64/libc.so.6(__libc_start_main+0x100)[0x200000592a8]
> /bin/bash(clearerr+0x5e)[0x8001c092]
>
> With this bug fix the commit 0e4a9b59282914fe057ab17027f55123964bc2e2
> "ext2/xip: refuse to change xip flag during remount with busy inodes"
> can be removed again.
>
> Cc: Carsten Otte <cotte@de.ibm.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Jared Hulbert <jaredeh@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>
>  mm/filemap_xip.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -urpN linux-2.6/mm/filemap_xip.c linux-2.6-patched/mm/filemap_xip.c
> --- linux-2.6/mm/filemap_xip.c  2009-03-24 00:12:14.000000000 +0100
> +++ linux-2.6-patched/mm/filemap_xip.c  2009-03-31 15:25:53.000000000 +0200
> @@ -89,8 +89,8 @@ do_xip_mapping_read(struct address_space
>                        }
>                }
>                nr = nr - offset;
> -               if (nr > len)
> -                       nr = len;
> +               if (nr > len - copied)
> +                       nr = len - copied;
>
>                error = mapping->a_ops->get_xip_mem(mapping, index, 0,
>                                                        &xip_mem, &xip_pfn);
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim
