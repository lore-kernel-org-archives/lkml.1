Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYGMAz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYGMAz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 20:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYGMAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 20:55:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:58877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYGMAzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 20:55:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="16818933"
Date: Sat, 12 Jul 2008 17:55:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080713005548.GZ1678@linux-os.sc.intel.com>
References: <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 08:16:03PM -0700, Yinghai Lu wrote:
> 1. wonder if x2apic can be use with uniprocessor.

>From the theory yes.

> in APIC_init_uniprocessor, it will try to enable x2apic, but later
> 
> apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
> 
> but SET_APIC_ID is still for xapic version. so need to GET_APIC_ID,
> SET_APIC_ID for different
> genapic like 32bit.

apic_write for APIC_ID in x2apic is ignored. As it is a RO register.

> 2 check_x2apic is called in setup_arch, but it only set apic_ops,

BIOS can handover the control to OS in x2apic mode, so we need
to check very early about the mode of the APIC to use proper
accesses (mem Vs reg). BIOS can hand over in x2apic if the platform
has > 8 bit apic id's.

> and genapic still not changed, aka apic_flat...
> wonder if you need to call setup_apic_routing to set genapic.
> 
> otherwise read_apic_id could have use the one from apic_flat....need
> to shift......

for setup_apic_routing(), we really need to know the platform capbilities,
like intr-remapping etc. So we can;t do the genapic setup so early.

Ideally, read_apic_id() can be part of native apic_ops, but UV has
a different implementation.

And also, typically for boot processor, xapic id and x2apic id will be same.
xapic id needs shifting but not x2apic id.

And also, we can re-set the boot_cpu_physical_apicid, after enabling x2apic.
I was planning to look at this in the next patchset.

> 3.or move read_apic_id to apic_ops intead...together with GET_APIC_ID too.
> but 32bit version seems like to put GET_APIC_ID with genapic...

yeah, UV has a different version. so need to think more about the clean solution

thanks,
suresh

> 
> which one is better? 2 or 3
> 
> YH
