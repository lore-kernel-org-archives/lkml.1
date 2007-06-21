Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXFUOBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXFUOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXFUOA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:00:58 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:53224 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbXFUOA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:00:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 21 Jun 2007 16:00:24 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070621140024.GW24544@erda.amd.com>
References: <20070620182126.248753000@amd.com>
 <20070620184113.GC5874@erda.amd.com>
 <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jun 2007 14:00:24.0866 (UTC)
 FILETIME=[83E33020:01C7B40C]
X-WSS-ID: 6A645B061S41035448-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.07 12:49:05, David Rientjes wrote:
> On Wed, 20 Jun 2007, Robert Richter wrote:
> 
> > Debug messages added for better debugging.
> > 
> 
> And you added BUG_ON()'s.
> 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > 
> > Index: linux-2.6.22-rc3/perfmon/perfmon_file.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/perfmon/perfmon_file.c
> > +++ linux-2.6.22-rc3/perfmon/perfmon_file.c
> > @@ -192,6 +192,8 @@ static int pfm_mmap(struct file *file, s
> >  	unsigned long flags;
> >  	int ret;
> >  
> > +	PFM_DBG("pfm_file_ops");
> 
> After commenting on your first set of patches, I've been using it a little 
> more.  In my use, these debugging messages weren't very helpful because 
> "pfm_file_ops" can indicate pfm_mmap, pfm_read, pfm_poll, etc.  Could 
> these be changed to be more specific based on the function they're in?
> 
> > Index: linux-2.6.22-rc3/perfmon/perfmon_syscalls.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/perfmon/perfmon_syscalls.c
> > +++ linux-2.6.22-rc3/perfmon/perfmon_syscalls.c
> > @@ -403,6 +403,8 @@ asmlinkage long sys_pfm_create_context(s
> >  	void *fmt_arg = NULL;
> >  	int ret;
> >  
> > +	PFM_DBG("syscall");
> 
> Likewise.  Using "syscall" for all debugging messages in the syscall 
> handlers isn't very informative.  Could this be PFM_DBG(__FUNCTION__) 
> instead?
> 
> > +
> >  	if (atomic_read(&perfmon_disabled))
> >  		return -ENOSYS;
> >  
> > @@ -433,8 +435,12 @@ asmlinkage long sys_pfm_write_pmcs(int f
> >  	size_t sz;
> >  	int ret, fput_needed;
> >  
> > -	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
> > +	PFM_DBG("syscall");
> > +
> > +	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq)) {
> > +                PFM_DBG("invalid arg count %d", count);
> 
> This is whitespace damaged.

Fixed in patch version 3.

> 
> >  		return -EINVAL;
> > +	}
> >  
> >  	sz = count*sizeof(*ureq);
> >  
> > @@ -475,6 +481,8 @@ asmlinkage long sys_pfm_write_pmcs(int f
> >  		kfree(fptr);
> >  error:
> >  	fput_light(filp, fput_needed);
> > +	if (ret)
> > +		PFM_DBG("failed: errno=%d", -ret);
> 
> What failed?  More information would be helpful since this is, after all, 
> a diagnostic message.

Removed in version 3.

> 
> > Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
> > +++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
> > @@ -140,6 +140,10 @@ static inline void pfm_arch_write_pmc(st
> >  	if (ctx && ctx->flags.started == 0)
> >  		return;
> >  
> > +	PFM_DBG_ovfl("pfm_arch_write_pmc(0x%016Lx, 0x%016Lx)",
> > +		     (unsigned long long) pfm_pmu_conf->pmc_desc[cnum].hw_addr,
> > +		     (unsigned long long) value);
> 
> Casting here should be unnecessary.  Changing %L would be advisible to 
> display the data as it is stored in the object.

Not casting here would lead to warnings if compiling a 32 bit kernel.

> 
> > +	BUG_ON(pfm_pmu_conf->pmc_desc[cnum].type & PFM_REG_V);
> >  	if (arch_info->pmu_style == PFM_X86_PMU_P4)
> >  		__pfm_write_reg_p4(&arch_info->pmc_addrs[cnum], value);
> >  	else
> > @@ -155,6 +159,10 @@ static inline void pfm_arch_write_pmd(st
> >  	if (pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_C64)
> >  		value |= ~pfm_pmu_conf->ovfl_mask;
> >  
> > +	PFM_DBG_ovfl("pfm_arch_write_pmd(0x%016Lx, 0x%016Lx)",
> > +		     (unsigned long long) pfm_pmu_conf->pmd_desc[cnum].hw_addr,
> > +		     (unsigned long long) value);
> > +	BUG_ON(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V);
> >  	if (arch_info->pmu_style == PFM_X86_PMU_P4)
> >  		__pfm_write_reg_p4(&arch_info->pmd_addrs[cnum], value);
> >  	else
> > @@ -165,10 +173,14 @@ static inline u64 pfm_arch_read_pmd(stru
> >  {
> >  	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
> >  	u64 tmp;
> > +	BUG_ON(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V);
> >  	if (arch_info->pmu_style == PFM_X86_PMU_P4)
> >  		__pfm_read_reg_p4(&arch_info->pmd_addrs[cnum], &tmp);
> >  	else
> >  		rdmsrl(pfm_pmu_conf->pmd_desc[cnum].hw_addr, tmp);
> > +	PFM_DBG_ovfl("pfm_arch_read_pmd(0x%016Lx) = 0x%016Lx",
> > +		     (unsigned long long) pfm_pmu_conf->pmd_desc[cnum].hw_addr,
> > +		     (unsigned long long) tmp);
> >  	return tmp;
> >  }
> >  
> > @@ -176,10 +188,14 @@ static inline u64 pfm_arch_read_pmc(stru
> >  {
> >  	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
> >  	u64 tmp;
> > +	BUG_ON(pfm_pmu_conf->pmc_desc[cnum].type & PFM_REG_V);
> >  	if (arch_info->pmu_style == PFM_X86_PMU_P4)
> >  		__pfm_read_reg_p4(&arch_info->pmc_addrs[cnum], &tmp);
> >  	else
> >  		rdmsrl(pfm_pmu_conf->pmc_desc[cnum].hw_addr, tmp);
> > +        PFM_DBG_ovfl("pfm_arch_read_pmc(0x%016Lx) = 0x%016Lx",
> > +		     (unsigned long long) pfm_pmu_conf->pmc_desc[cnum].hw_addr,
> > +		     (unsigned long long) tmp);
> 
> More whitespace damage.

Fixed in patch version 3.

> 
> 

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



