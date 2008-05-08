Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYEHM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYEHM63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYEHM6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:58:21 -0400
Received: from gw.goop.org ([64.81.55.164]:38295 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYEHM6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:58:21 -0400
Message-ID: <4822F8E4.4040401@goop.org>
Date: Thu, 08 May 2008 13:58:12 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
References: <20080508012957.c778c8e7.akpm@linux-foundation.org> <4822D30E.5010506@goop.org> <20080508193224.0EFF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080508193224.0EFF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
>
> Thanks good comment!
>
>   
>>> How many times do we have to make this mistake :(
>>>
>>> Only the caller knows what allocation mode the callee can use. 
>>> call_usermodehelper_setup() should be extended to take a gfp_t argument.
>>>       
>> Yeah, but making the caller need to know about the internal 
>> implementation details of the callee (ie, whether it needs to allocate 
>> memory or not) leads to pretty warty interfaces.  In this case, you 
>> could push the gfp_t up to the call_usermodehelper_setup() level, but 
>> pushing it any higher wouldn't make much sense.
>>     
>
> No problem :)
> almost caller doesn't call call_usermodehelper_setup() directly.
>
> thus, call_usermodehelper_setup() chage is hided in call_usermodehelper().
>   

Yep, seems reasonable.  Are there any UMH_NO_WAIT callers who could be 
using GFP_KERNEL?

> ----------------chunk of my current testing patch-----------------------------
>
> @@ -68,8 +69,9 @@ static inline int
>  call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
>  {
>  	struct subprocess_info *info;
> +	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>  
> -	info = call_usermodehelper_setup(path, argv, envp);
> +	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
>  	if (info == NULL)
>  		return -ENOMEM;
>  	return call_usermodehelper_exec(info, wait);
>
>   

    J
