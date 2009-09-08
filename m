Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZIHQbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZIHQbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZIHQbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:31:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZIHQbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:31:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=azMf5jnR2QZxEgM2MB/nmlwrSIZaPXOY+OQ5TaeXgbOW676bFMAQJ8VIUmqzZFyx7
	v+77WT4Jgp441cwxvJs3Q==
MIME-Version: 1.0
In-Reply-To: <20090908134244.GA15974@redhat.com>
References: <20090904231129.GA3689@redhat.com>
	 <20090907.200222.193693062.ryov@valinux.co.jp>
	 <4AA51065.6050000@redhat.com>
	 <20090908.120119.71095369.ryov@valinux.co.jp>
	 <20090908134244.GA15974@redhat.com>
Date: Tue, 8 Sep 2009 09:30:53 -0700
Message-ID: <e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
Subject: Re: Regarding dm-ioband tests
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, riel@redhat.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 6:42 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Tue, Sep 08, 2009 at 12:01:19PM +0900, Ryo Tsuruta wrote:
>> Hi Rik,
>>
>> Rik van Riel <riel@redhat.com> wrote:
>> > Ryo Tsuruta wrote:
>> >
>> > > However, if you want to get fairness in a case like this, a new
>> > > bandwidth control policy which controls accurately according to
>> > > assigned weights can be added to dm-ioband.
>> >
>> > Are you saying that dm-ioband is purposely unfair,
>> > until a certain load level is reached?
>>
>> Not unfair, dm-ioband(weight policy) is intentionally designed to
>> use bandwidth efficiently, weight policy tries to give spare bandwidth
>> of inactive groups to active groups.
>>
>
> This group is running a sequential reader. How can you call it an inactive
> group?
>
> I think that whole problem is that like CFQ you have not taken care of
> idling into account.

I think this is probably the key deal breaker. dm-ioband has no
mechanism to anticipate or idle for a reader task. Without such a
mechanism, a proportional division scheme cannot work for tasks doing
reads. Most readers do not send down more than one IO at a time, and
they do not send another until the previous one is complete.
Anticipation helps in this case, as we would wait for the task to send
down a new IO, before we expire its timeslice. Without anticipation,
we would serve the one IO from reader and then go on to serve IOs from
other tasks. When the reader would finally get around to sending next
IO, it would have to wait behind other IOs that have sent down in the
meanwhile.

IO schedulers in block layer have anticipation built into them, so a
proportional scheduling scheduling at that layer does not have to
repeat the logic or data structures for anticipation.

In fact, a rate limiting mechanism like dm-ioband can potentially
break the anticipation logic at IO schedulers, by queuing up the IOs
at an upper layer, while scheduler in block layer could have been
anticipating for it.

>
> Your solution seems to be designed only for processes doing bulk IO over
> a very long period of time. I think it limits the usefulness of solution
> severely.
>
>> > > We regarded reducing throughput loss rather than reducing duration
>> > > as the design of dm-ioband. Of course, it is possible to make a new
>> > > policy which reduces duration.
>> >
>> > ... while also reducing overall system throughput
>> > by design?
>>
>> I think it reduces system throughput compared to the current
>> implementation, because it causes more overhead to do fine grained
>> control.
>>
>> > Why are you even bothering to submit this to the
>> > linux-kernel mailing list, when there is a codebase
>> > available that has no throughput or fairness regressions?
>> > (Vivek's io scheduler based io controler)
>>
>> I think there are some advantages to dm-ioband. That's why I post
>> dm-ioband to the mailing list.
>>
>> - dm-ioband supports not only proportional weight policy but also rate
>>   limiting policy. Besides, new policies can be added to dm-ioband if
>>   a user wants to control bandwidth by his or her own policy.
>
> I think we can easily extent io scheduler based controller to also support
> max rate per group policy also. That should not be too hard. It is a
> matter of only keeping track of io rate per group and if a group is
> exceeding the rate, then schedule it out and move on to next group.

At Google, we have implemented a rate limiting mechanism on top of
Vivek's patches, and have been testing it. But I feel like the patch
set maintained by Vivek is pretty big already. Once we have those
patches merged, we can introduce more functionality.

>
> I can do that once proportional weight solution is stablized and gets
> merged.
>
> So its not an advantage of dm-ioband.
>
>> - The dm-ioband driver can be replaced without stopping the system by
>>   using device-mapper's facility. It's easy to maintain.
>
> We talked about this point in the past also. In io scheduler based
> controller, just move all the tasks to root group and you got a system
> not doing any io control.
>
> By the way why would one like to do that?
>
> So this is also not an advantage.
>
>> - dm-ioband can use without cgroup. (I remember Vivek said it's not an
>>   advantage.)
>
> I think this is more of a disadvantage than advantage. We have a very well
> defined functionality of cgroup in kernel to group the tasks. Now you are
> coming up with your own method of grouping the tasks which will make life
> even more confusing for users and application writers.
>
> I don't understand what is that core requirement of yours which is not met
> by io scheduler based io controller. range policy control you have
> implemented recently. I don't think that removing dm-ioband module
> dynamically is core requirement. Also whatever you can do with additional
> grouping mechanism, you can do with cgroup also.
>
> So if there is any of your core functionality which is not fulfilled by
> io scheduler based controller, please let me know. I will be happy to look
> into it and try to provide that feature. But looking at above list, I am
> not convinced that any of the above is a compelling argument for dm-ioband
> inclusion.
>
> Thanks
> Vivek
>
