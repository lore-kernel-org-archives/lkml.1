Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbZHZBPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbZHZBPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZHZBPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:15:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:38854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbZHZBPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:15:50 -0400
Message-ID: <4A948C88.9060403@kernel.org>
Date: Tue, 25 Aug 2009 18:14:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] x86: use hard_smp_processor_id to get apic id in identify_cpu
 -v2
References: <4A9391CD.5020804@kernel.org>  <4A946082.9090809@kernel.org> <1251240835.2636.28.camel@sbs-t61>
In-Reply-To: <1251240835.2636.28.camel@sbs-t61>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, 2009-08-25 at 15:06 -0700, Yinghai Lu wrote:
>> and leave phys_proc_id to use initial apic id.
> 
> No. We need to be consistent for both phys_proc_id and apicid
> computations.
> 
> i.e., if the bios changes the apic id's and those updated apic id's are
> not reflected in the initial apic id, then we need to use
> hard_smp_processor_id() for both phys_proc_id and apicid computations.

then you may get wrong phys_proc_id for amd system with apic id lifting.

> 
> On the other platforms (default option) we need to use initial apic id
> (returned by cpuid).
> 
>> -v2: update the one in detect_extended_topology too.
> 
> This is not required. On these platforms, initial_apicid will be updated
> (along with the physical apicid) if there are any bios modifications.
> 
> Instead of this patch, what we need to do is: Just like the vsmp change,
> we need to override the phys_pkg_id routine for the platforms where the
> bios will modify apic id's and where cpuid doesn't reflect the bios
> modification (for example IBM x445 system etc)

A: phys_pkg_id:
Default option:
use cpu id to get initial apic id, and then use initial apic id to get phys_pkg_id.

exception:
vsmp: need to use apic id to get phys_pkg_id, and apic id and initial apic id is not consistent. 

for AMD system with apic id lifting, initial apic id and apic is not consistent. but we should
use initial apic id to get phys_pkg_id. and that is consistent to Default option.

B: c->apicid for real apic id?
we already have c->initial_apicid, and c->apicid.
1. for amd system with apicid lifting, should use hard_smp_processor_id to get c->apicid.
2. for intel system (other than vsmp, and x445), c->apicid c->initial_apicid is the same, so could use hard_smp_processor_id
3. for vsmp, and x445, do you want to have c->apicid to have real apic id or the same as initial apic_id?

this patch is trying to make c->apicid to have real apic_id.

YH

