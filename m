Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZCEKzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZCEKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCEKyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:54:54 -0500
Received: from cmpxchg.org ([85.214.51.133]:55638 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZCEKyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:54:54 -0500
Date: Thu, 5 Mar 2009 11:53:46 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Johannes Weiner <jw@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -v2] flat: fix data sections alignment
Message-ID: <20090305105346.GA1779@cmpxchg.org>
References: <E1LerUo-0000NE-Q3@mailer.emlix.com> <8bd0f97a0903041348i2c88343fvbc7a1b6d428c7e7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0903041348i2c88343fvbc7a1b6d428c7e7a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 04:48:04PM -0500, Mike Frysinger wrote:
> On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> > --- a/fs/binfmt_flat.c
> > +++ b/fs/binfmt_flat.c
> > +#ifdef ARCH_SLAB_MINALIGN
> > +#define FLAT_DATA_ALIGN        (ARCH_SLAB_MINALIGN)
> > +#else
> > +#define FLAT_DATA_ALIGN        (sizeof(void *))
> > +#endif
> > ...
> > +       sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
> > ...
> > -               datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
> > +               datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
> > +                               FLAT_DATA_ALIGN);
> > ...
> > -               datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
> > +               datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
> > +                               FLAT_DATA_ALIGN);
> 
> why not make FLAT_DATA_ALIGN into a macro ?  then it'd naturally
> follow the existing ALIGN() behavior.

datapos is aligned to the next higher bound while the stack pointer
grows down and is therefor aligned to the next lower bound.  A
FLAT_DATA_ALIGN() doesn't make sense.

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

	Hannes
