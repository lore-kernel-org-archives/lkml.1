Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZDPUZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZDPUZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDPUZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:25:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZDPUY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:24:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=o9JB1jj5/+L2aNl6rouHfNFrmeIryTUP52MU2CHHcPzuClnmIwGx8Kf6p5bppm0uU
	mh7ZzEI60bgopKvO6WkNw==
MIME-Version: 1.0
In-Reply-To: <20090416141125.GB8896@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	 <20090415043759.GA8349@redhat.com>
	 <20090415.223832.71125857.ryov@valinux.co.jp>
	 <20090416.114750.226794985.ryov@valinux.co.jp>
	 <20090416141125.GB8896@redhat.com>
Date: Thu, 16 Apr 2009 13:24:29 -0700
Message-ID: <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, fernando@oss.ntt.co.jp,
       linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
>> Hi Vivek,
>>
>> > General thoughts about dm-ioband
>> > ================================
>> > - Implementing control at second level has the advantage tha one does not
>> >   have to muck with IO scheduler code. But then it also has the
>> >   disadvantage that there is no communication with IO scheduler.
>> >
>> > - dm-ioband is buffering bio at higher layer and then doing FIFO release
>> >   of these bios. This FIFO release can lead to priority inversion problems
>> >   in certain cases where RT requests are way behind BE requests or
>> >   reader starvation where reader bios are getting hidden behind writer
>> >   bios etc. These are hard to notice issues in user space. I guess above
>> >   RT results do highlight the RT task problems. I am still working on
>> >   other test cases and see if i can show the probelm.

Ryo, I could not agree more with Vivek here. At Google, we have very
stringent requirement for latency of our RT requests. If RT requests
get queued in any higher layer (behind BE requests), all bets are off.
I don't find doing IO control at two layer for this particular reason.
The upper layer (dm-ioband in this case) would have to make sure that
RT requests are released immediately, irrespective of the state (FIFO
queuing and tokens held). And the lower layer (IO scheduling layer)
has to do the same. This requirement is not specific to us. I have
seen similar comments from filesystem folks here previously, in the
context of metadata updates being submitted as RT. Basically, the
semantics of RT class has to be preserved by any solution that is
build on top of CFQ scheduler.

