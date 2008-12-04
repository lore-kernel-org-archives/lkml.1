Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYLDWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYLDWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYLDWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:31:35 -0500
Received: from igw3.br.ibm.com ([32.104.18.26]:33582 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbYLDWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:31:34 -0500
Subject: Re: [PATCH 1/6] integrity: TPM internel kernel interface
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@br.ibm.com>
In-Reply-To: <1228422093.19683.66.camel@blackbox>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
	 <1228256380.2971.176.camel@nimitz>  <1228422093.19683.66.camel@blackbox>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 20:31:14 -0200
Message-Id: <1228429874.19683.73.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +/**
> > > + * tpm_pcr_read - read a pcr value
> > > + * @chip_id: 	tpm chip identifier
> > > + * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
> > > + * 		Lower 2 bytes: tpm idx # or AN&
> > > + * @pcr_idx:	pcr idx to retrieve
> > > + * @res_buf: 	TPM_PCR value
> > > + * 		size of res_buf is 20 bytes (or NULL if you don't care)
> > > + *
> > > + * The TPM driver should be built-in, but for whatever reason it
> > > + * isn't, protect against the chip disappearing, by incrementing
> > > + * the module usage count.
> > > + */
> > > +int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf)
> > > +{
> > > +	u8 data[READ_PCR_RESULT_SIZE];
> > > +	int rc;
> > > +	__be32 index;
> > > +	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
> > > +	struct tpm_chip *chip;
> > > +
> > > +	rcu_read_lock();
> > > +	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
> > > +	if (chip == NULL) {
> > > +		rcu_read_unlock();
> > > +		return -ENODEV;
> > > +	}
> > > +	if (!try_module_get(chip->dev->driver->owner)) {
> > > +		rcu_read_unlock();
> > > +		return -ENODEV;
> > > +	}
> > > +	rcu_read_unlock();
> > 
> > This little bit of lookup, check for NULL, and try_module_get() looks
> > cut-n-pasted in the next two functions.  Should be consolidated.
> > 
> 
> Same here.
> 
> > Also, if you need to shift down the chip_id every time anyway, why not
> > just do it inside the lookup function?
> 
> tpm_chip_lookup() only needs the chip type, not the entire chip_id, so
> its usage is probably clearer if written this way.
> 

Wait.. chip_num, the other parameter, depends on chip_id and a
previously defined constant, so, you are right, it's saner to just pass
chip_id to it.. sorry, and thanks. This will be included also on the
next patchset I'm about to send.

Rajiv

