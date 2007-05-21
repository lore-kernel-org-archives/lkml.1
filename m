Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbXEUVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbXEUVC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEUVCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:02:18 -0400
Received: from stinky.trash.net ([213.144.137.162]:63920 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXEUVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:02:18 -0400
Message-ID: <465208D2.6070409@trash.net>
Date: Mon, 21 May 2007 23:02:10 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu> <200705220110.14175.kernel@prachanda.hub> <20070521204606.GA4354@elte.hu>
In-Reply-To: <20070521204606.GA4354@elte.hu>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Anant Nitya <kernel@prachanda.info> wrote:
> 
> 
>>I am posting links to the information you asked for. One more thing, 
>>after digging a bit more I found its QoS shaping that is making the 
>>box crawl. Once I disabled the traffic shaping everything comes back 
>>to smooth and normal. Shaping being done on very low speed residential 
>>ADSL 256/64 Kbps connection. If you want me to post shaping rules, 
>>please free to ask. BTW its a simple HTB/SFQ rules.
> 
> [...]
> 
>>http://cybertek.info/taitai/trace-to-ingo.txt.bz2
> 
> 
> thanks! This trace indeed includes the smoking gun, htb_dequeue() and 
> __qdisc_run():
> 
>    privoxy-12926 1.Ns1 1597us : rb_first (htb_dequeue)
> 
> this goes on, non-preemptible, for 160 milliseconds (!):
> 
>  privoxy-12926 1.Ns1 161568us : rb_first (htb_dequeue)
>  privoxy-12926 1.Ns1 161568us : qdisc_watchdog_schedule (htb_dequeue)
> 
> and finally manages to escape the loop:
> 
>  privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
>  privoxy-12926 1.Ns1 161597us : rb_first (htb_dequeue)
>  privoxy-12926 1.Ns1 161599us : htb_safe_rb_erase (htb_dequeue)
>  privoxy-12926 1.Ns1 161599us : rb_erase (htb_safe_rb_erase)
>  privoxy-12926 1.Ns1 161600us : htb_change_class_mode (htb_dequeue)
>  privoxy-12926 1.Ns1 161601us : htb_activate_prios (htb_change_class_mode)
> 
> and the system recovers.
> 
> David, any ideas about what's wrong with htb_dequeue(), based on this 
> trace?


This looks like fallout from the switch to hrtimers. Anant, please
send me your HTB script, I'll try to reproduce it.

