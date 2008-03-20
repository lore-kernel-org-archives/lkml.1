Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYCTCmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYCTCmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYCTCl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:41:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbYCTCly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:41:54 -0400
Date: Wed, 19 Mar 2008 19:40:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
In-Reply-To: <20080319212024.EA03126F995@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803191935080.3020@woody.linux-foundation.org>
References: <20080319211714.8B14226F995@magilla.localdomain> <20080319212024.EA03126F995@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Roland McGrath wrote:
>
> The arch_ptrace and compat_arch_ptrace functions can now return
> -ENOSYS for requests they do not actually implement in arch
> code.

Hmm.. I see the whole series, and I see this patch, but I think it adds 
new code and new complexity, and I don't really see *why*.

So I'm obviously not going to apply it outside the merge window anyway, 
but even for later I'd really like to know what you're building up 
towards, because without understanding the upsides it just feels like it 
adds ugly code and unnecessary infrastructure without any real point to 
it.

And I have to say, I really hate that

		ret = arch_ptrace(child, request, addr, data);
		if (ret == -ENOSYS && !forced_successful_syscall_return())
			ret = ptrace_request(child, request, addr, data);

thing. Instead of doing it that ugly way (return value and a special 
per-arch forced_successful_syscall_return() thing), this really smells 
like you just want to change the calling conventions for "arch_ptrace()" 
instead.

Wouldn't it be nicer to just let "arch_ptrace()" return a flag saying 
whether it handled things or not?

			Linus
