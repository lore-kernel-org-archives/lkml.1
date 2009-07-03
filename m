Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZGCTqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZGCTqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbZGCTpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:45:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46859 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZGCTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:45:54 -0400
Date: Fri, 3 Jul 2009 13:45:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703194557.GQ5480@parisc-linux.org>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <20090703185414.GP23611@kernel.dk> <20090703191321.GO5480@parisc-linux.org> <20090703192235.GV23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703192235.GV23611@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 09:22:35PM +0200, Jens Axboe wrote:
> On Fri, Jul 03 2009, Matthew Wilcox wrote:
> > Yes, but the irqs/sec increase doesn't appear to be due to MPT interrupts.
> > In the /proc/interrupt summaries, RH5 did 388666895 IOC interrupts and
> > 2.6.30 did 378419042.  As a percentage of interrupts, the IOC interrupts
> > were 59.4% with RH and 51.8% with 2.6.30.
> 
> OK. So where are the extra irqs from?

Let's see:

Source	2.6.18	2.6.30	Delta
qla	0.8%	0.8%	0
eth	20%	27.6%	+7.6%
ioc	59.4%	51.8%	-7.6%
NMI	7.6%	7.9%	+0.3%
LOC	12.2%	10%	-2.2%
RES	-	1.8%	+1.8%

I wouldn't be surprised to find out that 2.6.18 accounted rescheduling
interrupts as 'LOC'.  So the difference in interrupts is all about
the ethernet card.  I believe these systems have an igb card.

The big difference between 2.6.18 and 2.6.30 is that the cards now have
eight interrupts in use each, instead of one each (four for rx queues
and four for tx queues).  Distressingly, these interrupts are all affine
to the same CPUs (eth1's eight interrupts are all on CPU 9 and eth0's
interrupts are all on CPU 1).  That would seem to be a fruitful avenue of
investigation -- whether limiting the cards to a single RX/TX interrupt
would be advantageous, or whether spreading the eight interrupts out
over the CPUs would be advantageous.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
