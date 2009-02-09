Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZBISOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZBISOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZBISNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:13:50 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:36309 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbZBISNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:13:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EADr9j0lMQWt2/2dsb2JhbACBbs59hBoG
Date: Mon, 9 Feb 2009 13:13:41 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090209181341.GA15514@Krystal>
References: <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209132343.GT7120@linux.vnet.ibm.com> <20090209172816.GA12934@Krystal> <20090209174741.GE6802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090209174741.GE6802@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:02:07 up 39 days, 18:00,  4 users,  load average: 1.04, 0.84,
	0.76
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Feb 09, 2009 at 12:28:17PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Mon, Feb 09, 2009 at 12:17:37AM -0500, Mathieu Desnoyers wrote:
> 
> [ . . . ]
> 
> > > > The new version is pushed into the repository. I changed you patch a
> > > > bit. Flaming is welcome. :)
> > > 
> > > Looks reasonable at first glance.  Just out of curiosity, why are
> > > urcu_gp_ctr and urcu_active_readers int rather than char?  I guess that
> > > one reason would be that many architectures work better with int than
> > > with char...
> > 
> > Exactly. This is done to make sure we don't end up having false register
> > dependencies causing stalls on such architectures. I'll add a comment.
> 
> Are there any 64-bit architectures that would prefer a long to an int?
> (Other than really old Alpha CPUs, that is.)
> 

None that I am aware of, but Christoph or Peter would probably know more
than I do on this aspect.

> > > So, how many cycles did this save?  ;-)
> > 
> > On x86_64, it's pretty much the same as before. It just helps having the
> > 32 and 64 bits algorithms being exactly the same, which I think is a
> > very good thing.
> 
> Good point!
> 
> > BTW, my tests were done without any CMOV instruction due to the standard
> > gcc options I used. Given think past discussion about CMOV :
> > 
> > http://ondioline.org/mail/cmov-a-bad-idea-on-out-of-order-cpus
> > 
> > It does not seem like such a good idea to use it anyway, given it can
> > take 10 cycles to run on a P4a
> 
> Fair enough!
> 
> > BTW, do you think having the 256 nested rcu read locks limitation could
> > become a problem ? I really think an application has recursion problem
> > if it does, but this is not impossible, especially on a particularly
> > badly designed tree-traversal algorithm on a 64-bits arch...
> 
> I don't know of any code in the Linux kernel that nests rcu_read_lock()
> anywhere near that deep.  And if someone does find such a case, it is
> pretty easy to use 15 bits rather than 8 to hold the nesting depth, just
> by changing the definition of RCU_GP_CTR_BIT.
> 

You know what ? Changing RCU_GP_CTR_BIT to 16 uses a
testw %ax, %ax instead of a testb %al, %al. The trick here is that
RCU_GP_CTR_BIT must be a multiple of 8 so we can use a full 8-bits,
16-bits or 32-bits bitmask for the lower order bits.

On 64-bits, using a RCU_GP_CTR_BIT of 32 is also ok. It uses a testl.

To provide 32-bits compability and allow the deepest nesting possible, I
think it makes sense to use

/* Use the amount of bits equal to half of the architecture long size */
#define RCU_GP_CTR_BIT (sizeof(long) << 2)

Mathieu


> 							Thanx, Paul
> 
> > Mathieu
> > 
> > > 						Thanx, Paul
> > > 
> > > > Mathieu
> > > > 
> > > > > Mathieu
> > > > > 
> > > > > > > > Again, looks interesting!  Looks plausible, although I have not 100%
> > > > > > > > convinced myself that it is perfectly bug-free.  But I do maintain
> > > > > > > > a healthy skepticism of purported RCU algorithms, especially ones that
> > > > > > > > I have written.  ;-)
> > > > > > > > 
> > > > > > > 
> > > > > > > That's always good. I also tend to always be very skeptical about what I
> > > > > > > write and review.
> > > > > > > 
> > > > > > > Thanks for the thorough review.
> > > > > > 
> > > > > > No problem -- it has been quite fun!  ;-)
> > > > > > 
> > > > > > 							Thanx, Paul
> > > > > > 
> > > > > 
> > > > > -- 
> > > > > Mathieu Desnoyers
> > > > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > > > > 
> > > > > _______________________________________________
> > > > > ltt-dev mailing list
> > > > > ltt-dev@lists.casi.polymtl.ca
> > > > > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > > > > 
> > > > 
> > > > -- 
> > > > Mathieu Desnoyers
> > > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
