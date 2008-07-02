Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYGBEhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYGBEhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYGBEh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:37:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbYGBEhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:37:24 -0400
Date: Tue, 1 Jul 2008 21:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/23] make section names compatible with
 -ffunction-sections -fdata-sections
Message-Id: <20080701213006.5502987a.akpm@linux-foundation.org>
In-Reply-To: <200807020233.48646.vda.linux@googlemail.com>
References: <200807020233.48646.vda.linux@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 02:33:48 +0200 Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi Andrew, folks,
> 
> I am unsure how to synchronize propagation of these patches
> across all architectures.
> 
> Andrew, how this can be done without causing lots of pain
> for arch maintainers? Please advise.

You didn't describe the problem which you're trying to solve, so how
can I say?

Possibilities are:

a) the generic bit depends on the arch bits

   -> No probs.  I can merge the generic bit once all architectures are in.

b) the arch bits depend on the generic bits

   -> No probs.  I can merge the generic bit then send all the arch bits.

c) they each depend on each other

   -> No probs.  We go round gaththering acks, slam it all into
      a single patch then in it goes.  2.6.28, presumably.

d) something else

   -> please do tell.

> The purpose of these patches is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> 
> Newer gcc and binutils can do dead code and data removal
> at link time. It is achieved using combination of
> -ffunction-sections -fdata-sections options for gcc and
> --gc-sections for ld.
> 
> Theory of operation:
> 
> -ffunction-sections instructs gcc to place each function
> (including static ones) in it's own section named .text.function_name
> instead of placing all functions in one big .text section.
> 
> At link time, ld normally coalesce all such sections into one
> output section .text again. It is achieved by having *(.text.*) spec
> along with *(.text) spec in built-in linker scripts.
> 
> If ld is invoked with --gc-sections, it tracks references, starting
> from entry point and marks all input sections which are reachable
> from there. Then it discards all input sections which are not marked.
> 
> This isn't buying much if you have one big .text section per .o module,
> because even one referenced function will pull in entire section.
> You need -ffunction-sections in order to split .text into per-function
> sections and make --gc-sections much more useful.
> 
> -fdata-sections is analogous: it places each global or static variable
> into .data.variable_name, .rodata.variable_name or .bss.variable_name.
> 
> If we ever want to use described mechanism, we need to adapt
> existing code for new section names. Basically, we need to stop using
> section names of the form
> .text.xxxx
> .data.xxxx
> .rodata.xxxx
> .bss.xxxx
> in the kernel - otherwise section placement done by kernel's
> custom linker scripts produces broken vmlinux and vdso images.
> 
> The following patches fix section names, one per architecture.
> 
> The patch in _this_ mail fixes generic part.

(tries to work out what it does)

oh, it does the above section renaming.  So I guess we're looking at
scenario c), above?

"otherwise section placement done by kernel's custom linker scripts
produces broken vmlinux and vdso images" is an inadequate description. 
Please describe the problem more completely.  This is important,
because once we actually find out what the patch is fixing, perhaps
others will be aware of less intrusive ways of fixing the problem, and
we end up with a better patch.


Please be aware that last time someone tried function-sections, maybe
five years ago, problems were encountered with linker efficiency
(possible an O(nsections) or worse algorithm in ld).  Link times went
up a lot.

So it would be good to hunt down some old ld versions and run some
timings.  A mention of the results in the changelog is appropriate.


Is there actually a patch anywhere which enables function-sections for
some architectures?  It would be good to see that (and its associated
size-reduction results) so we can work out whether all these changes
are worth pursuing.


> ...
>
> --- 0.org/scripts/mod/modpost.c	Wed Jul  2 00:40:54 2008
> +++ 1.fixname/scripts/mod/modpost.c	Wed Jul  2 00:54:21 2008
> @@ -794,9 +794,9 @@
>  /* sections that may refer to an init/exit section with no warning */
>  static const char *initref_sections[] =
>  {
> -	".text.init.refok*",
> -	".exit.text.refok*",
> -	".data.init.refok*",
> +	".init.refok.text*",
> +	".exit.refok.text*",
> +	".init.refok.data*",
>  	NULL
>  };
>  
> @@ -915,7 +915,7 @@
>   * Pattern 0:
>   *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
>   *   The pattern is identified by:
> - *   fromsec = .text.init.refok* | .data.init.refok*
> + *   fromsec = .init.refok.text* | .init.refok.data*
>   *
>   * Pattern 1:
>   *   If a module parameter is declared __initdata and permissions=0
> @@ -939,8 +939,8 @@
>   *           *probe_one, *_console, *_timer
>   *
>   * Pattern 3:
> - *   Whitelist all refereces from .text.head to .init.data
> - *   Whitelist all refereces from .text.head to .init.text
> + *   Whitelist all refereces from .head.text to .init.data
> + *   Whitelist all refereces from .head.text to .init.text

um, this would be a good occasion for us to have another attempt at
spelling "references".

