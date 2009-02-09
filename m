Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZBITXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZBITXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZBITXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:23:09 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42615 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZBITXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:23:06 -0500
Date: Mon, 9 Feb 2009 11:23:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090209192302.GM6802@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209132343.GT7120@linux.vnet.ibm.com> <20090209172816.GA12934@Krystal> <20090209174741.GE6802@linux.vnet.ibm.com> <20090209181341.GA15514@Krystal> <20090209183742.GI6802@linux.vnet.ibm.com> <20090209184951.GA12184@linux.vnet.ibm.com> <20090209190509.GA17895@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209190509.GA17895@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 02:05:09PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Feb 09, 2009 at 10:37:42AM -0800, Paul E. McKenney wrote:
> > > On Mon, Feb 09, 2009 at 01:13:41PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > 
> > [ . . . ]
> > 
> > > > You know what ? Changing RCU_GP_CTR_BIT to 16 uses a
> > > > testw %ax, %ax instead of a testb %al, %al. The trick here is that
> > > > RCU_GP_CTR_BIT must be a multiple of 8 so we can use a full 8-bits,
> > > > 16-bits or 32-bits bitmask for the lower order bits.
> > > > 
> > > > On 64-bits, using a RCU_GP_CTR_BIT of 32 is also ok. It uses a testl.
> > > > 
> > > > To provide 32-bits compability and allow the deepest nesting possible, I
> > > > think it makes sense to use
> > > > 
> > > > /* Use the amount of bits equal to half of the architecture long size */
> > > > #define RCU_GP_CTR_BIT (sizeof(long) << 2)
> > > 
> > > You lost me on this one:
> > > 
> > > 	sizeof(long) << 2 = 0x10
> > > 
> > > I could believe the following (run on a 32-bit machine):
> > > 
> > > 	1 << (sizeof(long) * 8 - 1) = 0x80000000
> > > 
> > > Or, if you were wanting to use a bit halfway up the word, perhaps this:
> > > 
> > > 	1 << (sizeof(long) * 4 - 1) = 0x8000
> > > 
> > > Or am I confused?
> > 
> > Well, I am at least partly confused.  You were wanting a low-order bit,
> > so you want to lose the "- 1" above.  Here are some of the possibilities:
> > 
> > 	sizeof(long) = 0x4
> > 	sizeof(long) << 2 = 0x10
> > 	1 << (sizeof(long) * 8 - 1) = 0x80000000
> > 	1 << (sizeof(long) * 4) = 0x10000
> > 	1 << (sizeof(long) * 4 - 1) = 0x8000
> > 	1 << (sizeof(long) * 2) = 0x100
> > 	1 << (sizeof(long) * 2 - 1) = 0x80
> > 
> > My guess is that 1 << (sizeof(long) * 4) and 1 << (sizeof(long) * 2)
> > are of the most interest.
> > 
> 
> Exactly. I'll change it to :
> 
> #define RCU_GP_CTR_BIT          (1 << (sizeof(long) << 2))
> 
> I somehow thought this define was used as a bit number rather than the
> bit mask.

Ah!  Been there, done that!  ;-)

							Thanx, Paul
