Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbXJNTMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbXJNTMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXJNTMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:12:12 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36791 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXJNTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WG9neKRYeQBb1ScATV//R983m8W1e2o0z/a4xuVz5av+SEt+prQmj+uTuH9yhaMwt+s4+juSOJwMslcO6HwYc+wgPlM5/Nq+aIYM/oafOIANTR90rPZxn6H5ZkD5F/rNZJAdR2aDyP9A4HIwZwbn6FLxkfGuwq1OZqy7H2xzg7Y=
Message-ID: <64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
Date: Sun, 14 Oct 2007 21:12:08 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071014113914.7654759d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <4710B7C5.5050403@garzik.org>
	 <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	 <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	 <47110500.8050503@garzik.org>
	 <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	 <20071013111853.7e67c6c3.akpm@linux-foundation.org>
	 <64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
	 <20071014113914.7654759d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 14 Oct 2007 13:54:26 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > > The page-owner code can pinpoint a leak source.  See
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/page-owner-tracking-leak-detector.patch
> > >
> > > Enable CONFIG_DEBUG_SLAB_LEAK, check out /proc/slab_allocators
> >
> > Did that. The output of /proc/page_owner is ~350Mb, gzipped still ~7Mb.
> >
> > Taking only the first line from each stackdump it shows the following counts:
> >
> > ...
> >
> >  354042 [0xffffffff80266373] mempool_alloc+83
>
> This one is suspicious.  Can you find the whole record for it?

I still have all 354042 records of it. ;)
The first column is the times I found this line in page_owner.
I divided the counts for the duplicate lines (mempool_alloc+83 and
kcryptd_do_crypt+0) by two, so normalize them. There still are some
false positive counts in there, so it does not match the 354042
precisely.

354036 Page allocated via order 0, mask 0x11202
            1 (PFN/Block always differ) PFN 3072 Block 6 type 0          Flags
354338 [0xffffffff80266373] mempool_alloc+83
354338 [0xffffffff80266373] mempool_alloc+83
354025 [0xffffffff802bb389] bio_alloc_bioset+185
354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
354052 [0xffffffff804d2cc7] kcryptd_do_crypt+391
354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
354052 [0xffffffff80245d3c] run_workqueue+204
354062 [0xffffffff802467b0] worker_thread+0

I'm using dm-crypt with CONFIG_CRYPTO_TWOFISH_X86_64

> The other info shows a tremendous memory leak, not via slab.  Looks like
> someone is running alloc_pages() directly and isnb't giving them back.

Blaming it on dm-crypt looks right, as the leak seems to happens, if
there is (heavy) disk activity.
(updatedb just ate ~500 Mb)

Torsten
