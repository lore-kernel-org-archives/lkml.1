Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZHZRuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZHZRuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZHZRuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:50:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:30873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZHZRui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,280,1249282800"; 
   d="scan'208";a="442971782"
Subject: Re: [PATCH] x86: use hard_smp_processor_id to get apic id in
 identify_cpu -v2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
In-Reply-To: <4A948C88.9060403@kernel.org>
References: <4A9391CD.5020804@kernel.org>  <4A946082.9090809@kernel.org>
	 <1251240835.2636.28.camel@sbs-t61>  <4A948C88.9060403@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 26 Aug 2009 10:49:48 -0700
Message-Id: <1251308988.2787.39.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 18:14 -0700, Yinghai Lu wrote:
> Suresh Siddha wrote:
> > On Tue, 2009-08-25 at 15:06 -0700, Yinghai Lu wrote:
> >> and leave phys_proc_id to use initial apic id.
> > 
> > No. We need to be consistent for both phys_proc_id and apicid
> > computations.
> > 
> > i.e., if the bios changes the apic id's and those updated apic id's are
> > not reflected in the initial apic id, then we need to use
> > hard_smp_processor_id() for both phys_proc_id and apicid computations.
> 
> then you may get wrong phys_proc_id for amd system with apic id lifting.

Then we should add an exception for AMD systems too. And not change
generic code.

> A: phys_pkg_id:
> Default option:
> use cpu id to get initial apic id, and then use initial apic id to get phys_pkg_id.
> 
> exception:
> vsmp: need to use apic id to get phys_pkg_id, and apic id and initial apic id is not consistent. 
> 
> for AMD system with apic id lifting, initial apic id and apic is not consistent. but we should
> use initial apic id to get phys_pkg_id. and that is consistent to Default option.
> 
> B: c->apicid for real apic id?
> we already have c->initial_apicid, and c->apicid.
> 1. for amd system with apicid lifting, should use hard_smp_processor_id to get c->apicid.
> 2. for intel system (other than vsmp, and x445), c->apicid c->initial_apicid is the same, so could use hard_smp_processor_id

On the platforms which don't support cpuid leaf 0xb, apicid and initial
apicid might be potentially different if the bios changes the apicid.
And we don't want to depend on the bios to get the things correct. So
where it is not needed, we don't want to depend on the
hard_smp_processor_id() for topology detection.

In short, on all the platforms we want to use initial apic id for apicid
and phys_proc_id. And only on the required platforms like x445, vsmp,
some AMD platforms, we can have their own mechanisms.

> 3. for vsmp, and x445, do you want to have c->apicid to have real apic id or the same as initial apic_id?

On these platforms, c->apicid should be based on their real apic id.

> 
> this patch is trying to make c->apicid to have real apic_id.

Can you please modify the patch so that we can have exceptions for
needed platforms only?

thanks,
suresh

