Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZFXHnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZFXHnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZFXHnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:43:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:16905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZFXHnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,281,1243839600"; 
   d="scan'208";a="527338866"
Date: Wed, 24 Jun 2009 15:40:52 +0800
From: Feng Tang <feng.tang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090624154052.1301144f@feng-desktop>
In-Reply-To: <20090624071220.GJ6760@one.firstfloor.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
	<87iqin166f.fsf@basil.nowhere.org>
	<20090624113440.2774d13d@feng-desktop>
	<20090624071220.GJ6760@one.firstfloor.org>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 15:12:20 +0800
Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Jun 24, 2009 at 11:34:40AM +0800, Feng Tang wrote:
> > 
> > > > +static void __iomem *sfi_map_memory(u32 phys, u32 size)
> > > > +{
> > > > +	if (!phys || !size)
> > > > +		return NULL;
> > > > +
> > > > +	if (sfi_tbl_permanant_mapped)
> > > > +		return ioremap((unsigned long)phys, size);
> > > > +	else
> > > > +		return arch_early_ioremap((unsigned long)phys,
> > > > size); +}
> > > 
> > > imho it would be cleaner if the callers just called these
> > > functions directly. Are the !phys !size checks really needed?
> > 
> > Andi,
> > 
> > Thanks for many good comments, will address them.
> > 
> > For this question, this sfi_map_memory() may get called before and
> > after the ioremap() is ready, so we add a permanent flag to judge
> > the
> 
> Yes, but the callers should know this and they can call the right 
> function. I suspect only very few callers will need the early
> variant.
> 
There is one sfi_table_parse() API, which is a SFI core function, it is exported
out and used in both boot phase (parsing cpu/ioapic) and later driver phase
(parsing idle/freq ...), when it get called, it doesn't know in which phase it get
called, and need such a flag to judge.


> > environment and chose the right API automatically. e.g. after
> > system is booted, cpu freq driver will implicitly call this API to
> > get freq info 
> 
> cpufreq driver shouldn't be initialized before ioremap

Right, it called the sfi_table_parse() after ioremap is ready.

> 
> > > 
> > > Since the mappings are always 4K you would only need to remap
> > > if the size is > PAGE_SIZE
> > 
> > yes, some of the table may be in one page, but some may not start
> > at page boundary and cross pages, we do it this way as this
> > map/unmap/remap/unmap routine only happen few times in boot phase.
> 
> The TLB flushes tend to be a few thousand cycles at least.
> 
> It's not much, but with all the recent focus on faster boot times it's
> still better to not write unnecessarily inefficient initialization
> code.

good point, will take care of it

> 
> > 
> > > 
> > > > +
> > > > +	if (sfi_tb_verify_checksum(table, length))
> > > > +		goto unmap_and_exit;
> > > > +
> > > > +	/* Initialize sfi_tblist entry */
> > > > +	sfi_tblist.tables[sfi_tblist.count].flags = flags;
> > > > +	sfi_tblist.tables[sfi_tblist.count].address = addr;
> > > > +	sfi_tblist.tables[sfi_tblist.count].pointer = NULL;
> > > > +	memcpy(&sfi_tblist.tables[sfi_tblist.count].header,
> > > > +		table, sizeof(struct sfi_table_header));
> > > 
> > > To be honest I'm not sure why this list exists at all.
> > > Is it that difficult to just rewalk the firmware supplied
> > > table as needed? 
> > 
> > Currently, there are about 10 SFI tables (more are expected), and
> > most of them will be parsed in driver initialization phase, like
> > timer/cpu idle/ cpu frequency/rtc/system wake driver. Using a
> > global list may save some system overhead
> 
> Walking the tables as they are laid out in memory should be quite
> equivalent to walking a list, shouldn't it?
> 
> It would be only a relatively small simplification agreed, but if
> you're claiming to do a "Simple Firmware Interface" imho you should
> try to make it as simple possible, and that includes not setting up
> redundant data structures.

understand your concern, but to walk a list we still need have some global
parameter like SYST address, and do the map/unmap and checksum work.

another reason for the global sfi_table_desc[] is, we only do some time ioremap
for each table and save the mapped address for future use. this idea is
borrowed from ACPI table handling.

Thanks,
Feng

> 
> -Andi
