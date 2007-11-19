Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbXKSWOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbXKSWOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXKSWOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:14:15 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56895 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXKSWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:14:13 -0500
Date: Mon, 19 Nov 2007 23:15:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: document kernel config and build
Message-ID: <20071119221554.GB15377@uranus.ravnborg.org>
References: <20071119173320.GB11309@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119173320.GB11309@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 06:33:20PM +0100, Andreas Herrmann wrote:
> Hi,
> 
> I suggest to add some documentation snippet to
> 
>     Documentation/x86/{kbuild,kconfig,README}
> 
> or whatsoever to primarily describe the new ARCH=x86 build.
> As a starter I named it Documentation/x86/kbuild.

I would prefer a general document that has a target specific
section.

Something like Documentation/make/headers_install and your text merged.
And the resuting file could be named kernel-build-howto.txt (or similar)
and located in Documentation/kbuild/

On top of this we should enhance the arch specific help for x86
to tell how to select bit-size. But I have left that until we unify
the 32 and 64 bit Makefiles.


I have yet to read your document - too late for that now..

	Sam


> 
> The following text is based on my observations with
> Linus' git (v2.6.24-rc3-19-g2ffbb83).
> Some text was shamelessly stolen from one of Sam's patch
> descriptions.
> 
> Comments are welcome.
> 
> 
> Regards,
> 
> Andreas
> 
> --
> Added documentation about kernel configuration and build for ARCH=x86.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kbuild |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 71 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/kbuild
> 
> diff --git a/arch/x86/kbuild b/arch/x86/kbuild
> new file mode 100644
> index 0000000..7a918a9
> --- /dev/null
> +++ b/arch/x86/kbuild
> @@ -0,0 +1,71 @@
> +Kernel configuration
> +
> +    The general rule is that ARCH={i386,x86_64} and native
> +    architecture take precedence over the configuration.
> +    So make ARCH=i386 [whatever] will always build a 32-bit
> +    kernel no matter what the configuration says.
> +    The configuration will be updated to 32-bit if it was
> +    configured to 64-bit and the other way around:
> +
> +    /=================================================\
> +    | Target kernel architecture for                  |
> +    |     $ make [ARCH=...] <config-target>           |
> +    |-------------------------------------------------|
> +    | option \ host arch      | i386         | x86_64 |
> +    |=================================================|
> +    | ./.                     | i386         | x86_64 |
> +    | ARCH=i386               | i386         | i386   |
> +    | ARCH=x86_64             | x86_64       | x86_64 |
> +    \=================================================/
> +
> +    This behaviour is consistent with previous behaviour so
> +    no surprises here.
> +    
> +    "make ARCH=x86" is special. It is the only ARCH= value that
> +    allows the user to select between 32-bit and 64-bit using
> +    menuconfig. This has impact on most config targets. Following
> +    table shows what kernel will be configured depending on host
> +    architecture and config-target.
> +
> +    /=========================================================\
> +    | Target kernel architecture for                          |
> +    |     $ make ARCH=x86 <config-target>                     |
> +    |---------------------------------------------------------|
> +    | config-target \ host arch  | i386         | x86_64      |
> +    |=========================================================|
> +    | [menu]config (*1)          | i386/x86_64  | i386/x86_64 |
> +    | {old,silentold}config (*2) | i386/x86_64  | i386/x86_64 |
> +    | defconfig                  | i386         | i386        |
> +    | randconfig (*3)            | i386/x86_64  | i386/x86_64 |
> +    | allnoconfig                | i386         | i386        |
> +    | allyesconfig               | x86_64       | x86_64      |
> +    | allmodconfig               | x86_64       | x86_64      |
> +    |---------------------------------------------------------|
> +    | (*1) The default selection equals the host architecture |
> +    |   for new configurations. Otherwise it depends on the   |
> +    |   setting of CONFIG_64BIT in the old configuration.     |
> +    |---------------------------------------------------------|
> +    | (*2) The default selection depends on the setting of    |
> +    |   CONFIG_64BIT in the old configuration.                |
> +    |---------------------------------------------------------|
> +    | (*3) Both configurations are possible.                  |
> +    \=========================================================/
> +
> +
> +Cross compilation
> +
> +    (1) To compile a 32-bit kernel on a x86_64 system you have to
> +        disable 64-bit support in the kernel configuration
> +        (CONFIG_64BIT=n).
> +
> +        A subsequent kernel compile will build a 32-bit kernel. No
> +        cross compiler is needed.
> +
> +    (2) To compile a 64-bit kernel on a i386 system you have to switch
> +        on 64-bit support in the kernel configuration (CONFIG_64BIT=y).
> +        In the subsequent kernel compile a cross compiler (supporting
> +        x86_64) is needed. You have to use a command line like
> +
> +            $ make CROSS_COMPILE=x86_64-pc-linux-gnu-
> +
> +        to cross compile your kernel.
> -- 
> 1.5.3.4
> 
> 
> 
> 
