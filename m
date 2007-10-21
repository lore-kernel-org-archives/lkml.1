Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXJUUNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXJUUNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXJUUMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:12:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:42486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751885AbXJUUMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:12:54 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+VKr9tc3yVjoSkFiGbdSOdWu6tQybIf6mRpgX+U1
	Y2MqYUal6LpTnd
From: Helge Deller <deller@gmx.de>
To: Theodore Tso <tytso@thunk.org>
Subject: Re: [PATCH 2/2] UUID: Time-based RFC 4122 UUID generator
Date: Sun, 21 Oct 2007 22:11:41 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <200710202139.25595.deller@gmx.de> <200710202200.03275.deller@gmx.de> <20071021122639.GB7045@thunk.org>
In-Reply-To: <20071021122639.GB7045@thunk.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?iso-8859-1?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?iso-8859-1?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?iso-8859-1?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bd?=
 =?iso-8859-1?q?c=5E=5FY=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710212211.41403.deller@gmx.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007, Theodore Tso wrote:
> On Sat, Oct 20, 2007 at 10:00:03PM +0200, Helge Deller wrote:
> > Additionally a mutex takes care of the proper locking against a mistaken
> > double creation of UUIDs for simultanious running processes.
> 
> This is trickier to do in userspace, given that in userspace we have
> to worry about malicious code that might grab and hold the mutex for
> long periods of time.  It is soluble, though.

Yes, userspace would need quite some overhead/syncronization/locking tricks to get it right.
That's basically one of the reasons I prefer the in-kernel solution.
The other reason is, that due to reduced code size compared to user-space, it's even a nice and clean solution for embedded devices.

> > +	/* Determine clock sequence (max. 14 bit) */
> > +	if (unlikely(!clock_seq_initialized)) {
> > +		get_random_bytes(&clock_seq, sizeof(clock_seq));
> > +		clock_seq &= 0x3fff;
> > +		clock_seq_started = clock_seq;
> > +		clock_seq_initialized = 1;
> 
> If you're really going to do this right, it should be possible to get
> and set the clock sequence from userspace, since the clock sequence is
> supposed to be retained across system bootups.  Otherwise, it's
> possible for you to get really unlucky, and pick the same clock
> sequence number just at the same point that the clock gets changed.
> Not all that likely, granted, but technically it's good thing to do
> and required by RFC 4122.

Ok, I'll add that to the next version of the patch.
Do you have a suggestion how to realize that ?
I currently see two possibilities:
a) reading: userspace reads /proc/sys/kernel/random/uuid_time and parses/stores the clock sequence number.
    writing: just echo a value to /proc/sys/kernel/random/uuid_time, kernel will use this value then as new clock sequence number.
b) add a new sysfs entry, e.g. /proc/sys/kernel/random/uuid_time_clockseq, to read/write the current/new value

Possibility b) is probably the cleaner solution, although it adds some more code.
What's your opinion ?

> I don't do this in the userspace library, but again that's because of
> the security issue of dealiing with multiple userids needing to update
> a file.  (What we really need to do this right in userspace is the
> concept of lightweight privileged shared libraries, such as what
> Multics had.)  So if that's going to be the justification to do this
> in the kernel, it should be possible to set/get the clock sequence
> number, so that in an init.d script, the clock sequence numer can be
> fetched at bootup and stored at shutdown.  (Yeah, that still leaves
> open the possibility of how to handle an unclean shutdown.  If you
> really wanted to be anal about guaranteeing that a clock sequence
> number was never reused, any time a clock sequence number is changed,
> a hal event could be sent that would cause a userspace helper script
> to sample the clock sequence and update the file.)

Yuk. If you really want, I'll add that hal event...

> > +	/* Set the spatially unique node identifier */
> > +#ifdef CONFIG_NET
> > +	read_lock(&dev_base_lock);
> > +	for_each_netdev(&init_net, d) {
> > +		if (d->type == ARPHRD_ETHER && d->addr_len == ETH_ALEN 
> > +		    && d != init_net.loopback_dev) {
> > +			memcpy(&uuid_out[10], d->dev_addr, ETH_ALEN);
> > +			netdev_found = 1;
> > +			break;
> > +		}
> > +	}
> > +	read_unlock(&dev_base_lock);
> > +#endif
> 
> This means you have to grab the dev_base_lock each time you generate a
> UUID.  

Yes, IMHO this seems unavoidable. 
Basically even the user-space implementation gets the lock. It's just indirect and less efficient.

> In addition, since this code always grabs the first ethernet 
> device in the list, if the list has changed --- for example, if
> someone inserts a PCMCIA wireless or ethernet card, or removes the
> card for power management reasons --- you could end up changing the
> MAC address and forcing a clock sequence bump even though it's not
> necessary.  So there are a couple of things that we might do here.

Agreed.

> First of all, if we *know* that that a particular mac address is
> associated with a card which is hardwired to the machine, we're
> actually better off using it even if it is no longer present in the
> list.  But aside from getting a userspace hint, I don't see a good way
> for us to implement this.

Me neither.

> What you probably should do, since you're keeping the MAC address
> around to compare if it changes, is to search the list to see if the
> MAC address is still on the list, and use it if it's there; and if it
> isn't, then you can use the first ethernet address found instead.

Yes, I'll do that in the next version of the patch.

> > +	if (unlikely(!netdev_found)) {
> > +		/* use bootid's nodeID if no network interface found */
> 
> If CONFIG_NET is undefined, the netdev_found will always be false, so
> the unlikely() would be particularly inappropriate.  Probably will
> only matter for embedded systems, but they won't thank you....

When I wrote that, I thought the same and my first idea was just to move the if clause before the #endif, e.g. like this:
	if (unlikely(!netdev_found))
	#endif /* CONFIG_NET */
	{ ....
But I didn't like that code folding very much.

On the other side, if CONFIG_NET is undefined, netdev_found still stays at "0", and the compiler should
convert that directly to 
	if (unlikely(!0)) {
	/* use bootid's nodeID if no network interface found */
and just drop the if() and thus the unlikely() statement.
So I think the compiler will just optimize it away and ignore the unlikely (because as it knows, it's not unlikely any more).

> > +	/* if MAC/NodeID changed, create a new clock_seq value */
> > +	if (unlikely(memcmp(&uuid_out[10], &last_mac, ETH_ALEN))) {
> > +		memcpy(&last_mac, &uuid_out[10], ETH_ALEN);
> > +		/* for very first UUID, do not increment clock_seq */
> > +		if (unlikely(clock_seq_initialized == 1))
> > +			clock_seq_initialized = 2;
> > +		else
> > +			goto inc_clock_seq;
> > +	}
> 
> The goto loop could be much simplified if you grab the MAC/NodeID
> *before* you do clock_seq logic.  Right now, if the Mac/NodeID
> changes, you end up having to redo a lot of processing for no good
> reason (and under the uuid_mutex).

I'm not sure if this gains much. Probably the jumps will just be at some other place or the code will become more complex.
MAC/NodeID changes quite seldom. And if it changes, the machine will be quite busy anyway, e.g. configure IP addresses/DHCP, ...
But anyway, I'll give it a try for the next patch.

Thanks,
Helge
