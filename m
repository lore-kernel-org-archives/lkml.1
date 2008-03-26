Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYCZPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYCZPp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYCZPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:45:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40882 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYCZPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:45:13 -0400
Date: Wed, 26 Mar 2008 16:19:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Dave Airlie <airlied@gmail.com>, I2C <i2c@lm-sensors.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080326161934.7eae544f@hyperion.delvare>
In-Reply-To: <20080325200714.GA25487@deepthought>
References: <20080325200714.GA25487@deepthought>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

On Tue, 25 Mar 2008 20:07:14 +0000, Ken Moffat wrote:
> Hi,
> 
>  on one of my boxes, I've got a problem with gdm and kernels newer
> than 2.6.24 (tested on 2.6.24.2, 2.6.24.4).  If I try to restart or
> shut down from gdm, the window disappears but the X background remains
> and the box stays in runlevel 5 until I switch to a tty and shut it
> down (as root) or give it a 3-fingered salute to reboot.
> 
>  The same with 2.6.25-rc6-git8.
> 
>  The only oddity in the logs is a large block of
> Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> 'GET_CONFIG greeter/SetPosition :0'
> Mar 24 13:49:29 bluesbreaker gdmlogin[2995]:   Got response: 'OK
> false'
> Mar 24 13:49:29 bluesbreaker gdmlogin[2995]: Sending command:
> 'CLOSE'
> Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> 'CLOSE'
> Mar 24 13:49:29 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> loop
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> end verify for ''
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> login/Bad login
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> loop
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> end verify for ''
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> login/Bad login
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> loop
> ... about 165 repeats of these 3 lines, it seems to stop the
> messages on its own, then I ran shutdown and got the normal
> 
> Mar 24 13:50:02 bluesbreaker shutdown[3000]: shutting down for
> system halt
> Mar 24 13:50:02 bluesbreaker init: Switching to runlevel: 0
> Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/init.d/rc called with
> arg 0
> Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/rc0.d/K01cups called
> with arg stop
>  and so forth.
> 
>  Yes, I've got a lot of debugging in there, I used this box to find
> out why gdm-2.20 gave me a messy shutdown, and left it in after I
> reverted to gdm-2.18.
> 
>  This only happens with 64-bit kernels, I've been using it as i686
> without any issues.
> 
>  While trying to debug this, I reverted the two drm patches from
> 2.6.24.1 (in 2.6.24.4) and normal behaviour was restored.  I forgot
> to change the extraversion, which meant my modules were overwritten.
> When I later went back to the "bad 2.6.24.4" it shut down correctly.
> Examination showed i2c_viapro was the key - if I rmmod it in
> 2.6.24.x, gdm works correctly.  For the record, my 32-bit config is
> very different, but does include i2c_viapro as a module.

I have to admit that I am very skeptical. The i2c-viapro driver deals
with the motherboard's SMBus. It's not related in any way to gdm nor
drm, so I just can't see how it could cause the problem you report.
What gave you the idea to try unloading this driver?

Do you have I2C or SMBus devices connected to the SMBus on that machine?
If you don't know, i2cdetect should tell.

You say that your 32-bit and 64-bit configs are very different. It
might be interesting to get them to match as much as possible. This
could either point at a 64-bit specific problem, or isolate a kernel
configuration option which causes the problem.

> 
>  So, I started to think it might be an i2c problem.  But with
> 2.6.25-rc6-git8 I can't get gdm to work correctly, neither by
> reverting the patches, nor with rmmod, so for the moment I'm in the
> dark.  My notes say that I managed to fix it one time on -rc6-git8,
> by 'rmmod i2c_viapro' before logging out, but all subsequent attempts
> to repeat this have failed.

This brings a question: how many times (out of how many tries) did you
manage to fix your 2.6.24.x kernel with "rmmod i2c-viapro"? If it's
just 1 our of 1 try, it could be just luck? Did you try to rmmod any
other driver?

> 
>  FWIW, the via ISA bridge is a 1106:3227 (VIA_8237, also
> described as VT8237R in i2c-viapro).
> 
>  Going back to 2.6.24.4 and reverting only the following patch,
> normal behaviour is restored:
> 
> diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
> index e8d50af..ef5e6b1 100644
> --- a/drivers/char/drm/drm_vm.c
> +++ b/drivers/char/drm/drm_vm.c
> @@ -506,6 +506,7 @@ static int drm_mmap_dma(struct file *filp,
> struct vm_area_struct *vma)
>         vma->vm_ops = &drm_vm_dma_ops;
>  
>         vma->vm_flags |= VM_RESERVED;   /* Don't swap */
> +       vma->vm_flags |= VM_DONTEXPAND;
>  
>         vma->vm_file = filp;    /* Needed for drm_vm_open() */
>         drm_vm_open_locked(vma);
> @@ -655,6 +656,7 @@ static int drm_mmap_locked(struct file *filp,
> struct vm_area_struct *vma)
>                 return -EINVAL; /* This should never happen. */
>         }
>         vma->vm_flags |= VM_RESERVED;   /* Don't swap */
> +       vma->vm_flags |= VM_DONTEXPAND;
>  
>         vma->vm_file = filp;    /* Needed for drm_vm_open() */
>         drm_vm_open_locked(vma);
> 
>  I haven't been following 2.6.25 closely, but I assume that what got
> applied to 2.6.24-stable was only part of the change to 2.6.25, and
> perhaps some other part of it is affecting me ?
> 
>  .config.gz for 2.6.25-rc6-git8 is attached.
> 
> Ken


-- 
Jean Delvare
