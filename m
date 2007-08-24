Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbXHXMqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbXHXMqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760741AbXHXMqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:46:38 -0400
Received: from mailhub.hp.com ([192.151.27.10]:46486 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684AbXHXMqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:46:36 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Fri, 24 Aug 2007 08:46:31 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824124631.GF10594@localhost>
References: <20070823222115.122a37ca@localhost> <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com> <1187903135.6024.18.camel@localhost.localdomain> <1187905306.6024.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187905306.6024.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:	[Thu Aug 23 2007, 05:41:45PM EDT]
> On Thu, 2007-08-23 at 14:05 -0700, john stultz wrote:
> > On Thu, 2007-08-23 at 13:41 -0700, Luck, Tony wrote:
> > > > I have a double "hpet" entry in "available_clocksource":
> > > >	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > >	tsc hpet hpet acpi_pm jiffies
> > > 
> > > Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
> > > both register a clocksource named "hpet".  Probably a result of bringing
> > > back to life a long lost patch, and having someone else (John Stultz, according
> > > to git blame) make a similar change to a different file in the intervening
> > > time.
> > > 
> > > Presumably the thing to do would be merge the x86_64 specific version
> > > into the drivers/char/hpet.c version?
> > 
> > Ugh. Yea. i386 has an hpet clocksource as well. We should kill the
> > duplication, but at the moment I'm not comfortable that the
> > driver/char/hpet.c is ok to be used for i386/x86_64 (Bob: Do you know
> > why the shift value is only 10?).
> > 
> > 
> > I'm a little surprised by this, as the clocksource code use to prevent
> > duplicate named clocksources from being registered, so I'm not sure how
> > that check got dropped.  Also I'm not quite sure I see where the hard
> > freeze is coming from.
> > 
> > My initial reaction would be to either ifdef ia64 implementation in
> > drivers/char/hpet.c or move the code under the ia64 arch dir until it is
> > really usable by all arches.
> 
> Here is a possible quick fix. I'm open to other approaches, but I also
> want to avoid too much churn before 2.6.23 goes out.
> 
> Paolo, could you verify this fixes the issue for you?
> 
> thanks
> -john
> 
[snip]

I saw what was missed by me in my brief examination of this last night.
The platform registers the hpet clocksource too.

Instead of adding the config flag to hpet driver, how about the patch
below? Since you already check for duplication by address then adding
a check for by name too seems okay to me.

bob


Prevent duplicate names being registered with clocksource. This also
eliminates the duplication of hpet clock registration when the arch
uses the hpet timer and the hpet driver does too. The patch was
compile and link tested.


Signed-off-by: Bob Picco <bob.picco@hp.com>

 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc3/kernel/time/clocksource.c
===================================================================
--- linux-2.6.23-rc3.orig/kernel/time/clocksource.c	2007-08-23 16:44:03.000000000 -0400
+++ linux-2.6.23-rc3/kernel/time/clocksource.c	2007-08-24 08:36:41.000000000 -0400
@@ -281,7 +281,7 @@ static int clocksource_enqueue(struct cl
 		struct clocksource *cs;
 
 		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
+		if (cs == c || !strcmp(cs->name, c->name))
 			return -EBUSY;
 		/* Keep track of the place, where to insert */
 		if (cs->rating >= c->rating)
