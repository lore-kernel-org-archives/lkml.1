Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbYLCPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbYLCPER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLCPEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:04:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYLCPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:04:00 -0500
Date: Wed, 3 Dec 2008 13:03:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bluesmoke-devel <bluesmoke-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com
Subject: Re: [PATCH RESEND] driver for i5400 MCH
Message-ID: <20081203130347.1c21c37d@pedra.chehab.org>
In-Reply-To: <20081202223347.bf6506f1.akpm@linux-foundation.org>
References: <20081201194623.3ce28246@pedra.chehab.org>
	<20081202223347.bf6506f1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 22:33:47 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 1 Dec 2008 19:46:23 -0200 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > EDAC driver for i5400 MCH (Seaburg)
> > 
> > This driver adds support for i5400 MCH chipset.
> 
> checkpatch has fun with this one.

Ok. I fixed the remaining errors. 

I'll just keep the 80 char warns on lines with comments explaining each field, like:

WARNING: line over 80 characters
#200: FILE: drivers/edac/i5400_edac.c:151:
+	EMASK_M9  = 1<<8,  /* Non-Aliased Uncorrectable Non-Mirrored Demand Data ECC */

Where breaking the line wouldn't be that fun.

> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Both you and Ben Woodard are listed under MODULE_AUTHOR.  Should this
> patch have Ben's Signed-off-by:?  And/or his From:?

I'll ask his SOB.

> > +#ifndef PCI_DEVICE_ID_INTEL_5400_ERR
> 
> This ifndef is unneeded: PCI_DEVICE_ID_INTEL_5400_ERR _is_ defined.
> 
> What's more, it is actually bad, because if pci_ids.h were to #define
> PCI_DEVICE_ID_INTEL_5400_ERR to something other than 0x4030, the ifndef
> would prevent the compiler from informing us of this potential problem.

Fixed.
 
> > +char *error_name[] = {
> 
> error_name is a global symbol.

Changed. Also changed it to const.

> > +/* masks for non-fatal error register */
> > +#define TO_NF_MASK(a)		(((a) & EMASK_M29) | ((a) >> 3))
> > +#define FROM_NF_FERR(a)		(((a) & EMASK_M29) | (((a) << 3) & ((1 << 30)-1)))
> 
> These macros will misbehave if passed an expression with side-effects. 
> Not really a problem as they're only used for constructing constants. 
> I guess if one was being paranoid, one could #undef them again as soon
> as possible.

Good point. I've converted both macros into inline functions, since gcc will likely optimize
the code into a constant, instead of calculating at runtime.

> > +#ifdef CONFIG_EDAC_DEBUG
> > +/* MTR NUMROW */
> > +static char *numrow_toString[] = {
> > +	"8,192 - 13 rows",
> > +	"16,384 - 14 rows",
> > +	"32,768 - 15 rows",
> > +	"65,536 - 16 rows"
> > +};
> > +
> > +/* MTR NUMCOL */
> > +static char *numcol_toString[] = {
> > +	"1,024 - 10 columns",
> > +	"2,048 - 11 columns",
> > +	"4,096 - 12 columns",
> > +	"reserved"
> > +};
> 
> These could possibly be made const.  We don't modify them at runtime...

Fixed.

> 202 bytes.  Tolerable, I guess.
> 
> Heaven knows why and how this dimension was chosen, and under which
> circumstances it will overflow :(
> 
> It looks like such a hack that perhaps you should give up and use
> kasprintf()+kfree()?

I also didn't like that code. It is present also on other edac drivers.

I'll fix this on a later patch. I'll probably propose some patches to the other
edac drivers that use this kind of construction.

> > +	/* Decrement usage count for devices */
> > +	if (pvt->branch_1)
> > +		pci_dev_put(pvt->branch_1);
> > +
> > +	if (pvt->branch_0)
> > +		pci_dev_put(pvt->branch_0);
> > +
> > +	if (pvt->fsb_error_regs)
> > +		pci_dev_put(pvt->fsb_error_regs);
> > +
> > +	if (pvt->branchmap_werrors)
> > +		pci_dev_put(pvt->branchmap_werrors);
> 
> pci_dev_put(NULL) is legal.

Fixed.

> > +	mci->ctl_name = i5400_devs[dev_idx].ctl_name;
> 
> This is a bit strange.  i5400_devs[] has a single entry, so what's the
> point in indexing it with `dev_idx', which MUST have a value of zero
> anyway?

I'm not sure if we covered all PCI ID's for i5400 (maybe some i5400 variant may
be released?). That's why I preferred to keep a table: makes easier to add
other entries there, but I see your point.

I'll add a code to prevent dev_idx values equal or higher than
ARRAY_SIZE, to avoid the risk of trying to acess something outside the buffer.

> > +static struct pci_driver i5400_driver = {
> > +	.name = KBUILD_BASENAME,
> > +	.probe = i5400_init_one,
> > +	.remove = __devexit_p(i5400_remove_one),
> > +	.id_table = i5400_pci_tbl,
> > +};
> 
> Only one other driver in the tree uses KBUILD_BASENAME, and that is
> drivers/edac/i5100_edac.c, from which I suspect the above was copied.
> 
> I suspect that something is being done wrongly here.

Fixed.

I'll run some tests here, and submit a version 2 of the patch soon.

Cheers,
Mauro
