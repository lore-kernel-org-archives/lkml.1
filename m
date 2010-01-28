Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394Ab0A1UKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0A1UKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801Ab0A1UJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:09:59 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44719 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0A1UJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LxSYclceO9ly4oaW6t42FfR4LiRVuXZ0lIRh4HFIYLeX8W6aCnviP12I8AuOXCjzME
         yyUHcOkRFhNiPREk9c5JwQxa5MoAEofxB1xTKOnChWvD38RWxcQlR5CCRNXu9RlcSgmj
         gJDQw5Febu1UdoG7M6EraTy+laS5fUdCRohKk=
Date: Thu, 28 Jan 2010 21:09:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] perf,hw_breakpoint,kgdb: No mutex taken for
	kerneldebugger
Message-ID: <20100128200951.GD18683@nowhere>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-4-git-send-email-jason.wessel@windriver.com> <20100128173307.GB18683@nowhere> <4B61CE1A.8090001@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61CE1A.8090001@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:49:14AM -0600, Jason Wessel wrote:
> Frederic Weisbecker wrote:
> >> +static int hw_break_release_slot(int breakno)
> >> +{
> >> +	struct perf_event **pevent;
> >> +	int ret;
> >> +	int cpu;
> >> +
> >> +	for_each_online_cpu(cpu) {
> >> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
> >> +		ret = dbg_release_bp_slot(*pevent);
> >>     
> >
> >
> >
> > So, you are missing some return errors there. Actually, a slot
> > release shouldn't return an error.
> >
> >
> >   
> 
> This is a trick so to speak.   Either all the slot releases will return
> 0 or -1 depending on if the mutex is available, so it is not really
> missed. 



Oh right, I forgot everything was freezed here :)


 
> > Ok, best effort fits well for reserve, but is certainly not
> > suitable for release. We can't leave a fake occupied slot like
> > this. If it fails, we should do this asynchronously, using the
> > usual release_bp_slot, may be toward the workqueues.
> >
> >
> >
> >   
> 
> If it fails the debugger tried to remove it again later.   It seems to
> me like it is a don't care corner case.   You get a printk if it ever
> does happen (which it really shouldn't).



Yeah truly it's a corner case, especially if the debugger can handle that
later.

May be just add a comment so that future reviewers don't stick to
this part.

 
Thanks!

