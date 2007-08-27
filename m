Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbXH0Vw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbXH0Vw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965172AbXH0VkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:40:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33786 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765952AbXH0VkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:40:16 -0400
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
From: john stultz <johnstul@us.ibm.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Bob Picco <bob.picco@hp.com>, "Luck, Tony" <tony.luck@intel.com>,
       Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070827173458.5a1ffed1@localhost>
References: <20070823222115.122a37ca@localhost>
	 <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	 <1187903135.6024.18.camel@localhost.localdomain>
	 <1187905306.6024.24.camel@localhost.localdomain>
	 <20070824124631.GF10594@localhost>
	 <1187979454.6163.2.camel@localhost.localdomain>
	 <20070827173458.5a1ffed1@localhost>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 14:39:55 -0700
Message-Id: <1188250795.5798.113.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 17:34 -0300, Luiz Fernando N. Capitulino wrote:
> Em Fri, 24 Aug 2007 11:17:34 -0700
> john stultz <johnstul@us.ibm.com> escreveu:
> 
> | On Fri, 2007-08-24 at 08:46 -0400, Bob Picco wrote:
> | > john stultz wrote:	[Thu Aug 23 2007, 05:41:45PM EDT]
> | > > On Thu, 2007-08-23 at 14:05 -0700, john stultz wrote:
> | > > > On Thu, 2007-08-23 at 13:41 -0700, Luck, Tony wrote:
> | > > > > > I have a double "hpet" entry in "available_clocksource":
> | > > > > >	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> | > > > > >	tsc hpet hpet acpi_pm jiffies
> | > > > > 
> | > > > > Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
> | > > > > both register a clocksource named "hpet".  Probably a result of bringing
> | > > > > back to life a long lost patch, and having someone else (John Stultz, according
> | > > > > to git blame) make a similar change to a different file in the intervening
> | > > > > time.
> | > > > > 
> | > > > > Presumably the thing to do would be merge the x86_64 specific version
> | > > > > into the drivers/char/hpet.c version?
> | > > > 
> | > > > Ugh. Yea. i386 has an hpet clocksource as well. We should kill the
> | > > > duplication, but at the moment I'm not comfortable that the
> | > > > driver/char/hpet.c is ok to be used for i386/x86_64 (Bob: Do you know
> | > > > why the shift value is only 10?).
> | > > > 
> | > > > 
> | > > > I'm a little surprised by this, as the clocksource code use to prevent
> | > > > duplicate named clocksources from being registered, so I'm not sure how
> | > > > that check got dropped.  Also I'm not quite sure I see where the hard
> | > > > freeze is coming from.
> | > > > 
> | > > > My initial reaction would be to either ifdef ia64 implementation in
> | > > > drivers/char/hpet.c or move the code under the ia64 arch dir until it is
> | > > > really usable by all arches.
> | > > 
> | > > Here is a possible quick fix. I'm open to other approaches, but I also
> | > > want to avoid too much churn before 2.6.23 goes out.
> | > > 
> | > > Paolo, could you verify this fixes the issue for you?
> | > > 
> | > > thanks
> | > > -john
> | > > 
> | > [snip]
> | > 
> | > I saw what was missed by me in my brief examination of this last night.
> | > The platform registers the hpet clocksource too.
> | > 
> | > Instead of adding the config flag to hpet driver, how about the patch
> | > below? Since you already check for duplication by address then adding
> | > a check for by name too seems okay to me.
> | > 
> | > bob
> | > 
> | > 
> | > Prevent duplicate names being registered with clocksource. This also
> | > eliminates the duplication of hpet clock registration when the arch
> | > uses the hpet timer and the hpet driver does too. The patch was
> | > compile and link tested.
> | 
> | Yea. While I'm still not completely comfortable leaving this up to boot
> | order alone (the ia64 hpet clocksource is clearly causing issues on
> | x86_64), I think this patch is something we need as well.
> 
>  Does -stable need this too?

Looking at the git log, the ia64 clocksource code didn't land until
7/20, so I don't think so.

thanks
-john


