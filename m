Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZKDLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZKDLMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZKDLMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:12:41 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52033 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbZKDLMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l1oX5y19gSKRdghF6SRJcR5pd65rr+rGs1KfsxO4iUCbtvYD7FbYsdS8ikHbGes+xn
         mw9Uq/xQqZmJhnMo6gW7CtiCSyrSqUvIMSlxQL/+frfJID6VdH/o8IkjAehhR4d9FWGg
         +PIKBRnJCgFHgEYwsDaSt2MRZqAgIJTDgUv58=
MIME-Version: 1.0
In-Reply-To: <4AF150D2.6000207@tuffmail.co.uk>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> 
	<1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk> 
	<200911041849.43311.rusty@rustcorp.com.au> <4AF150D2.6000207@tuffmail.co.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 4 Nov 2009 06:12:24 -0500
Message-ID: <8bd0f97a0911040312s3e5212cdx70117f0ebf3b8d7a@mail.gmail.com>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the 
	kernel (__ksymtab)
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 05:00, Alan Jenkins wrote:
> Rusty Russell wrote:
>> On Tue, 3 Nov 2009 08:36:17 pm Alan Jenkins wrote:
>>> +/*
>>> + * We use CPP macros since they are more familiar than assembly macros.
>>> + * Note that CPP macros eat newlines, so each statement must be
>>> terminated
>>> + * by a semicolon.
>>> + */
>>> +
>>> +#ifdef CONFIG_HAVE_SYMBOL_PREFIX
>>> +#define __SYM(sym) _##sym
>>> +#else
>>> +#define __SYM(sym) sym
>>> +#endif
>>>
>>
>> Ideally, you would used MODULE_SYMBOL_PREFIX here, but of course it's a
>> string.  I don't think Kconfig can do arbitrary identifiers, so we can't
>> make CONFIG_SYMBOL_PREFIX empty or _.
>>
>> Perhaps clarify it to a bool CONFIG_HAVE_MODULE_UNDERSCORE_PREFIX then,
>> since that's what you're assuming here?
>>
>> Thanks,
>> Rusty.
>
> I made the same assumption in patch 4.  The arch defines
> CONFIG_HAVE_SYMBOL_PREFIX, which then causes init/Kconfig to define
> CONFIG_SYMBOL_PREFIX="_".
>
> Mike suggested that I hack kbuild instead, to do something like
>
> unquote = ...
> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(unquote CONFIG_SYMBOL_PREFIX)
>
> I'm experimenting with the idea, but I haven't managed to get it working
> yet.

presumably you're having trouble with the preprocessor using the
define name literally instead of expanding it.  you can address this
two ways:
 - force gcc to expand it wit a few more levels
 - define the macro on the command line

here is the first way:
$ cat test.c
#include <stdio.h>
foo() { puts("foo"); }
_foo() { puts("_foo"); }
__foo() { puts("__foo"); }
#define __SYM(x) ___SYM(PFX, x) /* queue PFX */
#define ___SYM(pfx,x) ____SYM(pfx, x) /* expand PFX */
#define ____SYM(pfx,x) pfx##x /* paste them together */
main() { __SYM(foo)(); }
$ gcc test.c -DPFX=_ && ./a.out
_foo

and here is the second:
$ cat test.c
#include <stdio.h>
foo() { puts("foo"); }
_foo() { puts("_foo"); }
__foo() { puts("__foo"); }
main() { __SYM(foo)(); }
$ gcc test.c -D'__SYM(x)=_##x' && ./a.out
_foo

HTH
-mike
