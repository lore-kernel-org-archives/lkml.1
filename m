Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXEUUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXEUUqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXEUUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:46:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbXEUUqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:46:44 -0400
Date: Mon, 21 May 2007 22:46:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521204606.GA4354@elte.hu>
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu> <200705220110.14175.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705220110.14175.kernel@prachanda.hub>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Anant Nitya <kernel@prachanda.info> wrote:

> I am posting links to the information you asked for. One more thing, 
> after digging a bit more I found its QoS shaping that is making the 
> box crawl. Once I disabled the traffic shaping everything comes back 
> to smooth and normal. Shaping being done on very low speed residential 
> ADSL 256/64 Kbps connection. If you want me to post shaping rules, 
> please free to ask. BTW its a simple HTB/SFQ rules.
[...]
> http://cybertek.info/taitai/trace-to-ingo.txt.bz2

thanks! This trace indeed includes the smoking gun, htb_dequeue() and 
__qdisc_run():

   privoxy-12926 1.Ns1 1597us : rb_first (htb_dequeue)

this goes on, non-preemptible, for 160 milliseconds (!):

 privoxy-12926 1.Ns1 161568us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161568us : qdisc_watchdog_schedule (htb_dequeue)

and finally manages to escape the loop:

 privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
 privoxy-12926 1.Ns1 161599us : htb_safe_rb_erase (htb_dequeue)
 privoxy-12926 1.Ns1 161599us : rb_erase (htb_safe_rb_erase)
 privoxy-12926 1.Ns1 161600us : htb_change_class_mode (htb_dequeue)
 privoxy-12926 1.Ns1 161601us : htb_activate_prios (htb_change_class_mode)

and the system recovers.

David, any ideas about what's wrong with htb_dequeue(), based on this 
trace?

	Ingo
