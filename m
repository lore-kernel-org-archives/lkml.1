Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYC0MR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYC0MR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYC0MRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:17:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:12483 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYC0MRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GG3Zhuwu2bekKcnuxRJojSPgG9Qkv5dcS+IvxFFVb6DP+I8YZ7Tv4IHFyTJ6tYD6v0IFvG8dq9TTMYU0PP1QGqQJDUCg3xdbmQ8ZmimmDnlyIhGMzyAVLj63UBDXQJzuL95KfPk1C+uo5pfcejsyehdIQ5JFKOd0OOw32ahvr7E=
Date: Thu, 27 Mar 2008 13:22:55 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327122255.GC2845@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <20080325134320.21525479.akpm@linux-foundation.org> <47EAD8A5.3070806@gmail.com> <20080326171403.ad186037.akpm@linux-foundation.org> <20080327085542.GA2778@ami.dom.local> <20080327021812.601776b8.akpm@linux-foundation.org> <1206615379.8514.502.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206615379.8514.502.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 11:56:19AM +0100, Peter Zijlstra wrote:
> On Thu, 2008-03-27 at 02:18 -0700, Andrew Morton wrote:
...
> > I bet the net code is wrong and we missed it ;)

It looks like you are natural born winner! Congratulations!

> How about this:
> 
> <irqs disabled>
> 
>   netpoll_poll()
>     poll_napi()
>       spin_trylock(&napi->poll_lock)
>       poll_one_napi()
>         napi->poll() := sky2_poll()
>           napi_complete()
>             local_irq_disable()
>             local_irq_enable() <--- *BUG*

Yes! I missed it's unconditional here... Great catch!

On the other hand, still a question why lockdep doesn't see this
every day?

Jarek P.
