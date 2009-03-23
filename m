Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZCWFcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZCWFcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZCWFcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:32:00 -0400
Received: from ozlabs.org ([203.10.76.45]:38773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZCWFb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:31:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/stacktrace] symbols, stacktrace: look up init symbols after module symbols
Date: Mon, 23 Mar 2009 16:01:50 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <new-discussion> <tip-4a44bac1f98223ed77e47bf3b42fcfd10cddd85f@git.kernel.org>
In-Reply-To: <tip-4a44bac1f98223ed77e47bf3b42fcfd10cddd85f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231601.51648.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 22:24:35 Ingo Molnar wrote:
>   a2da405: module: Don't report discarded init pages as kernel text.
> 
> The reason is this check added to core_kernel_text():
> 
> -       if (addr >= (unsigned long)_sinittext &&
> +       if (system_state == SYSTEM_BOOTING &&
> +           addr >= (unsigned long)_sinittext &&
>             addr <= (unsigned long)_einittext)
>                 return 1;
> 
> This will discard inittext symbols even though their symbol table
> is still present and even though stacktraces done while the system
> was booting up might still be relevant.
> 
> To not reintroduce the (not well-specified) bug addressed in that
> commit, first do a module symbols lookup, then a final init-symbols
> lookup.
> 
> This will work fine on architectures that have separate address
> spaces for modules (such as x86) - and should not crash any other
> architectures either.

Returning "1" all the time won't crash them either, AFAICT, but it's still
misleading if kernel_text_address() isn't reliable.  It makes me
uncomfortable.

Does every kernel_text_address() caller want this behavior, or should we
have a was_ever_text_address()?

Rusty.
