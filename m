Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZCEQnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZCEQnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZCEQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:41:05 -0500
Received: from mx1.emlix.com ([193.175.82.87]:42794 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbZCEQlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:41:04 -0500
From: "Oskar Schirmer" <os@emlix.com>
Date: Thu, 5 Mar 2009 17:40:28 +0100
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Johannes Weiner <jw@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -v2] flat: fix data sections alignment
References: <E1LerUo-0000NE-Q3@mailer.emlix.com> <8bd0f97a0903041348i2c88343fvbc7a1b6d428c7e7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0903041348i2c88343fvbc7a1b6d428c7e7a@mail.gmail.com>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Message-Id: <E1LfGcX-00071u-ID@mailer.emlix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 16:48:04 -0500, Mike Frysinger wrote:
> On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> > -       sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
> > -
> > -       sp -= envc+1;
> > -       envp = sp;
> > -       sp -= argc+1;
> > -       argv = sp;
> > +       sp = (unsigned long *)p;
> > +       sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
> > +       sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
> > +       argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
> > +       envp = argv + (argc + 1);
> 
> can this be cleaned up a bit so that the argv/envp assignment happens
> by using sp before aligning sp ?  that would be defensive coding wrt
> preventing sp adjustment falling out of line with argv initialization,
> and cut down on duplicated code.

The stack grows down and needs to be aligned when done,
i.e. where it's user space's turn. Therefor, we need to
first calculate the amount of space we need for argv/envp,
then align the result, and finally push argv/envp backward
into the reserved space. Note, that all this was done
before too, with one difference: Alignment was requested
in the middle of the calculation, which is nonsense (as
the comment in the ARM flat.h prooved).

> > @@ -854,7 +861,7 @@ static int load_flat_binary(struct linux
> >        stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
> >        stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
> >        stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
> > -
> > +       stack_len += FLAT_DATA_ALIGN;
> 
> this seems weird.  alignment is for aligning data, not padding it out
> some value ...

stack_len is the minimum amount of space to reserve
for the stack later on. As the stack pointer will be
aligned after pushing argv/envp (see above), we need
to reserve the additional space for maximum possible
alignment upon allocation.

  Oskar
