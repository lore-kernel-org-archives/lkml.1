Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZBITzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZBITzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZBITyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:54:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:47794 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZBITyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xvaewTANHwgDStNjpP02uO2to1H2nnqdxOP+k3S/mbtXj919gvkGnAEQrVcqKxqzho
         fz+/qoGBI7J0SF6vZ5lrDMxTPGSPkfXMmBiBm1ubRhYSy79cig8a8Mo+TYAqZjnyLJN3
         hKYafo8uJ8P1opVRMx5AChu4O7PiU6tAjzL2A=
Date: Mon, 9 Feb 2009 20:54:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH] softlockup: remove timestamp checking from hung_task
Message-ID: <20090209195446.GA4572@nowhere>
References: <20090206233747.GA8747@google.com> <20090207162328.GA5779@nowhere> <20090207163440.GB5779@nowhere> <20090207165154.GC5779@nowhere> <20090209192956.GA7332@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209192956.GA7332@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 11:29:56AM -0800, Mandeep Singh Baines wrote:
> Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > BTW, here is a small fixlet on top of your patch about what I commented concerning
> > the tasks than weren't yet scheduled once:
> > 
> > --
> > From e7120e424b031978e482b5fe311d90916ffb8b7e Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Sat, 7 Feb 2009 17:45:12 +0100
> > Subject: [PATCH] softlockup: ensure the task has been scheduled once
> > 
> > When we check if the task has been scheduled since the last scan, we might
> > have a race condition if the task has been inserted on the task list but not
> > yet scheduled once. So we just add a small check to ensure it has been switched
> > in at least one time to avoid false positive.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/hung_task.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> > index 4a10756..7f57a71 100644
> > --- a/kernel/hung_task.c
> > +++ b/kernel/hung_task.c
> > @@ -72,7 +72,11 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
> >  {
> >  	unsigned long switch_count = t->nvcsw + t->nivcsw;
> >  
> > -	if (t->flags & PF_FROZEN)
> > +	/*
> > +	 * Ensure the task is not frozen and that it has been scheduled
> > +	 * at least once.
> > +	 */
> > +	if (t->flags & PF_FROZEN || !switch_count)
> >  		return;
> >  
> >  	if (switch_count != t->last_switch_count) {
> > -- 
> > 1.6.1
> > 
> 
> Good catch! I would change the description though. The race is a little
> more subtle than your current description. For a newly forked process, the race
> can occur if check_hung_task() processes the task in the time between the task
> changing its state to UNINTERRUPTIBLE and the the scheduler updating the
> switch_count (nivcsw or nvcsw).
> 
> One minor change to the  code comment. You want to ensure that the task has
> context switched at least once, NOT that the task has been scheduled at least
> once.

Ooh ok. I thought that the first schedule updated nivcsw/nvcsw, that's why
I cancelled my comment.

Ok so I will resend the patch with the appropriate comment.


> 
> If you re-send the patch with the fixed comment and description, I'll
> ack it.

Thanks! :-)

