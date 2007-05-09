Return-Path: <linux-kernel-owner+w=401wt.eu-S1032976AbXEIA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032976AbXEIA6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968417AbXEIA6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:58:10 -0400
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:36274 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968414AbXEIA6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:58:09 -0400
Message-ID: <46411CA1.8060506@gmail.com>
Date: Tue, 08 May 2007 21:58:09 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <4640FE35.2070605@gmail.com> <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com> <464108CC.3060604@gmail.com> <Pine.LNX.4.64.0705081639570.16372@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705081639570.16372@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 8 May 2007, Kevin Winchester wrote:
>
>   
>> Here's the dmesg of the slub_debug run, I'll try the patch next:
>>     
>
> Ok someone wrote to an object after it was freed. Not slubs problem.
>
>   
>> [    1.367129]     Object 0xffff810001bdecd0:  80 b7 b1 01 00 81 ff ff 6b 6b
>> 6b 6b 6b 6b 6b 6b .·±...kkkkkkkk
>>     
>
> The first 8 bytes of the freed object were overwritten.
>
>   
>> [    1.374455] Last alloc: cryptomgr_notify+0x28/0x190 jiffies_ago=0 cpu=0
>> pid=1
>> [    1.374611] Last free : cryptomgr_probe+0x85/0xb0 jiffies_ago=0 cpu=0
>> pid=405
>>     
>
> Here are some potential candidates that have recently handled the object. 
> That was less than a jiffy ago. So very recent.
>
>   
Not having any idea what I'm doing, I looked at cryptomgr_probe and 
cryptomgr_notify, and can't seem to see much, except for the following 
odd lines.

 From cryptomgr_schedule_probe, which is almost certainly inlined into 
crypto_notify:

-----

param = kzalloc(sizeof(*param), GFP_KERNEL);
...
param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
if (IS_ERR(param->thread))
    goto err_free_param;

    return NOTIFY_STOP;

err_free_param:
        kfree(param);
err_put_module:
        module_put(THIS_MODULE);
err:
        return NOTIFY_OK;

-----

while cryptomgr_probe does (with a local variable param that points to 
the same data):

-----
...
if (err)
    goto err;

out:
    kfree(param);
    module_put_and_exit(0);
-----

Now perhaps I am wrong, but would it be possible for the kthread_run() 
call to cause cryptomgr_probe to run before the return result is stored 
into param->thread?  That would mean that param would be accessed after 
freeing.

<changes thread to a local variable in the cryptomgr_schedule_probe 
method...compile...test...still fails>

I guess that's not it.

Any thoughts on what might be the cause of this (I've added Herbert Xu 
to the CC list since he seems to be the crypto maintainer)?

I'll try to add some printk's in there to see if that enlightens me.

Kevin


