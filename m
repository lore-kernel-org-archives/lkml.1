Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYH2Hwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYH2Hwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYH2Hwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:52:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:5382 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYH2Hwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EuJy9cffm9mKRdc5JYSvGJBcvbeqpIL5G2trlrDx0urnVNjNgP0xitLI6EQsxQS+01
         +dgg4loVt9i31U97WkqQliJq3cWqEg4WPEKn1ULnzr20wyCIz0DqoRWnkLcoawbImXEy
         8s8epT1fQ7OqdvnzVnqKIcrTW58K/FIa0Bf2s=
Message-ID: <86802c440808290052i609134b6nced5cf957e0197b7@mail.gmail.com>
Date: Fri, 29 Aug 2008 00:52:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080829072833.GA9232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080829063012.GA19459@elte.hu>
	 <86802c440808282347n66a6dfb7r2bebd9f65918614a@mail.gmail.com>
	 <20080829065812.GA28777@elte.hu>
	 <86802c440808290016m6af6ecc7l52f5c7eca7f29a02@mail.gmail.com>
	 <20080829072833.GA9232@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Thu, Aug 28, 2008 at 11:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >
>> >> >  BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
>> >> >  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>> >> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>> >> >
>> >> > which overlaps with the chipset PCI BAR (hpet) resource:
>> >> >
>> >> >   pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
>> >> >
>> >> > so due to this 1K conflict we take the full e820-reserved entry out and
>> >> > give the range 0xfec00000-0x100000000 as 'free'.
>> >>
>> >> you will get
>> >> fec00000 - ffffffff reserved
>> >>    fed0000 - fed003ff hpet
>> >>      fed0000 - fed003ff 0000:00:14.0
>> >
>> > ok - because it's fully contained insert_resource() will succeed? I
>> > thought it would only succeed if the new resource was smaller than (a
>> > subset of) the existing resource. In the other direction, when a newly
>> > inserted resource is a superset of the existing resource, i thought we'd
>> > fail.
>> >
>> > hypothetical scenario, what if we had neither a superset nor a subset
>> > scenario, but a partial overlap, between:
>> >
>> >> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>> >
>> > and:
>> >
>> >> >   pci 0000:00:14.0: BAR has HPET at feb0f000-fec01000
>> >
>> > i.e. we have:
>> >
>> >      [... PCI BAR ...]
>> >            [... e820 reservation ...]
>> >
>> > in that case the insert_resource() will fail due to the conflict. Can we
>> > declare it in that case that the e820 reserved entry is mortally broken
>> > and we just ignore it?
>>
>> yes, that will fail to insert ...
>>
>> expand to 0xfeb0f000 - 0xfffffff and try again.?
>>
>> may need to update insert_resource to return conflict resource ...
>
> yes, that sounds an excellent idea - i was thinking of something
> muchmore complex like breaking up the reserved entry - but indeed just
> creating a large enough superset should be perfect. I.e. extend both
> start and end until we fit fully. [or reach some natural boundary such
> as 0 or 4GB]
>
>> > At least we should emit a prominent warning if insert_resource() fails,
>> > and add in an mdelay(2000) so that the user sees it.
>>
>> right
>
> btw., perhaps we should try this: first try a request_resource(). If
> that fails it means we overlap with something - then we should already
> printk a warning. (e820 reserved entries should never conflict with PCI
> resources, should they?)
>
> then try an insert_resource(). If that too fails it means a partial
> overlap - printk another warning. Try the extension (within reasonable
> limits) and retry.
>
> Does that sound worthwile?

request_resource should always fail at that case, because we are using
iomem_resource at first parent...

YH
