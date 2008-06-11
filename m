Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYFKIcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYFKIcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYFKIco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:32:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6850 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYFKIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:32:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oZ1ELppHhwUSOdXORcxqB9bsP5VIt9r2ckmb9cO9LfDJqhsTvb5EkNyvfkEn6zqbU
	7VgRn/HLywLq+6+8+qNVA==
Message-ID: <6599ad830806110132j1b3f899bx57fd3c894fd0c1c6@mail.gmail.com>
Date: Wed, 11 Jun 2008 01:32:30 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "Balaji Rao" <balajirrao@gmail.com>,
       containers@lists.osdl.org, menage@google.com, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
Subject: Re: [-mm] CPU controller statistics (v5)
In-Reply-To: <20080603200515.GA25753@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603200515.GA25753@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 1:05 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e155aa7..60a25cb 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -293,6 +293,7 @@ int cgroup_is_descendant(const struct cgroup *cgrp);
>  struct cgroup_subsys {
>        struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
>                                                  struct cgroup *cgrp);
> +       void (*initialize)(int early);
>        void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>        void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>        int (*can_attach)(struct cgroup_subsys *ss,
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 15ac0e1..77569d7 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2553,6 +2553,9 @@ int __init cgroup_init_early(void)
>
>                if (ss->early_init)
>                        cgroup_init_subsys(ss);
> +
> +               if (ss->initialize)
> +                       ss->initialize(1);
>        }
>        return 0;
>  }
> @@ -2577,6 +2580,9 @@ int __init cgroup_init(void)
>                struct cgroup_subsys *ss = subsys[i];
>                if (!ss->early_init)
>                        cgroup_init_subsys(ss);
> +
> +               if (ss->initialize)
> +                       ss->initialize(0);
>        }

This seems a little weird - even if the subsystem didn't want early
initialization, we call its initialize() during early setup?

I assume the idea is to move away from the current model where the
subsystem is expected to initialize itself during the first call to
its create() method, when it gets passed a cgroup with a NULL parent?
I agree that was a bit icky. How about we call ss->initialize() from
cgroup_init_subsys()? Then we wouldn't need the "early" parameter,
since it would be implicit based on whether the subsystem wanted early
initialization or not.

Also, if you're adding a new subsystem method, you should document it
in Documentation/cgroups.txt

Paul
