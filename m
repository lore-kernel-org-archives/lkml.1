Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZCXJIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZCXJIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZCXJIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:08:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbZCXJIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:08:12 -0400
Date: Tue, 24 Mar 2009 10:07:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324090757.GH13016@elte.hu>
References: <1237884230.25315.33.camel@penberg-laptop> <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop> <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237885074.25315.43.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-03-24 at 09:56 +0100, Ingo Molnar wrote:
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > On Tue, 2009-03-24 at 09:51 +0100, Ingo Molnar wrote:
> > > > there's another build problem as well, in squashfs, and in key.h:
> > > > 
> > > >  include/linux/key.h:128: error: field 'sem' has incomplete type
> > > >  fs/squashfs/export.c:133: error: implicit declaration of function 'kmalloc'
> > > >  fs/squashfs/export.c:143: error: implicit declaration of function 'kfree'
> > > > 
> > > > And i suspect there's more as well. Is there really no unintrusive 
> > > > way to solve this - or do you think the RCU change reduces the 
> > > > include file spaghetti?
> > > 
> > > I don't think there is and yes, I do think the RCU change cleans 
> > > up things as well.
> > 
> > Okay. Note, you'll have to test tip:tracing/kmemtrace explicitly as 
> > i had to exclude it from tip:master due to test failures. Will put 
> > it back in once fixes arrive :)
> 
> That's what I am testing right now. It's just that I am working on 
> an old laptop where building the kernel takes a looong time.... 
> :-)

ok - let me help then.

On (64-bit) allyesconfig there's 5 distinct build failures:
 
include/linux/key.h:128: error: field ‘sem’ has incomplete type
distcc[22541] ERROR: compile security/keys/sysctl.c on a/16 failed

lib/decompress_bunzip2.c:636: error: implicit declaration of function ‘kmalloc’
lib/decompress_bunzip2.c:726: error: implicit declaration of function ‘kfree’

In file included from include/keys/user-type.h:16,
                 from fs/cifs/cifs_spnego.c:25:
include/linux/key.h:128: error: field ‘sem’ has incomplete type
distcc[3226] ERROR: compile fs/cifs/cifs_spnego.c on ph/16 failed

lib/decompress_inflate.c:45: error: implicit declaration of function ‘kmalloc’
lib/decompress_inflate.c:154: error: implicit declaration of function ‘kfree’

lib/decompress_unlzma.c:122: error: implicit declaration of function ‘kfree’
lib/decompress_unlzma.c:551: error: implicit declaration of function ‘kmalloc’

You should be able to reproduce them (on 32-bit too) one by one via:

  make lib/decompress_unlzma.o

etc. - without having to redo the full allyesconfig. (i'll redo that 
after the fixes, to flush out remaining/dependent bugs)

	Ingo
