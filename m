Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZG3QRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZG3QRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZG3QRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:17:40 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:50569 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZG3QRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=vr6J6kS+zVoaMPP15qpA32QKXtP/PTe4wyjUIxL3BGAtM+txMlWlAX90nQL+vTTBrM
         Xcy3wizek8/UpCV9J9KdiJbbBhywnx2iRGrDO5VLx/zgNU90w3oD1BUlTe4WOWMmOvxX
         57sNJ5GJiUMLy/lALrn7eZoO96ZZihNP5o9CY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1248963211.6391.45.camel@twins>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622114931.GB24366@elte.hu> <20090622125837.GA9429@infradead.org>
	 <1247482393.7529.74.camel@twins>
	 <7c86c4470907300658j62410f05k1ac66eefe866780d@mail.gmail.com>
	 <1248963211.6391.45.camel@twins>
Date: Thu, 30 Jul 2009 18:17:38 +0200
Message-ID: <7c86c4470907300917s5d3f2bf0iefe333cefc08c7fa@mail.gmail.com>
Subject: Re: I.1 - System calls - ioctl
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 4:13 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Thu, 2009-07-30 at 15:58 +0200, stephane eranian wrote:
>> On Mon, Jul 13, 2009 at 12:53 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>> > On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
>> >> But talking about syscalls the sys_perf_counter_open prototype is
>> >> really ugly - it uses either the pid or cpu argument which is a pretty
>> >> clear indicator it should actually be two sys calls.
>> >
>> > Would something like the below be any better?
>> >
>> > It would allow us to later add something like PERF_TARGET_SOCKET and
>> > things like that.
>>
>> One thing for sure, you need to provision for future targets, SOCKET
>> is an obvious
>> one. But given that your goal is to have a generic API, not just for
>> CPU PMU, then you
>> need to be able to add new targets, e.g., socket, chipset, GPU. The
>> current model with
>> pid and cpu is too limited, relying on flags to add more parameters
>> for a target is not pretty.
>>
>> Given that an event can only be attached to a single target at a time, it seems
>> you could either do:
>>    - encapsulate target type + target into a struct and pass that.
>> This is your proposal here.
>
> *nod*
>
>>    - add a generic int target parameter and pass the target type in flags
>
> This would mean reserving a number of bits in the flags field for this
> target id. We can do that, I figure 8 should do.. (640kb should be
> enough comes to mind though :-).
>
I meant:

long sys_perf_counter_open(
       struct perf_counter_attr *attr,
       int target,
       int group_fd,
       unsigned long flags);

If you reserve 8 bits in flags, that gives you 256 types of targets,
given that you can only measure an event on one target.

The target "name" would be passed in target.

per-thread: (self-monitoring)
          sys_perf_counter_open(&attr, getpid(), 0, 0);

cpu-wide: (monitored CPU1)
         sys_perf_counter_open(&attr, 1, 0, PERF_TARGET_CPU);

socket-wide: (socket 2)
         sys_perf_counter_open(&attr, 2, 0, PERF_TARGET_SOCKET);

I also suspect you can get by with fewer than 8 bits for the type of target.

Because in this scheme, part of flags would not be treated as bitmask
but rather bitfield, it may be better to just separate this target bitfield
like in:

long sys_perf_counter_open(
       struct perf_counter_attr *attr,
       enum perf_target_type  target_type,
       int target_id,
       int group_fd,
       unsigned long flags);

Which is what you had, except without the struct.

Then, it boils down to whether expressing a target id in 32 bits is enough.
Obviously, 64-bit would be the safest but then I understand this causes issues
on 32-bit systems.


>>    - provide one syscall per target type (seems to be Hellwig's)
>>
>> Your scheme makes it possible to pass 64-bit target id. Not clear if
>> this is really needed.
>
> Yeah, not sure either, pids, fds and similar are all 32bit iirc. We do
> have 64bit resource ids but that's for things like inodes, and I'm not
> sure it'd make sense to attach a counter to an inode :-)
>
>
>
