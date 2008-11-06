Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYKFGjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYKFGjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKFGjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:39:36 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:10595 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYKFGjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IkL3+VDJbWJH/ReE15rlTM1940dywzNHJMLKkHohn7VbXzTHq0/U+KduSKzIsVHhlP
         GazbOES4uDp6Bh7xdWNVXNkHwcI519DwV2w5URheaftJn298mKTtL4MzkQ4ErE4cS+Yp
         rhgl4QxOJUi4xESKJcV9gMR806oOveuEVsVVU=
Message-ID: <86802c440811052239m7c78cbc4s532e3cdb41606ca6@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:39:34 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Theodore Tso" <tytso@mit.edu>, "Yinghai Lu" <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
In-Reply-To: <49128E50.3020704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104224510.GA7672@mit.edu>
	 <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
	 <20081105153508.GB22998@mit.edu>
	 <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com>
	 <20081106052340.GA12762@mit.edu> <49128E50.3020704@kernel.org>
X-Google-Sender-Auth: 3e67de2befb347dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Theodore Tso wrote:
>> On Wed, Nov 05, 2008 at 09:22:38AM -0800, Yinghai Lu wrote:
>>>> What is your theory for why this was causing a failure in the timer
>>>> subsystem?  Were we overrunning the end of irq_desc array and stomping
>>>> on some other data structure?
>>> Yes. Please do apply that two patches at first.
>>>
>>
>> Success!  Applying these two patches, as found at:
>>
>
> did you apply
> http://lkml.org/lkml/2008/11/4/431
>
> it seems we aready incread NR_IRQS big enough, but still get...
>
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/io_apic.c:3614 probe_nr_irqs+0x44/0x4d()
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc3-00123-g72a0780 #97
> [    0.000000] Call Trace:
> [    0.000000]  [<c01418f1>] warn_on_slowpath+0x46/0x60
> [    0.000000]  [<c0160a3e>] ? __lock_acquire+0x3d9/0xa5b
> [    0.000000]  [<c06dd463>] ? alloc_bootmem_core+0x1bf/0x221
> [    0.000000]  [<c012db8b>] ? native_pmd_val+0x8/0xa
> [    0.000000]  [<c01324a2>] ? pmd_val+0x11/0x21
> [    0.000000]  [<c011bb31>] ? sched_clock+0xc/0x1c
> [    0.000000]  [<c015e5fb>] ? lock_release_holdtime+0x43/0x48
> [    0.000000]  [<c016142c>] ? lock_release+0x14c/0x155
> [    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
> [    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
> [    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
> [    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
> [    0.000000]  [<c06d5853>] probe_nr_irqs+0x44/0x4d
> [    0.000000]  [<c06cbfe8>] setup_arch+0xa90/0xb00
> [    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
> [    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
> [    0.000000]  [<c015e91a>] ? lockdep_init_map+0x6b/0xc7
> [    0.000000]  [<c06c65e2>] start_kernel+0x85/0x30e
> [    0.000000]  [<c06c6080>] __init_begin+0x80/0x88
> [    0.000000] ---[ end trace 8305b6ae03c24dde ]---
>

ah, you have
CONFIG_PARAVIRT=y

YH
