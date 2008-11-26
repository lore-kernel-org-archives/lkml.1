Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYKZNp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYKZNp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYKZNnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:43:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbYKZNnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:43:24 -0500
Date: Wed, 26 Nov 2008 14:43:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126134302.GB6562@elte.hu>
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
> +
> +	if (flags) {
> +		PFM_DBG("no flags accepted yet");
> +		return -EINVAL;
> +	}
> +	ret = __pfm_create_context(flags, &sif, &new_ctx);
> +
> +	/*
> +	 * copy sif to user level argument, if requested
> +	 */
> +	if (ureq && copy_to_user(ureq, &sif, sizeof(sif))) {
> +		pfm_undo_create(ret, new_ctx);
> +		ret  = -EFAULT;
> +	}
> +	return ret;
> +}

the error control flow of fd creation is sloppy here and has an 
kernel-data information leak: if __pfm_create_context() fails:

 - due to memory pressure
 - or due to lack of CPU support
 - or due to lack of permissions
 - or due to a busy PMU

then &sif is not initialized, and sys_pfm_create() copies it to 
user-space. This way attackers can probe portions of the kernel stack.

Worse than that, there's also a DoS hole here: in the same scenario 
above (easily created by attackers), new_ctx is not initialized either 
- and if a ureq is provided by (unprivileged) userspace with a 
faulting address (say ureq == (void *)1), then sys_pfm_create() will 
call pfm_undo_create() => kaboom.

It's even a root hole, because attacker can likely prime the kernel 
stack with arbitrary values via prior syscalls and hence controls 
new_ctx's value, and the freeing logic happily uses it => local root 
hole.

Is this stuff in any distro kernel?

	Ingo
