Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYGWPMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYGWPMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYGWPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:11:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:57903 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYGWPLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=VtqF1E8sxpz1/2DgSQnCH/sk81U5kpwYUuAycrmnnAKSC4n/9vZF3kwUfvxmXYXPdE
         E29mrN/VxFuS51QoMhWaNbp2Wc2BibycWC1CXRY7ang5mN8HUYV6UGhAhK90YzFEocm+
         bh6y6bvGGijhGUDJ8jIK7tsxtB/MdKaCjTeOc=
Date: Wed, 23 Jul 2008 19:11:44 +0200
To: Andrei Popa <andrei.popa@i-neo.ro>, Oliver Neukum <oneukum@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel oops
Message-ID: <20080723171144.GA7349@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216817556.4415.29.camel@ierdnac>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 23, 2008 at 2:52 PM, Andrei Popa <andrei.popa@i-neo.ro> wrote:
>
> Hello,
>
> I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> and the kernel oopsed:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000458
> IP: [<c0444b52>] mutex_unlock+0x0/0xb
> *pde = 00000000
> Oops: 0002 [#1] PREEMPT SMP
>
> Pid: 19043, comm: gnokii Not tainted (2.6.26-ineo7 #2)
> EIP: 0060:[<c0444b52>] EFLAGS: 00010246 CPU: 0
> EIP is at mutex_unlock+0x0/0xb
...
>  [<c03830ae>] acm_tty_open+0x4c/0x214

This shouldn't be too hard; the code is trying to unlock the mutex
&acm->mutex even when "acm" is NULL. It seems that the label "err_out"
is otherwise unused, so it makes sense to move this one step further
down, so that it doesn't try to unlock the non-existant mutex.

If the problem is reproducible, you could try the patch below!


Vegard

PS: I actually think the code has some other problems too. Shouldn't
&acm->mutex be locked before we even inspect acm->dev?


Reported-by: Andrei Popa <andrei.popa@i-neo.ro>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 63c3404..74d03a7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -525,8 +525,8 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 	tasklet_schedule(&acm->urb_task);
 
 done:
-err_out:
 	mutex_unlock(&acm->mutex);
+err_out:
 	mutex_unlock(&open_mutex);
 	return rv;
 
