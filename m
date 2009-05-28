Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZE1SFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZE1SFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZE1SEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:04:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbZE1SEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:04:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lN5ThpYbu7uulDfPRss0bRHiFpILuV8GR9qUBXW+5sRaGvFmui8kFCvbBdkUqbq4E
	MpswMNzsLKgJWG4Twe04g==
MIME-Version: 1.0
In-Reply-To: <20090528165710.GB4335@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	 <1243377729-2176-16-git-send-email-vgoyal@redhat.com>
	 <20090528.182740.193697101.ryov@valinux.co.jp>
	 <20090528165710.GB4335@redhat.com>
Date: Thu, 28 May 2009 11:04:46 -0700
Message-ID: <e98e18940905281104t4099575bn6a20725c919061ba@mail.gmail.com>
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate 
	cgroup
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 9:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 28, 2009 at 06:27:40PM +0900, Ryo Tsuruta wrote:
>> Hi Vivek,
>>
>> > +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
>> > +   if (elv_bio_sync(bio)) {
>> > +           /* sync io. Determine cgroup from submitting task context. */
>> > +           cgroup = task_cgroup(current, io_subsys_id);
>> > +           return cgroup;
>> > +   }
>> > +
>> > +   /* Async io. Determine cgroup from with cgroup id stored in page */
>> > +   bio_cgroup_id = get_blkio_cgroup_id(bio);
>> > +
>> > +   if (!bio_cgroup_id)
>> > +           return NULL;
>> > +
>> > +   cgroup = blkio_cgroup_lookup(bio_cgroup_id);
>> > +#else
>> > +   cgroup = task_cgroup(current, io_subsys_id);
>> > +#endif
>> > +   return cgroup;
>> > +}
>>
>> There is a case where a kernel thread (such as device-mapper drivers)
>> submits a sync IO instead of a task which originates the IO. I think
>> you should always use get_blkio_cgroup_id() to determine cgroup.
>>
>
> Hi Ryo,
>
> Ok. Can you give some examples of drivers which are submitting reads in
> different context al-together. You mentioned in the past that dm-crypt
> looks like the one. How does current CFQ takes care of that. So if a
> BE prio 7 or an RT prio 0, task is submitting a READ, CFQ will not know it
> and it will put that READ in the queue of the READ submitting device
> mapper thread (may be BE prio 3 or 4)?
>
> Always determining the cgroup from bio, will make things slower at the
> same time complicated from the CFQ point of view. Right now cfq creates
> and caches the queue pointer in the io context of the bio submitting task
> and assumes sync requests are coming from that task/io context. Currently
> there can only be one sync queue associated with one context. So if a single
> thread is submitting reads (may be a worker thread) on behalf of other
> processes, then we loose the io context information. In fact currently we
> don't even carry ioprio and io class information in bio.
>
> So looks like we need to carry task io context information also in bio
> to be able to associate the bio to right queue at CFQ level. This makes
> it bit more complicated. For the time being I will keep it in my TODO
> list and handle it once other more severe problems have been taken care
> of.

>From what I remember, Fernando pointed out the same problem in LFS'09
(device mapper drivers submitting sync bio) for his motivation to
track io_context in bio. Fernando, what is the state the patch you
were working on?

>
> Thanks
> Vivek
>
