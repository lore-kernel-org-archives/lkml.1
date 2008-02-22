Return-Path: <linux-kernel-owner+w=401wt.eu-S936797AbYBVBr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936797AbYBVBr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762818AbYBVBrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:47:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2862 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762223AbYBVBrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:47:14 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5235"; a="757847"
Message-ID: <47BE29A0.6040409@qualcomm.com>
Date: Thu, 21 Feb 2008 17:47:12 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com> <47BE245F.3030809@qualcomm.com> <47BE27AE.8050009@gmail.com>
In-Reply-To: <47BE27AE.8050009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Max Krasnyanskiy wrote:
>> Thanks for the info. I guess I missed that from the code. In any case
>> that seems like a pretty heavy refcounting mechanism. In a sense that
>> every time something is loaded or unloaded entire machine freezes,
>> potentially for several milliseconds. Normally it's not a big deal. But
>> once you get more and more CPUs and/or start using realtime apps this
>> becomes a big deal.
> 
> Module loading doesn't involve stop_machine last time I checked.  It's a
> big deal when unloading a module but it's actually a very good trade off
> because it makes much hotter path (module_get/put) much cheaper.  If
> your application can't stand stop_machine, simply don't unload a module.

static struct module *load_module(void __user *umod,
                                  unsigned long len,
                                  const char __user *uargs)
{
      ...

      /* Now sew it into the lists so we can get lockdep and oops
         * info during argument parsing.  Noone should access us, since
         * strong_try_module_get() will fail. */
        stop_machine_run(__link_module, mod, NR_CPUS);
      ...
}

I actually rarely unload modules. The way I notice the problem in first place is when 
things started hanging when tun driver was autoloaded or when fs automounts triggered 
some auto loading.
These days it's kind hard to have a semi-general purpose machine without module loading :).

Max
