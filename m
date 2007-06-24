Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXFXWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXFXWCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXFXWCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:02:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:26060 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXFXWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qO5RuGIDdn62ag8/wg4rCh9nFm8RsvnsVJEShWRdGqtwCOwH82TjYGDmyx0FMYTcWdLFQrSJKAuErKB3y65ueaLyh0huAL+a53WS91TbyVaa1QMoXik3ppdi373uQ3XdjfQ586qnfNfaPB7ZCRcDMnOJ+a7WrQIUZjmTcHWYavk=
Message-ID: <9a8748490706241502j217a5c6drd015dcd84633ab3a@mail.gmail.com>
Date: Mon, 25 Jun 2007 00:02:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Avoid potential NULL deref in scripts/genksyms/lex.l
Cc: "Richard Henderson" <rth@tamu.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070624145837.f3141572.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706242340.03871.jesper.juhl@gmail.com>
	 <20070624145837.f3141572.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 24 Jun 2007 23:40:03 +0200 Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> > strchr() returns NULL in case the string is not found and if that
> > happens we risk dereferencing a NULL pointer. It never hurts to
> > check for that condition and exit normally with an error rather
> > than crashing.
> >
> > (no, the indentation is not according to CodingStyle, it's simply
> >  following whatever else is in that file)
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > ---
> >
> >  scripts/genksyms/lex.l        |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
> > index 5e544a0..28edc0c 100644
> > --- a/scripts/genksyms/lex.l
> > +++ b/scripts/genksyms/lex.l
> > @@ -154,6 +154,8 @@ repeat:
> >
> >        file = strchr(yytext, '\"')+1;
> >        e = strchr(file, '\"');
>
> If `file' can be null we'd have oopsed here.
>
> > +      if (!file || !e)
> > +     exit(1);
> >        *e = '\0';
> >        cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
> >        cur_line = atoi(yytext+2);
>
> I don't think the bug which you're fixing can occur:
>
> ^#[ \t]+{INT}[ \t]+\"[^\"\n]+\".*\n     return FILENAME;
>
> has anyone reported crashes in there?
>

It may indeed not be possible. Found by inspection, not by any actual
observed crashes.
But does it really hurt to be defensive here? In case it can somehow
be caused to fail, with my patch it'll fail a bit nicer :) It's not
like it's at all speed critical code that will be hurt by that extra
'if'...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
