Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYCEQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYCEQMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYCEQMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:12:33 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:59617 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753992AbYCEQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:12:32 -0500
Message-ID: <47CEC614.7060705@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 21:41:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain> <20080225115550.23920.43199.sendpatchset@localhost.localdomain> <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com> <47C2F86A.9010709@linux.vnet.ibm.com> <6599ad830802250932s5eaa3bcchbfc49fe0e76d3f7d@mail.gmail.com> <47C2FCC1.7090203@linux.vnet.ibm.com> <47C30EDC.4060005@google.com>
In-Reply-To: <47C30EDC.4060005@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>>> I'll send out a prototype for comment.
> 
> Something like the patch below. The effects of cgroup_disable=foo are:
> 
> - foo doesn't show up in /proc/cgroups
> - foo isn't auto-mounted if you mount all cgroups in a single hierarchy
> - foo isn't visible as an individually mountable subsystem
> 
> As a result there will only ever be one call to foo->create(), at init
> time; all processes will stay in this group, and the group will never be
> mounted on a visible hierarchy. Any additional effects (e.g. not
> allocating metadata) are up to the foo subsystem.
> 
> This doesn't handle early_init subsystems (their "disabled" bit isn't
> set be, but it could easily be extended to do so if any of the
> early_init systems wanted it - I think it would just involve some
> nastier parameter processing since it would occur before the
> command-line argument parser had been run.
> 
> include/linux/cgroup.h |    1 +
> kernel/cgroup.c        |   29 +++++++++++++++++++++++++++--
> 2 files changed, 28 insertions(+), 2 deletions(-)
> 
> Index: cgroup_disable-2.6.25-rc2-mm1/include/linux/cgroup.h
> ===================================================================
> --- cgroup_disable-2.6.25-rc2-mm1.orig/include/linux/cgroup.h
> +++ cgroup_disable-2.6.25-rc2-mm1/include/linux/cgroup.h
> @@ -256,6 +256,7 @@ struct cgroup_subsys {
>     void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
>     int subsys_id;
>     int active;
> +    int disabled;
>     int early_init;
> #define MAX_CGROUP_TYPE_NAMELEN 32
>     const char *name;
> Index: cgroup_disable-2.6.25-rc2-mm1/kernel/cgroup.c
> ===================================================================
> --- cgroup_disable-2.6.25-rc2-mm1.orig/kernel/cgroup.c
> +++ cgroup_disable-2.6.25-rc2-mm1/kernel/cgroup.c
> @@ -790,7 +790,14 @@ static int parse_cgroupfs_options(char *
>         if (!*token)
>             return -EINVAL;
>         if (!strcmp(token, "all")) {
> -            opts->subsys_bits = (1 << CGROUP_SUBSYS_COUNT) - 1;
> +            /* Add all non-disabled subsystems */
> +            int i;
> +            opts->subsys_bits = 0;
> +            for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +                struct cgroup_subsys *ss = subsys[i];
> +                if (!ss->disabled)
> +                    opts->subsys_bits |= 1ul << i;
> +            }
>         } else if (!strcmp(token, "noprefix")) {
>             set_bit(ROOT_NOPREFIX, &opts->flags);
>         } else if (!strncmp(token, "release_agent=", 14)) {
> @@ -808,7 +815,8 @@ static int parse_cgroupfs_options(char *
>             for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>                 ss = subsys[i];
>                 if (!strcmp(token, ss->name)) {
> -                    set_bit(i, &opts->subsys_bits);
> +                    if (!ss->disabled)
> +                        set_bit(i, &opts->subsys_bits);
>                     break;
>                 }
>             }
> @@ -2596,6 +2606,8 @@ static int proc_cgroupstats_show(struct
>     mutex_lock(&cgroup_mutex);
>     for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>         struct cgroup_subsys *ss = subsys[i];
> +        if (ss->disabled)
> +            continue;
>         seq_printf(m, "%s\t%lu\t%d\n",
>                ss->name, ss->root->subsys_bits,
>                ss->root->number_of_cgroups);
> @@ -2991,3 +3003,16 @@ static void cgroup_release_agent(struct
>     spin_unlock(&release_list_lock);
>     mutex_unlock(&cgroup_mutex);
> }
> +
> +static int __init cgroup_disable(char *str)
> +{
> +    int i;
> +    for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +        struct cgroup_subsys *ss = subsys[i];
> +        if (!strcmp(str, ss->name)) {
> +            ss->disabled = 1;
> +            break;
> +        }
> +    }
> +}
> +__setup("cgroup_disable=", cgroup_disable);
> 

Hi, Paul,

I am going to go ahead and test this patch. If they work fine, I'll request you
to send them out, so that we can get them in by 2.6.25.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
