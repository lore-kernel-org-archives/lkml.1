Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYGIWmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYGIWmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYGIWl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:41:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38498 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYGIWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:41:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>
	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>
	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com>
	<m1r6a4c5im.fsf@frodo.ebiederm.org> <4874CD22.20502@sgi.com>
Date: Wed, 09 Jul 2008 15:38:50 -0700
In-Reply-To: <4874CD22.20502@sgi.com> (Mike Travis's message of "Wed, 09 Jul
	2008 07:37:22 -0700")
Message-ID: <m1k5fuof7p.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Very cool, thanks!!!  I will start using this.  (I have been using the trick
> to replace printk with early_printk so messages come out immediately instead
> of from the log buf.)

Just passing early_printk=xxx on the command line should have that effect.
Although I do admit you have to be a little bit into the boot before early_printk
is setup.

> I've been able to make some more progress.  I've gotten to a point where it
> panics from stack overflow.  I've verified this by bumping THREAD_ORDER and
> it boots fine.  Now tracking down stack usages.  (I have found a couple of new
> functions using set_cpus_allowed(..., CPU_MASK_ALL) instead of
> set_cpus_allowed_ptr(... , CPU_MASK_ALL_PTR).  But these are not in the calling
> sequence so subsequently are not the cause.

Is stack overflow the only problem you are seeing or are there still other mysteries?

> One weird thing is early_idt_handler seems to have been called and that's one
> thing our simulator does not mimic for standard Intel FSB systems - early
> pending
> interrupts.  (It's designed after all to mimic our h/w, and of course it's been
> booting fine under that environment.) 

That usually indicates you are taking an exception during boot not that you
have received an external interrupt.  Something like a page fault or a
division by 0 error.

> Only a few of these though I would think might get called early in
> the boot, that might also be contributing to the stack overflow.

Still the call chain depth shouldn't really be changing.  So why should it
matter?  Ah.  The high cpu count is growing cpumask_t so when you put
it on the stack.  That makes sense.  So what stars out as a 4 byte
variable on the stack in a normal setup winds up being a 1k variable
with 4k cpus.

> Oh yeah, I looked very closely at the differences in the assembler
> for vmlinux when compiled with 4.2.0 (fails) and 4.2.4 (which boots
> with the above mentioned THREAD_ORDER change) and except for some
> weirdness around ident_complete it seems to be the same code.  But
> the per_cpu variables are in a completely different address order.
> I wouldn't think that the -j10 for make could cause this but I can
> verify that with -j1.  But in any case, I'm sticking with 4.2.4 for
> now.

Reasonable.  The practical problem is you are mixing a lot of changes
simultaneously and it confuses things.  Compiling with NR_CPUS=4096
and working out the bugs from a growing cpumask_t, putting the per cpu
area in a zero based segment, and putting putting the pda into the
per cpu area all at the same time.

Who knows maybe the only difference between 4.2.0 and 4.2.4 is that
4.2.4 optimizes it's stack usage a little better and you don't see
a stack overflow.

It would be very very good if we could separate out these issues
especially the segment for the per cpu variables.  We need something
like that.

Eric
