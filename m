Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0BXRnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:43:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab0BXRnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:43:01 -0500
Message-ID: <4B856500.9030108@infradead.org>
Date: Wed, 24 Feb 2010 14:42:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, tglx@linutronix.de,
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
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100216210215.GA9051@elte.hu> <20100222082840.GA3975@liondog.tnic> <20100222094739.GA20844@elte.hu> <4B8271AA.9060005@redhat.com>
In-Reply-To: <4B8271AA.9060005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> The EDAC data model needs some discussion, as, currently, the memory is represented 
> per csrow, and modern MCU don't allow such level of control (and it doesn't 
> make much sense on representing this way, as you can't replace a csrow). The 
> better is to use DIMM as the minumum unit.

Just to start the data model, this is what a typical EDAC driver presents:

/sys/devices/system/edac/mc/mc0/                                                
|-- ce_count                                                                    
|-- ce_noinfo_count                                                             
|-- csrow0
|   |-- ce_count
|   |-- ch0_ce_count
|   |-- ch0_dimm_label
|   |-- ch1_ce_count
|   |-- ch1_dimm_label
|   |-- ch2_ce_count
|   |-- ch2_dimm_label
|   |-- ch3_ce_count
|   |-- ch3_dimm_label
|   |-- dev_type
|   |-- edac_mode
|   |-- mem_type
|   |-- size_mb
|   `-- ue_count
|-- csrow1                                                                      
|   |-- ce_count
|   |-- ch0_ce_count
|   |-- ch0_dimm_label
|   |-- ch1_ce_count
|   |-- ch1_dimm_label
|   |-- ch2_ce_count
|   |-- ch2_dimm_label
|   |-- ch3_ce_count
|   |-- ch3_dimm_label
|   |-- dev_type
|   |-- edac_mode
|   |-- mem_type
|   |-- size_mb
|   `-- ue_count
|-- device -> ../../../../pci0000:3f/0000:3f:03.0                               
|-- mc_name                                                                     
|-- reset_counters                                                              
|-- sdram_scrub_rate                                                            
|-- seconds_since_reset                                                         
|-- size_mb                                                                     
|-- ue_count                                                                    
`-- ue_noinfo_count                                                             

In the case of i7core_edac, there's no way to identify csrows by using
the public registers (I've no idea is is there any non-documented register
for it). So, the driver maps one dimm per "edac csrow".

It would be good to see a better struct for it.

With respect to error injection, this is the way i7core maps it:

|-- inject_addrmatch                                                            
|   |-- bank                                                                    
|   |-- channel                                                                 
|   |-- col                                                                     
|   |-- dimm                                                                    
|   |-- page                                                                    
|   `-- rank                                                                    
|-- inject_eccmask                                                              
|-- inject_enable                                                               
|-- inject_section                                                              
|-- inject_type                                                                 

The inject_addrmatch leaves control a match filter for the error
where the error will be inject. I doubt we would find a way to standardize it.

Cheers,
Mauro
