Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXELC6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXELC6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXELC6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:58:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:22726 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXELC6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NC1nzKK3Pl+CRtUpInxXHahkhxoUvbbi/24pghCDFOHpk3JcT3rgt7culYPjzpB1Sgxub3agkPJrEmfXtW0Aeey6wuHu3eTG4Q8Z6DKYJXTqE0f0Izzk/JWSA5o3jizdYa4063TS96g3Zx0qsa+rYnPBElGa3qMZD/S5Y8k1koE=
Message-ID: <a781481a0705111958p364ebe4al4f2bde84817db88d@mail.gmail.com>
Date: Sat, 12 May 2007 08:28:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: [RFC PATCH] kbuild: silence section mismatch warnings
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <8210B049-55BD-409F-8A5E-EC5E1C365604@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070511210850.GA382@uranus.ravnborg.org>
	 <8210B049-55BD-409F-8A5E-EC5E1C365604@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> On May 11, 2007, at 4:08 PM, Sam Ravnborg wrote:
> > Following patch allow us in specific places to silence section
> > mismatch warnings.

Well, I had spelled out my reservations about this earlier, but I don't feel
too strongly. Most people probably do not want / prefer to see warnings
(even if they know they're false positives), and this also helps reduce
unnecessary reports of known FPs on lkml.

> > The annotation is simple to grep for so revieing all uses in a few
> > months time are trivial. It is assumed that a few places will
> > use this to shut up the warning as replacement for the real fix.
> > But these cases are esay to spot and to fix up.

Yes, so we have to be careful with its use.

On 5/12/07, Kumar Gala <galak@kernel.crashing.org> wrote:
> Its unclear if you expect that some things will be tagged
> __init_refok/__initdata_refok forever or if we'll find some way to
> fix/change the code so the things tagged no longer need it.

We'll _have_ to fix those bugs that use the whitelisting in modpost
merely to kill off a warning, need to fix binutils for some others,
and may have to live with this for still others (mm/sl*b.c suffer
from a chicken-and-egg problem, for example).

> On May 11, 2007, at 4:08 PM, Sam Ravnborg wrote:
> With this and the following two patches I have a section mismatch free
> build.
> The plan is that a section mismatch soon will graduate from a
> warning to an error.

Yes, that's only sane.

> diff --git a/include/linux/init.h b/include/linux/init.h
> [...]
> +/* modpost check for references from .text to .init.text and likewise
> + * from .data to .init.data. They are in most cases sign of bugs but

You may want to list all illegal combinations in the comment above
check_sec_ref instead, and only introduce __init{data}_refok here.

> + * in a few places this is OK. The following can be used to tell
> + * modpost that such a reference is OK.
> + * For references to .exit.text and .exit.data the same annotation
> + * will silence warnings from modpost.
> + */
> +#define __init_refok     noinline __attribute__ ((__section__ (".text_initrefok")))
> +#define __initdata_refok noinline __attribute__ ((__section__ (".data_initrefok")))

Actually, for a second there I got confused you had done this the other
way round. __init_refok sounds similar to __init (almost a "variant" of
__init) so I thought you were annotating the _callees_ and not the
_callers_.

BTW, I wonder if there would be any relative merits of doing things that
way. Did you consider this "reversed" approach?

Hmmm ... we would be annotating lesser functions, for one. With
the current __init_refok-for-callers semantics, we mark the callee __init
_and_ the caller __init_refok, which is unnecessary double-work, and
will only get worse if the same __init callee is called by multiple
callers in .text.

For the case where a caller references multiple __init callees? I don't
see any relative advantage of either scheme, or is there ...

Also, it's easier to spot a function that _is_ (or should be) __init
in the code already, than see if it is being referenced from .text,
and if so, make it __init_whatever (__init_refok is an equally
good name for callee-semantics).

(looking at code in 21-mm2)

I looked at scripts/mod/modpost.c only briefly, but it seems to me
shifting the semantics of __init_refok to refer to callees could also
subsume (and make redundant) patterns #1, 2, 6, 7 and 9 of
secref_whitelist, no?

[BTW I noticed _three_ whitelisting functions in there -- could it be
possible for us to do what init_section_ref_ok and
exit_section_ref_ok do in secref_whitelist itself? Those three
whitelists are beginning to look darn ugly.]

Anyway, somehow the __init_refok-callee scheme seems saner to
me -- please do consider it. Note, in that case, however:

1. We'll have to invent separate __exit_refok and __exitdata_refok,
of course. But that's a good thing for me, compared to giving a
multiplexed definition to __init_refok to mean
caller-can-safely-call-__init && caller-can-safely-call-__exit.

2. The init section freeing code in the kernel would need to be patched
to free sections marked as __init_refok, __initdata_refok, __exit_refok
and __exitdata_refok too. But that would most likely be a trivial patch.

3. When the exception / bug is fixed, we would convert such
__init_refok annotations to __init.

> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 113dc77..986200b 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -582,6 +582,14 @@ static int strrcmp(const char *s, const char *sub)
>
>  /**
   ^^^ should be simply /*

That's a doc-book-style comment header for a comment that's actually not
doc-book-style. Randy gets angry.

Thanks,
Satyam
