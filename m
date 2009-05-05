Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZEEVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZEEVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZEEVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEEVlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:41:10 -0400
Date: Tue, 5 May 2009 18:39:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask
 in a family-specific way
Message-ID: <20090505183927.33eda184@pedra.chehab.org>
In-Reply-To: <824989.5191.qm@web50101.mail.re2.yahoo.com>
References: <824989.5191.qm@web50101.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 5 May 2009 12:28:01 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> escreveu:

> 
> --- On Mon, 5/4/09, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > From: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
> > To: "Borislav Petkov" <borislav.petkov@amd.com>
> > Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> > Date: Monday, May 4, 2009, 3:59 PM
> > Borislav Petkov escreveu:
> > > +    for (cs = 0; cs <
> > CHIPSELECT_COUNT; cs++) {
> > > +        reg = K8_DCSB0
> > + (cs * 4);
> > > +        err =
> > pci_read_config_dword(pvt->dram_f2_ctl, reg,
> > > +       
> >            
> >     &pvt->dcsb0[cs]);
> > > +        if (err != 0)
> > > +       
> >     debugf0("%s() Reading K8_DCSB0[%d]
> > failed\n",
> > > +       
> >         __func__, cs);
> > > +
> > > +        debugf0(" 
> > DCSB0[%d]=0x%08x reg: F2x%x\n",
> > > +       
> >     cs, pvt->dcsb0[cs], reg);
> > >   
> > 
> > Hmm... I suspect that there's a missing else before the
> > debugf0(). If you got an error while reading it, you
> > shouldn't be showing the results. 
> > > +
> > > +        /* If DCT are
> > NOT ganged, then read in DCT1's base */
> > > +        if
> > (boot_cpu_data.x86 >= 0x10 &&
> > !dct_ganging_enabled(pvt)) {
> > > +       
> >     reg = F10_DCSB1 + (cs * 4);
> > > +       
> >     err =
> > pci_read_config_dword(pvt->dram_f2_ctl, reg,
> > > +       
> >            
> >        
> > &pvt->dcsb1[cs]);
> > > +       
> >     if (err != 0)
> > > +       
> >         debugf0("%s() Reading
> > F10_DCSB1[%d] failed\n",
> > > +       
> >            
> > __func__, cs);
> > > +       
> >     debugf0("  DCSB1[%d]=0x%08x reg:
> > F2x%x\n",
> > > +       
> >         cs, pvt->dcsb1[cs],
> > reg);
> > >   
> > The same issue here: if you got an error while reading it,
> > you shouldn't be showing the results. 
> > Cheers,
> > Mauro.
> > 
> 
> An 'else' could be inserted, but it is only under DEBUG state for development purposes.  

Yet, it seems worthy to have it.
> 
> BACKGROUND: The error checking of the pci config space read was added during the time when the kernel couldn't read the extended 4k config space via the AMD IOConfig port access function (12 bits of offset) not via MMCONFIG. 

As this is unlikely to happen, I would also replace the:
	if (err != 0)

by:
	if (unlikely(err))

in order to optimize the tests a little bit, avoiding the risk of cache flushes due to the branches.

Cheers,
Mauro
