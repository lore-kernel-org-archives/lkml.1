Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZKTTut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZKTTut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZKTTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:50:48 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52468 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbZKTTur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VfJ5rGB8S8vdFzIQRJHwyYKdDd2bDp68+DumSxvz/AYfY8aXr5m+TjkEhYyVN6eXjX
         fZCRSwAS2qWiO2WKYPI7DTQc7PArCuEQuQfuWbuuLwkMh55+Jr0uDz3AmpsxfWINm5Xf
         DPfsbJKE8qaORtbdwCKgdF4aUbZL/Sktm/HLU=
MIME-Version: 1.0
In-Reply-To: <20091120184257.GG5872@redhat.com>
References: <20091116221827.GL13235@redhat.com>
	 <20091118153227.GA5796@redhat.com>
	 <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <20091118225626.GA2974@redhat.com>
	 <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
	 <20091120141840.GA5872@redhat.com>
	 <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
	 <20091120150421.GC5872@redhat.com>
	 <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
	 <20091120184257.GG5872@redhat.com>
Date: Fri, 20 Nov 2009 20:50:47 +0100
Message-ID: <4e5e476b0911201150p7cbdfc20k4b8d02f07e16abc8@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 7:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Should we also take into account the "cfqq->dispatched" request in
> determining whether we should enable idling on deep queue random seeky
> readers?

Probably, but I think the most important thing is to do some averaging
or hysteresis, so the completion of a single request doesn't cause the
switch of a workload.

>
> Adding that helps me a bit in cgroup setup but I still see sync seeky random
> writers switching between sync and sync-noidle so frequently.
>
> In fact I think that's part of the reason why it is slow. Out of 4, 1
> random seeky reader will switch group so often and then will not drive
> the enough queue depth. Rest of them seem to be running in other group.
>
> In fact sometimes this same writer will jump to second group, get the time
> slice and then jump back to root group and then again get the time slice
> in sync-noidle category. This will preempt the reader in root group at the
> same time will not drive higher queue depths as rest of the writers are
> in other groups.
>
> So frequent switching of type of random seeky reqder queue from
> sync --> sync-noidle--->sync seems to be one of the hurting factors.
>
> But when I started taking cfqq->dispatched also in account, share of
> random writers increased when running without cgroups. So it is kind of
> puzzling.
>
> But in general, we need to stablize the type of a queue and it should
> not vary so fast, given the fact nature of the workload/queue has not
> changed.
Yes. I'll work on a better patch.

>> > With cgroup, problem still persists. I am wondering why both are loosing.
>> > Looks like I am idling somewhere otherwise at least one person should have
>> > gained.
>> With just 2 groups (one is the root), you can't be idling 50% of the
>> time. How is the disk utilization during the test?
>>
>
> How do I measure the utilization of the array?
On software raids (with md), 'iostat -x 2' shows the utilization of
the md device, as well as the single components, so you can see if the
array is fully utilized. On hardware raid, you can't see the
individual disks, so it is less useful.

Thanks
Corrado

>> Note that you can lose even if you're not idling enough.
>> How does this workload fare with noop or deadline.
>> Thanks
>> Corrado
>>
>> >
>> > Thanks
>> > Vivek
>> >
>>
>>
>>
>> --
>> __________________________________________________________________________
>>
>> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
>> PhD - Department of Computer Science - University of Pisa, Italy
>> --------------------------------------------------------------------------
>> The self-confidence of a warrior is not the self-confidence of the average
>> man. The average man seeks certainty in the eyes of the onlooker and calls
>> that self-confidence. The warrior seeks impeccability in his own eyes and
>> calls that humbleness.
>>                                Tales of Power - C. Castaneda
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
