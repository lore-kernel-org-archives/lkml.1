Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZABVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZABVL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbZABVLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:11:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65474 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580AbZABVLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:11:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MuTEaetPHrtcf6/08sM6XNZk96oHgkqZqL6fYdj56MoIR4Ea3I2U5+SlPxbBFXSFx/
         gtAEjU0ev2kITEDfPEo+y+2uR0KimF8kJP+PmqXo303/bUR3Ff7l5jzfqoxaFmPr45Xb
         4saY13LV9sBAIFWlZR+qWQZog5QQ5V+am9aj0=
Date: Fri, 2 Jan 2009 22:11:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: unsigned idx cannot be less than 0
Message-ID: <20090102211140.GA5770@nowhere>
References: <495E2987.3070501@gmail.com> <20090102154805.GA6833@nowhere> <495E68F5.5010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E68F5.5010309@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 08:20:21PM +0100, Roel Kluin wrote:
> Frederic Weisbecker wrote:
> > On Fri, Jan 02, 2009 at 03:49:43PM +0100, Roel Kluin wrote:
> >> // vi kernel/trace/ftrace.c +787
> >> struct ftrace_iterator {
> >> ...
> >>         unsigned                idx;
> >> ...
> >> };
> >>
> >> idx is unsigned and cannot be less than 0.
> >>
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >> ---
> >> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> >> index 2f32969..a344add 100644
> >> --- a/kernel/trace/ftrace.c
> >> +++ b/kernel/trace/ftrace.c
> >> @@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
> >>  	void *p = NULL;
> >>  
> >>  	if (*pos > 0) {
> >> -		if (iter->idx < 0)
> >> +		if (iter->idx == 0)
> >>  			return p;
> >>  		(*pos)--;
> >>  		iter->idx--;
> > 
> > 
> > Hi Roel,
> > 
> > I'm not sure this is the right fix.
> > If you look at t_next, if there is no more page to look at,
> > iter_idx takes -1.
> > 
> > A 0 value would mean: we are in the first index on the page, which means
> > there is something to read and we don't want to return NULL.
> > 
> > I guess that would be better to turn idx into a signed int.
> 
> If we turn idx in a signed int, isn't it true that
> in kernel/trace/ftrace.c, line 806:
> 
> retry:
> if (iter->idx >= iter->pg->index) {
> 	...
> } else {
> 	iter->idx++;
> 	if ( a certain rec-> and iter->flags )
> 		goto retry;
> }
> 
> since iter->pg->index is an unsigned long, when larger than INT_MAX this
> could result in an endless loop?
> 
> Roel


Actually, this is not supposed to reach such a threshold.
Looks like it wouldn't increase over ENTRIES_PER_PAGE (defined
in ftrace.c) which is smaller than PAGE_SIZE.
So it will stay far from an overflow.

I don't think this type conversion would be an issue. But perhaps
there are other things that I don't see.

