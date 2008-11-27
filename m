Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYK0O3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYK0O3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYK0O2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:28:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:42351 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYK0O2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:28:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=F9ImJXYbnf1n5ezaiXN7u2GhlivTgyF+hmz6/hMLp5wmep3zosIn27pgZXotyKwykX
         bXxDnOC0qzSxQc5cWID2BtuF5bge15DTamUtlsWvyZPLuQe+dpHonbukd6jXgFPi0Spn
         HsY7dzjG5n/em1Tud8S0SNyGj0XE92CLCoksA=
Message-ID: <7c86c4470811270628l4ab533j24dd3b62c4380307@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:28:51 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <20081126140835.GE6562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <20081126140835.GE6562@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On Wed, Nov 26, 2008 at 3:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * eranian@googlemail.com <eranian@googlemail.com> wrote:
>
>> +/*
>> + * unlike the other perfmon system calls, this one returns a file descriptor
>> + * or a value < 0 in case of error, very much like open() or socket()
>> + */
>> +asmlinkage long sys_pfm_create(int flags, struct pfarg_sinfo __user *ureq)
>> +{
>> +     struct pfm_context *new_ctx;
>> +     struct pfarg_sinfo sif;
>> +     int ret;
>> +
>> +     PFM_DBG("flags=0x%x sif=%p", flags, ureq);
>> +
>> +     if (perfmon_disabled)
>> +             return -ENOSYS;
>
> uhm. So we have a dynamic 'we dont support perfmon' flag. Which is
> global and defined as:
>
>  +int perfmon_disabled;  /* >0 if perfmon is disabled */
>
This variable says, there is perfmon support in the kernel but
initialization of the
subsystem failed. Thus the subsystem is disabled.

> (sidenote: that should be __read_mostly)
>

>> +     ret = __pfm_create_context(flags, &sif, &new_ctx);
>
> where we get:
>
> +int __pfm_create_context(__u32 ctx_flags,
> +                        struct pfarg_sinfo *sif,
> +                        struct pfm_context **new_ctx)
> +{
> +       struct pfm_context *ctx;
> +       struct file *filp = NULL;
> +       int fd = 0, ret = -EINVAL;
> +
> +       if (!pfm_pmu_conf)
> +               return -ENOSYS;
> +
>
> _ANOTHER_ global dynamic flag to tell us that ... in essence 'we dont
> support perfmon'. Which flag is again:
>
That one says that we do not have support for that particular PMU model.
In the fully-featured version, there PMU description table is loaded
via a kernel
module. So you can be in a situation where the subsystem initialized properly
but no PMU description module is loaded or none exists for this processor.
That's what this second test is about. Note that if all PMU description tables
are compiled in, we can still get into a situation where none support the
host processor.

> +struct pfm_pmu_config  *pfm_pmu_conf;
>
> ... which should be __read_mostly at minimum.
>
> +EXPORT_SYMBOL(pfm_pmu_conf);
>
> and _MUST_ be exported as EXPORT_SYMBOL_GPL. If exported at all. Why
> are any symbols exported here? perfmom does core kernel system calls
> and is non-modular:
>
In the patchset, yes. I can drop that for now.
