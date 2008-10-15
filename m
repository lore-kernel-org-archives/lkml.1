Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYJOTvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYJOTvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYJOTuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:61913 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYJOTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UUbDzPpzEj9tFmuyrFw4/vFsMGH+/Ywqgu71FvEWiaVKsTjtromMzADkirWBHfvwT9
         JRFNVf2uvkoU5YK2Rj2wmPYAhoRNtlTzLSEmDGL73NFd/rCpqfpGB4ObuXwqEtQGR3cn
         5n5g2S3YofuM1PZKc+74ch9cgJ1WTPHukSc6s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ide: replace the global ide_lock spinlock by per-hwgroup spinlocks
Date: Wed, 15 Oct 2008 20:27:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Vaibhav V. Nivargi" <vaibhav.nivargi@gmail.com>,
       "Alok N. Kataria" <alokk@calsoftinc.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalex86.org>
References: <200810102126.14475.bzolnier@gmail.com> <87ej2ld761.fsf@denkblock.local>
In-Reply-To: <87ej2ld761.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152027.47368.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: replace the global ide_lock spinlock by per-hwgroup spinlocks
> >
> > Now that (almost) all host drivers have been fixed not to abuse ide_lock
> > and core code usage of ide_lock has been sanitized we may safely replace
> > ide_lock by per-hwgroup locks.
> >
> > This patch is partially based on earlier patch from Ravikiran G Thirumalai.
> >
> > While at it:
> > - don't use deprecated HWIF() and HWGROUP() macros
> > - update locking documentation in ide.h
> >
> > Cc: Vaibhav V. Nivargi <vaibhav.nivargi@gmail.com>
> > Cc: Alok N. Kataria <alokk@calsoftinc.com>
> > Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> > Cc: Shai Fultheim <shai@scalex86.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > this is against 2.6.27 + pata tree + pre-patchset posted on Wednesday
> > (http://lkml.org/lkml/2008/10/8/221)
> 
> I've only had a casual look at this patch, but there is one thing:
> 
> [...]
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> [...]
> > @@ -1091,11 +1092,11 @@ static int init_irq (ide_hwif_t *hwif)
> >  		 * linked list, the first entry is the hwif that owns
> >  		 * hwgroup->handler - do not change that.
> >  		 */
> > -		spin_lock_irq(&ide_lock);
> > +		spin_lock_irq(&hwgroup->lock);
> >  		hwif->next = hwgroup->hwif->next;
> >  		hwgroup->hwif->next = hwif;
> >  		BUG_ON(hwif->next == hwif);
> > -		spin_unlock_irq(&ide_lock);
> > +		spin_unlock_irq(&hwgroup->lock);
> >  	} else {
> >  		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
> >  				       hwif_to_node(hwif));
> 
> Something like
> 
> 	spin_lock_init(&hwgroup->lock);
> 
> should go into this else clause too.

Thanks!

I fixed this in v2, obvious interdiff:

...
v2:
Add missing spin_lock_init(&hwgroup->lock).  (Noticed by Elias Oltmanns)
...

diff -u b/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
--- b/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1103,6 +1103,8 @@
 		if (hwgroup == NULL)
 			goto out_up;
 
+		spin_lock_init(&hwgroup->lock);
+
 		hwif->hwgroup = hwgroup;
 		hwgroup->hwif = hwif->next = hwif;
 
