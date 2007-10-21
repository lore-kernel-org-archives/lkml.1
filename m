Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbXJUM04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbXJUM04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXJUM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:26:49 -0400
Received: from thunk.org ([69.25.196.29]:55492 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXJUM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:26:48 -0400
Date: Sun, 21 Oct 2007 08:26:39 -0400
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/2] UUID: Time-based RFC 4122 UUID generator
Message-ID: <20071021122639.GB7045@thunk.org>
Mail-Followup-To: tytso@mit.edu, Helge Deller <deller@gmx.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Valdis.Kletnieks@vt.edu
References: <200710202139.25595.deller@gmx.de> <200710202200.03275.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710202200.03275.deller@gmx.de>
1;1609;0cFrom: Theodore Tso <tytso@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: Theodore Tso <tytso@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 10:00:03PM +0200, Helge Deller wrote:
> The attached patch additionally adds the "Time-based UUID" variant 
> of RFC 4122 to the Linux Kernel.
> With this patch applied, userspace applications may easily get real unique
> time-based UUIDs through /proc/sys/kernel/random/uuid_time.

> The attached implementation uses getnstimeofday() to get more fine-grained
> granularity than what would be possible with gettimeofday() in userspace.

I'm not convinced this is really needed, given that we have a UUID
generation library; we can just as easily use clock_gettime() to get
nanosecond granularity in userspace.  The reason why I didn't add this
in libuuid a decade ago was that we didn't have anything that was near
even microsecond resolution back then.  But this is a problem we can
fix in userspace.

> Additionally a mutex takes care of the proper locking against a mistaken
> double creation of UUIDs for simultanious running processes.

This is trickier to do in userspace, given that in userspace we have
to worry about malicious code that might grab and hold the mutex for
long periods of time.  It is soluble, though.

> +	/* Determine clock sequence (max. 14 bit) */
> +	if (unlikely(!clock_seq_initialized)) {
> +		get_random_bytes(&clock_seq, sizeof(clock_seq));
> +		clock_seq &= 0x3fff;
> +		clock_seq_started = clock_seq;
> +		clock_seq_initialized = 1;

If you're really going to do this right, it should be possible to get
and set the clock sequence from userspace, since the clock sequence is
supposed to be retained across system bootups.  Otherwise, it's
possible for you to get really unlucky, and pick the same clock
sequence number just at the same point that the clock gets changed.
Not all that likely, granted, but technically it's good thing to do
and required by RFC 4122.

I don't do this in the userspace library, but again that's because of
the security issue of dealiing with multiple userids needing to update
a file.  (What we really need to do this right in userspace is the
concept of lightweight privileged shared libraries, such as what
Multics had.)  So if that's going to be the justification to do this
in the kernel, it should be possible to set/get the clock sequence
number, so that in an init.d script, the clock sequence numer can be
fetched at bootup and stored at shutdown.  (Yeah, that still leaves
open the possibility of how to handle an unclean shutdown.  If you
really wanted to be anal about guaranteeing that a clock sequence
number was never reused, any time a clock sequence number is changed,
a hal event could be sent that would cause a userspace helper script
to sample the clock sequence and update the file.)

> +	/* Set the spatially unique node identifier */
> +#ifdef CONFIG_NET
> +	read_lock(&dev_base_lock);
> +	for_each_netdev(&init_net, d) {
> +		if (d->type == ARPHRD_ETHER && d->addr_len == ETH_ALEN 
> +		    && d != init_net.loopback_dev) {
> +			memcpy(&uuid_out[10], d->dev_addr, ETH_ALEN);
> +			netdev_found = 1;
> +			break;
> +		}
> +	}
> +	read_unlock(&dev_base_lock);
> +#endif

This means you have to grab the dev_base_lock each time you generate a
UUID.  In addition, since this code always grabs the first ethernet
device in the list, if the list has changed --- for example, if
someone inserts a PCMCIA wireless or ethernet card, or removes the
card for power management reasons --- you could end up changing the
MAC address and forcing a clock sequence bump even though it's not
necessary.  So there are a couple of things that we might do here.

First of all, if we *know* that that a particular mac address is
associated with a card which is hardwired to the machine, we're
actually better off using it even if it is no longer present in the
list.  But aside from getting a userspace hint, I don't see a good way
for us to implement this.

What you probably should do, since you're keeping the MAC address
around to compare if it changes, is to search the list to see if the
MAC address is still on the list, and use it if it's there; and if it
isn't, then you can use the first ethernet address found instead.

> +	if (unlikely(!netdev_found)) {
> +		/* use bootid's nodeID if no network interface found */

If CONFIG_NET is undefined, the netdev_found will always be false, so
the unlikely() would be particularly inappropriate.  Probably will
only matter for embedded systems, but they won't thank you....

> +	/* if MAC/NodeID changed, create a new clock_seq value */
> +	if (unlikely(memcmp(&uuid_out[10], &last_mac, ETH_ALEN))) {
> +		memcpy(&last_mac, &uuid_out[10], ETH_ALEN);
> +		/* for very first UUID, do not increment clock_seq */
> +		if (unlikely(clock_seq_initialized == 1))
> +			clock_seq_initialized = 2;
> +		else
> +			goto inc_clock_seq;
> +	}

The goto loop could be much simplified if you grab the MAC/NodeID
*before* you do clock_seq logic.  Right now, if the Mac/NodeID
changes, you end up having to redo a lot of processing for no good
reason (and under the uuid_mutex).

						- Ted
