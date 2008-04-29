Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYD2WZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYD2WZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYD2WYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:24:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbYD2WYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:24:49 -0400
Date: Wed, 30 Apr 2008 00:24:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Henry Nestler <Henry.Ne@arcor.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
	2.6
Message-ID: <20080429222427.GA16629@elte.hu>
References: <480E6BB4.5080902@henry.nestler.gmail.com> <480E8069.20502@henry.ne.arcor.de> <20080428164634.GC18210@elte.hu> <48164E29.4080409@henry.ne.arcor.de> <20080429143314.GG26461@elte.hu> <84144f020804290814o18f4868tf6536cc7f16cb8d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804290814o18f4868tf6536cc7f16cb8d7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Apr 29, 2008 at 5:33 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >  btw., i have a kmemcheck-reported bug fixed in this same area with the
> >  patch below. I dont remember the details anymore, but the root mount
> >  code did something really, really weird here.
> >
> >  Subject: init: root mount fix
> >  From: Ingo Molnar <mingo@elte.hu>
> >  Date: Tue Apr 29 16:31:50 CEST 2008
> >
> >  Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >  ---
> >   init/do_mounts.c |    8 ++++++--
> >   1 file changed, 6 insertions(+), 2 deletions(-)
> >
> >  Index: linux/init/do_mounts.c
> >  ===================================================================
> >  --- linux.orig/init/do_mounts.c
> >  +++ linux/init/do_mounts.c
> >  @@ -201,9 +201,13 @@ static int __init do_mount_root(char *na
> >         return 0;
> >   }
> >
> >  +#if PAGE_SIZE < PATH_MAX
> >  +# error increase the fs_names allocation size here
> >  +#endif
> >
> > +
> >   void __init mount_block_root(char *name, int flags)
> >   {
> >  -       char *fs_names = __getname();
> >  +       char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
> >
> >         char *p;
> >   #ifdef CONFIG_BLOCK
> >         char b[BDEVNAME_SIZE];
> >  @@ -251,7 +255,7 @@ retry:
> >
> >  #endif
> >         panic("VFS: Unable to mount root fs on %s", b);
> >   out:
> >  -       putname(fs_names);
> >  +       free_pages((unsigned long)fs_names, 1);
> >   }
> >
> >   #ifdef CONFIG_ROOT_NFS
> 
> It could have been a bug in early kmemcheck too. We don't check memory 
> allocated with the page allocator, only slab, so this shouldn't 
> trigger anything.

no, i tracked it down and the problem was some genuine weirdness in this 
code (and not in kmemcheck) but i forgot the details :-)

it was something rather disgusting, the boot parameter parsing stuff.

	Ingo
