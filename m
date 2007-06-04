Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXFDRqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXFDRqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXFDRqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:46:34 -0400
Received: from waste.org ([66.93.16.53]:54928 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbXFDRqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:46:34 -0400
Date: Mon, 4 Jun 2007 12:46:16 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: lguest rebroken in 2.6.22-rc3-mm1
Message-ID: <20070604174616.GF11115@waste.org>
References: <20070522223828.GV11115@waste.org> <1179876460.20705.157.camel@localhost.localdomain> <20070604171932.GE11115@waste.org> <20070604102820.a4a0ee15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604102820.a4a0ee15.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:28:20AM -0700, Andrew Morton wrote:
> On Mon, 4 Jun 2007 12:19:33 -0500 Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Wed, May 23, 2007 at 09:27:40AM +1000, Rusty Russell wrote:
> > > On Tue, 2007-05-22 at 17:38 -0500, Matt Mackall wrote:
> > > > [    0.120007] EIP is at resync_sc_freq+0x4b/0x56
> > > 
> > > Hi Matt,
> > > 
> > > 	Thanks for the report!  Andrew should have these two patches queued,
> > > but here they are again:
> > > 
> > > If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
> > > divide by zero on boot.
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > 
> > > ---
> > >  arch/i386/kernel/sched-clock.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > ===================================================================
> > > --- a/arch/i386/kernel/sched-clock.c
> > > +++ b/arch/i386/kernel/sched-clock.c
> > > @@ -103,7 +103,7 @@ static void resync_sc_freq(struct sc_dat
> > >  static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
> > >  {
> > >  	sc->sync_base = jiffies;
> > > -	if (!cpu_has_tsc) {
> > > +	if (!cpu_has_tsc || tsc_disable) {
> > >  		sc->unstable = 1;
> > >  		return;
> > >  	}
> > 
> > Looks like this one got lost in rc3-mm1.
> > 
> 
> Andi said that he fixed the zero-divide by other means?

Got this, patch fixed it:

[    0.392024] divide error: 0000 [#1]
[    0.392024] PREEMPT 
[    0.392024] Modules linked in:
[    0.392024] CPU:    0
[    0.392024] EIP:    0061:[<c010995a>]    Not tainted VLI
[    0.392024] EFLAGS: 00010246   (2.6.22-rc3-mm1 #145)
[    0.392024] EIP is at resync_freq+0x7a/0x85
[    0.392024] eax: 3d090000   ebx: c1c04f70   ecx: 00000e70   edx: 00000000
[    0.392024] esi: 00000000   edi: c1c04f80   ebp: c1c04f68   esp: c1c04f64
[    0.392024] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0069
[    0.392024] Process swapper (pid: 1, ti=c1c04000 task=c1c20ae0 task.ti=c1c04000)
[    0.392024] Stack: 00000000 c1c04f84 c058eb2d 00000000 00000000 00000000 00000000 00000000 
[    0.392024]        c1c04fe0 c058c6c4 c1c04fac c0119c22 00000000 00000002 c054c320 c1c20ae0 
[    0.392024]        00000000 c05b2dc0 c1c20ae0 00000000 00000001 c058c608 00000000 00000000 
[    0.392024] Call Trace:
[    0.392024]  [<c058eb2d>] init_sched_clock+0x5c/0x90
[    0.392024]  [<c058c6c4>] kernel_init+0xbc/0x23e
[    0.392024]  [<c0104a6b>] kernel_thread_helper+0x7/0x10
[    0.392024]  =======================
[    0.392024] INFO: lockdep is turned off.
[    0.392024] Code: 30 0c 55 c0 89 15 34 0c 55 c0 e8 75 a6 00 00 90 31 c9 89 d1 a3 28 0c 55 c0 ba 00 00 00 00 b8 00 00 09 3d 89 0d 2c 0c 55 c0 31 d2 <f7> 73 08 a3 20 0c 55 c0 5b 5d c3 55 b8 01 00 00 00 89 e5 57 56 
[    0.392024] EIP: [<c010995a>] resync_freq+0x7a/0x85 SS:ESP 0069:c1c04f64
[    0.392024] Kernel panic - not syncing: Attempted to kill init!


-- 
Mathematics is the supreme nostalgia of our time.
