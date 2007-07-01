Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbXGAUjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbXGAUjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbXGAUjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:39:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:47361 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbXGAUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=Iji7JFEhQ2veIV6qtU41KgJXk7i6Y8ZCsK0oTNRD4swW8PoDuL2TVMAmh4GMJ7/SJ7mBRp4aOyBaNY8G2g6oF8YdPTiHNGIUMqorDR5dUVOhJy56hJeJPxfCR+iCgc3M9vdINifl7tZnPHDT71E4EpBUMjMak+jkImh+tf/iMYo=
Date: Sun, 1 Jul 2007 23:38:33 +0300
To: linux-kernel@vger.kernel.org
Subject: [i386] Questions regarding provisional page tables initialization
Message-ID: <20070701203833.GA3498@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

AFAIK, in the initializaion phase, kernel builds pages tables with two
mappings, identity and PAGE_OFFSET + C mapping. The provisional _global
directory_ is contained in swapper_pg_dir variable. while the provisional 
_page tables_ are stored starting from pg0, right after _end.

There're some stuff that confused me for a full day about the code (head.S)
that  accomplishes the above words:

	movl $(pg0 - __PAGE_OFFSET), %edi
	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx	
	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
10:
	leal $0x007(%edi),%ecx			/* Create PDE entry */

What does the address of 7 bytes displacement after %edi - the physical address
of pg0 - represent ?. Why not just putting the address of %edi (the address of
pagetable cell to be mapped by swapper_pg_dir) in %ecx without displacement?

        page_pde_offset = (__PAGE_OFFSET >> 20)
	movl %ecx,(%edx)			/* Store identity PDE entry */
	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */

Why the pde_offset is PAGE_OFFSET >> 20 instead of PAGE_OFFSET >> 22 ?
* 22 to right shift the whole page_shift (12) and pgdir_shift (10) bits.

        [...]
	/* Initialize the 1024 _page table_ cells with %eax (0x007) */
	movl $1024, %ecx
11:
	stosl
	addl $0x1000,%eax
	loop 11b

The page table entries beginning from pg0 (pointed by %edi) and following pages 
are initialized with  the series 7 + 8 + 8 + ... for each cell. This series has
the property of setting the PRESENT+RW+USER bits in the whole entries to 1 but it
sets lots of the entries BASE address to 0 too. Why is this done ?

Thanks,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
