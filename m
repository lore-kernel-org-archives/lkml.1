Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYGJAMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYGJAMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYGJAL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:11:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32938 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYGJAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:11:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>
	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>
	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com>
	<m1r6a4c5im.fsf@frodo.ebiederm.org> <4874CD22.20502@sgi.com>
	<m1k5fuof7p.fsf@frodo.ebiederm.org> <48754A08.1060302@sgi.com>
Date: Wed, 09 Jul 2008 17:04:33 -0700
In-Reply-To: <48754A08.1060302@sgi.com> (Mike Travis's message of "Wed, 09 Jul
	2008 16:30:16 -0700")
Message-ID: <m1mykqfvu6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4586]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> What I meant was using early_printk in place of printk, which seems to stuff the
> messages into the log buf until the serial console is setup fairly late in
> start_kernel.
> I did this by removing printk() and renaming early_printk() to be printk (and a
> couple
> other things like #define early_printk printk ...

Last I looked after the magic early_printk setup.  printk calls early_printk
and stuff messages in the log buffer.

It matters little though.  As long as you get the print messages.  Weird
cases where you don't get into C code worry me much more.

Once you get into C things are much easier to track.

>> Is stack overflow the only problem you are seeing or are there still other
> mysteries?
>
> I'm not entirely sure it's a stack overflow, the fault has a NULL dereference
> and
> then the stack overflow message.

Ok.  Interesting.

>>> Only a few of these though I would think might get called early in
>>> the boot, that might also be contributing to the stack overflow.
>> 
>> Still the call chain depth shouldn't really be changing.  So why should it
>> matter?  Ah.  The high cpu count is growing cpumask_t so when you put
>> it on the stack.  That makes sense.  So what stars out as a 4 byte
>> variable on the stack in a normal setup winds up being a 1k variable
>> with 4k cpus.
>
> Yes, it's definitely the three related:
>
> NR_CPUS Patch_Applied THREAD_ORDER Results
>   256        NO           1        works (obviously ;-)
>   256        YES          1        works
>  4096        NO           1        works
>  4096        YES          1        panics
>  4096        YES          3        works (just happened to pick 3,
> 					  2 probably will work as well.)

> I've been testing NR_CPUS=4096 for quite a while and it's been very
> reliable.  It's just weird that this config fails with this new patch
> applied.  (default configs and some fairly normal distro configs also
> work fine.)  And with the zillion config straws we now have, spotting
> the arbitrary needle is proving difficult. ;-) 

Right.  Just please split your patch up.  It would be good to see
if simply changing the per cpu segment address to 0 is related
to your problem.  Or if it the other logic changes necessary to 
put the use the pda as a per cpu variable?

I just noticed that we always allocate the pda in the per cpu section.

> One reason I've been sticking with 4.2.4.

Eric
