Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXCSKOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXCSKOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXCSKOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:14:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15963 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXCSKOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:14:35 -0400
Date: Mon, 19 Mar 2007 13:21:07 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       devel@openvz.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       pmarques@grupopie.com
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
Message-ID: <20070319102107.GA6811@localhost.sw.ru>
References: <20070316114458.GB6817@localhost.sw.ru> <20070316115154.GC30195@elte.hu> <1174124239.8897.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174124239.8897.41.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 08:37:18PM +1100, Rusty Russell wrote:
> On Fri, 2007-03-16 at 12:51 +0100, Ingo Molnar wrote:
> > * Alexey Dobriyan <adobriyan@sw.ru> wrote:
> >
> > > [cc'ing folks whose proc files are affected]
> > >
> > > kallsyms_lookup() can call module_address_lookup() which iterates over
> > > modules list without module_mutex taken. Comment at the top of
> > > module_address_lookup() says it's for oops resolution so races are
> > > irrelevant, but in some cases it's reachable from regular code:
> >
> > looking at the problem from another angle: wouldnt this be something
> > that would benefit from freeze_processes()/unfreeze_processes(), and
> > hence no locking would be required?
>
> Actually, the list manipulation is done with stop_machine for this
> reason.

mmm, my changelog is slightly narrow than it should be.

	Non-emergency code is traversing modules list.
	It finds "struct module *".
	module is removed.
	"struct module *" is now meaningless, but still dereferenced.

How would all this refrigerator stuff would help? It wouldn't,

	Non-emergency code is traversing modules list.
	It finds "struct module *".
	Everything is freezed.
	Module is removed.
	Everything is unfreezed.
	"struct module *" is now meaningless, but still dereferenced.

> Alexey, is preempt enabled in your kernel?

Yes. FWIW,

CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_DEBUG_PREEMPT=y

I very much agree with proto-patch which _copies_ all relevant
information into caller-supplied structure, keeping module_mutex private.
Time to split it sanely.