>> >
>> > - dm-ioband does this extra grouping logic using dm messages. Why
>> >   cgroup infrastructure is not sufficient to meet your needs like
>> >   grouping tasks based on uid etc? I think we should get rid of all
>> >   the extra grouping logic and just use cgroup for grouping information.
>>
>> I want to use dm-ioband even without cgroup and to make dm-ioband has
>> flexibility to support various type of objects.
>
> That's the core question. We all know that you want to use it that way.
> But the point is that does not sound the right way. cgroup infrastructure
> has been created for the precise reason to allow arbitrary grouping of
> tasks in hierarchical manner. The kind of grouping you are doing like
> uid based, you can easily do with cgroups also. In fact I have written
> a pam plugin and contributed to libcg project (user space library) to
> put a uid's task automatically in a specified cgroup upon login to help
> the admin.
>
> By not using cgroups and creating additional grouping mechanisms in the
> dm layer I don't think we are helping anybody. We are just increasing
> the complexity for no reason without any proper justification. The only
> reason I have heard so far is "I want it that way" or "This is my goal".
> This kind of reasoning does not help.
>
>>
>> > - Why do we need to specify bio cgroup ids to the dm-ioband externally with
>> >   the help of dm messages? A user should be able to just create the
>> >   cgroups, put the tasks in right cgroup and then everything should
>> >   just work fine.
>>
>> This is because to handle cgroup on dm-ioband easily and it keeps the
>> code simple.
>
> But it becomes the configuration nightmare. cgroup is the way for grouping
> tasks from resource management perspective. Please use that and don't
> create additional ways of grouping which increase configuration
> complexity. If you think there are deficiencies in cgroup infrastructure
> and it can't handle your case, then please enhance cgroup infrstructure to
> meet that case.
>
>>
>> > - Why do we have to put another dm-ioband device on top of every partition
>> >   or existing device mapper device to control it? Is it possible to do
>> >   this control on make_request function of the reuqest queue so that
>> >   we don't end up creating additional dm devices? I had posted the crude
>> >   RFC patch as proof of concept but did not continue the development
>> >   because of fundamental issue of FIFO release of buffered bios.
>> >
>> >     http://lkml.org/lkml/2008/11/6/227
>> >
>> >   Can you please have a look and provide feedback about why we can not
>> >   go in the direction of the above patches and why do we need to create
>> >   additional dm device.
>> >
>> >   I think in current form, dm-ioband is hard to configure and we should
>> >   look for ways simplify configuration.
>>
>> This can be solved by using a tool or a small script.
>>
>
> libcg is trying to provide generic helper library so that all the
> user space management programs can use it to control resource controllers
> which are using cgroup. Now by not using cgroup, an admin shall have to
> come up with entirely different set of scripts for IO controller? That
> does not make too much of sense.
>
> Please also answer rest of the question above. Why do we need to put
> additional device mapper device on every device we want to control and
> why can't we do it by providing a hook into make_request function of
> the queue and not putting additional device mapper device.
>
> Why do you think that it will not turn out to be a simpler approach?
>
>> > - I personally think that even group IO scheduling should be done at
>> >   IO scheduler level and we should not break down IO scheduling in two
>> >   parts where group scheduling is done by higher level IO scheduler
>> >   sitting in dm layer and io scheduling among tasks with-in groups is
>> >   done by actual IO scheduler.
>> >
>> >   But this also means more work as one has to muck around with core IO
>> >   scheduler's to make them cgroup aware and also make sure existing
>> >   functionality is not broken. I posted the patches here.
>> >
>> >     http://lkml.org/lkml/2009/3/11/486
>> >
>> >   Can you please let us know that why does IO scheduler based approach
>> >   does not work for you?
>>
>> I think your approach is not bad, but I've made it my purpose to
>> control disk bandwidth of virtual machines by device-mapper and
>> dm-ioband.
>
> What do you mean by "I have made it my purpose"? Its not about that
> I have decided to do something in a specific way and I will do it
> only that way.
>
> I think open source development is more about that this is the problem
> statement and we discuss openly and experiment with various approaches
> and then a approach which works for most of the people is accepted.
>
> If you say that providing "IO control infrastructure in linux kernel"
> is my goal, I can very well relate to it. But if you say providng "IO
> control infrastructure only through dm-ioband, only through device-mapper
> infrastructure" is my goal, then it is hard to digest.
>
> I also have same concern and that is control the IO resources for
> virtual machines. And IO schduler modification based approach as as well as
> hooking into make_request function approach will achive the same
> goal.
>
> Here we are having a technical discussion about interfaces and what's the
> best way do that. And not looking at other approches and not having an
> open discussion about merits and demerits of all the approaches and not
> willing to change the direction does not help.
>
>> I think device-mapper is a well designed system for the following
>> reasons:
>>  - It can easily add new functions to a block device.
>>  - No need to muck around with the existing kernel code.
>
> Not touching the core code makes life simple and is an advantage.  But
> remember that it comes at a cost of FIFO dispatch and possible unwanted
> scnerios with underlying ioscheduoer like CFQ. I already demonstrated that
> with one RT example.
>
> But then hooking into make_request_function will give us same advantage
> with simpler configuration and there is no need of putting extra dm
> device on every device.
>
>>  - dm-devices are detachable. It doesn't make any effects on the
>>    system if a user doesn't use it.
>
> Even wth make_request approach, one could enable/disable io controller
> by writing 0/1 to a file.
>
> So why are you not open to experimenting with hooking into make_request
> function approach and try to make it work? It would meet your requirements
> at the same time achive the goals of not touching the core IO scheduler,
> elevator and block layer code etc.? It will also be simple to
> enable/disable IO control. We shall not have to put additional dm device
> on every device. We shall not have to come up with additional grouping
> mechanisms and can use cgroup interfaces etc.
>
>> So I think dm-ioband and your IO controller can coexist. What do you
>> think about it?
>
> Yes they can. I am not against that. But I don't think that dm-ioband
> currently is in the right shape for various reasons have been citing
> in the mails.
>
>>
>> >   Jens, it would be nice to hear your opinion about two level vs one
>> >   level conrol. Do you think that common layer approach is the way
>> >   to go where one can control things more tightly or FIFO release of bios
>> >   from second level controller is fine and we can live with this additional       serialization in the layer above just above IO scheduler?
>> >
>> > - There is no notion of RT cgroups. So even if one wants to run an RT
>> >   task in root cgroup to make sure to get full access of disk, it can't
>> >   do that. It has to share the BW with other competing groups.
>> >
>> > - dm-ioband controls amount of IO done per second. Will a seeky process
>> >   not run away more disk time?
>>
>> Could you elaborate on this? dm-ioband doesn't control it per second.
>>
>
> There are two ways to view fairness.
>
> - Fairness in terms of amount of sectors/data transferred.
> - Fairness in terms of disk access time one gets.
>
> In first case, if there is a seeky process doing IO, it will run away
> with lot more disk time than a process doing sequential IO. Some people
> consider it unfair and I think that's the reason CFQ provides fairness
> in terms of disk time slices and not in terms of number of sectors
> transferred.
>
> Now with any two level of scheme, at higher layer only easy way to
> provide fairness is in terms of secotrs transferred and underlying
> CFQ will be working on providing fairness in terms of disk slices.
>
> Thanks
> Vivek
>
>> >   Additionally, at group level we will provide fairness in terms of amount
>> >   of IO (number of blocks transferred etc) and with-in group cfq will try
>> >   to provide fairness in terms of disk access time slices. I don't even
>> >   know whether it is a matter of concern or not. I was thinking that
>> >   probably one uniform policy on the hierarchical scheduling tree would
>> >   have probably been better. Just thinking loud.....
>> >
>> > Thanks
>> > Vivek
>>
>> Thanks,
>> Ryo Tsuruta
>
