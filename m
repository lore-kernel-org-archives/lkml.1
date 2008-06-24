Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYFXUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYFXUuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYFXUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:50:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYFXUuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:50:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Date: Tue, 24 Jun 2008 22:51:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       mingo@elte.hu, torvalds@linux-foundation.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
References: <20080601153042.GA8238@tv-sign.ru> <20080623135253.ed7cabf1.akpm@linux-foundation.org> <20080624134240.GA310@tv-sign.ru>
In-Reply-To: <20080624134240.GA310@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242251.23125.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 of June 2008, Oleg Nesterov wrote:
> On 06/23, Andrew Morton wrote:
> >
> > On Mon, 23 Jun 2008 13:47:06 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > I don't yet know how much additional damage will happen as a result.
> > 
> > Lots.
> > 
> > I restored the patches and just dropped the hunk:
> > 
> >   static int has_mm(struct task_struct *p)
> >   {
> > -       return (p->mm && !(p->flags & PF_BORROWED_MM));
> >   }
> >   
> >   /**
> > --- 86,92 ----
> >   
> >   static int has_mm(struct task_struct *p)
> >   {
> > +       return (p->mm && !(p->flags & PF_KTHREAD));
> >   }
> > 
> > due to that function having been turned into:
> > 
> > static inline bool should_send_signal(struct task_struct *p)
> > {
> >         return !(p->flags & PF_FREEZER_NOSIG);
> > }
> >
> > Please check the result?
> 
> Thanks, this looks OK.
> 
> Rafael, can't freezer just use PF_KTHREAD (which btw kills PF_BORROWED_MM)
> instead of the new PF_FREEZER_NOSIG flag? They look very similar, please
> look at
> 
> 	"[PATCH 1/3] introduce PF_KTHREAD flag"
> 	http://marc.info/?l=linux-kernel&m=121233423530812
> 
> 	"[PATCH 2/3] kill PF_BORROWED_MM in favour of PF_KTHREAD"
> 	http://marc.info/?l=linux-kernel&m=121233423530820

The problem is that some kernel threads may actually want to clear
PF_FREEZER_NOSIG, but it would be invalid to clear PF_KTHREAD I think.

Hmm, well, in principle we could use two flags for that, with the combinations
of bits defined as follows:
11 - user space task (freezable with a fake signal)
10 - kernel thread freezable with a fake signal
01 - kernel thread freezable withoug a fake signal
00 - non-freezable kernel thread

Thanks,
Rafael
