Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882Ab0AKTJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0AKTJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274Ab0AKTJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:09:40 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:53650 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0AKTJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ATeVyENdHRiTmfElp93rjweeiViTfpvNjNUt8ddm+TrxtmLjP1Jq+uVW37osVz8x4c
         DxYyKSc/BxKW4ehFCTqfd8qv7DM94DegN2gmqjo/kGdMEyXT6w3yCHrRajnb464Heb3D
         ZNYxthvp1z3kX8qrG9Jp8bPJJ6kBx48nXaEfs=
MIME-Version: 1.0
In-Reply-To: <20100111171149.GE22899@redhat.com>
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	 <1263157461-12294-1-git-send-email-czoccolo@gmail.com>
	 <4B4B0AA9.5020900@garzik.org>
	 <4e5e476b1001110426t2afa0502p7f19a9b24e48ba82@mail.gmail.com>
	 <20100111131317.GB4489@kernel.dk> <4B4B250D.8020205@garzik.org>
	 <4e5e476b1001110653x397a8008gfea2f62497be1f42@mail.gmail.com>
	 <20100111164433.GB22899@redhat.com>
	 <4e5e476b1001110900v579054cam246775a74cf1e854@mail.gmail.com>
	 <20100111171149.GE22899@redhat.com>
Date: Mon, 11 Jan 2010 20:09:37 +0100
Message-ID: <4e5e476b1001111109l34f1398dha2f369cdd525596d@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 6:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Jan 11, 2010 at 06:00:51PM +0100, Corrado Zoccolo wrote:
>> On Mon, Jan 11, 2010 at 5:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Mon, Jan 11, 2010 at 03:53:00PM +0100, Corrado Zoccolo wrote:
>> >> On Mon, Jan 11, 2010 at 2:18 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> >> > On 01/11/2010 08:13 AM, Jens Axboe wrote:
>> >> >>
>> >> >> On Mon, Jan 11 2010, Corrado Zoccolo wrote:
>> >> >>>
>> >> >>> On Mon, Jan 11, 2010 at 12:25 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>> >> >>>>
>> >> >>>> On 01/10/2010 04:04 PM, Corrado Zoccolo wrote:
>> >> >>>>>
>> >> >>>>> NCQ SSDs' performances are not affected by
>> >> >>>>> distance of read requests, so there is no point in having
>> >> >>>>> overhead to merge such queues.
>> >> >>>>>
>> >> >>>>> Non-NCQ SSDs showed regression in some special cases, so
>> >> >>>>> they are ruled out by this patch.
>> >> >>>>>
>> >> >>>>> This patch intentionally doesn't affect writes, so
>> >> >>>>> it changes the queued[] field, to be indexed by
>> >> >>>>> READ/WRITE instead of SYNC/ASYNC, and only compute proximity
>> >> >>>>> for queues with WRITE requests.
>> >> >>>>>
>> >> >>>>> Signed-off-by: Corrado Zoccolo<czoccolo@gmail.com>
>> >> >>>>
>> >> >>>> That's not really true.  Overhead always increases as the total number
>> >> >>>> of
>> >> >>>> ATA commands issued increases.
>> >> >>>
>> >> >>> Jeff Moyer tested the patch on the workload that mostly benefit of
>> >> >>> queue merging, and found that
>> >> >>> the performance was improved by the patch.
>> >> >>> So removing the CPU overhead helps much more than the marginal gain
>> >> >>> given by merging on this hardware.
>> >> >>
>> >> >> It's not always going to be true. On SATA the command overhead is fairly
>> >> >> low, but on other hardware that may not be the case. Unless you are CPU
>> >> >> bound by your IO device, then merging will always be beneficial. I'm a
>> >> >> little behind on emails after my vacation, Jeff what numbers did you
>> >> >> generate and on what hardware?
>> >> >
>> >> >  ...and on what workload?   "the workload that mostly benefit of queue
>> >> > merging" is highly subjective, and likely does not cover most workloads SSDs
>> >> > will see in the field.
>> >> Hi Jeff,
>> >> exactly.
>> >> The workloads that benefits from queue merging are the ones in which a
>> >> sequential
>> >> read is actually splitt, and carried out by different processes in
>> >> different I/O context, each
>> >> sending requests with strides. This is clearly not the best way of
>> >> doing sequential access
>> >> (I would happily declare those programs as buggy).
>> >> CFQ has code that merges queues in this case. I'm disabling the READ
>> >> part for NCQ SSDs,
>> >> since, as Jeff measured, the code overhead outweight the gain from
>> >> merging (if any).
>> >
>> > Hi Corrado,
>> >
>> > In Jeff's test case of running read-test2, I am not even sure if any
>> > merging between the queues took place or not as on NCQ SSD, we are driving
>> > deeper queue depths and unless read-test2 is creating more than 32
>> > threads, there might not be any merging taking place at all.
>>
>> Jeff's test was modeled after real use cases: widely used, legacy
>> programs like dump.
>> Since we often said that splitting the sequential stream in multiple
>> threads was not the
>> correct approach, and we did introduce the change in the kernel just
>> to support those
>> programs (not to encourage writing more of this league), we can assume
>> that if they
>> do not drive deeper queues, no one will. So the overhead is just
>> overhead, and will never
>> give any benefit.
>
> Two things come to mind.
>
> - Even if dump/read-test2 is not driving deeper queue depths, but other
>  competing programs might be driving deeper queue depths, which can give
>  queue merging opportunity in case of dump program on NCQ SSD.

Correct. We need a better test to determine if those merges can happen.

>
> - If we are thinking that on NCQ SSD we practically don't have queue
>  merging opportunity then there is no point in keeping it enabled for
>  WRITES also?

Probably. Needs test here, too.

Corrado


>
> Vivek
>
>>
>> I therefore want to remove it, since for SSD it matters.
>> >
>> > We also don't have any data/numbers what kind of cpu savings does this
>> > patch bring in.
>>
>> Jeff's test showed larger bandwidth with merge disabled, so it implies
>> some saving is present.
>>
>> Thanks,
>> Corrado
>>
>> >
>> > Vivek
>> >
>> >>
>> >> As you said, most workloads don't benefit from queue merging. On those
>> >> ones, the patch
>> >> just removes an overhead.
>> >>
>> >> Thanks,
>> >> Corrado
>> >>
