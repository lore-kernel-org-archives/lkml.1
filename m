Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYIOR4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYIOR4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYIORzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:55:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYIORzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:55:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=jqsqMnFtd2lnXDIGbuhxm2PH4/XGnNNGY6MeAjAHg3v8s/sKaR6SXE6rQyRnN/+7h
	v941XYKIiqhAgK7ssg+oQ==
Message-ID: <6599ad830809151055v10191becl2f528fa006902b40@mail.gmail.com>
Date: Mon, 15 Sep 2008 10:55:45 -0700
From: "Paul Menage" <menage@google.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] cgroups: don't depend on CONFIG_MM_OWNER
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com
In-Reply-To: <Pine.LNX.4.64.0809142037070.30252@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809142037070.30252@melkki.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 10:37 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> The revoke patches, for example, select CONFIG_MM_OWNER independently of
> cgroups. Therefore, don't depend on CONFIG_MM_OWNER in cgroup specific code.

Yes, the existing code doesn't seem quite right - if !CONFIG_MM_OWNER
then we don't need to even define a trivial version of
cgroup_mm_owner_callbacks()

But your patch is too specific - tying the existance of
cgroup_mm_owner_callbacks() to the memory controller would break other
controllers (e.g. the memrlimit or swap controllers, which also want
to use it)

How about:

- any cgroup that needs mm-owner callbacks selects an option
CGROUP_MM_OWNER_CALLBACK

- CGROUP_MM_OWNER_CALLBACK selects MM_OWNER and triggers the
definition of a non-trivial cgroup_mm_owner_callbacks() function


Paul


>
> Cc: Paul Menage <menage@google.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/cgroup.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c98dd7c..e270ec3 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -413,10 +413,10 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
>
>  #endif /* !CONFIG_CGROUPS */
>
> -#ifdef CONFIG_MM_OWNER
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  extern void
>  cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new);
> -#else /* !CONFIG_MM_OWNER */
> +#else /* !CONFIG_CGROUP_MEM_RES_CTLR */
>  static inline void
>  cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
>  {
> --
> 1.5.4.3
>
>
