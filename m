Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZJLKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZJLKoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZJLKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbZJLKob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:44:31 -0400
Date: Mon, 12 Oct 2009 12:42:39 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Takashi Iwai <tiwai@suse.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
In-Reply-To: <s5hr5t8ex1j.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.2.00.0910121241040.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain> <20091011004219.74c30f67@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0910110223510.4921@localhost.localdomain> <20091011113317.GA4901@nowhere> <alpine.LFD.2.00.0910111437270.3587@localhost.localdomain>
 <s5hiqelf8ow.wl%tiwai@suse.de> <alpine.LFD.2.00.0910121028420.3658@localhost.localdomain> <s5hr5t8ex1j.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Takashi Iwai wrote:

> At Mon, 12 Oct 2009 10:37:05 +0200 (CEST),
> John Kacur wrote:
> > 
> > On Mon, 12 Oct 2009, Takashi Iwai wrote:
> > 
> > > At Sun, 11 Oct 2009 14:41:15 +0200 (CEST),
> > > John Kacur wrote:
> > > > 
> > > > @@ -631,17 +629,17 @@ static int soundcore_open(struct inode *inode, struct file *file)
> > > >  		file->f_op = new_fops;
> > > >  		spin_unlock(&sound_loader_lock);
> > > >  		if(file->f_op->open)
> > > > +			lock_kernel();
> > > >  			err = file->f_op->open(inode,file);
> > > > +			unlock_kernel();
> > > 
> > > You certainly want braces around here, no?
> > > 
> > 
> > Oh, I don't know, I was kinda hoping that the spaces would magically 
> > impart bracketnishish to the whole thing. My God yes we want the brackets -
> > Thank you Takashi!
> > 
> > What follows is version four.
> > 
> > >From 90f527d2ae660a3a0e712075479a4cc24504ad45 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Sun, 11 Oct 2009 14:25:46 +0200
> > Subject: [PATCH] soundcore_open: Reduce the area BKL coverage in this function.
> > 
> > Most of this function is protected by the sound_loader_lock.
> > We can push down the BKL to this call out err = file->f_op->open(inode,file);
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > Acked-by: Alan Cox <alan@linux.intel.com>
> > ---
> >  sound/sound_core.c |   10 ++++------
> >  1 files changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/sound/sound_core.c b/sound/sound_core.c
> > index 49c9981..643a61f 100644
> > --- a/sound/sound_core.c
> > +++ b/sound/sound_core.c
> > @@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct file *file)
> >  	struct sound_unit *s;
> >  	const struct file_operations *new_fops = NULL;
> >  
> > -	lock_kernel ();
> > -
> >  	chain=unit&0x0F;
> >  	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
> >  	{
> > @@ -630,18 +628,18 @@ static int soundcore_open(struct inode *inode, struct file *file)
> >  		const struct file_operations *old_fops = file->f_op;
> >  		file->f_op = new_fops;
> >  		spin_unlock(&sound_loader_lock);
> > -		if(file->f_op->open)
> > +		if(file->f_op->open) {
> > +			lock_kernel();
> >  			err = file->f_op->open(inode,file);
> > -		if (err) {
> > +			unlock_kernel();
> > +		} if (err) {
> 
> It's better to break the line after the closing brace here.
> 

Thank you for your review Takashi.

I corrected the style problems, and added a bit of spacing to make the 
code more readable.

Version 5 follows

>From 8007707e02f68b6315ff80aa3ca471af12eeb491 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 11 Oct 2009 14:25:46 +0200
Subject: [PATCH] soundcore_open: Reduce the area BKL coverage in this function.

Most of this function is protected by the sound_loader_lock.
We can push down the BKL to this call out err = file->f_op->open(inode,file);

Signed-off-by: John Kacur <jkacur@redhat.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---
 sound/sound_core.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..2ca17ec 100644
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
@@ -630,18 +628,22 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		const struct file_operations *old_fops = file->f_op;
 		file->f_op = new_fops;
 		spin_unlock(&sound_loader_lock);
-		if(file->f_op->open)
+
+		if (file->f_op->open) {
+			lock_kernel();
 			err = file->f_op->open(inode,file);
+			unlock_kernel();
+		}
+
 		if (err) {
 			fops_put(file->f_op);
 			file->f_op = fops_get(old_fops);
 		}
+
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

