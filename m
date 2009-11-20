Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKTSc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKTSc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZKTSc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:32:26 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54578 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbZKTScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cA6Cj/3nKYi6jBcYKpc2NNO2MmIl+KClmPkv+EQkh+clMTKO684JOif3UOAOfTYVp8
         takImPAZ1wy3eln5R07ONMaeLm4tiF9VhwLTiGeYARLXAUQVAYdrBVDe0Xls8tdMp4nh
         zhCoEG9XRfww4+5vcmfmEex1/Q3jxwU/w9Kl0=
MIME-Version: 1.0
In-Reply-To: <20091120150421.GC5872@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091118153227.GA5796@redhat.com>
	 <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <20091118225626.GA2974@redhat.com>
	 <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
	 <20091120141840.GA5872@redhat.com>
	 <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
	 <20091120150421.GC5872@redhat.com>
Date: Fri, 20 Nov 2009 19:32:28 +0100
Message-ID: <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 4:04 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 20, 2009 at 03:28:27PM +0100, Corrado Zoccolo wrote:
>> Hi Vivek,
>> On Fri, Nov 20, 2009 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi Corrado,
>> >
>> > I liked the idea of putting all the sync-noidle queues together in root
>> > group to achieve better throughput and implemeted a small patch.
>> >
>> > It works fine for random readers. But when I do multiple direct random writers
>> > in one group vs a random reader in other group, I am getting strange
>> > behavior. Random reader moves to root group as sync-noidle workload. But
>> > random writers are largely sync queues in remain in other group. But many
>> > a times also jump into root group and preempt random reader.
>>
>> can you try the attached patches?
>> They fix the problems you identified about no-idle preemption, and
>> deep seeky queues.
>> With those, you should not see this jumping any more.
>> I'll send them to Jens as soon has he comes back from vacation.
>>
>> Corrado
>>
>> > Anyway, with 4 random writers and 1 random reader running for 30 seconds
>> > in root group I get following.
>> >
>> > rw: 59,963KB/s
>> > rr: 66KB/s
>> >
>> > But if these are put in seprate groups test1 and test2 then
>> >
>> > rw: 30,587KB/s
>> > rr: 23KB/s
>> >
>
> I quickly tried your new patches to try to keep idling enabled on deep
> seeky sync queues so that it does not jump around too much and consume
> share both in sync workload and sync-noidle workload.
>
> Here are new results.
>
> Without cgroup.
>
> rw: 58,571KB/s
> rr: 83KB/s
>
> With cgroup:
>
> rw: 32,525KB/s
> rr: 25KB/s
>
> So without cgroup it looks like that random reader gained a bit and that's
> a good thing.

Great.
> With cgroup, problem still persists. I am wondering why both are loosing.
> Looks like I am idling somewhere otherwise at least one person should have
> gained.
With just 2 groups (one is the root), you can't be idling 50% of the
time. How is the disk utilization during the test?

Note that you can lose even if you're not idling enough.
How does this workload fare with noop or deadline?

Thanks
Corrado

>
> Thanks
> Vivek
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
