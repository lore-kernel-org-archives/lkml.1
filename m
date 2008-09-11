Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYIKUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYIKUA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYIKUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:00:48 -0400
Received: from nebensachen.de ([195.34.83.29]:37523 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYIKUAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:00:47 -0400
X-Hashcash: 1:20:080911:tj@kernel.org::WPcFEfSSNJidNm25:00000RgM
X-Hashcash: 1:20:080911:multinymous@gmail.com::9rMUb50RlMJRhmfb:00000000000000000000000000000000000000005bFS
X-Hashcash: 1:20:080911:trenn@suse.de::w6BjxT7oOoOiY9og:000019qT
X-Hashcash: 1:20:080911:linux-kernel@vger.kernel.org::p+iY+CgVgBLnrmsq:0000000000000000000000000000000000Euf
X-Hashcash: 1:20:080911:linux-ide@vger.kernel.org::VPN16mTTaGoh5U9O:0000000000000000000000000000000000001nM4
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <tj@kernel.org>
Cc: Shem Multinymous <multinymous@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org>
	<41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>
	<48C948A6.3080404@kernel.org>
Date: Thu, 11 Sep 2008 22:00:37 +0200
Message-ID: <877i9ipi56.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:
> Hello, Shem Multinymous.
>
> Shem Multinymous wrote:
[...]
>>> 2. If we're gonna unify interface, how much can we unify the backend?
>>>   Some devices are based on polling, others interrupt.  For polling,
>>>   is it better to delegate the whole polling to userland or is it
>>>   better to do some of it in kernel (tp_smapi seems to be doing
>>>   this)?
>> 
>> The ThinkPad accelerometer needs to be polled at very regular
>> intervals (max jitter on the order of 10ms), which sounds like a job
>> for the kernel.
>
> Yes, I agree.
>
>> This is because in ThinkPads we actually have a 4-level pile:
>> [hdapsd userspace] -> [hdaps kernel] -> [embedded controller] ->
>> [accelerometer A2D]
>> What the kernel polls is actually is the H8S embedded controller (EC)
>> chip, which in turn does its own polling of the accelerometer A2D.
>> Now, the EC has a tiny buffer and strange buffering semantics, and it
>> has its own internal clock, so the software->EC polling should be very
>> regular to minmize EC buffer overflows/underruns.
>
> So, I think the whole polling should be implemented inside the kernel
> and the kernel should notify userland when new data is available,
> which is about what the current joystick implementation does and can
> be achieved using sysfs_notify_event().

Short of a satisfying proposition regarding the questions raised, I just
want to add two things that would be nice to solve in the future one way
or another and should perhaps be taken into consideration from the
beginning:

1. Disable polling completely when it isn't required: once the hd has
   spun down, there is no need to keep polling the sensors at all. Only
   when the first request requiring the hd to spin up arrives, the
   kernel needs to hold back for a short while to gather enough data
   from the sensors, so shock protection is up and running again.
2. Make shock protection interact nicely with suspend operations:
   currently, we are out of luck if anything should happen after
   processes have been frozen. This is particularly unfortunatel in the
   case of s2disk.

As far as 1. is concerned, I'm not quite sure yet how to determine when
the disk has spun down since this may have happened according to vendor
specific timing rules. Once we have established that the disk is
sleeping safe and sound, sensor drivers can be notified to stop polling
the hardware and possibly notify clients (like hdapsd) about that fact.

Something along the lines of the disk_shock module approach suggested by
Bart in [1] sounds promising, but it still needs some careful thinking
when designing the interfaces to all components involved. As for the
suspend problem, we could either put some simplified logic into
disk_shock so it can take over once hdapsd has been frozen, or we can
find a way to keep hdapsd unfrozen until the hd has been put to sleep.
Of course, we'd have to think about resume as well, although it'll be
impossible to protect right from the start in the s2disk case.

Regards,

Elias

[1] http://marc.info/?l=linux-kernel&m=122021163324843&w=2
