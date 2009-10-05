Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZJEIw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZJEIw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZJEIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:52:25 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62894 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbZJEIwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QBA5750qs0toFAzaF5GtLoRb7SAWJhJ6TCUhd3G7rMNPPeW/LBCIwbH8dB76Mx8sq1
         SWwNrn3Vl6xG9CdXCWPLTvXDxzObLA3RQm4BV0NNTVEDhzY2AnZ8f+PgRu2GSRn5ZtBx
         FxCD4QJAfrJezXSN7L3ZHFzWBg34h8HGLfcNU=
MIME-Version: 1.0
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
	 <4AC990E1.7030708@jp.fujitsu.com>
Date: Mon, 5 Oct 2009 10:51:46 +0200
Message-ID: <c62985530910050151u78b46fa4l6ec0184f4f75be27@mail.gmail.com>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/5 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> Hi Huang,
>
> Huang Ying wrote:
>> Current MCE log ring buffer has following bugs and issues:
>>
>> - On larger systems the 32 size buffer easily overflow, losing events.
>>
>> - We had some reports of events getting corrupted which were also
>>   blamed on the ring buffer.
>>
>> - There's a known livelock, now hit by more people, under high error
>>   rate.
>>
>> We fix these bugs and issues via making MCE log ring buffer as
>> lock-less per-CPU ring buffer.
>
> Now I have a real problem on the small MCE log buffer on my new large
> system with Nehalem which has many cpus/banks in one socket...
> So I'd like to solve the problem asap.  I think this problem might block
> some distros to support new processor.
>
> Last week I reviewed your patch again and noticed that it is doing a lot
> of changes at once.  I suppose that this method must be one of reasons
> why your patch seems to be so hard to review, and why it is taking long
> time to be accepted by x86 maintainers.
>
> Fortunately I had some spare time so I carefully broke your patch into
> some purpose-designed pieces.  It would be the most significant change
> that now there are 2 steps to convert the buffer structure - 1) to make
> it per-CPU and 2) to make it ring buffer.
>
> Also I fixed some problem in your patch, found on the way to make this
> patch set.  I'll explain about my changes later using diff from your
> change.  Comments are welcomed.
>
> Thanks,
> H.Seto
>


Looks like the conversion of MCE log into a TRACE_EVENT is still in
discussion whereas the
current issues are urgent.

So the need is to have a more stable ring buffer. But this one is an ad-hoc one.
We already have a general purpose per-cpu/lockless ring buffer implementation in
kernel/trace/ring_buffer.c
And it's not only used by tracing, it's generally available.

I think it would be nicer to use it to avoid a proliferation of
unstable ring buffers
inside the kernel.
