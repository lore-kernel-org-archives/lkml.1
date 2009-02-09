Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZBIOJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZBIOJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZBIOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:09:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:34003 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZBIOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:09:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TVU2cUn/aapEgh0VkZRDPfz+wcMkOjfy2yhI3gYtBeuP6Kb9yHH5U+s72/ogeJGoo8
         zYUwkfR2CWXqJdySsg4w5vqJh2OCLU1lqj4b7NF3dhJlbdi5jGclOXv2nvfZ9utbWbPE
         NXTDNyWWpjTEYBKabix1V4X/Jia/GIm82by/w=
MIME-Version: 1.0
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
Date: Mon, 9 Feb 2009 09:09:01 -0500
Message-ID: <73c1f2160902090609qeabc926nc5579f87c1ca5207@mail.gmail.com>
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> This patchset adds stack protector support for x86_32.  The basics are
> the same with x86_64 but there are some noticeable differences.
>
> * x86_32 uses %fs for percpu base.  %gs is unused by the kernel and
>  managed lazily.  %gs is used for userland TLS and loading %gs with
>  different value on kernel entry is known to cost quite a bit on some
>  chips.
>
>  Lazy %gs handling is made optional and disabled if stack protector
>  is enabled.  To do this, entry for %gs is added to pt_regs.  This
>  adds one "pushl $0" to SAVE_ALL in entry_32.S when lazy %gs is on.
>  However, no overhead is added to common exit path and error_code
>  entry path shed a few instructions.  I don't think there will be
>  noticeable overhead but then again it does add an instruction to a
>  very hot path.  Would this be okay?
>
> * x86_32 doesn't support direct access to shadow part of %gs and
>  there's no swapgs, so GDT entry should be built for stack canary.
>
>  GDT entry 28 is used for this.  The boot cpu one is setup from
>  head_32.S.  Others while setting up percpu areas.
>
> * math_emu register access was completely broken.  Fixed.
>
> * x86_32 exception handlers take register frame verbatim as struct
>  pt_regs.  With -fstack-protector, gcc copies pt_regs into the
>  callee's stack frame to put it after the stack canary.  Of course it
>  doesn't copy back (as the callee owns the argument) and any change
>  made to pt_regs is lost on return.  This is currently worked around
>  by adding -fno-stack-protector to any file containing such
>  functions.  We really need to teach gcc about the calling
>  convention.

I had a patch a while back that would convert those function to take a
pointer to pt_regs instead of assuming that the struct was passed by
value.  I'll take a stab at reworking it on top of this series.

--
Brian Gerst
