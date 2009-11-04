Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZKDAoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZKDAoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZKDAop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:44:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZKDAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:44:45 -0500
Date: Wed, 4 Nov 2009 01:43:36 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent^M^J Sanders <vince@simtec.co.uk>,
       Jonathan Corbet <corbet@lwn.net>,
       Christoph^M^J Hellwig <hch@infradead.org>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Subject: [PATCH] rtc: Explicitly set llseek to no_llseek
In-Reply-To: <20091103154800.f7f6ef5f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0911040132350.6542@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153350.046644063@linutronix.de> <alpine.LFD.2.00.0910212312270.3526@localhost.localdomain> <20091103154800.f7f6ef5f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Andrew Morton wrote:

> On Wed, 21 Oct 2009 23:13:26 +0200 (CEST)
> John Kacur <jkacur@redhat.com> wrote:
> 
> > >From e1b7175258b33da3b0564ef04a0b1956f04f0cc7 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Wed, 21 Oct 2009 23:10:30 +0200
> > Subject: [PATCH] rtc: Explicitly set llseek to no_llseek
> > 
> > Now that we've removed the BKL here, lets explicitly set llseek to no_llseek
> > since the default llseek is not used here.
> > 
> 
> I don't understand.
> 
> > 
> > diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
> > index 26a47dc..53c524e 100644
> > --- a/drivers/char/efirtc.c
> > +++ b/drivers/char/efirtc.c
> > @@ -285,6 +285,7 @@ static const struct file_operations efi_rtc_fops = {
> >  	.unlocked_ioctl	= efi_rtc_ioctl,
> >  	.open		= efi_rtc_open,
> >  	.release	= efi_rtc_close,
> > +	.llseek		= no_llseek,
> >  };
> >  
> >  static struct miscdevice efi_rtc_dev= {
> 
> What has this change to do with the BKL?

The default_llseek function still contains the BKL.
When we are auditing code to see if we can remove the BKL, this is one of 
the hidden considerations we need to take into account.
i.e., is there syncronization between code that has the BKL and llseek.

At the same time we remove the BKL it would be a good idea to do indicate 
when no llseek function is required, so we don't have to revisit this code 
again, when we are trying to determine if we can remove the BKL from
the default_llseek.
