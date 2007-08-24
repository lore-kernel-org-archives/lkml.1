Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbXHXI1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbXHXI1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbXHXI1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:27:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:15341 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbXHXI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=WkGq2cW5OPUbZd5eCatAVZY+q45Fdtu5xKA3Ay4AO3HWaUAvRuUdHeetr0bpYuvs/KmB3I85cJXWEIb9NajWf1ir6OPfrQQUYh51iE6qNMf5QR8I5P5tp06iZn/Yv5j20VLN8JwV62yFc0WY5sW8O1nqodWUVVUyKZbkAe9yZqM=
Date: Fri, 24 Aug 2007 10:22:49 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, rusty@rustcorp.com.au, kraxel@redhat.com
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070824082249.GG31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org> <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE7EDC.9080007@goop.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Gerd Hoffman and Rusty Russel to cc]
On Thu, Aug 23, 2007 at 11:46:52PM -0700, Jeremy Fitzhardinge wrote:
> Frederik Deweerdt wrote:
> > That means that even when you specify noreplace_smp, some replacing
> > takes place anyway. One of the consequences, besides noreplace_smp not
> > working as expected, is that lguest crashes when you feed it an SMP kernel
> > (I suspect that you can not replace alternatives for smp _and_ paravirt).
> >   
> 
> No, that should be fine.  Why does lguest crash?
It dies with:
[    0.131000] SMP alternatives: switching to UP code
lguest: bad stack page 0xc057a000

I added a dump_stack on the Host, which gives:
[124320.090946]  [<c01052f8>] dump_trace+0x65/0x1de
[124320.090956]  [<c010548b>] show_trace_log_lvl+0x1a/0x2f
[124320.090970]  [<c0105ea4>] show_trace+0x12/0x14
[124320.090975]  [<c0105fcd>] dump_stack+0x16/0x18
[124320.090980]  [<f888032c>] pin_page+0x5f/0xa3 [lg]
[124320.090993]  [<f8880654>] pin_stack_pages+0x3a/0x4a [lg]
[124320.091004]  [<f888007e>] guest_pagetable_clear_all+0x12/0x15 [lg]
[124320.091013]  [<f887f81a>] do_hcall+0xb1/0x1cb [lg]
[124320.091021]  [<f887fbbe>] do_hypercalls+0x28a/0x2a0 [lg]
[124320.091029]  [<f887f2a2>] run_guest+0x24/0x492 [lg]
[124320.091037]  [<f8881b48>] read+0x83/0x8f [lg]
[124320.091048]  [<c0175a77>] vfs_read+0x8e/0x117
[124320.091054]  [<c0175e99>] sys_read+0x3d/0x61
[124320.091059]  [<c0104166>] sysenter_past_esp+0x6b/0xb5
[124320.091065]  [<ffffe410>] 0xffffe410
[124320.091069]  =======================

Now, the "SMP alternatives: switching to UP code" message made me wonder
if it had anything to do with the alternatives, so I tried disabling
the switch by passing noreplace_smp...
... But the message was displayes anyway (and the smp_locks section
freed), because the check my patch adds is not made.
With the patch, I can boot lguest with an SMP kernel if I pass
noreplace_smp.
> 
> > I agree, but I don't think it is doable (alt_smp_once comes to mind). I'll
> > double check however.
> 
> Hm.  Is alt_smp_once useful?

I can't figure what the use case is, debugging set aside,
but there are places (eg xen, __cpu_die) in the kernel calling
alternatives_smp_switch(1) at runtime.  Passing smp-alt-once will prevent
the switch.

Regards,
Frederik
