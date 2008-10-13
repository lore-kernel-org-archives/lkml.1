Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYJMOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYJMOqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYJMOpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:45:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbYJMOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:45:32 -0400
Date: Mon, 13 Oct 2008 07:45:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: GIT head no longer boots on x86-64
In-Reply-To: <1223895414-19793-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LFD.2.00.0810130740360.3288@nehalem.linux-foundation.org>
References: <20081013112024.0183f982@lxorguk.ukuu.org.uk> <1223895414-19793-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Jiri Slaby wrote:
> +	sprint_symbol(buf, (unsigned long)__builtin_return_address(0));
> +	if (!is_vmalloc_addr(vmalloc_addr) && !is_module_address(addr))
> +		printk("BUG? %s (from %s): %p\n", __func__, buf, vmalloc_addr);

Just use

	printk("BUG? %s (from %pS): %p\n",
		__func__,
		__builtin_return_address(0),
		vmalloc_addr);

and don't ever sprint_symbol() any more. 

The rules:
 - %pS for symbolic names of real pointers off the stack etc (ie something 
   that is approximately type "void *" and points directly to the function 
   code)
 - %pF for symbolic names of a C function pointer (ie of type (*fn)(...) 
   and actually has a real C function pointer type)
where the difference doesn't matter for x86 (or most sane architectures), 
but does matter for architectures that use function descriptors rather 
than direct pointers (ia64, hppa, ppc64, maybe others).

			Linus
