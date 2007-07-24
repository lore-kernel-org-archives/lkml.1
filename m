Return-Path: <linux-kernel-owner+w=401wt.eu-S935616AbXGXKkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616AbXGXKkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 06:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXGXKjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 06:39:52 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3212 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXGXKjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 06:39:51 -0400
Date: Tue, 24 Jul 2007 06:38:48 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH]: allow individual core dump methods to be unlimited when sending to a pipe
Message-ID: <20070724103847.GA23976@hmsreliant.homelinux.net>
References: <20070722153947.GA11941@hmsreliant.homelinux.net> <20070724020939.7644f18c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724020939.7644f18c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:09:39AM -0700, Andrew Morton wrote:
> On Sun, 22 Jul 2007 11:39:47 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > 	This is a follow on to the patch entitled:
> > update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
> > It allows individual core dump methods to have the core dump size limit passed
> > into them.  Its more efficient than each method having to retrieve it on their
> > own, and it allows for do_coredump to specify a infinite limit in the event that
> > a pipe is configured in /proc/sys/kernel/core_pattern, in which case ulimit -c
> > should not apply.
> 
> Needed this warning fix:
> 
> fs/exec.c: In function 'do_coredump':
> fs/exec.c:1761: warning: large integer implicitly truncated to unsigned type
> 
> diff -puN fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix fs/exec.c
> --- a/fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix
> +++ a/fs/exec.c
> @@ -1703,7 +1703,7 @@ int do_coredump(long signr, int exit_cod
>  	int fsuid = current->fsuid;
>  	int flag = 0;
>  	int ispipe = 0;
> -	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
> +	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
>  
>  	audit_core_dumps(signr);
>  
> _
> 
> which makes me worry about how much care was taken here on 32/64 issues,
> and crsos-arch issues (the underlying type for compat_ulong_t, for one).
> 
> Could you please go over it with a toothcomb, see if there are any other
> slipups there?
> 
Yes, I had noticed this yesterday aternoon as well, Andrew. Sorry about that.
Upon looking at it using unsigned long should be the superset of all the
definitions, so I'm working on a patch to align that, and am testing it on all
the arches I have available here (x86, x86_64, ia64, and perhaps ppc64 if I can
get hold of it).  I also have a few more bugs that need fixing in the
core_pattern/pipe code as well as one more feature enhancement (the ability to
pass an argv array).  I'll fix up the bugs first, and you can expect these
patches in the next day or two.

Thanks & Regards
Neil
> 
> Thanks.

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
