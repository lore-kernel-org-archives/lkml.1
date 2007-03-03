Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXCCGAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXCCGAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 01:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965062AbXCCGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 01:00:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:9899 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbXCCGAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 01:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KOsAeDxPKpX6Fvv8kxsN78UCYMM9pTb1YbNbbmd2R6guM5NzWAKAWHWrUT/bffC91URpauOyYotPc9fZgcb/A63WrlapIh3PcnsF8KVAeT2m3RLY0rWg0u+R0KEnYEGoHLIRsj5LTBuAX3InrXf4grWOZK1GYKkHTBNZB5o41oo=
Message-ID: <41b516cb0703022200t50f8ad62wfa04030f11649ff2@mail.gmail.com>
Date: Fri, 2 Mar 2007 22:00:00 -0800
From: "Chris Leech" <christopher.leech@intel.com>
Reply-To: chris.leech@gmail.com
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/9] ioatdma: Push pending transactions to hardware more frequently
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070302.202706.95898424.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303022238.31033.84558.stgit@gitlost.site>
	 <20070303022417.31033.72244.stgit@gitlost.site>
	 <45E8E81F.8070805@garzik.org>
	 <20070302.202706.95898424.davem@davemloft.net>
X-Google-Sender-Auth: 37f61fc483ff0a0c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This sounds like something that will always be wrong -- or in other
> > words, always be right for only the latest CPUs.  Can this be made
> > dynamic, based on some timing factor?
>
> In fact I think this has been tweaked twice in the vanilla tree
> already.

This is actually just the same tweak you remember me posting before
and I never pushed to get it in mainline, but Jeff's right.  The
problem isn't so much in the driver itself, as in how it's used by
I/OAT in the TCP receive code, there are inherent assumptions about
how long a context switch takes compared to how long an offloaded
memcpy takes.

I'm working on using completion interrupts for the device so as not to
end up polling when the CPUs are faster than the code was tuned for,
and doing it in a way that doesn't introduce extra context switches.
I'm hoping to have something ready for 2.6.22, or at least ready for
MM in that time frame.

As for this change in the short term, we did go back and make sure
that it didn't performance worse with the older CPUs supported on
these platforms.  We should have tested more intermediate values
instead of just jumping from 1 t o 20 for that threshold.

- Chris
