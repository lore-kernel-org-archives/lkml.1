Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZH3U3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZH3U3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZH3U3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:29:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46019 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZH3U3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=W7VFYgeup7cZRhhTh65mjPgDjNZ3O2gwvJoIGXNv1mmFg7DtbxFT5wtT9amCxzXJ1y
         3sZFuGvQe6Oq1atxMdyTOtfNcWp0DTr9fTRGLm7dFfPauQ7ZAAYQi+gWTv03Y2F4DmVo
         N2+z4OCM/tX94Fmj9sJNCXxO3uUTiIkJS230I=
Date: Sun, 30 Aug 2009 22:29:26 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
Message-ID: <20090830202926.GC22234@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
	tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
 <1251633031-2244-3-git-send-email-petkovbb@gmail.com>
 <4A9AD17A.6060507@zytor.com>
 <20090830193039.GB22234@liondog.tnic>
 <4A9ADAC3.3020004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A9ADAC3.3020004@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 01:02:11PM -0700, H. Peter Anvin wrote:
> On 08/30/2009 12:30 PM, Borislav Petkov wrote:
> > On Sun, Aug 30, 2009 at 12:22:34PM -0700, H. Peter Anvin wrote:
> >> On 08/30/2009 04:50 AM, Borislav Petkov wrote:
> >>>  			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> >>> +			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
> >>> +				val &= ~(1ULL << 32);
> >>> +				wrmsr_amd_safe(0xc001100d, (u32) val,
> >>> +							   (u32)(val >> 32));
> >>> +			}
> >>> +		}
> >> We presumably want/need wrmsrl_amd_safe() here!
> > 
> > Actually, it is wrmsr_amd_safe() because we need the magic value in
> > %edi. wrmsr_amd_safe() calls the _regs variant with the array argument.
> > And we don't have a wrmsrl_amd_safe-one which gets a 64bit msr value as
> > an argument similar to the rdmsrl one.
> > 
> 
> That's exactly the point.  We shouldn't have rdmsrl_amd_safe() on one
> hand and wrmsr_asm_safe() on the other.  I have already fixed this up in
> my tree, but this kind of asymmetry should have been a big red flashing
> light.

Ok, what do we want actually? We have rdmsr_safe and rdmsrl_safe where
the last one engineers the 2 u32s into a u64. My gut feeling would opt
for the 2 32bit values instead of one 64bit since they're naturally
returned into %eax:%edx. And in the most cases we need only one of the
values. However, the MSRs themselves are 64bit... Hmmm...

-- 
Regards/Gruss,
    Boris.
