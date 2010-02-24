Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0BXU2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:28:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0BXU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:28:36 -0500
Date: Wed, 24 Feb 2010 21:28:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <petkovbb@googlemail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100224202827.GA25414@basil.fritz.box>
References: <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100216210215.GA9051@elte.hu> <20100222082840.GA3975@liondog.tnic> <20100222094739.GA20844@elte.hu> <4B8271AA.9060005@redhat.com> <4B856500.9030108@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B856500.9030108@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 02:42:24PM -0300, Mauro Carvalho Chehab wrote:
> Mauro Carvalho Chehab wrote:
> > The EDAC data model needs some discussion, as, currently, the memory is represented 
> > per csrow, and modern MCU don't allow such level of control (and it doesn't 
> > make much sense on representing this way, as you can't replace a csrow). The 
> > better is to use DIMM as the minumum unit.
> 
> Just to start the data model, this is what a typical EDAC driver presents:

First I suspect the result wouldn't be too compatible with current EDAC,
so it might be less confusing to give it a new name.

> 
> /sys/devices/system/edac/mc/mc0/                                                
> |-- ce_count                                                                    
> |-- ce_noinfo_count                                                             
> |-- csrow0
> |   |-- ce_count
> |   |-- ch0_ce_count
> |   |-- ch0_dimm_label
> |   |-- ch1_ce_count
> |   |-- ch1_dimm_label
> |   |-- ch2_ce_count
> |   |-- ch2_dimm_label
> |   |-- ch3_ce_count
> |   |-- ch3_dimm_label
> |   |-- dev_type
> |   |-- edac_mode
> |   |-- mem_type
> |   |-- size_mb
> |   `-- ue_count
> |-- csrow1                                                                      
> |   |-- ce_count
> |   |-- ch0_ce_count
> |   |-- ch0_dimm_label
> |   |-- ch1_ce_count
> |   |-- ch1_dimm_label
> |   |-- ch2_ce_count
> |   |-- ch2_dimm_label
> |   |-- ch3_ce_count
> |   |-- ch3_dimm_label
> |   |-- dev_type
> |   |-- edac_mode
> |   |-- mem_type
> |   |-- size_mb
> |   `-- ue_count
> |-- device -> ../../../../pci0000:3f/0000:3f:03.0                               
> |-- mc_name                                                                     
> |-- reset_counters                                                              
> |-- sdram_scrub_rate                                                            
> |-- seconds_since_reset                                                         
> |-- size_mb                                                                     
> |-- ue_count                                                                    
> `-- ue_noinfo_count                                                             
> 
> In the case of i7core_edac, there's no way to identify csrows by using
> the public registers (I've no idea is is there any non-documented register
> for it). So, the driver maps one dimm per "edac csrow".

Some thoughts on this:

One of my goals would be that a fall back driver can create the information
just from the SMBIOS (that is without error counts, although there
are some cases those can be mapped from corrected MCEs)

I think I would prefer a flat model:

socket <-> DIMM 

socket could be arbitary, either a CPU socket, or a external memory controller

and then have a "path" string per DIMM that can be a arbitrary path to the DIMM,
depending on the system: e.g. on a system with on board buffers it could
include the buffer, the channel to the buffer and the channel behind
the buffer. The string could be free form like a path name e.g. 

FOO-CH1/DDR-CH2/DIMMa

I think it doesn't make sense to have that in the file system hierarchy
itself (that would just make it harder to parse without any real 
benefit, since hardware changes could completely change the directory
structure), I would just keep it as an attribute file in the leaf nodes.

I don't think we it makes much sense to have anything below the DIMM (e.g. ranks)
These are typically hard to get in a generic way and the most important
information on this level is what units to replace.

Then the other important part is a good way to manage fall back counters 
when you cannot identify the target DIMM (that happens occasionally for various
reasons).

In this case would need a "aggregator object" with a truncated path
that still maintains the same counts.

Then of course there still needs to be a event interface to let someone
actually do something with all these counts without having to poll.

Most interesting cases always need user space support, so also of course
user space needs raw events too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
