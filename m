Return-Path: <linux-kernel-owner+w=401wt.eu-S1751118AbXBMVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbXBMVpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXBMVpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:45:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXBMVpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:45:34 -0500
Date: Tue, 13 Feb 2007 22:43:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 02/11] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070213214335.GC22104@elte.hu>
References: <20070213142024.GC638@elte.hu> <4390.81.207.0.53.1171397879.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4390.81.207.0.53.1171397879.squirrel@secure.samage.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Indan Zupancic <indan@nul.nu> wrote:

> > + * Execution control: conditions upon the return code
> > + * of the previous syslet atom. 'Stop' means syslet
> > + * execution is stopped and the atom is put into the
> > + * completion ring:
> > + */
> > +#define SYSLET_STOP_ON_NONZERO			0x00000008
> > +#define SYSLET_STOP_ON_ZERO			0x00000010
> > +#define SYSLET_STOP_ON_NEGATIVE			0x00000020
> > +#define SYSLET_STOP_ON_NON_POSITIVE		0x00000040
> 
> This is confusing. Why the return code of the previous syslet atom? 
> Wouldn't it be more clear if the flag was for the current tasklet? 
> Worse, what is the previous atom? [...]

the previously executed atom. (I have fixed up the comment in my tree to 
say that.)

> [...] Imagine some case with a loop:
> 
>   A
>   |
>   B<--.
>   |   |
>   C---'
> 
> What will be the previous atom of B here? It can be either A or C, but 
> their return values can be different and incompatible, so what flag 
> should B set?

previous here is the previously executed atom, which is always a 
specific atom. Think of atoms as 'instructions', and these condition 
flags as the 'CPU flags' like 'zero' 'carry' 'sign', etc. Syslets can be 
thought of as streams of simplified instructions.

> > +/*
> > + * Special modifier to 'stop' handling: instead of stopping the
> > + * execution of the syslet, the linearly next syslet is executed.
> > + * (Normal execution flows along atom->next, and execution stops
> > + *  if atom->next is NULL or a stop condition becomes true.)
> > + *
> > + * This is what allows true branches of execution within syslets.
> > + */
> > +#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000080
> > +
> 
> Might rename this to SYSLET_SKIP_NEXT_ON_STOP too then.

but that's not what it does. It really 'skips to the next one on a stop 
event'. I.e. if you have three consecutive atoms (consecutive in linear 
memory):

	atom1 returns 0
	atom2 has SYSLET_STOP_ON_ZERO|SYSLET_SKIP_NEXT_ON_STOP set
	atom3

then after atom1 returns 0, the SYSLET_STOP_ON_ZERO condition is 
recognized as a 'stop' event - but due to the SYSLET_SKIP_NEXT_ON_STOP 
flag execution does not stop (i.e. we do not return to user-space or 
complete the syslet), but we continue execution at atom3.

this flag basically avoids having to add an atom->else pointer and keeps 
the data structure more compressed. Two-way branches are sufficiently 
rare, so i wanted to avoid the atom->else pointer.

	Ingo
