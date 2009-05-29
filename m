Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZE2PYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZE2PYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbZE2PYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:24:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbZE2PYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:24:08 -0400
Date: Fri, 29 May 2009 11:24:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: wuzhangjin@gmail.com
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
In-Reply-To: <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
Message-ID: <alpine.DEB.2.00.0905291122260.31247@gandalf.stny.rr.com>
References: <cover.1243604390.git.wuzj@lemote.com> <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 409596e..a5d2ace 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -213,6 +213,17 @@ if ($arch eq "x86_64") {
>      if ($is_module eq "0") {
>          $cc .= " -mconstant-gp";
>      }
> +
> +} elsif ($arch eq "mips") {
> +	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> +	$ld .= " -melf".$bits."btsmip";
> +
> +	$cc .= " -mno-abicalls -fno-pic ";
> +
> +    if ($bits == 64) {
> +		$type = ".dword";
> +    }
> +
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }
> @@ -441,12 +452,12 @@ if ($#converts >= 0) {
>      #
>      # Step 5: set up each local function as a global
>      #
> -    `$objcopy $globallist $inputfile $globalobj`;
> +    `$objcopy $globallist $inputfile $globalobj 2>&1 >/dev/null`;
>  
>      #
>      # Step 6: Link the global version to our list.
>      #
> -    `$ld -r $globalobj $mcount_o -o $globalmix`;
> +    `$ld -r $globalobj $mcount_o -o $globalmix 2>&1 >/dev/null`;

We still need to find out why these are giving errors. I don't like the 
idea of hiding errors that might be useful. The better way is to change 
the code to avoid having any warnings or errors.

-- Steve


>  
>      #
>      # Step 7: Convert the local functions back into local symbols
> @@ -454,7 +465,7 @@ if ($#converts >= 0) {
>      `$objcopy $locallist $globalmix $inputfile`;
>  
>      # Remove the temp files
> -    `$rm $globalobj $globalmix`;
> +    `$rm $globalobj $globalmix 2>&1 >/dev/null`;
>  
>  } else {
>  
> -- 
> 1.6.0.4
> 
> 
