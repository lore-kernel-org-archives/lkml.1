Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXI1XIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXI1XIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXI1XIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:08:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbXI1XIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:08:37 -0400
Date: Fri, 28 Sep 2007 16:08:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: bernd.schmidt@analog.com, davidm@snapgear.com, gerg@snapgear.com,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] binfmt_flat: minimum support for the Blackfin
 relocations
Message-Id: <20070928160826.1483b9ba.akpm@linux-foundation.org>
In-Reply-To: <1190102965.4406.9.camel@roc-desktop>
References: <1190102965.4406.9.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 16:09:25 +0800
Bryan Wu <bryan.wu@analog.com> wrote:

> From: Bernd Schmidt <bernd.schmidt@analog.com>
> 
> This just adds minimum support for the Blackfin relocations,
> since we don't have enough space in each reloc. The idea
> is to store a value with one relocation so that subsequent ones can
> access it.
> 
> Actually, this patch is required for Blackfin. Currently if BINFMT_FLAT 
> is enabled, git-tree kernel will fail to compile. Please consider to
> accept it.
> 

A few things

> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 7b0265d..13b58f8 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -742,6 +742,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  	 * __start to address 4 so that is okay).
>  	 */
>  	if (rev > OLD_FLAT_VERSION) {
> +		unsigned long persistent = 0;

`persistent' here only has meaning inside the next nesting level, so should
be moved down into that scope for readability reasons.

Also, the initialisation to zero is, afaict, unneeded and wastes
instructions.  I suspect that's just there to suppress a gcc warning, which
is better done with uninitialized_var().

>  		for (i=0; i < relocs; i++) {
>  			unsigned long addr, relval;
>  
> @@ -749,6 +750,8 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			   relocated (of course, the address has to be
>  			   relocated first).  */
>  			relval = ntohl(reloc[i]);
> +			if (flat_set_persistent (relval, &persistent))
> +				continue;

If this correct?  flat_set_persistent() returns zero if it didn't write
anything to `persistent'.  It seems strange that in the case where
flat_set_persistent() _does_ write something to `persistent', we just throw
it away by doing `continue'.

Either that, or I've misread the code and you really did mean to put
`persistent' in the outer scope, and its value is supposed to propagate
over into the next iteration of the loop.  If so, that's all a bit too
tricky for it to be implemented with zero code comments, dontcha think?

Also, given that you are proposing that flat_set_persistent() becomes part
of the kernel's core<->arch interface (for all architectures which want to
implement binfmt_flat()), it is no longer appropriate that the reference
implementation of flat_set_persistent() (ie: blackfins's implementation) be
completely undocumented.  IMO.

> --- a/include/asm-h8300/flat.h
> +++ b/include/asm-h8300/flat.h
> @@ -9,6 +9,7 @@
>  #define	flat_argvp_envp_on_stack()		1
>  #define	flat_old_ram_flag(flags)		1
>  #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
> +#define	flat_set_persistent(relval, p)		0

ug.  those macros are crap.  who did that.  They will generate compiler
warnings and runtime failures in a whole host of well-known scenarios.  

My kingdom to the person who invents a keyboard which delivers 12 kV when
it detects the sequence # d e f i n e.  There is no reason why these
"functions" need to be implemented as crappy #defines and converting them
to C will fix bug, warnings and will clean stuff up.

Sigh.

