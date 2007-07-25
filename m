Return-Path: <linux-kernel-owner+w=401wt.eu-S934955AbXGYScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955AbXGYScU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934796AbXGYSaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53555 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934788AbXGYSaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:21 -0400
Date: Wed, 25 Jul 2007 20:31:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Nathan Lynch <ntl@pobox.com>, Andy Whitcroft <apw@shadowen.org>
Subject: x86_64 has 2 x arch_vma_name() - can we drop one?
Message-ID: <20070725183132.GA28408@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/mm.h arch_vma_name() is declared __weak.
This hide the fact that x86_64 has 2 implementations of
said function.

In arch/x86_64/mm/init.c:
const char *arch_vma_name(struct vm_area_struct *vma)
{
	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
		return "[vdso]";
	if (vma == &gate_vma)
		return "[vsyscall]";
	return NULL;
}

And in arch/x86_64/ia32/syscall32.c:
const char *arch_vma_name(struct vm_area_struct *vma)
{
	if (vma->vm_start == VSYSCALL32_BASE &&
	    vma->vm_mm && vma->vm_mm->task_size == IA32_PAGE_OFFSET)
		return "[vdso]";
	return NULL;
}

As no comment were preceeding the fucntions this seems not to be on
purpose.
If I am correct which one should die?

The reason why this popped up is that the __weak definition in mm.h
causes problems on at least powerpc (trigger a binutils bug).
A similar bug is present at ia64 - but I have not confirmed if the
same fix is needed.

	Sam
