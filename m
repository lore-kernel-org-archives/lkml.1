Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZETIrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZETIrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZETIri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:47:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:43719 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZETIrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ClntyjhyV/iaxuvIMi6rqnHiiAxf2lMZAvmupet3D793ASfuZVwzHIMk0P8LLPMnuM
         pzv0eGmRSY6xTh9eCIMOZOxzVzxOKumuAOJLRTBJ0/8xeqPKxCt2HoIasRAJwqhsO3f/
         eAt8C1HwyRTk+T1J5ILnnr0d3B+kh1MDjTR/k=
MIME-Version: 1.0
In-Reply-To: <1242803569.31350.14.camel@johannes.local>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
	 <d82e647a0905200009pc894d4yed0f81c83443a0ee@mail.gmail.com>
	 <1242803569.31350.14.camel@johannes.local>
Date: Wed, 20 May 2009 16:21:19 +0800
Message-ID: <d82e647a0905200121m6aa68fdcq74cd2825f43b056b@mail.gmail.com>
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
> On Wed, 2009-05-20 at 15:09 +0800, Ming Lei wrote:
>> 2009/5/20 Johannes Berg <johannes@sipsolutions.net>:
>> > On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:
>> >
>> >> > Anyway, you can have a deadlock like this:
>> >> >
>> >> > CPU 3                   CPU 2                           CPU 1
>> >> >                                                        suspend/hibernate
>> >> >                        something:
>> >> >                        rtnl_lock()                     device_pm_lock()
>> >> >                                                        -> mutex_lock(&dpm_list_mtx)
>> >> >
>> >> >                        mutex_lock(&dpm_list_mtx)
>> >>
>> >> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CPU2
>> >> and depends on rtnl_lock?
>> >
>> > Why not? Something is registering a hotplugged netdev.
>>
>> I see. I just feel a bit curious how lockdep may build the dependency
>> of dpm_list_mtx on rtnl_lock,  and it  is certainly related with
>> lockdep internal.
>
> No, it's just the way drivers/base/power/ works -- it acquires the lock
> when you register a new struct device.

For me, the real puzzle is that  how lockdep introduce  #3
(dpm_list_mtx){+.+.+.}

-> #3 (dpm_list_mtx){+.+.+.}:
      [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
      [<ffffffff80271f38>] lock_acquire+0x98/0x140
      [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
      [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
      [<ffffffff804532ff>] device_pm_add+0x1f/0xe0
      [<ffffffff8044b9bf>] device_add+0x45f/0x570
      [<ffffffffa007c578>] wiphy_register+0x158/0x280 [cfg80211]
      [<ffffffffa017567c>] ieee80211_register_hw+0xbc/0x410 [mac80211]
      [<ffffffffa01f7c5c>] iwl3945_pci_probe+0xa1c/0x1080 [iwl3945]
      [<ffffffff803c4307>] local_pci_probe+0x17/0x20
      [<ffffffff803c5458>] pci_device_probe+0x88/0xb0
      [<ffffffff8044e1e9>] driver_probe_device+0x89/0x180
      [<ffffffff8044e37b>] __driver_attach+0x9b/0xa0
      [<ffffffff8044d67c>] bus_for_each_dev+0x6c/0xa0
      [<ffffffff8044e03e>] driver_attach+0x1e/0x20
      [<ffffffff8044d955>] bus_add_driver+0xd5/0x290
      [<ffffffff8044e668>] driver_register+0x78/0x140
      [<ffffffff803c56f6>] __pci_register_driver+0x66/0xe0
      [<ffffffffa00bd05c>] 0xffffffffa00bd05c
      [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
      [<ffffffff8027d071>] sys_init_module+0xb1/0x200
      [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
      [<ffffffffffffffff>] 0xffffffffffffffff

into the lockdep graph?  in which process context?  and what is the
previous held lock?
After all, there is a path ( #0,#1,#2,...,#5 ) in the directed graph
and #3 is added by
add_lock_to_list().

Thanks.

-- 
Lei Ming
