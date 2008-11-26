Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYKZMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYKZMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYKZMYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:24:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYKZMYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:24:33 -0500
Date: Wed, 26 Nov 2008 07:24:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Detecting endianness in scripts/recordmcount.pl?
In-Reply-To: <20081126091752.GA21466@linux-sh.org>
Message-ID: <alpine.DEB.1.10.0811260723070.26424@gandalf.stny.rr.com>
References: <20081126083905.GA20472@linux-sh.org> <20081126091752.GA21466@linux-sh.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Paul Mundt wrote:

> On Wed, Nov 26, 2008 at 05:39:05PM +0900, Paul Mundt wrote:
> > Presently there doesn't seem to be any way to determine whether the
> > target is big or little endian, and it is assumed that the compiler will
> > do the right thing by default. Unfortunately this can not be assumed,
> > and mismatches ensue, resulting in the linker bailing out.
> > 
> > The only obvious solution I saw was to pass in KBUILD_CFLAGS and ld_flags
> > along with $(CC) and $(LD) to the script, and killing off the hardcoded
> > flags. This at least gets things building, but that still leaves objcopy
> > and objdump as the odd ones out. On the other hand, the format can be figured
> > out by objdumping the object and reading in the file format line, but people
> > obviously do not have consistent naming for these, and a double-pass would
> > be needed -- once for establishing little or big, followed by figuring out
> > which set of regexes to use.
> > 
> This is roughly what I had in mind for the objdump test, perhaps
> something like this could be reimplemented by someone who knows something
> about perl?
> 
> ---
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index c67cec8..177f4ee 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -143,6 +143,20 @@ if ($arch eq "x86") {
>      }
>  }
>  
> +open(IN, "$objdump -p $inputfile|") || die "error running $objdump";
> +
> +my $endian = "little";
> +
> +while (<IN>) {
> +	next if /^(\s)*$/;
> +	s/^.*file format //g;
> +	if (/big/) {
> +		$endian = "big";
> +	}
> +	last;
> +}
> +close(IN);

I'll turn this into a function and only run it on those archs that need 
it. This is executed on all C files, and we do not want to punish those
archs that have a single endian.

-- Steve

> +
>  if ($arch eq "x86_64") {
>      $section_regex = "Disassembly of section\\s+(\\S+):";
>      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> @@ -174,10 +188,15 @@ if ($arch eq "x86_64") {
>      $type = ".long";
>  
>      # force flags for this arch
> -    $ld .= " -m shlelf_linux";
> -    $objcopy .= " -O elf32-sh-linux";
> -    $cc .= " -m32";
> -
> +    if ($endian eq "big") {
> +	    $ld .= " -m shelf_linux";
> +	    $objcopy .= " -O elf32-shbig-linux";
> +	    $cc .= " -mb";
> +    } else {
> +            $ld .= " -m shlelf_linux";
> +            $objcopy .= " -O elf32-sh-linux";
> +            $cc .= " -ml";
> +    }
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }
> 
> 
