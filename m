Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZJKUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZJKUlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZJKUle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:41:34 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:56517 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZJKUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IFRNPnZM7cyNb9O2g3IfeNIc+P7cZTYHL8zhemc0JMEUzGRtg+GWLb3FiC6M8eocNP
         TnfHgKnQJRHfUC4MW9/3D2YA6zf6elxJv3vpHMMLNKUBiLix7VzK9mhS9nfKpb8s7JaL
         qqTa+8zDf2K1Mzn3gJhe0TW5tEXZ4CotRf19o=
Date: Sun, 11 Oct 2009 22:40:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: John Kacur <jkacur@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011204052.GB5486@nowhere>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain> <20091011113317.GA4901@nowhere> <alpine.LFD.2.00.0910111437270.3587@localhost.localdomain> <200910111612.41717.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910111612.41717.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 04:12:40PM +0200, Oliver Neukum wrote:
> Am Sonntag, 11. Oktober 2009 14:41:15 schrieb John Kacur:
> > @@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct
> > file *file) struct sound_unit *s;
> >         const struct file_operations *new_fops = NULL;
> >  
> > -       lock_kernel ();
> > -
> >         chain=unit&0x0F;
> >         if(chain==4 || chain==5)        /* dsp/audio/dsp16 */
> >         {
> > @@ -631,17 +629,17 @@ static int soundcore_open(struct inode *inode, struct
> > file *file) file->f_op = new_fops;
> >                 spin_unlock(&sound_loader_lock);
> >                 if(file->f_op->open)
> > +                       lock_kernel();
> >                         err = file->f_op->open(inode,file);
> > +                       unlock_kernel();
> >                 if (err) {
> >                         fops_put(file->f_op);
> >                         file->f_op = fops_get(old_fops);
> 
> Is that just me, or is file->f_op unguarded in this version?
> 
> 	Regards
> 		Oliver


Once assigned to file, the new fops won't move again.
And won't be freed until fops_put is called.

