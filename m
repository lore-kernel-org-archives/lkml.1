Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXITDSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXITDSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 23:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXITDSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 23:18:37 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:44631 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXITDSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 23:18:36 -0400
Date: Thu, 20 Sep 2007 12:18:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David McCullough <David_Mccullough@securecomputing.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Message-ID: <20070920031807.GA31263@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David McCullough <David_Mccullough@securecomputing.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
	Bernd Schmidt <bernd.schmidt@analog.com>,
	Greg Ungerer <gerg@snapgear.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ysato@users.sourceforge.jp, miles@lsi.nec.co.jp,
	linux-m32r@ml.linux-m32r.org
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920015525.GA16615@securecomputing.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 11:55:25AM +1000, David McCullough wrote:
> Jivin Robin Getz lays it down ...
> > On Tue 18 Sep 2007 04:09, Bryan Wu pondered:
> > > This just adds minimum support for the Blackfin relocations,
> > > since we don't have enough space in each reloc. The idea
> > > is to store a value with one relocation so that subsequent ones can
> > > access it.
> > 
> > Adding the other appropriate maintainers. for h8, m32r, sh and v850.
> 
> Looks fine to me,  obviously impacts the existing arches very little.
> Can't see why it shouldn't get included,
> 
I find it a bit disconcerting that blackfin already depends on this
in-tree without there being any earlier discussion on making these
changes.

> > >  	 */
> > >  	if (rev > OLD_FLAT_VERSION) {
> > > +		unsigned long persistent = 0;
> > >  		for (i=0; i < relocs; i++) {
> > >  			unsigned long addr, relval;
> > >  
> > > @@ -749,6 +750,8 @@ static int load_flat_file(struct linux_binprm * bprm,
> > >  			   relocated (of course, the address has to be
> > >  			   relocated first).  */
> > >  			relval = ntohl(reloc[i]);
> > > +			if (flat_set_persistent (relval, &persistent))
> > > +				continue;
> > >  			addr = flat_get_relocate_addr(relval);
> > >  			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
> > >  			if (rp == (unsigned long *)RELOC_FAILED) {

I don't much care for this API. It's shuffling around a temporary
variable for the architecture code that's set for certain relocations
that are otherwise unhandled.

Since all the architecture is interested in is the relval that has
associated "persistent" data encoded in it, why don't we just have a stub
to give the architecture a chance to validate the relval before the
flat_get_relocate_addr() and move this stuff there instead? ie, blackfin
takes this out-of-line and manages its persistent value there.

> > > @@ -757,7 +760,7 @@ static int load_flat_file(struct linux_binprm * bprm,
> > >  			}
> > >  
> > >  			/* Get the pointer's value.  */
> > > -			addr = flat_get_addr_from_rp(rp, relval, flags);
> > > +			addr = flat_get_addr_from_rp(rp, relval, flags, &persistent);
There's no reason for this to be a pointer. The current in-tree blackfin
code doesn't change this value, and if you have patches that are doing
that, this is even more reason to bury this kind of silliness in your
architecture code.

load_flat_file() is ugly enough without dumping more architecture
callback abuses in it.
