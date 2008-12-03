Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYLCSbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYLCSbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLCSbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:31:44 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46823 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYLCSbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:31:43 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1228328236.2821.28.camel@localhost.localdomain>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <1228260925.2971.240.camel@nimitz>
	 <1228328236.2821.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:31:14 -0800
Message-Id: <1228329074.26913.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 13:17 -0500, Mimi Zohar wrote:
> On Tue, 2008-12-02 at 15:35 -0800, Dave Hansen wrote: 
> > > +config IMA_MEASURE_PCR_IDX
> > > +	int "PCR for Aggregate (8 <= Index <= 14)"
> > > +	depends on IMA
> > > +	range 8 14
> > > +	default 10
> > > +	help
> > > +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> > > +	  that IMA uses to maintain the integrity aggregate of the
> > > +	  measurement list.  If unsure, use the default 10.
> > 
> > Why would you want to change this?  Can it be done at runtime instead of
> > compile time?  I don't know what a PCR is.
> 
> The only reason to change it would be if in the future, TCG decides on a
> standard PCR for IMA, other than 10, or if they pick 10 for something
> else. We really don't need a runtime variable for this, but kconfig
> makes it easy to change once if necessary in the future.

OK.  Could you take out the prompt for now?  You can use Kconfig for
values that don't give user prompts.  I just don't think it is something
that people need to see.

in mm/Kconfig, for instance:

config NR_QUICK
        int
        depends on QUICKLIST
        default "2" if SUPERH || AVR32
        default "1"

> > > +int ima_iint_insert(struct inode *inode)
> > > +{
> > > +	struct ima_iint_cache *iint;
> > > +	int rc = 0;
> > > +
> > > +	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
> > 
> > Does this basically get done for every inode, or only special ones?  I
> > just wonder if having a dedicated slab with a constructor to do
> > redundant things like mutex_init() would be helpful.
> 
> every inode, except those allocated before init_latecall.

I'd be willing to bet that you'll see a measurable performance
improvement if you decide to use a slab here.  All of the inodes for the
different fs's use slabs and these are at least as common as any single
fs's inode.  Also, using the con/destructors will save some work at each
object creation.

> > > +static void ima_add_boot_aggregate(void)
> > > +{
> > > +	struct ima_inode_measure_entry measure_entry;
> > > +	struct ima_store_template_data template = {
> > > +		.name = "ima",
> > > +		.len = sizeof(measure_entry),
> > > +		.data = (char *)&measure_entry,
> > > +	};
> > > +	int namelen, result;
> > > +
> > > +	memset(&measure_entry, 0, sizeof measure_entry);
> > > +	namelen = strlen(boot_aggregate_name);
> > > +	if (namelen > IMA_EVENT_NAME_LEN_MAX)
> > > +		namelen = IMA_EVENT_NAME_LEN_MAX;
> > > +	memcpy(measure_entry.file_name, boot_aggregate_name, namelen);
> > > +
> > > +	if (ima_used_chip) {
> > > +		int i;
> > > +		u8 pcr_i[IMA_DIGEST_SIZE];
> > > +		struct hash_desc desc;
> > > +		struct crypto_hash *tfm;
> > > +		struct scatterlist sg;
> > 
> > All of this stack stuff with very important, large sounding names makes
> > me nervous.  Can you reassure me?
> 
> The crypto code here will be moved to ima_crypto.c and will be
> refactored, cleaning up the code. Both measure_entry and template could
> be allocated/freed each time, but does that make sense?

That's reassuring, thanks. :)

-- Dave

