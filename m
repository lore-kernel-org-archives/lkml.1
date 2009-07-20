Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZGTX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZGTX2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZGTX2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:28:17 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:37648 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZGTX2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:28:16 -0400
Date: Mon, 20 Jul 2009 16:28:16 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
Subject: Re: [PATCH] TPM: DATA_EXPECT bit check bypass
Message-ID: <20090720232816.GR6370@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com> <1246410255-6839-6-git-send-email-adi@vmware.com> <20090701110136.576a1d14@lxorguk.ukuu.org.uk> <1246455920.9140.28.camel@blackbox> <1247765210.30736.3.camel@dyn531421.br.ibm.com> <1247766212.30736.17.camel@dyn531421.br.ibm.com> <49514.1247774890@turing-police.cc.vt.edu> <1247779226.3062.44.camel@dyn531421.br.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247779226.3062.44.camel@dyn531421.br.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 06:20:26PM -0300, Rajiv Andrade wrote:
> On Thu, 2009-07-16 at 16:08 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 16 Jul 2009 14:43:32 -0300, Rajiv Andrade said:
> > 
> > > @@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_siz
> > e_t start,
> > >         tpm_get_timeouts(chip);
> > >         tpm_continue_selftest(chip);
> > >  
> > > +       for (i=0; i < 8; i++)
> > > +               if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
> > > +                       break;
> > > +       if (i == 8)
> > > +               chip->is_itpm = 1;
> > > +
> > 
> > strcmp() variant of some sort instead?
> 
> Wait, is to_pnp_dev(dev)->id->id[i] null terminated? Maybe memcmp() fits
> better here..

Rather than checking the PNP ID at this point, I suggest something like:

(the context here depends on my earlier series, but it's fairly
obvious.)

@@ -467,6 +481,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 "1.2 TPM (%04X:%04X rev %d)\n", vendor & 0xffff,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (vendor == 0x10208086) {
+		dev_info(dev, "Intel iTPM workaround enabled\n");
+		chip->itpm = 1;
+	}
+
 	/* Figure out the capabilities */
 	intfcaps =
 	    ioread32(chip->vendor.iobase +

(I suppose there should be a #define of 0x10208086 somewhere.)

I'll cook up a refreshed patch series.

-andy
