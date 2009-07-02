Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZGBQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZGBQH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZGBQHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:07:51 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45410 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZGBQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=u3HAPR+Uuju6/ppvn+fLwGzVIeTq7uVGhJIrCJf5DW/UidR3+MCsyCR5eYBdtMqkKd
         liO6MTfRj9SwuGkIxkM746YLDyErCHZ9cTlsMB0GO++4yDMhPgsYAuWpK0FrYkITFRRY
         kpFT8b93Yc7ti5zh9mTzmPFtXAMIceTZOu0Tc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: wuzhangjin@gmail.com
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
Date: Thu, 2 Jul 2009 18:13:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.4; i686; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <200907011829.16850.bzolnier@gmail.com> <1246499203.9660.52.camel@falcon>
In-Reply-To: <1246499203.9660.52.camel@falcon>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907021813.57322.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009 03:46:43 Wu Zhangjin wrote:
> On Wed, 2009-07-01 at 18:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 01 July 2009 18:21:25 Bartlomiej Zolnierkiewicz wrote:
> > > On Wednesday 01 July 2009 16:47:41 Wu Zhangjin wrote:
> > > > On Wed, 2009-07-01 at 22:31 +0800, Jeff Chua wrote:
> > > > > On Tue, Jun 30, 2009 at 12:21 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:
> > > > > 
> > > > > > I just tried, and it "seems" to work. Will try a few more cycles.
> > > > > 
> > > > > STD/STR survived quite a few cycles now. Patch seems to be doing the
> > > > > right thing.
> > > > > 
> > > > > On Mon, Jun 29, 2009 at 11:51 PM, Etienne
> > > > > Basset<etienne.basset@numericable.fr> wrote:
> > > > > 
> > > > > > To have STR/resume work with current git, I have to :
> > > > > 
> > > > > > 1) apply Bart's patch
> > > > > 
> > > > > This is not yet in Linus's tree. And much needed to really fix the problem.
> > > > > 
> > > > > > 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b
> > > > > 
> > > > 
> > > > Yes, This commit must be reverted, otherwise, STD/Hibernation will not
> > > > work either. I have tested it on two different loongson-based machines:
> > > > fuloong2e box and yeeloong2f netbook.(loongson is mips compatiable)
> > > 
> > > Since it seems like Dave is taking his sweet time with doing the revert
> > > I stared at the code a bit more and I think that I finally found the bug
> > > (thanks to your debugging work for giving me the right hint!).
> > > 
> > > The patch needs to take into the account a new code introduced by the recent
> > > block layer changes (commit 8f6205cd572fece673da0255d74843680f67f879):
> > > 
> > > @@ -555,8 +560,11 @@ repeat:
> > >                 startstop = start_request(drive, rq);
> > >                 spin_lock_irq(&hwif->lock);
> > >  
> > > -               if (startstop == ide_stopped)
> > > +               if (startstop == ide_stopped) {
> > > +                       rq = hwif->rq;
> > > +                       hwif->rq = NULL;
> > >                         goto repeat;
> > > +               }
> > >         } else
> > >                 goto plug_device;
> > >  out:
> > > 
> > > and not zero hwif->rq if the device is blocked. 
> > > 
> > > Could you try the attached patch and see if it fixes the issue?
> > 
> > Here is the more complete version, also taking into the account changes
> > in ide_intr() and ide_timer_expiry():
> > 
> 
> Sorry, I can not apply this patch directly, which original version did
> you use? I used the one in the master branch of linux-mips development
> git repository.
> 
> commit 5a4f13fad1ab5bd08dea78fc55321e429d83cddf
> Merge: ec9c45d e18ed14
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Jun 29 20:07:43 2009 -0700
> 
>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6
>     
>     * git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6:
>       ide: memory overrun in ide_get_identity_ioctl() on big endian
> machines using ioctl HDIO_OBSOLETE_IDENTITY
>       ide: fix resume for CONFIG_BLK_DEV_IDEACPI=y
>       ide-cd: handle fragmented packet commands gracefully
>       ide: always kill the whole request on error
>       ide: fix ide_kill_rq() for special ide-{floppy,tape} driver
> requests
> 
> it this too old? should i merge another git repository?

Weird, I used linux-next but Linus' tree should also be fine
(as it matches linux-next w.r.t. ide currently).

Anyway since the patch was confirmed to fix the problem by
Jeff and Etienne here is the final version for Dave.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: make resume work again

It turns out that commit a1317f714af7aed60ddc182d0122477cbe36ee9b
("ide: improve handling of Power Management requests") needs to take
into the account a new code added by the recent block layer changes
in commit 8f6205cd572fece673da0255d74843680f67f879 ("ide: dequeue
in-flight request") and prevent clearing of hwif->rq if the device
is blocked.

Thanks to Etienne, Wu and Jeff for help in fixing the issue.

Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
Reported-and-tested-by: Etienne Basset <etienne.basset@numericable.fr>
Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Added patch description, no other changes.

 drivers/ide/ide-io.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -532,7 +532,8 @@ repeat:
 
 		if (startstop == ide_stopped) {
 			rq = hwif->rq;
-			hwif->rq = NULL;
+			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0)
+				hwif->rq = NULL;
 			goto repeat;
 		}
 	} else
@@ -679,8 +680,10 @@ void ide_timer_expiry (unsigned long dat
 		spin_lock_irq(&hwif->lock);
 		enable_irq(hwif->irq);
 		if (startstop == ide_stopped && hwif->polling == 0) {
-			rq_in_flight = hwif->rq;
-			hwif->rq = NULL;
+			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
+				rq_in_flight = hwif->rq;
+				hwif->rq = NULL;
+			}
 			ide_unlock_port(hwif);
 			plug_device = 1;
 		}
@@ -856,8 +859,10 @@ irqreturn_t ide_intr (int irq, void *dev
 	 */
 	if (startstop == ide_stopped && hwif->polling == 0) {
 		BUG_ON(hwif->handler);
-		rq_in_flight = hwif->rq;
-		hwif->rq = NULL;
+		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
+			rq_in_flight = hwif->rq;
+			hwif->rq = NULL;
+		}
 		ide_unlock_port(hwif);
 		plug_device = 1;
 	}
