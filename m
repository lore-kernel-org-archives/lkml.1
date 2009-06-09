Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZFIH6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZFIH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZFIH6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:58:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41398 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZFIH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:58:36 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
In-Reply-To: <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
Date: Tue, 09 Jun 2009 10:58:35 +0300
Message-Id: <1244534315.5024.34.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 2009-06-09 at 00:54 -0700, David Rientjes wrote:
> Larry reported this stack trace:
> 
> kernel: git: page allocation failure. order:1, mode:0x4020
> kernel: Pid: 3707, comm: git Not tainted 2.6.30-rc1-wl #115
> kernel: Call Trace:
> kernel:  [<ffffffff80292f84>] __alloc_pages_internal+0x43d/0x45d
> kernel:  [<ffffffff802b2383>] alloc_pages_current+0xbe/0xc6
> kernel:  [<ffffffff802b66a4>] new_slab+0xcf/0x28b
> 
> That's in the order fallback for new slab allocations; so this cache must 
> have oo_order(s->min) of 1.

Yes, agreed which is why I said it's unlikely that the allocated size is
800 bytes or so.

On Tue, 2009-06-09 at 00:54 -0700, David Rientjes wrote:
> To diagnose whether its object size dictates a >0 slab order, you could 
> enable CONFIG_SLUB_STATS (it's disabled in his .config) and check which 
> /sys/kernel/slab/cache/order_fallback increased.  Once you have identified 
> the cache, you can get this information via 
> /sys/kernel/slab/cache/{objsize,order,size}.  I think this is what 
> Christoph was getting at.
> 
> You could even boot with `slub_nomerge' to determine whether cache merging 
> was the issue where the cache under consideration was unnecessarily merged 
> with one that requires larger higher order minimums.

Sure. Applying my diagnostic patch will probably shed some light on the
subject too.

On Tue, 2009-06-09 at 00:54 -0700, David Rientjes wrote:
> I don't quite understand how its necessary to print the partial lists for 
> each node, they should be exhausted if we're allocating a new slab if the 
> node doesn't matter (and can't in Larry's case, he only has one).

It doesn't hurt either, does it? Yes, we expect the partial lists to be
exhausted but it's better to print that out just in case we have a bug
some day somewhere and that condition is not true. This is very
infrequent slow patch code here anyway.

			Pekka

