Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbXFXV6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbXFXV6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFXV6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:58:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbXFXV6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:58:47 -0400
Date: Sun, 24 Jun 2007 14:58:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Richard Henderson <rth@tamu.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid potential NULL deref in scripts/genksyms/lex.l
Message-Id: <20070624145837.f3141572.akpm@linux-foundation.org>
In-Reply-To: <200706242340.03871.jesper.juhl@gmail.com>
References: <200706242340.03871.jesper.juhl@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 23:40:03 +0200 Jesper Juhl <jesper.juhl@gmail.com> wrote:

> strchr() returns NULL in case the string is not found and if that 
> happens we risk dereferencing a NULL pointer. It never hurts to 
> check for that condition and exit normally with an error rather 
> than crashing.
> 
> (no, the indentation is not according to CodingStyle, it's simply 
>  following whatever else is in that file)
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  scripts/genksyms/lex.l        |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
> index 5e544a0..28edc0c 100644
> --- a/scripts/genksyms/lex.l
> +++ b/scripts/genksyms/lex.l
> @@ -154,6 +154,8 @@ repeat:
>  
>        file = strchr(yytext, '\"')+1;
>        e = strchr(file, '\"');

If `file' can be null we'd have oopsed here.

> +      if (!file || !e)
> +	exit(1);
>        *e = '\0';
>        cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
>        cur_line = atoi(yytext+2);

I don't think the bug which you're fixing can occur:

^#[ \t]+{INT}[ \t]+\"[^\"\n]+\".*\n     return FILENAME;

has anyone reported crashes in there?
