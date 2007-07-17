Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXGQRR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXGQRR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbXGQRRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:17:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38722 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbXGQRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:17:11 -0400
Date: Tue, 17 Jul 2007 10:03:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-Id: <20070717100300.821650f5.randy.dunlap@oracle.com>
In-Reply-To: <20070717154934.GA24231@elte.hu>
References: <20070717114453.GA8212@elte.hu>
	<469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 17:49:34 +0200 Ingo Molnar wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> > > Subject: softlockup: fix Xen bogosity
> > > From: Ingo Molnar <mingo@elte.hu>
> > >
> > > this Xen related commit:
> > >   
> > 
> > Well, not just Xen.  It relates to any virtual environment: kvm, 
> > lguest, vmi, xen...  (Not that they all implement a measure of 
> > unstolen time.)
> > 
> > How about a more descriptive patch title, along the lines of 
> > "softlockup watchdog: fix rate limiting"?
> 
> uhm, the problem was that it did not work _at all_, not something about 
> 'rate limiting'. Yes, i got quite a bit grumpy when i found this, 
> because you completely broke the softlockup watchdog via a pretty 
> intrusive commit and you apparently didnt even do a minimal check 
> whether its functionality was preserved! Updated patch for Andrew/Linus 
> and for -stable attached.
> 
> 	Ingo
> 
> ----------------------------->
> Subject: fix the softlockup watchdog to actually work
> From: Ingo Molnar <mingo@elte.hu>
> 
> this Xen related commit:
> 
>    commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
>    Author: Jeremy Fitzhardinge <jeremy@goop.org>
>    Date:   Tue May 8 00:28:02 2007 -0700
> 
>        Ignore stolen time in the softlockup watchdog
> 
> broke the softlockup watchdog to never report any lockups. (!)
> 
> print_timestamp defaults to 0, this makes the following condition
> always true:
> 
> 	if (print_timestamp < (touch_timestamp + 1) ||
> 
> and we'll in essence never report soft lockups.
> 
> apparently the functionality of the soft lockup watchdog was never
> actually tested with that patch applied ...
> 
> [this is -stable material too.]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -79,10 +79,11 @@ void softlockup_tick(void)
>  	print_timestamp = per_cpu(print_timestamp, this_cpu);
>  
>  	/* report at most once a second */
> -	if (print_timestamp < (touch_timestamp + 1) ||
> -		did_panic ||
> -			!per_cpu(watchdog_task, this_cpu))
> +	if ((print_timestamp >= touch_timestamp &&
> +			print_timestamp < (touch_timestamp + 1)) ||
> +			did_panic || !per_cpu(watchdog_task, this_cpu)) {
>  		return;
> +	}
>  
>  	/* do not print during early bootup: */
>  	if (unlikely(system_state != SYSTEM_RUNNING)) {

patch contains unneeded braces { }.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
