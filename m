Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYH2HQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYH2HQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYH2HQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:16:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:64281 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYH2HQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P/9a/ZkuXRRTYhqVbr2wCSsLlrZPdNXDS6hj/0b00RDJUPkipemMBdTZXoWpUU/cWQ
         vUTbK/IfeBpArqe4Ba619J/slI5bAZZ9s7QyV1nMgcyK+JKBCzZgE/l2KfIxvly1ZvSx
         7hINjKt8pw+vuFWzPtREUEdKzL/lgdRF37Zh8=
Message-ID: <86802c440808290016m6af6ecc7l52f5c7eca7f29a02@mail.gmail.com>
Date: Fri, 29 Aug 2008 00:16:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080829065812.GA28777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080829063012.GA19459@elte.hu>
	 <86802c440808282347n66a6dfb7r2bebd9f65918614a@mail.gmail.com>
	 <20080829065812.GA28777@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 11:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> >  BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
>> >  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>> >
>> > which overlaps with the chipset PCI BAR (hpet) resource:
>> >
>> >   pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
>> >
>> > so due to this 1K conflict we take the full e820-reserved entry out and
>> > give the range 0xfec00000-0x100000000 as 'free'.
>>
>> you will get
>> fec00000 - ffffffff reserved
>>    fed0000 - fed003ff hpet
>>      fed0000 - fed003ff 0000:00:14.0
>
> ok - because it's fully contained insert_resource() will succeed? I
> thought it would only succeed if the new resource was smaller than (a
> subset of) the existing resource. In the other direction, when a newly
> inserted resource is a superset of the existing resource, i thought we'd
> fail.
>
> hypothetical scenario, what if we had neither a superset nor a subset
> scenario, but a partial overlap, between:
>
>> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>
> and:
>
>> >   pci 0000:00:14.0: BAR has HPET at feb0f000-fec01000
>
> i.e. we have:
>
>      [... PCI BAR ...]
>            [... e820 reservation ...]
>
> in that case the insert_resource() will fail due to the conflict. Can we
> declare it in that case that the e820 reserved entry is mortally broken
> and we just ignore it?

yes, that will fail to insert ...

expand to 0xfeb0f000 - 0xfffffff and try again.?

may need to update insert_resource to return conflict resource ...

>
> At least we should emit a prominent warning if insert_resource() fails,
> and add in an mdelay(2000) so that the user sees it.
right

YH
