Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYJIGKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYJIGKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYJIGK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:10:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57890 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYJIGKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:10:25 -0400
Date: Thu, 9 Oct 2008 15:10:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #10 (linux-next) 3/8] LSM adapter functions.
Message-Id: <20081009151006.377fbf9e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081009042916.295927224@nttdata.co.jp>
References: <20081009042814.398846861@nttdata.co.jp>
	<20081009042916.295927224@nttdata.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

some nitpicks.

On Thu, 09 Oct 2008 13:28:17 +0900
Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
> ---
>  security/tomoyo/tomoyo.c |  319 +++++++++++++++++++++++++++++++++++++++++++++++
>  security/tomoyo/tomoyo.h |  106 +++++++++++++++
>  2 files changed, 425 insertions(+)
> 
> --- /dev/null
> +++ linux-next/security/tomoyo/tomoyo.c
> @@ -0,0 +1,319 @@
> +/*
> + * security/tomoyo/tomoyo.c
> + *
> + * LSM hooks for TOMOYO Linux.
> + *
> + * Copyright (C) 2005-2008  NTT DATA CORPORATION
> + *
> + * Version: 2.2.0-pre   2008/10/01
> + *
> + */

What is this Version for ?
Is this exported to userland via some interface ?

> +
> +#include <linux/security.h>
> +#include "common.h"
> +#include "tomoyo.h"
> +#include "realpath.h"
> +#include <linux/audit.h>
> +#include <linux/device_cgroup.h>
> +
> +static int tmy_cred_prepare(struct cred *new, const struct cred *old, gfp_t gfp)
> +{
> +	new->security = old->security;
> +	return 0;
> +}
> +
> +static int tmy_bprm_set_creds(struct linux_binprm *bprm)
> +{
> +	if (bprm->cred_prepared)
> +		return 0;
> +	if (!sbin_init_started)
> +		tmy_load_policy(bprm->filename);
> +	bprm->cred->security = NULL;
> +	return 0;
> +}
> +
> +static int tmy_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	struct domain_info *domain = bprm->cred->security;
> +	/*
> +	 * Execute permission is checked against pathname passed to do_execve()
> +	 * using current domain.
> +	 */
> +	if (!domain) {
> +		struct domain_info *next_domain = NULL;
> +		int retval = tmy_find_next_domain(bprm, &next_domain);
> +		if (!retval)
> +			bprm->cred->security = next_domain;
> +		return retval;
> +	}
> +	/*
> +	 * Read permission is checked against interpreters using next domain.
> +	 */
> +	return tmy_check_open_permission(domain, bprm->file->f_path.dentry,
> +					 bprm->file->f_path.mnt, 1);
> +}
> +
> +static int tmy_sysctl(struct ctl_table *table, int op)
> +{
> +	int error;
> +	char *name;
> +	if ((op & 6) == 0)
> +		return 0;

It seems that you need a blanc line between variable declaration and
start of code, like this.

==
  char *name;
                                 << 
  if ((op & 6) == 0)
		return 0;
==

BTW, is this "6" need to be "6" rather than some readable macro ?

<snip>
> +static int tmy_dentry_open(struct file *f, const struct cred *cred)
> +{
> +	int flags = f->f_flags;
> +	if ((flags + 1) & O_ACCMODE)
> +		flags++;
> +	flags |= f->f_flags & (O_APPEND | O_TRUNC);
> +	/* Don't check read permission here if called from do_execve(). */
> +	if (current->in_execve)
> +		return 0;
> +	return tmy_check_open_permission(tmy_domain(), f->f_path.dentry,
> +					 f->f_path.mnt, flags);
> +}
> +

This tmy_check_open_permission() is defiend in 7/8.
Because people uses "bisect" in these days, I think it's better to avoid
this kind of reversed dependency of patch stack.


Thanks,
-Kame


