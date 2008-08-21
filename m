Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYHUS4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYHUS4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYHUS4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:56:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41400 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYHUS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:56:33 -0400
Date: Thu, 21 Aug 2008 19:56:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jack Steiner <steiner@sgi.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging
 request"
In-Reply-To: <48ADB041.9040806@goop.org>
Message-ID: <Pine.LNX.4.64.0808211946300.28535@blonde.site>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>  <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
  <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com> 
 <48AB5D17.5030600@goop.org>  <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
  <48AC3FA4.9080603@goop.org> <b170af450808201327q48b5b2e0n319c89b0fc1759b6@mail.gmail.com>
 <48ADB041.9040806@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Jeremy Fitzhardinge wrote:
> 
> >>>>
> Some notes as I pick through all the evidence so far:
> 
> - the crash is specifically because there are reserved bits set in the pmd
> - the pmd is b02a00043a6001a3 in both cases

Yes, it's corrupt, it should be
               800000013a6001a3

> - the vaddr is ffff88013a600000 in the first crash, and
>                ffff81013a6d1c00 in the second
>   corresponding to the same large-page pmd mapping of phys page 0x13a600000
> - this maps to e820 entry
>  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> - the corresponding boot-time mapping is
> 
> init_memory_mapping
>  0100000000 - 0140000000 page 2M
> kernel direct mapping tables up to 140000000 @ b000-11000
>                                                ^^^^^^^^^^
> addr 100000000 reusing pgd 201880 0000000000202063
> last_map_addr: 140000000 end: 140000000
> 
> !!! and the memory allocated for this pagetable is:
>   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
>   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
>                                                      ^^^^^^^^^^^^^^^^^^^^^^^
> 
> IOW, it's mapping using b000-11000, but it has only reserved b000 - c000
> 
> Also, this is right in the middle of the ISA area, which seems risky.
> <<<<
> 
> Bug #11237 shows the same symptom, so I'm pretty confident they're dups now.

[ Sorry, I'm replying to #11313 even though we think it's dup of #11237. ]

Haven't you got that backwards?

My reading is that find_early_table_space set aside b000-11000 for the
worst case possible, but actually only b000-c000 was needed (because
most of the tables were already there): no problem.
