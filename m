Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbZATBj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbZATBj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZATBjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:39:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZATBjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:39:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=hcoDxMM2Px9a2+SsFcjSclmqTaReIrkRvNkfNjTlWDUiaPPxgmYnQ/K2phJl9JQVl
	Ij6nw3vw2Q0VXNzZzLebA==
MIME-Version: 1.0
In-Reply-To: <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 17:39:40 -0800
Message-ID: <6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.93
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 2:27 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> cgroup creation is done in several stages.
> After allocated and linked to cgroup's hierarchy tree, all necessary
> control files are created.
>
> When using CSS_ID, scanning cgroups without cgrouo_lock(), status
> of cgroup is important. At removal of cgroup/css, css_tryget() works fine
> and we can write a safe code.

What problems are you currently running into during creation? Won't
the fact that the css for the cgroup has been created, and its pointer
been stored in the cgroup, be sufficient?

Or is the problem that a cgroup that fails creation half-way could
result in the memory code alreadying having taken a reference on the
memcg, which can't then be cleanly destroyed?

Paul

> "This cgroup is not ready yet"
>
> This patch adds CSS_POPULATED flag.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
> Index: mmotm-2.6.29-Jan14/include/linux/cgroup.h
> ===================================================================
> --- mmotm-2.6.29-Jan14.orig/include/linux/cgroup.h
> +++ mmotm-2.6.29-Jan14/include/linux/cgroup.h
> @@ -69,6 +69,7 @@ struct cgroup_subsys_state {
>  enum {
>        CSS_ROOT, /* This CSS is the root of the subsystem */
>        CSS_REMOVED, /* This CSS is dead */
> +       CSS_POPULATED, /* This CSS finished all initialization */
>  };
>
>  /*
> @@ -90,6 +91,11 @@ static inline bool css_is_removed(struct
>        return test_bit(CSS_REMOVED, &css->flags);
>  }
>
> +static inline bool css_is_populated(struct cgroup_subsys_state *css)
> +{
> +       return test_bit(CSS_POPULATED, &css->flags);
> +}
> +
>  /*
>  * Call css_tryget() to take a reference on a css if your existing
>  * (known-valid) reference isn't already ref-counted. Returns false if
> Index: mmotm-2.6.29-Jan14/kernel/cgroup.c
> ===================================================================
> --- mmotm-2.6.29-Jan14.orig/kernel/cgroup.c
> +++ mmotm-2.6.29-Jan14/kernel/cgroup.c
> @@ -2326,8 +2326,10 @@ static int cgroup_populate_dir(struct cg
>        }
>
>        for_each_subsys(cgrp->root, ss) {
> +               struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
>                if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
>                        return err;
> +               set_bit(CSS_POPULATED, &css->flags);
>        }
>
>        return 0;
>
>
