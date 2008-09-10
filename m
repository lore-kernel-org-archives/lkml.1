Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYIJCld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYIJCld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 22:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYIJClY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 22:41:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYIJClX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 22:41:23 -0400
Message-ID: <48C733A2.2050709@cn.fujitsu.com>
Date: Wed, 10 Sep 2008 10:40:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
 and find_css_set
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com>
In-Reply-To: <48C72E7C.8080302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Paul Menage wrote:
>> On Mon, Aug 18, 2008 at 11:29 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>> 2) Use atomic_inc_not_zero() in find_existing_css_set(), to ensure
>> that we only return a referenced css, and remove the get_css_set()
>> call from find_css_set(). (Possibly wrapping this in a new
>> kref_get_not_zero() function)
>>
> 
> [CC: Greg Kroah-Hartman <greg@kroah.com>]
> 
> There are indeed several ways fix this race by Using the
> atomic-functions directly. I prefer the second one, i makes all
> code clearly. And put_css_set[_taskexit] do not need to be changed.
> 
> I don't think adding kref_get_not_zero() API is a good idea.
> It will bring kref APIs to a little chaos, kref_get_not_zero() is
> hard to be used, for this function needs a special lock held.
> 
> But I tried:
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index 0cef6ba..400ffab 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -25,6 +25,7 @@ struct kref {
>  void kref_set(struct kref *kref, int num);
>  void kref_init(struct kref *kref);
>  void kref_get(struct kref *kref);
> +int kref_get_not_zero(struct kref *kref);
>  int kref_put(struct kref *kref, void (*release) (struct kref *kref));
>  
>  #endif /* _KREF_H_ */
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 13932ab..0bbb98d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -347,6 +347,8 @@ static struct css_set *find_existing_css_set(
>  	hlist_for_each_entry(cg, node, hhead, hlist) {
>  		if (!memcmp(template, cg->subsys, sizeof(cg->subsys))) {
>  			/* All subsystems matched */
> +			if (!kref_get_not_zero(&cg->ref))
> +				return NULL;

Better add comments to explain why we might get 0 refcount here.

>  			return cg;
>  		}
>  	}
> @@ -410,8 +412,6 @@ static struct css_set *find_css_set(
>  	 * the desired set */
>  	read_lock(&css_set_lock);
>  	res = find_existing_css_set(oldcg, cgrp, template);
> -	if (res)
> -		get_css_set(res);
>  	read_unlock(&css_set_lock);
>  
>  	if (res)
> diff --git a/lib/kref.c b/lib/kref.c
> index 9ecd6e8..b8c1ce6 100644
> --- a/lib/kref.c
> +++ b/lib/kref.c
> @@ -46,6 +46,25 @@ void kref_get(struct kref *kref)
>  }
>  
>  /**
> + * kref_get_not_zero - increment refcount for object if current refcount
> + *                     is not zero.
> + * @kref: object.
> + *
> + * Beware, the object maybe be being released, so we need a special lock held

s/maybe be being/may be being/

> + * to ensure the object's refcount is remaining access.
> + * 

need better wording... what do you mean by "remaining access"? to ensure the object
is remaining valid?

> + * Return 0 if this refcount is 0, otherwise return 1.
> + */
> +int kref_get_not_zero(struct kref *kref)
> +{
> +	if (atomic_inc_not_zero(&kref->refcount)) {
> +		smp_mb__after_atomic_inc();
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/**
>   * kref_put - decrement refcount for object.
>   * @kref: object.
>   * @release: pointer to the function that will clean up the object when the
> 
> 

