Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZDGKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZDGKhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZDGKgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:36:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZDGKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:36:47 -0400
Date: Tue, 7 Apr 2009 12:36:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090407103611.GA5910@elte.hu>
References: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain> <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Tue, Apr 7, 2009 at 01:10, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Mon, 6 Apr 2009, Linus Torvalds wrote:
> >> thing that we think people would be happiest with.
> >>
> >> I think "ordered" was a reasonable default, but that was at least partly
> >> because _both_ ordered and writeback sucked (partly in different ways).
> >>
> >> I do think we could make it a config option.
> >
> > A patch _something_ like this.
> >
> > A few notes:
> >
> >  - This is UNTESTED (of course)
> >
> >  - If I did this right, this _only_ overrides the data mode if it's not
> >   explicitly specified on disk in the superblock mount options.
> >
> > IOW, if you have done a
> >
> >        tune2fs -o journal_data_ordered
> >
> > then this will _not_ override that. Only in the absense of any explicit
> > flags should this trigger and then make the choice be 'writeback'.
> >
> > And just to be _extra_ backwards compatible, if you really want the old
> > behavior, and don't want to set the ordering flag explicitly, just answer
> > 'y' to the EXT3_DEFAULTS_TO_ORDERED Kconfig question.
> >
> > What do people think? Anybody want to test?
> >
> >                Linus
> >
> > ---
> >  fs/ext3/Kconfig |   19 +++++++++++++++++++
> >  fs/ext3/super.c |    8 +++++++-
> >  2 files changed, 26 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
> > index 8e0cfe4..fb3c1a2 100644
> > --- a/fs/ext3/Kconfig
> > +++ b/fs/ext3/Kconfig
> > @@ -28,6 +28,25 @@ config EXT3_FS
> >          To compile this file system support as a module, choose M here: the
> >          module will be called ext3.
> >
> > +config EXT3_DEFAULTS_TO_ORDERED
> > +       bool "Default to 'data=ordered' in ext3 (legacy option)"
> > +       depends on EXT3_FS
> > +       help
> > +         If a filesystem does not explicitly specify a data ordering
> > +         mode, and the journal capability allowed it, ext3 used to
> > +         historically default to 'data=ordered'.
> > +
> > +         That was a rather unfortunate choice, because it leads to all
> > +         kinds of latency problems, and the 'data=writeback' mode is more
> > +         appropriate these days.
> > +
> > +         You should probably always answer 'n' here, and if you really
>             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +         want to use 'data=ordered' mode, set it in the filesystem itself
> > +         with 'tune2fs -o journal_data_ordered'.
> > +
> > +         But if you really want to enable the legacy default, you can do
> > +         so by answering 'y' to this question.
> > +
> 
> So `allmodconfig' will enable it? Is that the right thing to do, 
> or should it be inverted?
> 
> Gr{oetje,eeting}s,

allmod/allyes will enable all sorts of legacy options.

Since besides myself i'm not aware of any other person on this 
planet actually _booting_ allyes/allmod Linux kernels, i guess this 
is not a big issue anyway :-)

One small detail only: i'd suggest to name it 
CONFIG_COMPAT_EXT3_DEFAULTS_TO_ORDERED, to move it more in line with 
all the CONFIG_COMPAT_* legacy options.

	Ingo
