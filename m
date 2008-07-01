Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYGAVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYGAVlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYGAVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:41:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55050 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYGAVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:41:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>
	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>
	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org>
Date: Tue, 01 Jul 2008 14:39:27 -0700
In-Reply-To: <486A9D4F.8010508@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 01 Jul 2008 14:10:39 -0700")
Message-ID: <m1skutffn4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0284]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> I just looked and gcc does not use this technique for thread local data.
>>
>
> Which technique?

A section located at 0.
> It does assume you put the thread-local data near %gs (%fs in
> userspace), and it uses a small offset (positive or negative) to
> reach it.

Nope.  It achieves that affect with a magic set of relocations instead
of linker magic.

> At present, the x86-64 only uses %gs-relative addressing to reach the pda, which
> are always small positive offsets.  It always accesses per-cpu data in a
> two-step process of getting the base of per-cpu data, then offsetting to find
> the particular variable.
>
> x86-32 has no pda, and arranges %fs so that %fs:variable gets the percpu variant
> of variable.  The offsets are always quite large.

As a practical matter I like that approach (except for extra code size
of the offsets).

>> My initial concern about all of this was not making symbols section relative
>> is relieved as this all appears to be a 64bit arch thing where that doesn't
>> matter.
>>
>
> Why's that?  I thought you cared particularly about making the x86-64 kernel
> relocatable for kdump, and that using non-absolute symbols was part of that?

That is all true but unconnected.

For x86_64 the kernel lives at a fixed virtual address. So absolute or
non absolute symbols don't matter.  Only __pa and a little bit of code
in head64.S that sets up the intial page tables has to be aware of it.
So relocation on x86_64 is practically free.

For i386 since virtual address space is precious and because there were
concerns about putting code in __pa we actually relocate the kernel symbols
during load right after decompression.  When we do relocations absolute
symbols are a killer.

>> Has anyone investigated using the technique gcc uses for thread local storage?
>> http://people.redhat.com/drepper/tls.pdf
>>
>
> The powerpc guys tried using gcc-level thread-local storage, but it doesn't work
> well.  per-cpu data and per-thread data have different constraints, and its hard
> to tell gcc about them.  For example, if you have a section of preemptable code
> in your function, it's hard to tell gcc not to cache a "thread-local" variable
> across it, even though we could have switched CPUs in the meantime.

Yes, I completely agree with that.  It doesn't mean however that we
can't keep gcc ignorant and generate the same code manually.


>> In particular using the local exec model so we can say:
>> movq %fs:x@tpoff,%rax
>>
>> To load the contents of a per cpu variable x into %rax ?
>>
>> If we can use that model it should make it easier to interface with things
> like
>> the stack protector code.  Although we would still need to be very careful
>> about thread switches.
>>
>
> You mean cpu switches?  We don't really have a notion of thread-local data in
> the kernel, other than things hanging off the kernel stack.

Well I was thinking threads switching on a cpu having the kinds of problems you
described when it was tried on ppc.


Eric

