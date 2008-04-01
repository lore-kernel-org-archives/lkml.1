Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYDASzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYDASzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYDASzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:55:40 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:8321 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYDASzj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:55:39 -0400
Date: Tue, 1 Apr 2008 19:55:32 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080401185532.GA10046@deepthought>
References: <20080325200714.GA25487@deepthought> <20080325232417.8447318e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080325232417.8447318e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:24:17PM -0700, Andrew Morton wrote:
> 
> Looks like another post-2.6.24 regression for the list.
> 
> On Tue, 25 Mar 2008 20:07:14 +0000 Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> 
> > Hi,
> > 
> >  on one of my boxes, I've got a problem with gdm and kernels newer
> > than 2.6.24 (tested on 2.6.24.2, 2.6.24.4).  If I try to restart or
> > shut down from gdm, the window disappears but the X background remains
> > and the box stays in runlevel 5 until I switch to a tty and shut it
> > down (as root) or give it a 3-fingered salute to reboot.
> > 
> >  The same with 2.6.25-rc6-git8.
> > 
> >  The only oddity in the logs is a large block of
> > Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> > 'GET_CONFIG greeter/SetPosition :0'
> > Mar 24 13:49:29 bluesbreaker gdmlogin[2995]:   Got response: 'OK
> > false'
> > Mar 24 13:49:29 bluesbreaker gdmlogin[2995]: Sending command:
> > 'CLOSE'
> > Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> > 'CLOSE'
> > Mar 24 13:49:29 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> > loop
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> > end verify for ''
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> > login/Bad login
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> > loop
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> > end verify for ''
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> > login/Bad login
> > Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> > loop
> > ... about 165 repeats of these 3 lines, it seems to stop the
> > messages on its own, then I ran shutdown and got the normal
> > 
> > Mar 24 13:50:02 bluesbreaker shutdown[3000]: shutting down for
> > system halt
> > Mar 24 13:50:02 bluesbreaker init: Switching to runlevel: 0
> > Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/init.d/rc called with
> > arg 0
> > Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/rc0.d/K01cups called
> > with arg stop
> >  and so forth.
> > 
> >  Yes, I've got a lot of debugging in there, I used this box to find
> > out why gdm-2.20 gave me a messy shutdown, and left it in after I
> > reverted to gdm-2.18.
> > 
> >  This only happens with 64-bit kernels, I've been using it as i686
> > without any issues.
> > 
> >  While trying to debug this, I reverted the two drm patches from
> > 2.6.24.1 (in 2.6.24.4) and normal behaviour was restored.  I forgot
> > to change the extraversion, which meant my modules were overwritten.
> > When I later went back to the "bad 2.6.24.4" it shut down correctly.
> > Examination showed i2c_viapro was the key - if I rmmod it in
> > 2.6.24.x, gdm works correctly.  For the record, my 32-bit config is
> > very different, but does include i2c_viapro as a module.
> > 
> >  So, I started to think it might be an i2c problem.  But with
> > 2.6.25-rc6-git8 I can't get gdm to work correctly, neither by
> > reverting the patches, nor with rmmod, so for the moment I'm in the
> > dark.  My notes say that I managed to fix it one time on -rc6-git8,
> > by 'rmmod i2c_viapro' before logging out, but all subsequent attempts
> > to repeat this have failed.
> > 
> >  FWIW, the via ISA bridge is a 1106:3227 (VIA_8237, also
> > described as VT8237R in i2c-viapro).
> > 
> >  Going back to 2.6.24.4 and reverting only the following patch,
> > normal behaviour is restored:
> > 
> > diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
> > index e8d50af..ef5e6b1 100644
> > --- a/drivers/char/drm/drm_vm.c
> > +++ b/drivers/char/drm/drm_vm.c
> > @@ -506,6 +506,7 @@ static int drm_mmap_dma(struct file *filp,
> > struct vm_area_struct *vma)
> >         vma->vm_ops = &drm_vm_dma_ops;
> >  
> >         vma->vm_flags |= VM_RESERVED;   /* Don't swap */
> > +       vma->vm_flags |= VM_DONTEXPAND;
> >  
> >         vma->vm_file = filp;    /* Needed for drm_vm_open() */
> >         drm_vm_open_locked(vma);
> > @@ -655,6 +656,7 @@ static int drm_mmap_locked(struct file *filp,
> > struct vm_area_struct *vma)
> >                 return -EINVAL; /* This should never happen. */
> >         }
> >         vma->vm_flags |= VM_RESERVED;   /* Don't swap */
> > +       vma->vm_flags |= VM_DONTEXPAND;
> >  
> >         vma->vm_file = filp;    /* Needed for drm_vm_open() */
> >         drm_vm_open_locked(vma);
> > 
> >  I haven't been following 2.6.25 closely, but I assume that what got
> > applied to 2.6.24-stable was only part of the change to 2.6.25, and
> > perhaps some other part of it is affecting me ?
> > 
> >  .config.gz for 2.6.25-rc6-git8 is attached.
> > 
> > Ken
> > -- 
> > das eine Mal als Trag__die, das andere Mal als Farce
> > 
 I'm back on this with very mixed results - looks as if what I
reverted against 2.6.24.4 might not be the problem.  I've seen
failure to shutdown/reboot from gdm on versions of 2.6.24.n (>
2.6.24, with the patch above reverted) and intermittent failures in
2.6.25-rc.  Today's test results, with i2c-viapro removed from the
config (separate thread, it's a red herring): (success means it
rebooted or shut down, failure means gdm hung with just an X
background) - after failure, I shutdown or reboot from a tty)

2.6.25-rc1 success
2.6.25-rc1 success (used it to build rc7)
2.6.25-rc7 failure
2.6.25-rc1 failure (rebooted from rc7, wanted to shutdown).

 Looks like I'll have to bisect, and it may be nothing at all to do
with the patch above.  All I know for certain is that I haven't seen
the problem on vanilla 2.6.24, and it's intermittent.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
