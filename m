Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZFXDgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZFXDgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZFXDgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:36:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:19666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZFXDga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,279,1243839600"; 
   d="scan'208";a="527289637"
Date: Wed, 24 Jun 2009 11:34:40 +0800
From: Feng Tang <feng.tang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090624113440.2774d13d@feng-desktop>
In-Reply-To: <87iqin166f.fsf@basil.nowhere.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
	<87iqin166f.fsf@basil.nowhere.org>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 20:32:56 +0800
Andi Kleen <andi@firstfloor.org> wrote:

> > +static void __iomem *sfi_map_memory(u32 phys, u32 size)
> > +{
> > +	if (!phys || !size)
> > +		return NULL;
> > +
> > +	if (sfi_tbl_permanant_mapped)
> 
> 
> 
> > +		return ioremap((unsigned long)phys, size);
> > +	else
> > +		return arch_early_ioremap((unsigned long)phys,
> > size); +}
> 
> imho it would be cleaner if the callers just called these functions
> directly. Are the !phys !size checks really needed?

Andi,

Thanks for many good comments, will address them.

For this question, this sfi_map_memory() may get called before and after
the ioremap() is ready, so we add a permanent flag to judge the
environment and chose the right API automatically. e.g. after system is 
booted, cpu freq driver will implicitly call this API to get freq info 
> 
> 
> > +
> > +void sfi_tb_install_table(u64 addr, u32 flags)
> > +{
> > +	struct sfi_table_header *table;
> > +	u32 length;
> > +
> > +	/* only map table header before knowing actual length */
> > +	table = sfi_map_memory(addr, sizeof(struct
> > sfi_table_header));
> > +	if (!table)
> > +		return;
> > +
> > +	length = table->length;
> > +	sfi_unmap_memory(table, sizeof(struct sfi_table_header));
> > +
> > +	table = sfi_map_memory(addr, length);
> > +	if (!table)
> > +		return;
> 
> 
> Since the mappings are always 4K you would only need to remap
> if the size is > PAGE_SIZE

yes, some of the table may be in one page, but some may not start at page
boundary and cross pages, we do it this way as this map/unmap/remap/unmap
routine only happen few times in boot phase.

> 
> > +
> > +	if (sfi_tb_verify_checksum(table, length))
> > +		goto unmap_and_exit;
> > +
> > +	/* Initialize sfi_tblist entry */
> > +	sfi_tblist.tables[sfi_tblist.count].flags = flags;
> > +	sfi_tblist.tables[sfi_tblist.count].address = addr;
> > +	sfi_tblist.tables[sfi_tblist.count].pointer = NULL;
> > +	memcpy(&sfi_tblist.tables[sfi_tblist.count].header,
> > +		table, sizeof(struct sfi_table_header));
> 
> To be honest I'm not sure why this list exists at all.
> Is it that difficult to just rewalk the firmware supplied
> table as needed? 

Currently, there are about 10 SFI tables (more are expected), and most of
them will be parsed in driver initialization phase, like timer/cpu idle/
cpu frequency/rtc/system wake driver. Using a global list may save some
system overhead

Thanks,
Feng
> 
> 
> -andi
