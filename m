Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXDUPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXDUPIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXDUPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:08:13 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:49589
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752062AbXDUPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:08:12 -0400
Date: Sat, 21 Apr 2007 17:11:18 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH] fixed spinlock use in hysdn_log_close()
Message-ID: <20070421151118.GM5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kkeil@suse.de, kai.germaschewski@gmx.de,
	isdn4linux@listserv.isdn4linux.de
References: <20070411170907.GO24898@traven> <20070420174146.42ccd6b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420174146.42ccd6b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, Apr 20, 2007 at 05:41:46PM -0700 Andrew Morton ha dit:

> On Sat, 14 Apr 2007 07:09:07 +0200
> Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> 
> > fixed incorrect spinlock use in hysdn_log_close(). the function
> > declared a spinlock on the stack and used it to 'protect' a shared
> > driver structure. the patch removes the declaration of hysdn_lock and 
> > uses card->hysdn_lock instead.
> > 
> 
> Interesting.
> 
> > 
> > ---
> > diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
> > index f7e83a8..32f0b75 100644
> > --- a/drivers/isdn/hysdn/hysdn_proclog.c
> > +++ b/drivers/isdn/hysdn/hysdn_proclog.c
> > @@ -299,7 +299,6 @@ hysdn_log_close(struct inode *ino, struct file *filep)
> >  	hysdn_card *card;
> >  	int retval = 0;
> >  	unsigned long flags;
> > -	spinlock_t hysdn_lock = SPIN_LOCK_UNLOCKED;
> >  
> >  	lock_kernel();
> >  	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
> > @@ -309,7 +308,7 @@ hysdn_log_close(struct inode *ino, struct file *filep)
> >  		/* read access -> log/debug read, mark one further file as closed */
> >  
> >  		pd = NULL;
> > -		spin_lock_irqsave(&hysdn_lock, flags);
> > +		spin_lock_irqsave(&card->hysdn_lock, flags);
> 
> I guess it won't hurt - are you actually able to test this code?
> 
> afaict most of the data in there is locked with lock_kernel(), if it's
> locked at all.
> 
> If you had some runtime problem and this patch fixed it then fine.  If
> however you're not able to test this code then perhaps the safest option is
> to simply remove that locking altogether, which is pretty much a
> runtime-equivalent change.

i'm sorry, but i can't test it, i don't have the device. initially the
patch was a kernel janitorial with the idea to replace the assignation
to SPIN_LOCK_UNLOCKED by DEFINE_SPINLOCK. when i sent the first patch
to the kj list someone pointed me to the spinlock on stack. 

i also wondered about the use of the spinlock after aquiring the big
kernel lock, i agree that it's probable the safest to remove the
spinlockaltogether. below you find a patch that does this.

thanks for your comments

--

remove spinlock hysdn_lock (declared on the stack) from HYSDN
driver. the code region is already protected by the big kernel lock.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
index f7e83a8..ab18965 100644
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -298,8 +298,6 @@ hysdn_log_close(struct inode *ino, struct file *filep)
 	struct procdata *pd;
 	hysdn_card *card;
 	int retval = 0;
-	unsigned long flags;
-	spinlock_t hysdn_lock = SPIN_LOCK_UNLOCKED;
 
 	lock_kernel();
 	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
@@ -309,7 +307,6 @@ hysdn_log_close(struct inode *ino, struct file *filep)
 		/* read access -> log/debug read, mark one further file as closed */
 
 		pd = NULL;
-		spin_lock_irqsave(&hysdn_lock, flags);
 		inf = *((struct log_data **) filep->private_data);	/* get first log entry */
 		if (inf)
 			pd = (struct procdata *) inf->proc_ctrl;	/* still entries there */
@@ -332,7 +329,6 @@ hysdn_log_close(struct inode *ino, struct file *filep)
 			inf->usage_cnt--;	/* decrement usage count for buffers */
 			inf = inf->next;
 		}
-		spin_unlock_irqrestore(&hysdn_lock, flags);
 
 		if (pd)
 			if (pd->if_used <= 0)	/* delete buffers if last file closed */


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

               If sharing a thing in no way diminishes it,
               it is not rightly owned if it is not shared
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
