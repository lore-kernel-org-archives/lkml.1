Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYKZOJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYKZOJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYKZOI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:08:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYKZOI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:08:56 -0500
Date: Wed, 26 Nov 2008 15:08:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126140835.GE6562@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* eranian@googlemail.com <eranian@googlemail.com> wrote:

> +/*
> + * unlike the other perfmon system calls, this one returns a file descriptor
> + * or a value < 0 in case of error, very much like open() or socket()
> + */
> +asmlinkage long sys_pfm_create(int flags, struct pfarg_sinfo __user *ureq)
> +{
> +	struct pfm_context *new_ctx;
> +	struct pfarg_sinfo sif;
> +	int ret;
> +
> +	PFM_DBG("flags=0x%x sif=%p", flags, ureq);
> +
> +	if (perfmon_disabled)
> +		return -ENOSYS;

uhm. So we have a dynamic 'we dont support perfmon' flag. Which is 
global and defined as:

  +int perfmon_disabled;  /* >0 if perfmon is disabled */

(sidenote: that should be __read_mostly)

then we go:

> +	if (flags) {
> +		PFM_DBG("no flags accepted yet");
> +		return -EINVAL;
> +	}

that should be if (unlikely())

then:

> +	ret = __pfm_create_context(flags, &sif, &new_ctx);

where we get:

+int __pfm_create_context(__u32 ctx_flags,
+                        struct pfarg_sinfo *sif,
+                        struct pfm_context **new_ctx)
+{
+       struct pfm_context *ctx;
+       struct file *filp = NULL;
+       int fd = 0, ret = -EINVAL;
+
+       if (!pfm_pmu_conf)
+               return -ENOSYS;
+

_ANOTHER_ global dynamic flag to tell us that ... in essence 'we dont 
support perfmon'. Which flag is again:

+struct pfm_pmu_config  *pfm_pmu_conf;

... which should be __read_mostly at minimum.

+EXPORT_SYMBOL(pfm_pmu_conf);

and _MUST_ be exported as EXPORT_SYMBOL_GPL. If exported at all. Why 
are any symbols exported here? perfmom does core kernel system calls 
and is non-modular:

+config PERFMON
+       bool "Perfmon2 performance monitoring interface"

it needs _zero_ exports.

	Ingo
