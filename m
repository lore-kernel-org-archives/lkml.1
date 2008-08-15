Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHOBch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHOBch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHOBc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:32:28 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50013 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYHOBc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:32:27 -0400
Subject: Re: [PATCH]lockd: fix handling of grace period after long periods
	of inactivity
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NAKANO Hiroaki <nakano.hiroaki@oss.ntt.co.jp>, Trond.Myklebust@netapp.com,
       neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080814190652.GE23859@fieldses.org>
References: <48A41220.8030203@oss.ntt.co.jp>
	 <20080814190652.GE23859@fieldses.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 15 Aug 2008 10:32:25 +0900
Message-Id: <1218763945.5291.19.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce!

On Thu, 2008-08-14 at 15:06 -0400, J. Bruce Fields wrote:
> On Thu, Aug 14, 2008 at 08:08:16PM +0900, NAKANO Hiroaki wrote:
> > lockd uses time_before() to determine whether the grace period has
> > expired. This would seem to be enough to avoid timer wrap-around issues,
> > but, unfortunately, that is not the case. The time_* family of
> > comparison functions can be safely used to compare jiffies relatively
> > close in time, but they stop working after approximately LONG_MAX/2
> > ticks. nfsd can suffer this problem because the time_before() comparison
> > in lockd() is not performed until the first request comes in, which
> > means that if there is no lockd traffic for more than LONG_MAX/2 ticks
> > we are screwed.
> > 
> > The implication of this is that once time_before() starts misbehaving
> > any attempt from a NFS client to execute fcntl() will be received with a
> > NLM_LCK_DENIED_GRACE_PERIOD message for 25 days (assuming HZ=1000). In
> > other words, the 50 seconds grace period could turn into a grace period
> > of 50 days or more.
> > 
> > This patch corrects this behavior by implementing grace period with a
> > (retriggerable) timer.
> > 
> > Note: This bug was analyzed independently by Oda-san <oda@valinux.co.jp>
> > and myself.
> 
> Good catch!  Did you actually run across this in practice?  I would've
> thought it relatively unusual to have a lockd that didn't receive its
> first lock request until 25 days after startup.
Yes, we did find this problem in production. More often than one would
wish, installing new software in a system that has been running without
a hiccup for weeks or months is the only thing you will need to bring
mayhem.

> I still have a mild preference for a work struct just in case we end up
> wanting to do something slightly more complicated to end the grace
> period, but I don't really have anything in mind.
For simplicity I think we could we get Nakano-san's patch merged first.
If needed, moving to a work-based solution should be relatively easily.

Thank you for you comments!

- Fernando

