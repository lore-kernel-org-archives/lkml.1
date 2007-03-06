Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCFOkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCFOkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965883AbXCFOkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:40:15 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51256 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965105AbXCFOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:40:13 -0500
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use a zero-size array in the struct devres
References: <20070306095241.28180.76390.stgit@localhost.localdomain>
	<45ED6221.5090003@gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 06 Mar 2007 14:40:06 +0000
In-Reply-To: <45ED6221.5090003@gmail.com> (Tejun Heo's message of "Tue, 06
 Mar 2007 21:44:17 +0900")
Message-ID: <tnx649emo55.fsf@arm.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2007 14:40:07.0593 (UTC) FILETIME=[55E73990:01C75FFD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

Tejun Heo <htejun@gmail.com> wrote:
> Catalin Marinas wrote:
>> Commit 9ac7849e35f705830f7b016ff272b0ff1f7ff759 adds the devres
>> structure containing a flexible unsigned long long array, with a
>> comment about the guaranteed alignment. According to the gcc manual,
>> flexible arrays are considered incomplete types and it is an error to
>> ask for their alignment. This patch makes data[] a zero-size array.
>
> The gcc manual says nothing about alignment.  What it says is sizeof()
> doesn't work.  If flexible array doesn't honor the alignment of the
> declared type, it would be useless for its designed purpose of
> supporting *array* of dynamically-determined length.

Chapter 5.31 (http://gcc.gnu.org/onlinedocs/gcc/Alignment.html) states
that "it is an error to ask for the alignment of an incomplete type"
and flexible array members have incomplete type (according to ISO C99
as described in http://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html).

It sounds to me like the alignment of an incomplete type is not
guaranteed (as you can't even enquire about it, though I might be
wrong). This is probably dependent on the compiler as well - with
gcc-3.3 on x86, __alignof__(unsigned long long) is 8 but the
"offsetof(struct test, data)" below is 12 (and it doesn't make any
difference whether it is a 0-size array or not):

struct test {
    unsigned long a;
    unsigned long b;
    unsigned long c;
    unsigned long long data[];
};

>> I came across this when trying to build kmemleak as the modified
>> container_of macro tries to get the size of the devres.data member and
>> sizeof cannot be applied to incomplete types.
>
> If kmemleak's container_of cannot deal with the current struct devres,
> it means it can't deal with flexible arrays at all.  Flexible array
> being the standard as opposed to 0 size array gcc extension, I guess a
> lot of people would prefer flexible array.

I'm OK with flexible arrays (kmemleak uses them as well) but not as a
member of structure getting passed to the container_of macro.

I did a quick grep through the kernel and it looks like Linux mainly
uses 0-size rather than flexible arrays at the end of a structure
(>500 vs ~14). This might be for historical reasons but it's not a big
issue in modifying them.

> It would be best if kmemleak's container_of can be modified to work with
> flexible arrays.  If that's not possible, I guess it needs wider
> discussion to determine whether to ditch flexible array for
> kmemleak.

Kmemleak needs the sizeof the member passed to container_of and I'm
not aware of any __builtin_* predicate that would detect incomplete
types.

-- 
Catalin
