Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZFIIPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZFIIPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbZFIIPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:15:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZFIIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:15:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=g1hk2J1uOiXwxwYjD0kKk1/7OkxZFepqDt88a1OtV6Eiysxt3eRfLPQyYggQ44diF
	ZC26yOm/pRDyE9J7urEEQ==
Date: Tue, 9 Jun 2009 01:14:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <1244534315.5024.34.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
 <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com> <20090608110303.GD15377@csn.ul.ie> <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI> <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com> <1244534315.5024.34.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Pekka Enberg wrote:

> > To diagnose whether its object size dictates a >0 slab order, you could 
> > enable CONFIG_SLUB_STATS (it's disabled in his .config) and check which 
> > /sys/kernel/slab/cache/order_fallback increased.  Once you have identified 
> > the cache, you can get this information via 
> > /sys/kernel/slab/cache/{objsize,order,size}.  I think this is what 
> > Christoph was getting at.
> > 
> > You could even boot with `slub_nomerge' to determine whether cache merging 
> > was the issue where the cache under consideration was unnecessarily merged 
> > with one that requires larger higher order minimums.
> 
> Sure. Applying my diagnostic patch will probably shed some light on the
> subject too.
> 

I wasn't sure whether you were proposing the patch as an addition to slub 
or just to help with this issue.  I agree it would help in a hopefully 
ratelimited manner for general slab allocation failures and would have 
avoided some of the confusion for this issue from lack of diagnostics.

> > I don't quite understand how its necessary to print the partial lists for 
> > each node, they should be exhausted if we're allocating a new slab if the 
> > node doesn't matter (and can't in Larry's case, he only has one).
> 
> It doesn't hurt either, does it? Yes, we expect the partial lists to be
> exhausted but it's better to print that out just in case we have a bug
> some day somewhere and that condition is not true. This is very
> infrequent slow patch code here anyway.
> 

It will lead to false postiives since you can get a free to a full slab 
which moves it back to an allowed node's partial list before count_free() 
is printed.
