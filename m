Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZEFI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZEFI35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZEFI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:29:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZEFI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:29:31 -0400
Message-ID: <4A0149FD.3010008@cn.fujitsu.com>
Date: Wed, 06 May 2009 16:27:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk %0*X is broken.
References: <20090506081221.GA15317@damson.getinternet.no>
In-Reply-To: <20090506081221.GA15317@damson.getinternet.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 2009/5/6 Ingo Molnar <mingo@elte.hu>:
>> Cc:-ed more folks who modified lib/vsprintf.c recently.
>>
>>        Ingo
>>
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> it seems someone broke
>>>
>>> printk(   "%0*X\n", width, x);
>>>
>>> looks like 0 is dumped.
> 
> After %, we look for flags. The problem is that when a flag is found, we
> don't advance in the format string. And thus we start looking for the
> precision, which is read as 0, because we are still at the 0. I think
> this patch should fix it.
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 7536ace..ae7d4b2 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -800,14 +800,15 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
>  	if (fmt != start || !*fmt)
>  		return fmt - start;
>  
> +	/* this skips the first '%' */
> +	++fmt;
> +
>  	/* Process flags */
>  	spec->flags = 0;
>  
> -	while (1) { /* this also skips first '%' */
> +	while (1) {
>  		bool found = true;
>  
> -		++fmt;
> -
>  		switch (*fmt) {
>  		case '-': spec->flags |= LEFT;    break;
>  		case '+': spec->flags |= PLUS;    break;
> @@ -819,6 +820,8 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
>  
>  		if (!found)
>  			break;
> +
> +		++fmt;
>  	}
>

It seems that your patch does not change anything.
The code logic is still the same as before.

Lai

