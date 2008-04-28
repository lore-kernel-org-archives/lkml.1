Return-Path: <linux-kernel-owner+w=401wt.eu-S936053AbYD1Tz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936053AbYD1Tz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbYD1TzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:55:17 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:41892 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763459AbYD1TzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RiGOQ0ZjfHz+A3n1eeDDaF0cbdwAhK8xyB3Luttc4fdCi9en38tyUTiMBbcpXjMyc+Xhz//50EpYLq3ys9ibXnvHZXQF/X3IEimwbXPNAEeeytip8wWB2fVyK4zSF0C1qci9byG+1DcLRy2ESgZz6Tzw9cY7Wqdo1hwghsEHP3E=
Message-ID: <86802c440804281255n3926fe53r4015ff03c355d2d9@mail.gmail.com>
Date: Mon, 28 Apr 2008 12:55:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch] mm: node-setup agnostic free_bootmem()
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <86802c440804281211y3e512286k1d3f9f7e157b4957@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426185516.GA32364@elte.hu>
	 <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	 <20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
	 <20080427234630.GC14338@elte.hu> <877iein859.fsf@saeurebad.de>
	 <20080428004046.GA16155@elte.hu>
	 <86802c440804271848o5498eb9eu944f995cb9b8fc9a@mail.gmail.com>
	 <87od7t6hsx.fsf@saeurebad.de>
	 <86802c440804281211y3e512286k1d3f9f7e157b4957@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 12:11 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Mon, Apr 28, 2008 at 9:54 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>  > Hi Yinghai,
>  >
>  >
>  >
>  >  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>  >
>  >  > On Sun, Apr 27, 2008 at 5:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  >  >>
>  >  >>  * Johannes Weiner <hannes@saeurebad.de> wrote:
>  >  >>
>  >  >>  > > so i very much agree that your changes are cleaner, i just wanted to
>  >  >>  > > have one that has all the fixes included.
>  >  >>  >
>  >  >>  > I had planned this to be another patch because there are more then one
>  >  >>  > boundary check I wanted to tighten.  I can merge them though if you
>  >  >>  > like.
>  >  >>
>  >  >>  no, better to have them in separate patches.
>  >  >>
>  >  >>  > > Would you like to post a patch against current -git or should i
>  >  >>  > > extract the cleaner reserve_bootmem() from your previous patch?
>  >  >>  >
>  >  >>  > I just moved and have only sporadic internet access and free time
>  >  >>  > slots available.  Would be nice if you could do it!
>  >  >>
>  >  >>  sure, find the merged patch below, against latest -git, boot-tested on
>  >  >>  x86. Is this what you had in mind?
>  >  >>
>  >  >>         Ingo
>  >  >>
>  >  >>  ---------------->
>  >  >>  Subject: mm: node-setup agnostic free_bootmem()
>  >  >>  From: Johannes Weiner <hannes@saeurebad.de>
>  >  >>  Date: Wed, 16 Apr 2008 13:36:31 +0200
>  >  >>
>  >  >>  Make free_bootmem() look up the node holding the specified address
>  >  >>  range which lets it work transparently on single-node and multi-node
>  >  >>  configurations.
>  >  >>
>  >  >>  If the address range exceeds the node range, it well be marked free
>  >  >>  across node boundaries, too.
>  >  >>
>  >  >>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  >  >>  CC: Andi Kleen <andi@firstfloor.org>
>  >  >>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>  >  >>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>  >  >>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  >  >>  CC: Christoph Lameter <clameter@sgi.com>
>  >  >>  CC: Andrew Morton <akpm@linux-foundation.org>
>  >  >>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  >  >>  ---
>  >  >>   mm/bootmem.c |   27 +++++++++++++++++++++++++--
>  >  >>   1 file changed, 25 insertions(+), 2 deletions(-)
>  >  >>
>  >  >>  Index: linux-x86.q/mm/bootmem.c
>  >  >>  ===================================================================
>  >  >>  --- linux-x86.q.orig/mm/bootmem.c
>  >  >>  +++ linux-x86.q/mm/bootmem.c
>  >  >>  @@ -493,8 +493,31 @@ int __init reserve_bootmem(unsigned long
>  >  >>   void __init free_bootmem(unsigned long addr, unsigned long size)
>  >  >>   {
>  >  >>         bootmem_data_t *bdata;
>  >  >>  -       list_for_each_entry(bdata, &bdata_list, list)
>  >  >>  -               free_bootmem_core(bdata, addr, size);
>  >  >>  +       unsigned long pos = addr;
>  >  >>  +       unsigned long partsize = size;
>  >  >>  +
>  >  >>  +       list_for_each_entry(bdata, &bdata_list, list) {
>  >  >>  +               unsigned long remainder = 0;
>  >  >>  +
>  >  >>  +               if (pos < bdata->node_boot_start)
>  >  >>  +                       continue;
>  >  >>  +
>  >  >>  +               if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
>  >  >>  +                       remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
>  >  >>  +                       partsize -= remainder;
>  >  >>  +               }
>  >  >>  +
>  >  >>  +               free_bootmem_core(bdata, pos, partsize);
>  >  >>  +
>  >  >>  +               if (!remainder)
>  >  >>  +                       return;
>  >  >>  +
>  >  >>  +               pos = PFN_PHYS(bdata->node_low_pfn + 1);
>  >  >>  +       }
>  >  >>  +       printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
>  >  >>  +                       "state: pos=%lx, partsize=%lx\n", addr, size,
>  >  >>  +                       pos, partsize);
>  >  >>  +       BUG();
>  >  >>   }
>  >  >>
>  >  >>   unsigned long __init free_all_bootmem(void)
>  >  >>
>  >  >
>  >  > it will not work with cross nodes.
>  >  >
>  >  > for example: node 0: 0-2g, 4-6g, node1: 2-4g, 6-8g.
>  >  > and if ramdisk sit cross 2G boundary. you will only free the range
>  >  > before 2g.
>  >
>  >  Yes, you stated that several times but this is not a technical argument:
>  >  These setups are afaik not yet supported by the kernel at all.  And you
>  >  could not explain the node layout with the patch that implements support
>  >  for these configurations.
>
>  I looked at Suresh's patch, and it still only has one bdata for one node.

Suresh's patch already in the Linus tree.
commit 6ec6e0d9f2fd7cb6ca6bc3bfab5ae7b5cdd8c36f
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Mar 25 10:14:35 2008 -0700

    srat, x86: add support for nodes spanning other nodes

    For example, If the physical address layout on a two node system with 8 GB
    memory is something like:
    node 0: 0-2GB, 4-6GB
    node 1: 2-4GB, 6-8GB

    Current kernels fail to boot/detect this NUMA topology.

    ACPI SRAT tables can expose such a topology which needs to be supported.

    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


YH
