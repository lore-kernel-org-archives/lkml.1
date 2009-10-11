Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbZJKMme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbZJKMme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZJKMmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZJKMmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:42:32 -0400
Date: Sun, 11 Oct 2009 14:41:15 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
In-Reply-To: <20091011113317.GA4901@nowhere>
Message-ID: <alpine.LFD.2.00.0910111437270.3587@localhost.localdomain>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain> <20091011004219.74c30f67@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0910110223510.4921@localhost.localdomain> <20091011113317.GA4901@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Oct 2009, Frederic Weisbecker wrote:

> On Sun, Oct 11, 2009 at 02:25:53AM +0200, John Kacur wrote:
> > 
> > 
> > On Sun, 11 Oct 2009, Alan Cox wrote:
> > 
> > > On Sun, 11 Oct 2009 01:24:14 +0200 (CEST)
> > > John Kacur <jkacur@redhat.com> wrote:
> > > 
> > > > >From 030af455d4f54482130c8eccb47fe90aaba8808c Mon Sep 17 00:00:00 2001
> > > > From: John Kacur <jkacur@redhat.com>
> > > > Date: Sat, 10 Oct 2009 23:39:56 +0200
> > > > Subject: [PATCH] This code is already protected by spin_lock, and doesn't require the bkl
> > > 
> > > Sorry but I don't think that is true becaue of:
> > > 
> > >            spin_unlock(&sound_loader_lock);
> > >                 if(file->f_op->open)
> > >                         err = file->f_op->open(inode,file);
> > > 
> > > 
> > > So the underlying driver open method expects lock_kernel status and you
> > > don't propogate it down. You really need to track down each thing that
> > > can be called into here and fix it, or maybe just punt for the moment and
> > > push it down to
> > > 
> > > 	{
> > > 		lock_kernel()
> > > 		err = file-f_op->open ...
> > > 		unlock_kernel()
> > > 	}
> > > 
> > > so its obvious to the next person who takes up the war on the BKL what is
> > > to be tackled.
> > > 
> > 
> > Yikes, I missed that. Still I'm loath to just push it down like that. I 
> > wonder if I can use a mutex there. What about the following patch?
> > 
> > From 8b0b91523ee2fcf60ccd82dba44b8da8bad34ce4 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Sun, 11 Oct 2009 02:14:44 +0200
> > Subject: [PATCH] Remove the bkl in soundcore_open
> > 
> > Remove the bkl in soundcore_open since it is mostly covered by the sound_loader_lock spin_lock
> > 
> > Protect the underlying driver open method with a mutex.
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  sound/sound_core.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/sound/sound_core.c b/sound/sound_core.c
> > index 49c9981..6afb6f1 100644
> > --- a/sound/sound_core.c
> > +++ b/sound/sound_core.c
> > @@ -14,6 +14,8 @@
> >  #include <linux/major.h>
> >  #include <sound/core.h>
> >  
> > +static DEFINE_MUTEX(osc_mutex);
> > +
> >  #ifdef CONFIG_SOUND_OSS_CORE
> >  static int __init init_oss_soundcore(void);
> >  static void cleanup_oss_soundcore(void);
> > @@ -576,8 +578,6 @@ static int soundcore_open(struct inode *inode, struct file *file)
> >  	struct sound_unit *s;
> >  	const struct file_operations *new_fops = NULL;
> >  
> > -	lock_kernel ();
> > -
> >  	chain=unit&0x0F;
> >  	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
> >  	{
> > @@ -631,17 +631,17 @@ static int soundcore_open(struct inode *inode, struct file *file)
> >  		file->f_op = new_fops;
> >  		spin_unlock(&sound_loader_lock);
> >  		if(file->f_op->open)
> > +			mutex_lock(&osc_mutex);
> >  			err = file->f_op->open(inode,file);
> > +			mutex_unlock(&osc_mutex);
> 
> 
> Yeah that's tempting, but I fear that also means this mutex will
> never be removed....
> 

Sigh... I do see your point - but on the otherhand if measurements don't
show that mutex as being too coarse grained, then is it a problem?

Never-the-less here is version 3 of the patch - like Alan suggested, 
punting, but at least reducing the area covered by the BKL.
>From ac9bdbdd192149e2498b6e16dc71f0a3933e1554 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 11 Oct 2009 14:25:46 +0200
Subject: [PATCH] soundcore_open: Reduce the area BKL coverage in this function.

Most of this function is protected by the sound_loader_lock.
We can push down the BKL to this call out err = file->f_op->open(inode,file);

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 sound/sound_core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..a7d6956 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct file *file)
 	struct sound_unit *s;
 	const struct file_operations *new_fops = NULL;
 
-	lock_kernel ();
-
 	chain=unit&0x0F;
 	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
 	{
@@ -631,17 +629,17 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		file->f_op = new_fops;
 		spin_unlock(&sound_loader_lock);
 		if(file->f_op->open)
+			lock_kernel();
 			err = file->f_op->open(inode,file);
+			unlock_kernel();
 		if (err) {
 			fops_put(file->f_op);
 			file->f_op = fops_get(old_fops);
 		}
 		fops_put(old_fops);
-		unlock_kernel();
 		return err;
 	}
 	spin_unlock(&sound_loader_lock);
-	unlock_kernel();
 	return -ENODEV;
 }
 
-- 
1.6.0.6


