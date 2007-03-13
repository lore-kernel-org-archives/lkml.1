Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXCMHHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXCMHHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXCMHHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:07:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:39508 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXCMHHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:07:18 -0400
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       David Woodhouse <dwmw2@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, torvalds@linux-foundation.org
In-Reply-To: <20070312230137.GA8304@keitarou>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou>
	 <1172558897.11949.43.camel@localhost.localdomain>
	 <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
	 <1172644987.11949.90.camel@localhost.localdomain>
	 <1172657584.3452.51.camel@pmac.infradead.org>
	 <1172709056.5852.6.camel@concordia.ozlabs.ibm.com>
	 <20070312230137.GA8304@keitarou>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 08:03:49 +0100
Message-Id: <1173769429.24454.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm. The crash came back after I booted into Mac OS X and back. It was however
> a different crash, I believe it was coming from the USB modules (as it would
> keep going when it happened, and get another crash, which tended to scroll away
> too fast for me to capture) but I believe it was still getting down into the
> slab code and actually dying there.

Have you tried, instead, to apply
38f3323037de22bb0089d08be27be01196e7148b ? (That is revert
39d61db0edb34d60b83c5e0d62d0e906578cc707).

I suspect this is the proper fix...

Ben.

> However, reverting the reversion of
> 8d610dd52dd1da696e199e4b4545f33a2a5de5c6 and instead applying
> the following patch:
> 
> diff -ru linux-source-2.6.20.orig/arch/powerpc/mm/init_32.c linux-source-2.6.20/arch/powerpc/mm/init_32.c
> --- linux-source-2.6.20.orig/arch/powerpc/mm/init_32.c  2007-02-05 05:44:54.000000000 +1100
> +++ linux-source-2.6.20/arch/powerpc/mm/init_32.c       2007-03-10 11:03:56.000000000 +1100
> @@ -244,7 +244,8 @@
>  void free_initrd_mem(unsigned long start, unsigned long end)
>  {
>         if (start < end)
> -               printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
> +               printk ("NOT Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
> +       return;
>         for (; start < end; start += PAGE_SIZE) {
>                 ClearPageReserved(virt_to_page(start));
>                 init_page_count(virt_to_page(start));
> 
> which if I recall correctly David Woodhouse posted to this thread,
> seems to have fixed it.
> 
> I dunno if it's relevant, but my initrd.img is 13193315 bytes long,
> (ie 99 bytes over 12884k) and the above logs:
> "NOT Freeing initrd memory: 12888k freed"
> which makes sense...
> 
> I of course completely failed to think to check this with the crashing
> kernel, if it seems relevant I can roll back to it and get the numbers.
> 

