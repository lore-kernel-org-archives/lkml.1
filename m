Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYGGQfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYGGQfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYGGQf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:35:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbYGGQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:35:28 -0400
Date: Mon, 7 Jul 2008 09:34:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: <20080707065742.7C119154246@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Roland McGrath wrote:
>
> This adds fast paths for 32-bit syscall entry and exit when
> TIF_SYSCALL_AUDIT is set, but no other kind of syscall tracing.
> These paths does not need to save and restore all registers as
> the general case of tracing does.  Avoiding the iret return path
> when syscall audit is enabled helps performance a lot.

Please don't do it like this.

I realize that Fedora enables audit by default, and that you care about 
the speed of the audit path, but I care about the speed of the *non*audit 
path. And you just slowed it down unnecessarily.


>  	TRACE_IRQS_OFF
> -	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
> +	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),threadinfo_flags(%r10)
>  	jnz	int_ret_from_sys_call
> +	bt	$TIF_SYSCALL_AUDIT,threadinfo_flags(%r10)
> +	jc	sysexit_audit

Please don't add more instructions to the fastpath. Especially not 
relatively slow ones like 'bt'. 

So keep the

	testl   $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
	jnz     audit_or_other_work

and then in that *slow*path in int_ret_from_sys_call, do

  audit_or_other_work:
	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),threadinfo_flags(%r10)
	jnz  int_ret_from_sys_call
  sysexit_audit:
	....

so that we don't have any extra costs at all for the non-audit case.

I realize that maybe you don't care too much about the ia32 emulation, but 
it's going to be the common case for some distros (I think several distros 
end up with a 32-bit user space even when they use a 64-bit kernel).

		Linus
