Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0BVWOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:14:16 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51217 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0BVWOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:14:14 -0500
Date: Mon, 22 Feb 2010 16:14:12 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/12] AppArmor hooks to interface with the LSM, module
 parameters and initialization.
Message-ID: <20100222221412.GA22194@us.ibm.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
 <1266572188-26529-12-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266572188-26529-12-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting john.johansen@canonical.com (john.johansen@canonical.com):
> From: John Johansen <john.johansen@canonical.com>
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---
>  security/apparmor/lsm.c | 1091 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1091 insertions(+), 0 deletions(-)
>  create mode 100644 security/apparmor/lsm.c
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> new file mode 100644
> index 0000000..8d58905
> --- /dev/null
> +++ b/security/apparmor/lsm.c
> @@ -0,0 +1,1091 @@
> +/*
> + * AppArmor security module
> + *
> + * This file contains AppArmor LSM hooks.
> + *
> + * Copyright (C) 1998-2008 Novell/SUSE
> + * Copyright 2009-2010 Canonical Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + */
> +
> +#include <linux/security.h>
> +#include <linux/moduleparam.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/mount.h>
> +#include <linux/namei.h>
> +#include <linux/ptrace.h>
> +#include <linux/ctype.h>
> +#include <linux/sysctl.h>
> +#include <linux/audit.h>
> +#include <net/sock.h>
> +
> +#include "include/apparmor.h"
> +#include "include/apparmorfs.h"
> +#include "include/audit.h"
> +#include "include/capability.h"
> +#include "include/context.h"
> +#include "include/file.h"
> +#include "include/ipc.h"
> +#include "include/net.h"
> +#include "include/path.h"
> +#include "include/policy.h"
> +#include "include/procattr.h"
> +
> +/* Flag indicating whether initialization completed */
> +int apparmor_initialized;
> +
> +/*
> + * LSM hook functions
> + */
> +
> +/*
> + * free the associated aa_task_cxt and put its profiles
> + */
> +static void apparmor_cred_free(struct cred *cred)
> +{
> +	aa_free_task_context(cred->security);
> +	cred->security = NULL;
> +}
> +
> +/*
> + * allocate the apparmor part of blank credentials
> + */
> +static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
> +{
> +	/* freed by apparmor_cred_free */
> +	struct aa_task_cxt *cxt = aa_alloc_task_context(gfp);
> +	if (cxt)
> +		return -ENOMEM;

if (!cxt)?  :)

> +
> +	cred->security = cxt;
> +	return 0;
> +}
> +
> +/*
> + * prepare new aa_task_cxt for modification by prepare_cred block
> + */
> +static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
> +				 gfp_t gfp)
> +{
> +	/* freed by apparmor_cred_free */
> +	struct aa_task_cxt *cxt = aa_alloc_task_context(gfp);
> +	if (!cxt)
> +		return -ENOMEM;
> +
> +	aa_dup_task_context(cxt, old->security);
> +	new->security = cxt;
> +	return 0;
> +}

Don't see any other problems on my first readthrough of this one, but
I'm trying walking backward through the set so will likely have to
come back to it...

thanks,
-serge
