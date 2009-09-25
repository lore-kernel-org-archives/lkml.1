Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZIYBXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZIYBXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIYBXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:23:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33825 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbZIYBXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:23:35 -0400
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid
 context
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: iceberg <strakh@ispras.ru>, eric@andante.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090924155604.4299aa0a.akpm@linux-foundation.org>
References: <200909231758.47612.strakh@ispras.ru>
	 <20090924155604.4299aa0a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 18:23:36 -0700
Message-Id: <1253841816.5183.361.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 15:56 -0700, Andrew Morton wrote:
> On Wed, 23 Sep 2009 17:58:47 +0000
> iceberg <strakh@ispras.ru> wrote:
> 
> > Driver scsi_lib.c might sleep in atomic context, because it calls 
> > scsi_device_put under spin_lock_irqsave.
> > drivers/scsi/scsi_lib.c:356:
> > 	spin_lock_irqsave(shost->host_lock, flags);
> > 	scsi_device_put(sdev);
> > Path to might_sleep macro from scsi_device_put:
> > 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> > 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> > 3. kobject_put calls kref_put at ./lib/kobject.c
> > 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> > refcount becomes zero, which might_sleep because it calls user event. Details:
> > 	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> > 	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
> > 	4.3 kobject_uevent_env calls call_usermodehelper_exec at 
> > ./include/linux/kmod.h:83
> > 	4.4 call_usermodehelper_exec calls wait_for_completion at 
> > ./kernel/kmod.c:481
> > 	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> > 	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> > 
> > Found by Linux Driver Verification project.
> > 
> > Delete wrong sleeping function calls.
> > 
> > Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> > 
> > ---
> > diff --git a/./a/drivers/scsi/scsi_lib.c b/./b/drivers/scsi/scsi_lib.c
> > index f3c4089..a8f8e2f 100644
> > --- a/./a/drivers/scsi/scsi_lib.c
> > +++ b/./b/drivers/scsi/scsi_lib.c
> > @@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct scsi_device 
> > *current_sdev)
> >  
> >  		spin_unlock_irqrestore(shost->host_lock, flags);
> >  		blk_run_queue(sdev->request_queue);
> > -		spin_lock_irqsave(shost->host_lock, flags);
> >  	
> > -		scsi_device_put(sdev);
> > +		scsi_device_put(sdev);	
> > +		spin_lock_irqsave(shost->host_lock, flags);
> >  	}
> >   out:
> >  	spin_unlock_irqrestore(shost->host_lock, flags);
> > 
> 
> Well this is strange.  afacit all the code to which you refer is
> ancient, so why did this bug just pop up now?

No idea.  I think the root cause of this is in the kobject code:  we
explicitly require the ability to call last put from interrupt context
(and that includes holding locks).  I'll talks to Greg and Kai about
this (they're both here at plumbers).  I think the fix is to indirect
the kobject uevent stuff via a usermode helper so we don't get this
problem.

James

---


