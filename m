Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbXCPTfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbXCPTfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXCPTfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:35:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33429 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbXCPTe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:34:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com>
	<m17itho10v.fsf@ebiederm.dsl.xmission.com> <45FAC4EF.4060305@goop.org>
	<20070316163118.GA12999@elte.hu> <45FAC6E6.5090000@goop.org>
Date: Fri, 16 Mar 2007 13:06:46 -0600
In-Reply-To: <45FAC6E6.5090000@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 16 Mar 2007 09:33:42 -0700")
Message-ID: <m1ps79m2ih.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ingo Molnar wrote:
>> that's what is the case right now, but much of the intention behind the 
>> vma based vDSO is to enable per-process randomized vdso locations, and 
>> various distributions do that. So the 'modern' vDSO concept is very much 
>> relocatable.
>
> No, the point is that it never needs relocating.  The kernel can map it
> anywhere and userspace can cope.  Its only the broken glibcs which
> require relocation.

Ok.  So to summarize.
There are three ways of finding the VDSO.
- AT_SYSINFO
- AT_SYSINFO_EHDR
- known fixed address (see x86_64)

Currently it doesn't sound like you need to deal with the known fixed
address case but COMPAT_VDSO also provides that.

If userspace uses AT_SYSINFO the premise is that it is not expecting
not to need to perform any relocation processing.

If userspace uses AT_SYSINFO_EHDR it expects it needs to perform
relocation processing and fixes up whatever needs fixing up.

With the module code we have shown the kernel is capable of performing
relocation processing at times and it works.

So is it possible to simply relocate the normal vdso and fixup
it's program header so it shows that relocation is not necessary.
If you can do that and still export AT_SYSINFO so the problem user
space still runs you are good.  (If you can relocate the vdso
you should be able to relocate it anywhere).

Otherwise it probably just make sense to simply not export a VDSO
on those systems.

This would leave COMPAT_VDSO for the case where you must use one magic
fixed address, and if user space does not require that it means
COMPAT_VDSO could be completely removed.

Eric
