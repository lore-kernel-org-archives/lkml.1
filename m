Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZJNTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZJNTMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZJNTMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:12:19 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:36659 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZJNTMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PBEsRQLdI/ryAMp2KEK/o8YGzgNyD2e8+SxFRn4uNLKFQsxXkfiAIacDeWJdxK0cHB
         BEeOXIvc6tyZz5eMQd7UvvVgqZQVh4r4lQ2UhoU33Ti0sR+sGn1zteuzBhlu6+6ccNxc
         zt7hprOtVK6fx5OUoew4k3EqDz/qcUO2qTdcM=
MIME-Version: 1.0
In-Reply-To: <4AD60CD1.4000804@s5r6.in-berlin.de>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
	 <20091014101336.GA25108@redhat.com>
	 <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
	 <4AD60CD1.4000804@s5r6.in-berlin.de>
Date: Thu, 15 Oct 2009 00:41:42 +0530
Message-ID: <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 11:09 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On 10/14/2009 12:24 PM, Leonidas . wrote:
>> On Wed, Oct 14, 2009 at 3:13 AM, Gleb Natapov <gleb@redhat.com> wrote:
>>> On Wed, Oct 14, 2009 at 02:21:22AM -0700, Leonidas . wrote:
>>>> On Tue, Oct 13, 2009 at 11:36 PM, Leonidas . <leonidas137@gmail.com> wrote:
>>>> > Hi List,
>>>> >
>>>> > I am working on a profiler kind of module, the exported apis of my module can be
>>>> > called from process context and interrupt context as well. Depending on the
>>>> > context I am called in, I need to call sleepable/nonsleepable variants
>>>> > of my internal bookkeeping functions.
>>>> >
>>>> > I am aware of in_interrupt() call which can be used to check current
>>>> > context and take action accordingly.
>>>> >
>>>> > Is there any api which can help figure out whether we are executing while hold a spinlock? I.e
>>>> > an api which can help figure out sleepable/nonsleepable context? If it is not there, what can
>>>> > be done for writing the same? Any pointers will be helpful.
> [...]
>>>>   While searching through the sources, I found this,
>>>>
>>>>   97/*
>>>>   98 * Are we running in atomic context?  WARNING: this macro cannot
>>>>   99 * always detect atomic context; in particular, it cannot know about
>>>>  100 * held spinlocks in non-preemptible kernels.  Thus it should not be
>>>>  101 * used in the general case to determine whether sleeping is possible.
>>>>  102 * Do not use in_atomic() in driver code.
>>>>  103 */
>>>>  104#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
>>>>  105
>>>>
>>>> this just complicates the matter, right? This does not work in general case but I think this
>>>> will always work if the kernel is preemptible.
>>>>
>>>> Is there no way to write a generic macro?
> [...]
>>> Attached patch make in_atomic() to work for non-preemptable kernels too.
>>> Doesn't look to big or scary.
>>>
>>> Disclaimer: tested only inside kvm guest 64bit, haven't measured overhead.
> [...]
>> Unbelievable! I was just thinking about the logic to achieve the same, and
>> someone has already done this. Thanks for the patch.
>
> I don't know whether Gleb's patch works or doesn't work as you require
> it.  But my opinion is that the recommendation "do not use in_atomic()
> in driver code" is valid nevertheless.
>
> Very often the better course of action is to change your API from
>
> void my_routine()
> {
>        if (in_atomic())
>                this;
>        else
>                that;
> }
>
> to either
>
> void my_routine(bool can_sleep)
> {
>        if (!can_sleep)
>                this;
>        else
>                that;
> }
>
> or to
>
> void my_routine_atomic()
> {
>        this;
> }
>
> void my_routine()
> {
>        that;
> }
>
> In other words, let the caller of your routine tell it whether it's
> atomic context or not.
>
> Instead of a "bool can_sleep" argument, a "gfp_t flags" argument is
> often used.
>
> Or provide only the my_routine_atomic() variant if the difference to the
> sleeping variant isn't huge.
> --
> Stefan Richter
> -=====-==--= =-=- -===-
> http://arcgraph.de/sr/
>


I agree with you and earlier consensus on list about the atomic and
non-atomic variants.

The issue with my code, as I have explained briefly earlier in the
same thread is as
follows:

My apis can be inserted at any place in this code by user. I have no
control over this
part except telling user to call atomic/non-atomic apis depending on
the context.

What makes it more complicated is this, the user might achieve the
functionality via instrumenting his source code, i.e. something like
using -finstrument flag of gcc. As per above inferences about
in_atomic(), in case of instrumentation there is no choice other than
providing all apis as atomic apis, this might not be the right thing
to do under all circumstances. Especially, for my code since I do lot
of allocations for book keeping.

I am not aware of any Linux kernel module which can comply to this
kind of use case, what would be the most optimal thing to do here?

-Leo.
