Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYILLVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYILLVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYILLUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:20:49 -0400
Received: from ns.suse.de ([195.135.220.2]:45986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYILLUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:20:48 -0400
From: Andreas Schwab <schwab@suse.de>
To: Adam Tkac <vonsch@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com>
	<20080910143141.a3bc8258.akpm@linux-foundation.org>
	<20080911075438.GA2882@traged.atkac.englab.brq.redhat.com>
	<20080911122219.fd5fdf4c.akpm@linux-foundation.org>
	<20080912110639.GA2706@traged.atkac.englab.brq.redhat.com>
X-Yow: Now that I have my ``APPLE,'' I comprehend COST ACCOUNTING!!
Date: Fri, 12 Sep 2008 13:20:46 +0200
In-Reply-To: <20080912110639.GA2706@traged.atkac.englab.brq.redhat.com> (Adam
	Tkac's message of "Fri, 12 Sep 2008 13:06:39 +0200")
Message-ID: <jesks5wqy9.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Tkac <vonsch@gmail.com> writes:

> diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
> --- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
> +++ a/kernel/sys.c
> @@ -1532,8 +1532,14 @@ asmlinkage long sys_setrlimit(unsigned i
>  	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
>  	    !capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
> -	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
> -		return -EPERM;
> +	if (resource == RLIMIT_NOFILE) {
> +		if (new_rlim.rlim_max == RLIM_INFINITY)
> +			new_rlim.rlim_max = sysctl_nr_open;
> +		if (new_rlim.rlim_cur == RLIM_INFINITY)
> +			new_rlim.rlim_cur = sysctl_nr_open;
> +		if (new_rlim.rlim_max > sysctl_nr_open)
> +			return -EPERM;

This makes it possible to set cur > nr_open (when max = INF but nr_open
< cur < INF).  You need to check that cur <= max after adjustment.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
