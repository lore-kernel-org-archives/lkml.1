Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYG2QxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYG2QxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYG2Qw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:52:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20886 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYG2Qw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K7sggYeNbSivgFTqOaTFXU2kbD8TESsP71P1TRxX6c3gkWzBFATl1YFo4H/kJ/f5D/
         50OyjQOO/QZ6XM4rIcyloDe7SoM5RG3jBasXyj7iXv56aCowNCqKTNW2brfIEVrErC/w
         Y2s8kSzQrBMjOXolz67PekZFrORD8VKYJUWoc=
Message-ID: <b647ffbd0807290952h393e874by93873c3e6158c364@mail.gmail.com>
Date: Tue, 29 Jul 2008 18:52:53 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [patch, minor] workqueue: consistently use 'err' in __create_workqueue_key()
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080729161343.GA412@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217277694.20627.9.camel@earth> <20080729110250.GA177@tv-sign.ru>
	 <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com>
	 <20080729125201.GC177@tv-sign.ru> <20080729134456.GA355@tv-sign.ru>
	 <b647ffbd0807290720r3223461dt9d4f7f248e5e3c37@mail.gmail.com>
	 <20080729161343.GA412@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 Oleg Nesterov <oleg@tv-sign.ru>:
> On 07/29, Dmitry Adamushko wrote:
>>
>> 2008/7/29 Oleg Nesterov <oleg@tv-sign.ru>:
>> > On 07/29, Oleg Nesterov wrote:
>> >>
>> >> On 07/29, Dmitry Adamushko wrote:
>> >> >
>> >> > And I'd say this behavior (of having a partially-created object
>> >> > visible to the outside world) is not that robust. e.g. the
>> >> > aforementioned race would be eliminated if we place a wq on the global
>> >> > list only when it's been successfully initialized.
>> >>
>> >> Yes, we can change __create_workqueue_key() to check err == 0 before
>> >> list_add(),
>> >
>> > Well no, we can't do even this.
>> >
>> > Then we have another race with cpu-hotplug. Suppose we have CPUs 0, 1, 2.
>> > create_workqueue() fails to create cwq->thread for CPU 2 and calls
>> > destroy_workqueue(). Before it takes the cpu_add_remove_lock, _cpu_down()
>> > removes CPU 1 from cpu_populated_map, but since we didn't add this wq
>> > on the global list, cwq[1]->thread remains alive.
>> >
>> > destroy_workqueue() takes cpu_add_remove_lock, and calls
>> > cleanup_workqueue_thread() for CPUs 0 and 2. cwq[1]->thread is lost.
>>
>> Yes, I've actually seen this case and that's why I said "the cleanup
>> path in __create_workqueue_key() would need
>> to be altered" :-) likely, to the extent that it would not be a call
>> to destroy_workqueue() anymore.
>>
>> either something that only does
>>
>> for_each_cpu_mask_nr(cpu, *cpu_map)
>>           cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
>>
>>
>> and from the _same_ 'cpu_add_remove_lock' section which is used to
>> create a wq (so we don't drop a lock);
>
> Why should we duplicate the code?
>
>> _or_ do it outside of the locked section _but_ don't rely on
>> for_each_cpu_mask_nr(cpu, *cpu_map)... e.g. just delete all per-cpu
>> wq->cpu_wq structures that have been initialized (that's no matter if
>> their respective cpus are online/offline now).
>
> Yes. And this means we change the code to handle another special case:
> destroy() is called by create(). Why?
>
>> yes, maybe this cleanup path would not look all that fancy (but I
>> didn't try) but I do think that by not exposing "partially-initialized
>> object to the outside world" (e.g. cpu-hotplug events won't see them)
>> this code would become more straightforward and less prone to possible
>> errors/races.
>>
>> e.g. all these "create_workqueue_key() may race with cpu-hotplug" would be gone.
>
> Once again, from my pov wq is fully initialized. Yes, cwq->thread can
> be NULL or not, and this doesn't necessary match cpu_online_map. This
> is normal, for example CPU_POST_DEAD runs when CPU doesn't exists, but
> cwq[CPU]->thread is alive.
>
> With the current code we just have no special cases.
> I do not see
> why create_workqueue_key()->destroy_workqueue() should be special.

heh, any particular implementation is secondary. My point was about
logic/easy-to-analyse/less-prone-to-bugs-races thing (which can be
quite subjective indeed).

(ok, I'm repeating myself last time and then do go away and shut up
[chorus] yeah, go-go-go!!! [/chorus] :^))

>From my pov, if we fail in create_workqueue_key(), this wq is _not_
fully initialized, after all we are about to destroy it and report a
failure to user (yeah, and here out tastes seem to be incompatible ;-)

>From my pov, create_workqueue_key() is a bit illogical.
(we did fail to create a wq from the pov of user, so why cpu-hotplug
is allowed to mess with it while we are in-between 2 locked-sections
in create_workqueue_key()? -- that's just a door for possible fancy
bug/races, imho).

All in all, I think that "as is" now it's more _prone_ to potential
bugs/races and it's harder to analyse (hey, you've said "Damn. I had
this in mind when I wrote the code, but forgot" ;-)

anyway, by no means I say my taste is better or whatever. Just  an
opinion (moreover, of a person who has nothing to do with workqueue's
code so it can be happily ignored ;-)


>
> Oleg.
>

-- 
Best regards,
Dmitry Adamushko
