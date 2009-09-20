Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZITVQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZITVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZITVQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:16:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52275 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZITVQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:16:25 -0400
Date: Sun, 20 Sep 2009 23:16:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] kbuild: Don't define ALIGN and ENTRY when
	preprocessing linker scripts.
Message-ID: <20090920211627.GB27042@merkur.ravnborg.org>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com> <1253472193-21106-2-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253472193-21106-2-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 02:43:10PM -0400, Tim Abbott wrote:
> Adding a reference to <linux/linkage.h> to x86's <asm/cache.h> causes
> the x86 linker script to have syntax errors, because the ALIGN and
> ENTRY keywords get redefined to the assembly implementations of those.
> One could fix this by adjusting the include structure, but I think any
> solution based on that approach would be fragile.
> 
> Currently, it is impossible when writing a header to do something
> different for assembly files and linker scripts, even though there are
> clearly cases where one wants them to define macros differently for
> the two (ENTRY being an excellent example).  So I think the right
> solution here is to introduce a new preprocessor definition,
> tentatively called __LINKER_SCRIPT__ that is set along with
> __ASSEMBLY__ for linker scripts, and to use that to not define ALIGN
> and ENTRY in linker scripts.  I suspect we'll find other uses for this
> mechanism in the future.

We will need this - agreed.

The reason for __XXX___ for ASSEMBLY and KERNEL is the fact
that these are used in user space headers.

I would suggest to use: LINKER_SCRIPT

> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 5c4b7a4..e51e213 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -269,7 +269,8 @@ targets += $(extra-y) $(MAKECMDGOALS) $(always)
>  # Linker scripts preprocessor (.lds.S -> .lds)
>  # ---------------------------------------------------------------------------
>  quiet_cmd_cpp_lds_S = LDS     $@
> -      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<
> +      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -D__LINKER_SCRIPT__ \
> +		      -o $@ $<

This will conflict (in a trivial way) with stuff I have
pending for this merge window.

	Sam
