Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZHPVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZHPVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZHPVeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:34:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZHPVeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:34:17 -0400
Date: Sun, 16 Aug 2009 23:34:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Martin-=C9ric?= Racine <q-funk@iki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090816213407.GA30245@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl> <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com> <200908132034.34951.rjw@sisk.pl> <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com> <20090816205706.GB3463@elte.hu> <11fae7c70908161412v61fd233au5166e18f4c4d0931@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11fae7c70908161412v61fd233au5166e18f4c4d0931@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin-Éric Racine <q-funk@iki.fi> wrote:

> 2009/8/16 Ingo Molnar <mingo@elte.hu>:
> >
> > * Martin-Éric Racine <q-funk@iki.fi> wrote:
> >
> >> On Thu, Aug 13, 2009 at 9:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> >> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
> >> >> On Thu, Aug 13, 2009 at 5:54 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> >> >> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
> >> >> >> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
> >> >> >> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> >> >> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
> >> >> >> >>> Yes, this bug is still valid.
> >> >> >> >>>
> >> >> >> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
> >> >> >> >>> bisecting our way through the changes that took place since 2.6.30
> >> >> >> >>> to find the commit that introduced this regression. Please stay
> >> >> >> >>> tuned.
> >> >> >> >>
> >> >> >> >> hm, the only outright Geode related commit was:
> >> >> >> >>
> >> >> >> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
> >> >> >> >>
> >> >> >> >> the jpg at:
> >> >> >> >>
> >> >> >> >>  http://launchpadlibrarian.net/28892781/00002.jpg
> >> >> >> >>
> >> >> >> >> is very out of focus - but what i could decypher suggests a
> >> >> >> >> pagefault crash in the VFS code, in generic_delete_inode().
> >> >> >>
> >> >> >> This one might be a bit better:
> >> >> >>
> >> >> >> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
> >> >
> >> > Hmm.  This looks like a sysfs oops to my untrained eye.
> >>
> >> The bisect I did with Leann Ogasawara has narrowed the kernel panic
> >> down to the following:
> >>
> >> commit f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0
> >> Author: Al Viro <viro@zeniv.linux.org.uk>
> >> Date: Mon Jun 8 19:50:45 2009 -0400
> >>
> >>     add caching of ACLs in struct inode
> >>
> >>     No helpers, no conversions yet.
> >>
> >>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >
> > Weird. If the functions do what their name suggests, i.e. if
> > inode_init_always() is an always called constructor and if
> > destroy_inode() is an unconditional destructor then this patch
> > should have no functional effect on the VFS side.
> >
> > It increases the size of struct inode, so if you have some old
> > module (built to an older version of fs.h) still around it might
> > corrupt your inode data structure.
> >
> > Or the size change might trigger some dormant bug. It might move a
> > critical inode right into the path of a pre-existing (but not
> > visibly crash-triggering) data corruption.
> >
> > The possibilities on the 'weird bug' front are endless - the 
> > crash/oops itself should be turned into text, posted here and 
> > analyzed.
> 
> If you mean something else than the large-size snapshot of the 
> whole panic output that was linked earlier in this thread, I'd 
> appreciate instructions on how to turn that crash into text.

it's still a JPG - posting the transcribed oops in email text would 
certainly help more folks looking over it.

(painful i know ...)

	Ingo
