Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab0BWGH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:07:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:62698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0BWGH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:07:27 -0500
Message-ID: <4B837205.8040007@windriver.com>
Date: Tue, 23 Feb 2010 14:13:25 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer
 dereference
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com> <201002231426.45886.rusty@rustcorp.com.au>
In-Reply-To: <201002231426.45886.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Feb 2010 06:07:13.0822 (UTC) FILETIME=[71812BE0:01CAB44E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
>> The param_set_fn() function will get a parameter which is a NULL
>> pointer when insmod module via bare params as following method:
>>
>> $insmod foo.ko foo
>>
>> If the param_set_fn() function didn't check that parameter and used
>> it directly, it could caused an OOPS due to NULL pointer dereference.
>>
>> The solution is simple:
>> Using "" to replace NULL parameter, thereby the param_set_fn()
>> function will never get a NULL pointer.
> 
> This changes the value of booleans, and loses checking for int params, etc.
> 
> I liked Americo's approach; I've combined the two approaches below.

Thanks for your correcting.

Acked-by: Dongdong Deng <dongdong.deng@windriver.com>


> 
> Since I'm going away, can Andrew take this?
> 
> Subject: params: don't hand NULL values to param.set callbacks.
> 
> An audit by Dongdong Deng revealed that most driver-author-written param
> calls don't handle val == NULL (which happens when parameters are specified
> with no =, eg "foo" instead of "foo=1").
> 
> The only real case to use this is boolean, so handle it specially for that
> case and remove a source of bugs for everyone else as suggested by Americo.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Dongdong Deng <dongdong.deng@windriver.com>
> Cc: Américo Wang <xiyou.wangcong@gmail.com>
> 
> diff --git a/kernel/params.c b/kernel/params.c
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -59,6 +59,9 @@ static int parse_one(char *param,
>  	/* Find parameter */
>  	for (i = 0; i < num_params; i++) {
>  		if (parameq(param, params[i].name)) {
> +			/* Noone handled NULL, so do it here. */
> +			if (!val && params[i].set != param_set_bool)
> +				return -EINVAL;
>  			DEBUGP("They are equal!  Calling %p\n",
>  			       params[i].set);
>  			return params[i].set(val, &params[i]);
> @@ -182,7 +185,6 @@ int parse_args(const char *name,
>  		tmptype l;						\
>  		int ret;						\
>  									\
> -		if (!val) return -EINVAL;				\
>  		ret = strtolfn(val, 0, &l);				\
>  		if (ret == -EINVAL || ((type)l != l))			\
>  			return -EINVAL;					\
> @@ -204,12 +206,6 @@ STANDARD_PARAM_DEF(ulong, unsigned long,
>  
>  int param_set_charp(const char *val, struct kernel_param *kp)
>  {
> -	if (!val) {
> -		printk(KERN_ERR "%s: string parameter expected\n",
> -		       kp->name);
> -		return -EINVAL;
> -	}
> -
>  	if (strlen(val) > 1024) {
>  		printk(KERN_ERR "%s: string parameter too long\n",
>  		       kp->name);
> @@ -310,12 +306,6 @@ static int param_array(const char *name,
>  	kp.arg = elem;
>  	kp.flags = flags;
>  
> -	/* No equals sign? */
> -	if (!val) {
> -		printk(KERN_ERR "%s: expects arguments\n", name);
> -		return -EINVAL;
> -	}
> -
>  	*num = 0;
>  	/* We expect a comma-separated list of values. */
>  	do {
> @@ -382,10 +372,6 @@ int param_set_copystring(const char *val
>  {
>  	const struct kparam_string *kps = kp->str;
>  
> -	if (!val) {
> -		printk(KERN_ERR "%s: missing param set value\n", kp->name);
> -		return -EINVAL;
> -	}
>  	if (strlen(val)+1 > kps->maxlen) {
>  		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
>  		       kp->name, kps->maxlen-1);
> 

