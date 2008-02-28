Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYB1QK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYB1QK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYB1QKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:10:45 -0500
Received: from mail128.messagelabs.com ([216.82.250.131]:45452 "HELO
	mail128.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751054AbYB1QKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:10:43 -0500
X-VirusChecked: Checked
X-Env-Sender: fsh016@ftw.mot.com
X-Msg-Ref: server-5.tower-128.messagelabs.com!1204215042!4729247!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
Date: Thu, 28 Feb 2008 10:10:39 -0600
From: Steven Hawkes <fsh016@ftw.mot.com>
Message-Id: <200802281610.m1SGAdMe023192@ftw.mot.com>
To: davem@davemloft.net, joe@perches.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: printk_ratelimit and net_ratelimit conflict and tunable behavior
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:

> On Mon, 2008-02-25 at 17:49 -0600, Hawkes Steve-FSH016 wrote:
> > Are you saying the few lines of code to handle changes to the tunables
> > aren't worth keeping?
> 
> Yes.
> 
> I think the tunables, if needed at all, should be set by modifying
> the struct and the call might as well be:
> 
> bool __printk_ratelimit(struct printk_ratelimit_state *state)

The tunables are used in the current rate-limiting algorithm. Wouldn't
incorporating them into the structure require protecting modification of the
tunables by the same spinlock used in the rate limiting? That could be done
by pulling the spinlock variable out into printk_ratelimit() and
net_ratelimit() and into the struct (the spinlock is needed internal to
__printk_ratelimit to allow the spin_unlock() done right before actually
printing the message). That seems a bit more complex.

Or are you suggesting copying the tunables into the struct each time
__printk_ratelimit() is called? I was looking at them as not part of the
state of rate limiting, but rather external attributes controlling rate
limiting.

Joe Perches wrote:

> Another quibble is not directed to your change because it's
> preexisting but "tok" isn't a good name and may not even need
> to be in the structure.  It does save a multiply though.

I agree the original name can be improved upon.

The toks state variable is needed because it actually maintains the current
rate-limiting water level, so to speak. The "bucket" is initially filled to
its capacity, ratelimit_jiffies * ratelimit_burst. Each time
__printk_ratelimit is called, water gets added to the bucket in proportion
to the time since the last call (capped by the capacity of the
bucket). Prints are allowed as long as the bucket has at least
ratelimit_jiffies of water left. Each allowed print sucks a
ratelimit_jiffies amount out of the bucket. (At least I think that's the way
the current kernel works; it wasn't immediately obvious to me.)
