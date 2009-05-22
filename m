Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZEVIET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZEVIET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbZEVIDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:03:36 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:50536 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbZEVIDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OJNVHKfLJcr2gbunUZMV80hkkuPC8CXmOXtop8lKVE/CdvwnVz1N2jAgpnqx2cpawI
         2UNPtAVY2ODeelr/oIKU1J+Bv2UV+6yHfFgLTsRqktQw6Rpw1XWoVqhYrgw7ARTsAKPz
         lFdqe5e1jCfSvQ6h3DPsRJ/1s+WEbEAEP2DIA=
MIME-Version: 1.0
In-Reply-To: <1242802064.31350.12.camel@johannes.local>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu>
	 <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
Date: Fri, 22 May 2009 16:03:32 +0800
Message-ID: <d82e647a0905220103s23ad0feejfaa787dcd481a41c@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency at 
	cleanup_workqueue_thread
From: Ming Lei <tom.leiming@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/20 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:
>
>> > Anyway, you can have a deadlock like this:
>> >
>> > CPU 3                   CPU 2                           CPU 1
>> >                                                        suspend/hibernate
>> >                        something:
>> >                        rtnl_lock()                     device_pm_lock()
>> >                                                        -> mutex_lock(&dpm_list_mtx)
>> >
>> >                        mutex_lock(&dpm_list_mtx)
>>
>> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CPU2
>> and depends on rtnl_lock?
>
> Why not? Something is registering a hotplugged netdev.

It seems dpm_list_mtx is held in kernel_init context, so should not consider
registering a hotplugged netdev, isn't it?

I am still confused, since rtnl_mutex is held before dpm_list_mtx which
is acquired in kernel_init context.

[  562.689476] -> #3 (dpm_list_mtx){+.+.+.}:
[  562.689480]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689484]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689489]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
[  562.689493]        [<ffffffff803f6395>] device_pm_add+0x4b/0xf2
[  562.689499]        [<ffffffff803ef382>] device_add+0x498/0x62a
[  562.689503]        [<ffffffff8043fd32>] netdev_register_kobject+0x7b/0x80
[  562.689509]        [<ffffffff80434761>] register_netdevice+0x2d0/0x469
[  562.689514]        [<ffffffff80434939>] register_netdev+0x3f/0x4d
[  562.689519]        [<ffffffff806f634f>] loopback_net_init+0x40/0x7d
[  562.689524]        [<ffffffff8042ee79>] register_pernet_device+0x32/0x5f
[  562.689528]        [<ffffffff806fb41a>] net_dev_init+0x143/0x1a1
[  562.689533]        [<ffffffff80209080>] do_one_initcall+0x75/0x18a
[  562.689538]        [<ffffffff806d0678>] kernel_init+0x138/0x18e
[  562.689542]        [<ffffffff8020c33a>] child_rip+0xa/0x20
[  562.689546]        [<ffffffffffffffff>] 0xffffffffffffffff

>
> johannes
>



-- 
Lei Ming
