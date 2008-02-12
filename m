Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYBLPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYBLPta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYBLPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:49:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:55662 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYBLPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QdqQIScUTjfh7yhwYCeZActby+FDGM/+oVMmSiZ7hk6iwMQaETJnYmDnlIX7LPYgwPNwaIfbge6XGQg6TUv4madHjCHHDyxeWr0locCSAO08WJkk1PX2NOaHRY93zBLrYFQ9PCGyT0uG+08EVpRq5tzQR1KtnJJ2IhiPANZpkrA=
Message-ID: <8499950a0802120749r33323a15k7cde80862ae26c3d@mail.gmail.com>
Date: Tue, 12 Feb 2008 16:49:16 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: [PATCH] kbuild: fix make V=1
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200802121007.50638.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
	 <20080212085605.GB26865@uranus.ravnborg.org>
	 <20080212092504.GI24008@flower.upol.cz>
	 <200802121007.50638.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 4:07 PM, Mike Frysinger <vapier@gentoo.org> wrote:
[]
> > - quiet_chk_filechk = echo '  CHK     $@'
> > -silent_chk_filechk = :
> > - quiet_upd_filechk = echo '  UPD     $@'
> > -silent_upd_filechk = :
> > +quiet_chk_filechk = '  CHK     $@'
> > +quiet_upd_filechk = '  UPD     $@'
> > +
> >  define filechk
> >       $(Q)set -e;                             \
> > -     $($(quiet)chk_filechk);                 \
> > +     echo $($(quiet)chk_filechk);            \
> >       mkdir -p $(dir $@);                     \
> >       $(filechk_$(1)) < $< > $@.tmp;          \
> >       if [ -r $@ ] && cmp -s $@ $@.tmp; then  \
> >               rm -f $@.tmp;                   \
> >       else                                    \
> > -             $($(quiet)upd_filechk);         \
> > +             echo $($(quiet)upd_filechk);    \
> >               mv -f $@.tmp $@;                \
> >       fi
> >  endef
> 
> i dont see how yours is more efficient when it always runs echo.

Oh, this? It's like doing syscall for every write to "/dev/null".

> nor does it give the same behavior ... your propposed change will echo
> blank lines in the silent mode which is incorrect.

At least this will not crash, if you don't have some variable set.

Efficiency there is lesser number of variables(-2 vs +2), that are copied
for every make job, and are textually parsed and searched.

> it also does not seem to follow the standard convention of other
> kconfig commands that have quiet/silent prefixes ... such commands do
> not define arguments to an unknown program/function, nor do they add
> arbitrary redirection which gets leads to confusion as to final
> expansion, they define the entire command.

Right. Seems like you are talking about "[quite_]cmd_*", which are
commands. Here you've invented such rules for ordinary utility in
`filechk`. And by try they've failed due to mixing functionality
dependency on having arbitrary variable being set.

Shell syntax tried to avoid this, but `make` syntax and ``convention''
did a boom. Boom, where hacker's V=1 mode failed itself and failed to
give a clue about problem (at least, when i saw Sam's message in
linux-kbuild). Yea, `make` is not needed.

> what Sam posted (and what was merged) makes sense to me.
> -mike
> 
-- 
-o--=O`C
 #oo'L O
<___=E M
