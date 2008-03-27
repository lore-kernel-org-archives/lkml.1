Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYC0Maj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYC0Maj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYC0Mab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:30:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:35169 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbYC0Mab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:30:31 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080327122255.GC2845@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/>
	 <20080325134320.21525479.akpm@linux-foundation.org>
	 <47EAD8A5.3070806@gmail.com>
	 <20080326171403.ad186037.akpm@linux-foundation.org>
	 <20080327085542.GA2778@ami.dom.local>
	 <20080327021812.601776b8.akpm@linux-foundation.org>
	 <1206615379.8514.502.camel@twins>  <20080327122255.GC2845@ami.dom.local>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 13:30:14 +0100
Message-Id: <1206621014.8514.563.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 13:22 +0100, Jarek Poplawski wrote:
> On Thu, Mar 27, 2008 at 11:56:19AM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-03-27 at 02:18 -0700, Andrew Morton wrote:
> ....
> > > I bet the net code is wrong and we missed it ;)
> 
> It looks like you are natural born winner! Congratulations!
> 
> > How about this:
> > 
> > <irqs disabled>
> > 
> >   netpoll_poll()
> >     poll_napi()
> >       spin_trylock(&napi->poll_lock)
> >       poll_one_napi()
> >         napi->poll() := sky2_poll()
> >           napi_complete()
> >             local_irq_disable()
> >             local_irq_enable() <--- *BUG*
> 
> Yes! I missed it's unconditional here... Great catch!
> 
> On the other hand, still a question why lockdep doesn't see this
> every day?

My guess is that it is a race between polling the device and irq pushing
the packet. That is, normally the IRQ handler wins and netpoll doesn't
have anything to do and it doesn't traverse this code path.

(although I must admit to being a little out of my depth here)

