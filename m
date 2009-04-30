Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbZD3Vvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbZD3Vvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZD3Vvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:51:35 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:54299 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZD3Vve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sc5dA1SPbf4wmsVUPCv5NUFSpJ6YcGAxURHiKrEq7F//3IoCb5R/3P/Tpi72MVUMsU
         x+YMVzdBNZCFx2S6V/h6lCNLF7oCkxv3f3nE3037VTR2JepKdgLRb+oj54J5PWBE0Gub
         E3vQ3GHTtFBK7ZnlBLj2CmBFXkXM1+n8eadJM=
MIME-Version: 1.0
In-Reply-To: <20090430185219.656122641@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
	 <20090430185219.656122641@goodmis.org>
Date: Thu, 30 Apr 2009 22:51:32 +0100
Message-ID: <9b2b86520904301451v1d77589l7ee48217fb64e567@mail.gmail.com>
Subject: Re: [PATCH 3/7] kconfig: enable CONFIG_IKCONFIG from 
	streamline_config.pl
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/09, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Ingo Molnar suggested that the streamline_config.pl should enable
> CONFIG_IKCONFIG to keep the current config in the kernel.
> Then we can use scripts/extract-ikconfig to find the current
> modules.
>
> This patch changes streamline_config.pl to check if CONFIG_IKCONFIG
> is not set, and if it is not, it enables it to be a module.
>
> [ Impact: make current config options easier to find ]
>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  scripts/kconfig/streamline_config.pl |   33
> +++++++++++++++++++++++----------
>  1 files changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/scripts/kconfig/streamline_config.pl
> b/scripts/kconfig/streamline_config.pl
> index caac952..2334641 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -256,18 +256,31 @@ my %setconfigs;
>  # Finally, read the .config file and turn off any module enabled that
>  # we could not find a reason to keep enabled.
>  while(<CIN>) {
> -	if (/^(CONFIG.*)=(m|y)/) {
> -		if (defined($configs{$1})) {
> -		    $setconfigs{$1} = $2;
> -		    print;
> -		} elsif ($2 eq "m") {
> -		    print "# $1 is not set\n";
> -		} else {
> -		    print;
> -		}
> +
> +    if (/CONFIG_IKCONFIG/) {
> +	if (/# CONFIG_IKCONFIG is not set/) {
> +	    # enable IKCONFIG at least as a module
> +	    print "CONFIG_IKCONFIG=m\n";
> +	    # don't ask about PROC
> +	    print "# CONFIG_IKCONFIG is not set\n";

I assume the second one should be CONFIG_IKCONFIG_PROC :-).

> +	} else {
> +	    print;
> +	}
> +	next;
> +    }
> +
> +    if (/^(CONFIG.*)=(m|y)/) {
> +	if (defined($configs{$1})) {
> +	    $setconfigs{$1} = $2;
> +	    print;
> +	} elsif ($2 eq "m") {
> +	    print "# $1 is not set\n";
>  	} else {
> -		print;
> +	    print;
>  	}

> +    } else {
> +	print;
> +    }


Maybe it would be cleaner make the two "if" blocks the same; i.e. do
this instead:

+	next;
+    }
+
+	print;


>  }
>  close(CIN);
>
