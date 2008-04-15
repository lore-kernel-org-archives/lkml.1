Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYDOHCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYDOHCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYDOHCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:02:30 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:46565 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752929AbYDOHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jv5XTYhCBe+ElvnH2POQ/58G9+0USkph5mq/hXCWZ3d3Ka3Fn4zxOrNHppgcibdJm7hYIxZin6/soxBaXY5KJrIzsMvrDtueXMZE3zz+OgXUN+H+4DKNaMGoRDBhb2PpTDv4+gWkadqLaCA6nI8KRDcyXvnRvf8yNIm4nJ6T1L0=
Message-ID: <86802c440804150002t2abd5532wddcce6304fe991fb@mail.gmail.com>
Date: Tue, 15 Apr 2008 00:02:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, hannes@saeurebad.de, ak@suse.de,
       clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu,
       y-goto@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:23 PM,  <akpm@linux-foundation.org> wrote:
>
>  The patch titled
>      bootmem: node-setup agnostic free_bootmem()
>  has been added to the -mm tree.  Its filename is
>      bootmem-node-setup-agnostic-free_bootmem.patch
>
>  Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
>  *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
>  See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>  out what to do about this
>
>  The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
>  ------------------------------------------------------
>  Subject: bootmem: node-setup agnostic free_bootmem()
>  From: Johannes Weiner <hannes@saeurebad.de>
>
>  Make free_bootmem() look up the node holding the specified address range which
>  lets it work transparently on single-node and multi-node configurations.
>
>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  Cc: Yinghai Lu <yhlu.kernel@gmail.com>
>  Acked-by: Andi Kleen <ak@suse.de>
>  Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
>  Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  Cc: Ingo Molnar <mingo@elte.hu>
>  Cc: Christoph Lameter <clameter@sgi.com>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>   mm/bootmem.c |   10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
>  diff -puN mm/bootmem.c~bootmem-node-setup-agnostic-free_bootmem mm/bootmem.c
>  --- a/mm/bootmem.c~bootmem-node-setup-agnostic-free_bootmem
>  +++ a/mm/bootmem.c
>  @@ -421,7 +421,15 @@ int __init reserve_bootmem(unsigned long
>
>   void __init free_bootmem(unsigned long addr, unsigned long size)
>   {
>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  +       bootmem_data_t *bdata;
>  +
>  +       list_for_each_entry (bdata, &bdata_list, list) {
>  +               if (addr < bdata->node_boot_start)
>  +                       continue;
>  +               free_bootmem_core(bdata, addr, size);
>  +               return;
>  +       }
>  +       BUG();
>   }

NAK,
it doesn't solve the cross nodes bootmem that is reserved via
reserve_early. like ramdisk free in x86/setup_64.c
...
                        free_bootmem(ramdisk_image, ramdisk_size);
                        printk(KERN_ERR "initrd extends beyond end of memory "
                               "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
                               ramdisk_end, end_of_mem);
                        initrd_start = 0;
..
YH
