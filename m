Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108Ab0AZOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0AZOu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327Ab0AZOu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:50:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38884 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0AZOu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:50:28 -0500
Date: Tue, 26 Jan 2010 08:50:22 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroups: Fix to return errno in a failure path
Message-ID: <20100126145022.GA6224@us.ibm.com>
References: <4B5EA4EC.8020700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5EA4EC.8020700@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> In cgroup_create(), if alloc_css_id() returns failure, the errno
> is not propagated to userspace, so mkdir will fail silently.
> 
> To trigger this bug, we mount blkio (or memory subsystem), and
> create more then 65534 cgroups. (The number of cgroups is limited
> to 65535 if a subsystem has use_id == 1)
> 
>  # mount -t cgroup -o blkio xxx /mnt
>  # for ((i = 0; i < 65534; i++)); do mkdir /mnt/$i; done
>  # mkdir /mnt/65534
>  (should return ENOSPC)
>  #
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Yup.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  cgroup.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/kernel/cgroup.c.orig	2010-01-19 16:37:37.000000000 +0800
> +++ a/kernel/cgroup.c	2010-01-19 16:39:07.000000000 +0800
> @@ -3279,14 +3279,17 @@ static long cgroup_create(struct cgroup 
> 
>  	for_each_subsys(root, ss) {
>  		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
> +
>  		if (IS_ERR(css)) {
>  			err = PTR_ERR(css);
>  			goto err_destroy;
>  		}
>  		init_cgroup_css(css, ss, cgrp);
> -		if (ss->use_id)
> -			if (alloc_css_id(ss, parent, cgrp))
> +		if (ss->use_id) {
> +			err = alloc_css_id(ss, parent, cgrp);
> +			if (err)
>  				goto err_destroy;
> +		}
>  		/* At error, ->destroy() callback has to free assigned ID. */
>  	}
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
