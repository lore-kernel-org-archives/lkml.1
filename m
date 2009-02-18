Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZBRVue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZBRVue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbZBRVkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:40:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60617
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757605AbZBRVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:40:15 -0500
Date: Wed, 18 Feb 2009 13:39:59 -0800 (PST)
Message-Id: <20090218.133959.193699273.davem@davemloft.net>
To: mingo@elte.hu
Cc: shemminger@vyatta.com, kaber@trash.net, rick.jones2@hp.com,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
Subject: Re: [RFT 2/4] Add mod_timer_noact
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090218110144.GA4100@elte.hu>
References: <20090218092041.GC3294@elte.hu>
	<20090218.013007.117003889.davem@davemloft.net>
	<20090218110144.GA4100@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 18 Feb 2009 12:01:44 +0100

> * David Miller <davem@davemloft.net> wrote:
> 
> | Introduce mod_timer_noact() which for example is to replace 
> | the calls to del_timer()/add_timer() in 
> | __nf_ct_refresh_acct(). It works like mod_timer() but doesn't 
> | activate or modify the timeout of an inactive timer which is 
> | the behaviour we want in order to be able to use timers as a 
> | means of synchronization in nf_conntrack.
> 
> It does not mention the overhead to the regular timer interfaces 
> at all, nor does it explain the reasons for this change 
> adequately.

You (conveniently) skipped this part of his commit message, so
I guess this is the part you didn't read very carefully:

	A later patch will modify __nf_ct_refresh_acct() to use
	mod_timer_noact() which will then save one spin_lock_irqsave()
	/ spin_lock_irqrestore() pair per conntrack timer update. This
	will also get rid of the race we currently have without adding
	more locking in nf_conntrack.

The whole point is to avoid two spin_lock_irqsave() sequences, thus
taking the timer locks twice.

So Ingo, when you say in response:

	Why don't you use?

		if (del_timer())
			add_timer();

you really look foolish and, in fact, disrespectful to Stephen.

This was my objection to your email, it proved that you didn't
really read his changelog message.  He explained perfectly well
what the final goal was of his changes.

And you have this knee-jerk reaction quite often.
