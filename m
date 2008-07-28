Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYG1I1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYG1I1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYG1I1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:27:24 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:46878 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750736AbYG1I1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:27:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UmPEHClSzk4GROACOSvoRd3puReqg9BdOre33q3I7e0bsQLQABKAOhk5bjTtTfrrnDMvIsPEZ8ib5i9iXrobN1lYcawjZJjnXrveWCRyZ8wgAcM1l4V0t7QATv01NgswEJ4/v8HKhtYDOl8sbhpTcE9lXoBcNo94YYmszsTtAx0=  ;
X-YMail-OSG: 3wdn_IgVM1lFu__jxWwtYOz4PMbYv4_qcWB._8ol6m1AdLUu.xaAPd8sbsbQKsxp3Y0qltsc.D6gzO6TTBgbkZci1HYiiFPkrQgSBZIduVcccKO.R4VKY0iUuUBcbbr8.Xs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [patch 2.6.26-git] /dev/hpet - fixes and cleanup
Date: Mon, 28 Jul 2008 01:27:21 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <200807251258.59878.david-b@pacbell.net> <488D7BFF.10005@ladisch.de>
In-Reply-To: <488D7BFF.10005@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807280127.22060.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Clemens Ladisch wrote:
> > +             /* FIXME this may trash both the system clocksource and
> > +              * the current clock event device!  Use HPET_TN_SETVAL
> > +              * instead, like arch/x86/kernel/hpet.c does ... never
> > +              * modify the counter, ever.
> > +              */
> >               m = read_counter(&hpet->hpet_mc);
> >               write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
> 
> This comment seems to assume that the code below modifies the main
> counter, which it doesn't.

There's only one counter.  How could it not modify that?

Oh ... I see.  It's called write_counter() but doesn't
actually write the counter.  Likewise, read_counter() is
not actually reading the counter.  Gaack ...

So that's not really an issue (good!).  I'll strike that
comment, except to comment that it's explicitly not modifying
any counter (just a hidden write-only accumulator) ... but
those silly function names should really be changed so they
have a less tenuous connection with reality.  In fact, most
places would be better off just hard-wiring 32-bit access...


> Additionally, HPET_TN_SETVAL has the same 
> value as Tn_VAL_SET_CNF_MASK (from <linux/hpet.h>), which _is_ used.

OK, I can see that too.  This HPET stuff is really a lot
dirtier than I had expected ... there's no reason at all
to have two separate headers with two incompatible sets
of definitions for the same registers!!


Any comments on the rest?

- Dave

