Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZCDVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZCDVsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZCDVsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:48:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:6361 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZCDVsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nRR/Dm2eBs/EHmNqAKGdvrwwXDHlXAbh5EkFb019TrJ5PEKUCJcz+6KMPePMNwWVV2
         2Eck5UskaSH7HqjE+NreAOwHoj9YTID0iKgosSzwkKPwQ9IzmEgZzDs7ucauraz8aAXY
         hC94lLKe0VHYJPwYC5ZBQlfzLYSzgGXWYLyH8=
MIME-Version: 1.0
In-Reply-To: <E1LerUo-0000NE-Q3@mailer.emlix.com>
References: <E1LerUo-0000NE-Q3@mailer.emlix.com>
Date: Wed, 4 Mar 2009 16:48:04 -0500
Message-ID: <8bd0f97a0903041348i2c88343fvbc7a1b6d428c7e7a@mail.gmail.com>
Subject: Re: [patch -v2] flat: fix data sections alignment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> +#ifdef ARCH_SLAB_MINALIGN
> +#define FLAT_DATA_ALIGN        (ARCH_SLAB_MINALIGN)
> +#else
> +#define FLAT_DATA_ALIGN        (sizeof(void *))
> +#endif
> ...
> +       sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
> ...
> -               datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
> +               datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
> +                               FLAT_DATA_ALIGN);
> ...
> -               datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
> +               datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
> +                               FLAT_DATA_ALIGN);

why not make FLAT_DATA_ALIGN into a macro ?  then it'd naturally
follow the existing ALIGN() behavior.

> -       sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
> -
> -       sp -= envc+1;
> -       envp = sp;
> -       sp -= argc+1;
> -       argv = sp;
> +       sp = (unsigned long *)p;
> +       sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
> +       sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
> +       argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
> +       envp = argv + (argc + 1);

can this be cleaned up a bit so that the argv/envp assignment happens
by using sp before aligning sp ?  that would be defensive coding wrt
preventing sp adjustment falling out of line with argv initialization,
and cut down on duplicated code.

> -       put_user(argc,--sp);
> +       put_user(argc,sp);

might as well fix the style issues here while you're changing code ...
stick a space after the comma

> @@ -854,7 +861,7 @@ static int load_flat_binary(struct linux
>        stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
>        stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
>        stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
> -
> +       stack_len += FLAT_DATA_ALIGN;

this seems weird.  alignment is for aligning data, not padding it out
some value ...
-mike
