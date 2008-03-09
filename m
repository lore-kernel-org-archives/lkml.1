Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYCIDCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYCIDCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 22:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCIDC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 22:02:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYCIDCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 22:02:25 -0500
Date: Sat, 8 Mar 2008 19:05:59 -0800
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 7: slab corruptions
Message-ID: <20080309030559.GA24355@suse.de>
References: <20080307141856.b27d1725.sfr@canb.auug.org.au> <47D26E42.9020704@free.fr> <200803090029.49180.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803090029.49180.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 12:29:48AM +0530, Balaji Rao wrote:
> On Saturday 08 March 2008 04:15:22 pm Laurent Riffard wrote:
> > Le 07.03.2008 04:18, Stephen Rothwell a ??crit :
> > > Hi all,
> > >
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> >
> > I've got a lot of "Slab corruption" with next-20060307 (actually a
> > continuous flow of warnings) whereas next-20060306 is fine.
> >
> > [    3.045882] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> > [    3.045885] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> > [    3.045890] 000: 03 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> > [    3.045902] 010: 00 00 00 00 00 00 85 de 00 50 85 de 00 00 85 de
> > [    3.055247] Slab corruption: size-512 start=defb5060, len=512
> > [    3.056465] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> > [    3.057363] Last user: [<c022789b>](device_release+0x36/0x58)
> > [    3.058594] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> > [    3.060109] Single bit error detected. Probably bad RAM.
> > [    3.061353] Run memtest86+ or a similar memory test tool.
> > [    3.062501] Next obj: start=defb5278, len=512
> > [    3.063596] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> > [    3.064751] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> > [    3.065447] 000: 04 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> > [    3.066965] 010: 00 00 00 00 00 80 85 de 00 d0 85 de 00 80 85 de
> > [    3.074109] Slab corruption: size-512 start=defb56a8, len=512
> > [    3.075336] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> > [    3.076510] Last user: [<c022789b>](device_release+0x36/0x58)
> > [    3.077360] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> > [    3.078885] Single bit error detected. Probably bad RAM.
> > [    3.080015] Run memtest86+ or a similar memory test tool.
> >
> > I did a bisection:
> >
> > 5a428808720b31026890d3ff71fbd891d9a94fd6 is first bad commit
> > commit 5a428808720b31026890d3ff71fbd891d9a94fd6
> > Author: Balaji Rao <balajirrao@gmail.com>
> > Date:   Thu Mar 6 22:23:18 2008 +0530
> >
> >     kobjects: mark cleaned up kobjects as unitialized
> >
> >     When I remove only the kvm-intel module without removing the kvm module
> >     itself, I get an error saying that a kobject is trying to be
> >     reinitialized. Its because of the fact that kvm reuses a kobject in
> >     kvm_init when calling sysdev_register.
> >
> >     This patch fixes kobject_cleanup by marking the kobject as
> > uninitialized when we cleanup to allow kobjects to be reused.
> >
> >     Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > :040000 040000 c15d08d966391dec783d137558fad66d9c2da57b
> > : eddea2ec69c014370cf98cc2fc7e24a8dc301e70 M     lib
> >
> > .config attached
> > ~~
> > laurent
> Hi greg,
> 
> Apparently, its the wrong place to mark the kobject as uninitialized as the 
> kobject could be freed by then. I've now moved it to the top of 
> kobject_cleanup(). This fixes the problem for me.
> 
> laurent, can you please revert the above commit , and apply this patch ? Does 
> it help ?
> 
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index d784dae..a1f87bd 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -548,6 +548,9 @@ static void kobject_cleanup(struct kobject *kobj)
>         pr_debug("kobject: '%s' (%p): %s\n",
>                  kobject_name(kobj), kobj, __FUNCTION__);
>  
> +       /* Set the state to uninitialized */
> +       kobj->state_initialized = 0;
> +
>         if (t && !t->release)
>                 pr_debug("kobject: '%s' (%p): does not have a release() "
>                          "function, it is broken and must be fixed.\n",
> 
> 

Doh, this is correct, sorry about that, I'll fix this up properly...

thanks,

greg k-h
