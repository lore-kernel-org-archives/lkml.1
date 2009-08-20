Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZHTNEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZHTNEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZHTNEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:04:47 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:36574 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZHTNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UFPpfFMMVwl9GXfqQrLm3wRiV11GAfZxXs3cSXQVAgOIZ9qvJanx0/avWwre1AB3hs
         R3GVP4cc6a3QoENZl+OY1GXmiwAVl6LEzQyxmQvnWGV1jcURoRfAFSFKx5RY679S+m2t
         vaPg4qRa7jFx/pm1PB2TeYV8crS+RMtxJnj1U=
Message-ID: <4A8D49F5.9090806@gmail.com>
Date: Thu, 20 Aug 2009 22:04:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, bzolnier@gmail.com,
       alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/6] Lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <20090820122212.GC6069@nowhere> <20090820124133.GL12579@kernel.dk>
In-Reply-To: <20090820124133.GL12579@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Aug 20 2009, Frederic Weisbecker wrote:
>> A idea to solve this:
>>
>> We could have one thread per struct work_struct.  Similarly to this
>> patchset, this thread waits for queuing requests, but only for this
>> work struct.  If the target cpu has no thread for this work, then
>> create one, like you do, etc...
>>
>> Then the idea is to have one workqueue per struct work_struct, which
>> handles per cpu task creation, etc... And this workqueue only handles
>> the given work.
>>
>> That may solve the deadlocks scenario that are often reported and lead
>> to dedicated workqueue creation.
>>
>> That also makes disappearing the work execution serialization between
>> different worklets. We just keep the serialization between same work,
>> which seems a pretty natural thing and is less haphazard than multiple
>> works of different natures randomly serialized between them.
>>
>> Note the effect would not only be a reducing of deadlocks but also
>> probably an increasing of throughput because works of different
>> natures won't need anymore to wait for the previous one completion.
>>
>> Also a reducing of latency (a high prio work that waits for a lower
>> prio work).
>>
>> There are good chances that we won't need any more per driver/subsys
>> workqueue creation after that, because everything would be per
>> worklet.  We could use a single schedule_work() for all of them and
>> not bother choosing a specific workqueue or the central events/%d
>>
>> Hmm?
> 
> I pretty much agree with you, my initial plan for a thread pool would be
> very similar. I'll gradually work towards that goal.

Several issues that come to my mind with the above approach are...

* There will still be cases where you need fixed dedicated thread.
  Execution resources for anything which might be used during IO needs
  to be preallocated (at least some of it) to guarantee forward
  progress.

* Depending on how popular works are used (and I think their usage
  will grow with improvements like this), we might end up with many
  idling threads again and please note that thread creation /
  destruction is quite costly compared to what works usually do.

* Having different threads executing different works all the time
  might improve latency but if works are used frequently enough it's
  likely to lower throughput because short works which can be handled
  in batch by a single thread now needs to be handled by different
  threads.  Scheduling overhead can be significant compared to what
  those works actually do and it will also cost much more cache
  footprint-wise.

Thanks.

-- 
tejun
