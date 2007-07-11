Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbXGKNoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbXGKNoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbXGKNoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:44:01 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49799 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323AbXGKNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:44:00 -0400
To: Dan Aloni <da-x@monatomic.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
In-reply-to: <20070711073216.GA11757@localdomain>
Message-Id: <20070711224304oomichi@mail.jp.nec.com>
References: <20070711073216.GA11757@localdomain>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Wed, 11 Jul 2007 22:43:04 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dan,

2007/07/11 10:32:16 +0300, Dan Aloni <da-x@monatomic.org> wrote:
>> This implementation looks interesting. No need of debug compiled
>> vmlinux for dump filtering purposes. No run time vmlinux binary modifications
>> as suggested by your previous mails. People can export kernel CONFIG info
>> like PAGESIZE etc with the help of this ELF note and any tool which is
>> processing kernel core file can benifit from this. No guesses required for
>> determining the page size of crashed kernel.
>> 
>> All the info required by dump filtering tool, put it into an ELF note, 
>> pass it to second kernel which appends it to final vmcore. The only concern
>> here again is that type of ELF note is not standard. The contents of 
>> ELF notes will keep on changing over a period of time. For example if a 
>> new memory model evolves. Now everytime this note data changes one shall
>> have to update mkdumpfile and user shall have to newer version. If there
>> are any issues, user will not come to know about the issue during kdump
>> service enablement time, instead it will be detected during dump 
>> capture time. It is too late till then.
>
>I guess that dump filtering will needed to be tested at least once 
>under various platforms for every major release of the kernel to see 
>if the information exported by the kernel through this elf note is 
>still sufficient. 
>
>Adding more info to this elf note as needed can be done through a simple 
>patch to the kernel and it can be tested along with mkdumpfile changes 
>even before a major version gets released.

As Vivek said, I think it is not a good idea that both kernel's code and
makedumpfile's code should be changed when makedumpfile needs more debug
information (ex. To extend the supported CPU architectures. To fix some
machine-specific problems, etc.).
Also it is difficult to change the list of necessary items in kernel,
because we should be careful about CPU architecture, linux version, and
memory model. makedumpfile needs the following items, and those existence
depends on CPU architecture, linux version, and memory model. If we don't
be careful about them, the kernel building may fail.
I think it is not a good idea that each items are defined by ifdef, it
is too complex.

* Symbols
  - mem_map
  - mem_section
  - pkmap_count
  - system_utsname
  - init_uts_ns
  - _stext
  - swapper_pg_dir
  - phys_base
  - node_online_map
  - node_data
  - pgdat_list
  - contig_page_data

* Structure sizes
  - page
  - mem_section
  - pglist_data
  - zone
  - free_area
  - list_head

* Field offsets
  - page.flags
  - page._count
  - page.mapping
  - page.lru
  - mem_section.section_mem_map
  - pglist_data.node_zones
  - pglist_data.nr_zones
  - pglist_data.node_mem_map
  - pglist_data.node_start_pfn
  - pglist_data.node_spanned_pages
  - pglist_data.pgdat_next
  - zone.free_pages
  - zone.free_area
  - zone.vm_stat
  - zone.spanned_pages
  - free_area.free_list
  - list_head.next
  - list_head.prev

* The numbers of array
  - mem_section
  - pgdat_list
  - node_data
  - zone.free_area


I'd like to know your motivation for this work.
I think you don't want to manage an extra file (mkdfinfo file) besides
a vmlinux file from distributor's point of view, right ?


Thanks
Ken'ichi Ohmichi
