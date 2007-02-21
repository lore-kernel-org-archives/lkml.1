Return-Path: <linux-kernel-owner+w=401wt.eu-S1751215AbXBULMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbXBULMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXBULMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:12:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXBULMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:12:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
In-Reply-To: Jeff Dike's message of  Tuesday, 20 February 2007 16:21:19 -0500 <20070220212119.GA8090@ccure.user-mode-linux.org>
X-Zippy-Says: ..  I'm IMAGINING a sensuous GIRAFFE, CAVORTING in the BACK ROOM of
   a KOSHER DELI --
Message-Id: <20070221111228.9CEA21800E4@magilla.sf.frob.com>
Date: Wed, 21 Feb 2007 03:12:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Below is the first step in your Fix-Your-Broken-Arch-HOWTO for UML.

Great!  Thanks for tackling this.

> Do you want incremental patches as I go along, or replacement ones?

The way I've organized my patch series is with the arch support split up
along with the separate infrastructure patches in the series.  That is,
just asm/tracehook.h with no utrace_regset stuff in the first patch so that
the kernel builds with only utrace-tracehook.patch; then the regset stuff
but no arch_ptrace et al in another patch so that it builds with
utrace-regset.patch but without the later patches; then arch_ptrace et al
in the final arch patch.  Your patch is mostly just the first of these
(utrace-tracehook-um), but includes utrace_regset and arch_ptrace stubs
that won't compile without the later infrastructure patches applied.

If you want to divide things up this way, then I'd like just to see a
replacement utrace-tracehook-um.patch followed by utrace-regset-um.patch
and utrace-ptrace-compat-um.patch, replacing each one whole as needed until
it's merged into my trees, and then I can take incremental changes after
that.  If you don't want to bother with dividing things so it compiles in
between patches in the series, then just one big replacement patch is fine.

> +const struct utrace_regset_view utrace_um_native = {
> +	.name		= "um",

This name wants to be the subarch name--it's usually the $ARCH or
UTS_MACHINE, i.e. the canonical arch name (i386 not i686, but ppc64 or ppc,
not powerpc).  In fact, I'm sure you really want to define the
utrace_regset_view structs separately somewhere in arch/um/sys-$SUBARCH.
On biarch platforms you'll need more than one, as the native biarch
platforms have.  (But that is all part of the second step that isn't really
tackled in this patch.)

> +#define ARCH_HAS_SINGLE_STEP	(1)

Note you'll eventually want to define the block-step macro and functions
depending on subarch.  (ia64 supports it, and x86 one day will.)

> +extern const struct utrace_regset_view utrace_um_native;
> +static inline const struct utrace_regset_view *
> +utrace_native_view(struct task_struct *tsk)
> +{
> +	return &utrace_um_native;
> +}

You probably just want an extern decl for utrace_native_view here,
since what it really does with depend on the subarch.

> BTW, UML runs on the utrace in -mm (i.e. utrace on the host), which it
> didn't with several Fedora kernels.

Oh, really?  That's good, but are you sure?  Have you tried a
CONFIG_PREEMPT=y host?  I reproduced a failure with the current code
recently after Alexey Dobriyan reported the problem.  But I didn't get
anywhere debugging it and got busy with other work.  I could use some help
tracking down what ptrace does differently that broke UML, if it does
indeed still come up.  I have plenty of experience debugging ptrace and
users of it, but I don't know much of anything about UML's usage pattern
and got quickly lost in its code trying to tell what it expected to happen.


Thanks,
Roland
