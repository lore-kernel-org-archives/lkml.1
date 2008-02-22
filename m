Return-Path: <linux-kernel-owner+w=401wt.eu-S935578AbYBVCAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935578AbYBVCAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761513AbYBVB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:59:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:57613 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYBVB7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Zgkp+ZOjQ7RghlirRWj4jAs9CLdI0+GwMMewF7oWqfxoeqkzZ+MNkw9ATCWZm0jSS/TX3cLQ+XGA9JqQmbSLVxh4ubwS3510HfwSPKK6ZzI5lNe+zmvoBVCE/TGyIT4fCqpjeGSRhKVZPb37LuhIag9bSuQ52kr0APV2Zxc6pDk=
Message-ID: <47BE2C7B.4000507@gmail.com>
Date: Fri, 22 Feb 2008 10:59:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Max Krasnyanskiy <maxk@qualcomm.com>
CC: rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com> <47BE245F.3030809@qualcomm.com> <47BE27AE.8050009@gmail.com> <47BE29A0.6040409@qualcomm.com>
In-Reply-To: <47BE29A0.6040409@qualcomm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyanskiy wrote:
> Tejun Heo wrote:
>> Max Krasnyanskiy wrote:
>>> Thanks for the info. I guess I missed that from the code. In any case
>>> that seems like a pretty heavy refcounting mechanism. In a sense that
>>> every time something is loaded or unloaded entire machine freezes,
>>> potentially for several milliseconds. Normally it's not a big deal. But
>>> once you get more and more CPUs and/or start using realtime apps this
>>> becomes a big deal.
>>
>> Module loading doesn't involve stop_machine last time I checked.  It's a
>> big deal when unloading a module but it's actually a very good trade off
>> because it makes much hotter path (module_get/put) much cheaper.  If
>> your application can't stand stop_machine, simply don't unload a module.
> 
> static struct module *load_module(void __user *umod,
>                                  unsigned long len,
>                                  const char __user *uargs)
> {
>      ...
> 
>      /* Now sew it into the lists so we can get lockdep and oops
>         * info during argument parsing.  Noone should access us, since
>         * strong_try_module_get() will fail. */
>        stop_machine_run(__link_module, mod, NR_CPUS);
>      ...
> }

Ah... right.  That part doesn't have anything to do with module
reference counting as the comment suggests and can probably be removed
by updating how kallsyms synchronize against module load/unload.

> I actually rarely unload modules. The way I notice the problem in first
> place is when things started hanging when tun driver was autoloaded or
> when fs automounts triggered some auto loading.
> These days it's kind hard to have a semi-general purpose machine without
> module loading :).

Yeap, agreed.

-- 
tejun
