Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZBVRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZBVRA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZBVRAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:00:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:53115 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZBVRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tx9TitYUbFdt04e4jrQe17tPNdwzutgqaUiKU6b0a1J/JctKr5oLnFwVFh5uVPZWSs
         Q1A6phH8WfXAUB4BdYRkcnp47fmGNT/RPGVba7tjM1vzSD+ZzLZ3rZ2QDimLtZj2uvAL
         g8+Fx+bhxf6BCNZPCbe7ff7jsWdMVJlfPYm7w=
Date: Sun, 22 Feb 2009 18:00:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for -tip
Message-ID: <20090222170044.GC6003@nowhere>
References: <20090222135739.GA28619@damson.getinternet.no> <20090222164419.GA28442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222164419.GA28442@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 05:44:19PM +0100, Ingo Molnar wrote:
> 
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > Hi,
> > 
> > Here are the latest kmemcheck developments. Changes are basically:
> > 
> > 1. Bitfield annotations.
> > 2. Fix REP handling on P4s.
> > 3. Page allocator hooks.
> > 
> > At boot, I get two false positives, in copy_mount_options() and
> > __dequeue_signal(). I've also seen two spontaneous floods of warnings from
> > somewhere in aio code, but I couldn't pinpoint exactly why things went
> > wrong. I guess it will need a bit more research.
> > 
> > 
> > Vegard
> > 
> > 
> > The following changes since commit 2215d76c949375d38b33f32580908accfffbb461:
> >   Ingo Molnar (1):
> >         Merge branch 'x86/core' into kmemcheck
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> > 
> > Vegard Nossum (12):
> >       kmemcheck: bitfield API
> >       net: use kmemcheck bitfields API for skbuff
> >       net: annotate bitfields in struct inet_sock
> >       ieee1394: annotate bitfield
> >       ieee1394/csr1212: fix false positive kmemcheck report
> >       kmemcheck: annotate inet_timewait_sock bitfields
> >       kmemcheck: disable fast string operations on P4 CPUs
> >       kmemcheck: rip out REP instruction emulation
> >       kmemcheck: add hooks for page- and sg-dma-mappings
> >       kmemcheck: don't track allocated page tables
> >       kmemcheck: add hooks for the page allocator
> >       kmemcheck: depend on !SLUB_DEBUG_ON
> > 
> >  arch/x86/Kconfig.debug             |    2 +-
> >  arch/x86/include/asm/dma-mapping.h |    6 ++
> >  arch/x86/include/asm/thread_info.h |    4 +-
> >  arch/x86/kernel/cpu/intel.c        |   23 +++++++
> >  arch/x86/mm/kmemcheck/kmemcheck.c  |  121 +-----------------------------------
> >  arch/x86/mm/kmemcheck/opcode.c     |   13 +----
> >  arch/x86/mm/kmemcheck/opcode.h     |    3 +-
> >  arch/x86/mm/kmemcheck/shadow.c     |    8 +++
> >  arch/x86/mm/pgtable.c              |   12 ++--
> >  drivers/ieee1394/csr1212.c         |    2 +
> >  drivers/ieee1394/nodemgr.c         |    7 ++-
> >  include/linux/gfp.h                |    5 ++
> >  include/linux/kmemcheck.h          |   72 ++++++++++++++++++++--
> >  include/linux/skbuff.h             |   33 ++++++----
> >  include/net/inet_sock.h            |   26 +++++---
> >  include/net/inet_timewait_sock.h   |   11 ++-
> >  mm/kmemcheck.c                     |   45 ++++++++++----
> >  mm/page_alloc.c                    |    8 +++
> >  mm/slab.c                          |   15 +++--
> >  mm/slub.c                          |   23 +++++--
> >  net/core/skbuff.c                  |    8 +++
> >  net/ipv4/inet_timewait_sock.c      |    3 +
> >  22 files changed, 252 insertions(+), 198 deletions(-)
> 
> Pulled into tip:kmemcheck and started testing it, thanks Vegard!
> 
> 	Ingo


BTW, I just tested kmemcheck (without these fixes pulled) and encountered some
troubles with the function graph tracer which hangs during the self tests.
As well as a message from hrtimer which tells its interrupt is too slow.

Well, I'm pulling latest -tip and will see.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


