Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbZFMNvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbZFMNvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZFMNvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:51:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZFMNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:51:45 -0400
Date: Sat, 13 Jun 2009 09:51:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Bring sparc64 dynamic ftrace up to snuff...
In-Reply-To: <20090613.011020.214065340.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0906130950220.16299@gandalf.stny.rr.com>
References: <20090613.011020.214065340.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 13 Jun 2009, David Miller wrote:

> 
> Do the ftrace maintainers mind if I merge the following in via my
> sparc-next-2.6 tree?

Not at all.

> 
> Thanks!
> 
> sparc64: Add proper dynamic ftrace support.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc/Kconfig              |    2 +
>  arch/sparc/include/asm/ftrace.h |   11 +++++++++
>  arch/sparc/kernel/ftrace.c      |   47 ++++++++++++++++++++++++++------------
>  scripts/recordmcount.pl         |   20 ++++++++++++++++
>  4 files changed, 65 insertions(+), 15 deletions(-)
> 


> +#endif
> +
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 409596e..e694eaf 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -213,6 +213,26 @@ if ($arch eq "x86_64") {
>      if ($is_module eq "0") {
>          $cc .= " -mconstant-gp";
>      }
> +} elsif ($arch eq "sparc64") {
> +    # In the objdump output there are giblets like:
> +    # 0000000000000000 <igmp_net_exit-0x18>:
> +    # As there's some data blobs that get emitted into the
> +    # text section before the first instructions and the first
> +    # real symbols.  We don't want to match that, so to combat
> +    # this we use '\w' so we'll match just plain symbol names,
> +    # and not those that also include hex offsets inside of the
> +    # '<>' brackets.  Actually the generic function_regex setting
> +    # could safely use this too.
> +    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\w*?)>:";
> +
> +    # Sparc64 calls '_mcount' instead of plain 'mcount'.
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> +
> +    $alignment = 8;
> +    $type = ".xword";
> +    $ld .= " -m elf64_sparc";
> +    $cc .= " -m64";
> +    $objcopy .= " -O elf64-sparc";
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }

The only thing outside of arch/sparc is this recordmcount.pl, and that too 
is arch specific.

I'm fine with it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

