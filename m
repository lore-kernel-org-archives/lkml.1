Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYKUTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYKUTFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYKUTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:05:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYKUTFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:05:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=K0awDF1izy1qZA2hUWYzvNvzP6wLvuTJxrZZ5TW+1olFhcCW1XU4vHX56jwrJKdeX
	0bFXboS1xrneHMerCKBBA==
MIME-Version: 1.0
In-Reply-To: <49267624.70305@cn.fujitsu.com>
References: <49267624.70305@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:05:18 -0800
Message-ID: <6599ad830811211105p711aebc3v85ffffbc399bdd6e@mail.gmail.com>
Subject: Re: [PATCH] cpuset: rcu_read_lock() to protect task_cs() even we 
	don't dereference to task_cs()'s return value
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> task_cs() calls cgroup_subsys_state().

You man "calls task_subsys_state()"

>
> we must use rcu_read_lock() to protect cgroup_subsys_state().
>
> in current_cpuset_is_being_rebound(), we don't dereference to task_cs()'s
> return value, but task_cs() accesses css_set, this css_set maybe freed
> when task_cs() called.

Wouldn't this be fixed by your patch that adds an rcu_read_lock() to
task_subsys_state() ?

Paul

>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3e00526..e0e087e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1141,7 +1136,11 @@ done:
>
>  int current_cpuset_is_being_rebound(void)
>  {
> -       return task_cs(current) == cpuset_being_rebound;
> +       struct cpuset *cs;
> +       rcu_read_lock();
> +       cs = task_cs(current);
> +       rcu_read_unlock();
> +       return cs == cpuset_being_rebound;
>  }
>
>  static int update_relax_domain_level(struct cpuset *cs, s64 val)
>
>
