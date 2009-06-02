Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZFBJKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZFBJKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZFBJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:10:04 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51933 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZFBJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:10:01 -0400
Date: Tue, 2 Jun 2009 14:39:44 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       lkml <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: +
	cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.
	patch added to -mm tree
Message-ID: <20090602090944.GB16753@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200906020602.n5262wcu008560@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020602.n5262wcu008560@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 11:02:58PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      cgroups: forbid noprefix if mounting more than just cpuset subsystem
> has been added to the -mm tree.  Its filename is
>      cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: cgroups: forbid noprefix if mounting more than just cpuset subsystem
> From: Li Zefan <lizf@cn.fujitsu.com>
> 
> The 'noprefix' option was introduced for backwards-compatibility of
> cpuset, but actually it can be used when mounting other subsystems.
> 
> This results in possibility of name collision, and now the collision can
> really happen, because we have 'stat' file in both memory and cpuacct
> subsystem:
> 
> 	# mount -t cgroup -o noprefix,memory,cpuacct xxx /mnt
> 
> Cgroup will happily mount the 2 subsystems, but only 'stat' file of memory
> subsys can be seen.
> 
> We don't want users to use nopreifx, and also want to avoid name
> collision, so we change to allow noprefix only if mounting just the cpuset
> subsystem.
> 

I am not sure if this is a good idea. For libcgroup, we would then be
adding a special case for just cpuset. I would rather that we allow it
either for all the subsystems or none of them.

thanks,
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Paul Menage <menage@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/cgroup.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff -puN kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem kernel/cgroup.c
> --- a/kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem
> +++ a/kernel/cgroup.c
> @@ -842,6 +842,11 @@ static int parse_cgroupfs_options(char *
>  				     struct cgroup_sb_opts *opts)
>  {
>  	char *token, *o = data ?: "all";
> +	unsigned long mask = (unsigned long)-1;
> +
> +#ifdef CONFIG_CPUSETS
> +	mask = ~(1 << cpuset_subsys_id);
> +#endif
> 
>  	opts->subsys_bits = 0;
>  	opts->flags = 0;
> @@ -886,6 +891,11 @@ static int parse_cgroupfs_options(char *
>  		}
>  	}
> 
> +	/* We allow noprefix only if mounting just the cpuset subsystem */
> +	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
> +	    (opts->subsys_bits & mask))
> +		return -EINVAL;
> +
>  	/* We can't have an empty hierarchy */
>  	if (!opts->subsys_bits)
>  		return -EINVAL;
> _
> 
> Patches currently in -mm which might be from lizf@cn.fujitsu.com are
> 
> origin.patch
> linux-next.patch
> mm-add-swap-cache-interface-for-swap-reference.patch
> mm-modify-swap_map-and-add-swap_has_cache-flag.patch
> mm-reuse-unused-swap-entry-if-necessary.patch
> hexdump-remove-the-trailing-space.patch
> cgroups-make-messages-more-readable.patch
> cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
> devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
> memcg-remove-some-redundant-checks.patch
> memcg-remove-unneeded-forward-declaration-from-schedh.patch
> memcg-fix-swap-accounting.patch

-- 
regards,
Dhaval
