Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYIEIwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYIEIwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYIEIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:52:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:5399 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYIEIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vbS2BIBktJ2jwZ9ACU0tgDUeXmqrI5FOYxroGMGoMlrtwzUn760nSFrYeqr71ileIC
         jIDNm592poDiAyBx5bl0bwoqlhkcMynMtbSU6pBsUDXvDDwu9o43n3c7w8/bvN28GXxB
         onJyzL2kwbH3YzqoRNNTYtlUCELrCgc7/y2Gc=
Message-ID: <48C0F2F8.1040308@gmail.com>
Date: Fri, 05 Sep 2008 10:51:04 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>
In-Reply-To: <87ej3zrf3o.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Tejun Heo <htejun@gmail.com> wrote:
>>  extern struct device_attribute **libata_sdev_attrs;
>>
>>  #define ATA_BASE_SHT(name)				\
>>  ....
>> 	.sdev_attrs		= libata_sdev_attrs;	\
>>  ....
>>
>> Which will give unload_heads to all libata drivers.  As ahci needs its
>> own node it would need to define its own sdev_attrs tho.
> 
> Dear me, I totally forgot about that, didn't I. Anyway, I meant to ask
> you about that when you mentioned it the last time round, so thanks for
> explaining in more detail. I'll do it this way then.

Great.

>> Isn't seconds a bit too crude? Or it just doesn't matter as it's
>> usually adjusted before expiring?  For most time interval values
>> (except for transfer timings of course) in ATA land, millisecs seem to
>> be good enough and I've been trying to unify things that direction.
> 
> Well, I can see your point. Technically, we are talking about magnitudes
> in the order of seconds rather than milliseconds here because the specs
> only guarantee command completion for head unload in 300 or even 500
> msecs. This means that the daemon should always schedule timeouts well
> above this limit. That's the reason why we have only accepted timeouts
> in seconds rather than milliseconds at the user's request. When reading
> from sysfs, we have returned seconds for consistency. I'm a bit torn
> between the options now:
> 
> 1. Switch the interface completely to msecs: consistent with the rest of
>    libata but slightly misleading because it may promise more accuracy
>    than we can actually provide for;
> 2. keep it the way it was (i.e. seconds on read and write): we don't
>    promise too much as far as accuracy is concerned, but it is
>    inconsistent with the rest of libata. Besides, user space can still
>    issue a 0 and another nonzero timeout within a very short time and we
>    don't protect against that anyway;
> 3. only switch to msecs on read: probably the worst of all options.
> 
> What do you think?

My favorite is #1.  Millisecond is small amount of time but it's also
not hard to imagine some future cases where, say, 0.5 sec of
granuality makes some difference.

>> Hmmm... Sorry to bring another issue with it but I think the interface
>> is a bit convoluted.  The unpark node is per-dev but the action is
>> per-port but devices can opt out by writing -2.  Also, although the
>> sysfs nodes are per-dev, writing to a node changes the value of park
>> node in the device sharing the port except when the value is -1 or -2.
>> That's strange, right?
> 
> Well, it is strange, but it pretty much reflects reality as close as it
> can get. Devices can only opt in / out of actually issuing the unload
> command but they will always stop I/O and thus be affected by the
> timeout (intentionally).
> 
>> How about something like the following?
>>
>> * In park_store: set dev->unpark_timeout, kick and wake up EH.
>>
>> * In park EH action: until the latest of all unpark_timeout are
>>   passed, park all drives whose unpark_timeout is in future.  When
>>   none of the drives needs to be parked (all timers expired), the
>>   action completes.
>>
>> * There probably needs to be a flag to indicate that the timeout is
>>   valid; otherwise, we could get spurious head unparking after jiffies
>>   wraps (or maybe just use jiffies_64?).
>>
>> With something like the above, the interface is cleanly per-dev and we
>> wouldn't need -1/-2 special cases.  The implementation is still
>> per-port but we can change that later without modifying userland
>> interface.
> 
> First of all, we cannot do a proper per-dev implementation internally.

Not yet but I think we should move toward per-queue EH which will
enable fine-grained exception handling like this.  Such approach would
also help things like ATAPI CHECK_SENSE behind PMP.  I think it's
better to define the interface which suits the problem best rather
than reflects the current implementation.

> Admittedly, we could do it per-link rather than per-port, but the point
> I'm making is this: there really is just *one* grobal timeout (per-port
> now or perhaps per-link in the long run). The confusing thing right now
> is that you can read the current timeout on any device, but you can only
> set a timeout on a device that actually supports head unloading. Perhaps
> we should return something like "n/a" when reading the sysfs attribute
> for a device that doesn't support head unloads, even though a timer on
> that port may be running because the other device has just received an
> unload request. This way, both devices will be affected by the timeout,
> but you can only read it on the device where you can change it as well.
> Would that suit you?

If the timeout is global, it's best to have one knob.  If the timeout
is per-port, it's best to have one knob per-port, and so on.  I can't
think of a good reason to implement per-port timeout with per-device
opt out instead of doing per-device timeout from the beginning.  It
just doesn't make much sense interface-wise to me.  As this is an
interface which is gonna stick around for a long time, I really think
it should be done as straight forward as possible even though the
current implementation of the feature has to do it in more crude
manner.

Thanks.

-- 
tejun
