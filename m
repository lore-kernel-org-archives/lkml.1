Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZBUB2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZBUB2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZBUB2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:28:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:8827 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZBUB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lDj6+3f/imxraOImYWiTiT3QhM8cikdzXPHSSzBEFpMfGrtGxJYjVf9rL3bKXx5yzg
         SLQfsNNTYICy7m4vjvwRxSUlzugoG3/80iVi8LOc9xErMgRyF+rQ+O84m2yjDEAV3l3U
         AG+TTpa7CJ0mpmUHFofCTCe1BNNQ8f1luAt5s=
MIME-Version: 1.0
In-Reply-To: <20090220073345.501247f7@infradead.org>
References: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
	 <20090220073345.501247f7@infradead.org>
Date: Sat, 21 Feb 2009 09:28:34 +0800
Message-ID: <d82e647a0902201728s5e57f02cs8f8c20567f914717@mail.gmail.com>
Subject: Re: [PATCH] [PATCH/RESEND] driver core: remove polling for 
	driver_probe_done(v4)
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/20 Arjan van de Ven <arjan@infradead.org>:
> On Fri, 20 Feb 2009 22:17:27 +0800
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch adds a function : driver_wait_probe_done,
>> which waits on condition of probing done to replace
>> polling for driver_probe_done in fs initialization.
>>
>> There is no better way to avoid polling for
>> driver_probe_done _and_ existence of the root device,
>> so we does not replace the driver_probe_done with
>> driver_wait_probe_done in such special case.
>>
>> Removing polling in fs initialization may lead to
>> a faster boot.
>>
>> This patch is against the latest linux-next tree.
>
> you broke it i this revision though
>
>> -int wait_for_device_probe(void)
>> +void driver_wait_probe_done(void)
>>  {
>> -     /* wait for the known devices to complete their probing */
>> -     while (driver_probe_done() != 0)
>> -             msleep(100);
>> -     async_synchronize_full();
>> -     return 0;
>> +     pr_debug("%s: probe_count = %d\n", __func__,
>> +              atomic_read(&probe_count));
>> +     wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
>
>
> You lost the async_synchronize_full()!

I patch  patch-v2.6.29-rc5-next-20090220.gz against v2.6.29-rc5
directly to build
the linux-next tree(it is quicker for me),so I don't know why you add
async_synchronize_full()
 in driver core and  seems it doesn't matter with driver core.

Would you mind  that I resend a patch,which does
async_synchronize_full()  after
driver_wait_probe_done() in do_mounts.c or do_mounts_md.c ?

>
>
>> -     wait_for_device_probe();
>> +     driver_wait_probe_done();
>
> I also don't understand why you rename the function..
> wait_for_device_probe() is not a bad name ;)
> Sounds like a gratuitous change to me.

OK, I will use wait_for_device_probe().

>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>



-- 
Lei Ming
