Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbXGRMta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbXGRMta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXGRMtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:49:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbXGRMtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:49:21 -0400
Date: Wed, 18 Jul 2007 14:48:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070718124856.GB31215@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707172034.20581.olaf.kirch@oracle.com> <20070717185602.GA25271@elte.hu> <200707181404.20458.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181404.20458.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> On Tuesday 17 July 2007 20:56, Ingo Molnar wrote:
> > i logged these not via netconsole but via logging on over the console 
> > and using dmesg, so it should include everything. in the 100hz case the 
> > following seems to show the anomaly:
> > 
> >   NETDEV WATCHDOG: eth0: transmit timed out
> 
> So, it seems as if for some reason, dev->poll isn't called frequently 
> enough.
> 
> Here's a debugging patch that tries to locate the problem - can you 
> give it a try, please?

it triggers here:

 netconsole: device eth0 not up yet, forcing it
 netconsole: timeout waiting for carrier
 console [netcon0] enabled
 WARNING: at kernel/softirq.c:138 local_bh_enable()
  [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
  [<c0105f43>] show_trace+0x12/0x14
  [<c0105f59>] dump_stack+0x14/0x16
  [<c0130f8d>] local_bh_enable+0x95/0x15d
  [<c03cf35b>] netpoll_poll+0xaf/0x361
  [<c03cf248>] netpoll_send_skb+0xe8/0x14c
  [<c03cf8d4>] netpoll_send_udp+0x258/0x260
  [<c02f4016>] write_msg+0x53/0x8d
  [<c012c87e>] __call_console_drivers+0x4e/0x5a
  [<c012c8e7>] _call_console_drivers+0x5d/0x61
  [<c012cf06>] release_console_sem+0x120/0x1c1
  [<c012d70a>] register_console+0x22e/0x236
  [<c02f3f98>] init_netconsole+0x55/0x67
  [<c05e28e5>] kernel_init+0x154/0x2d9
  [<c0105c5f>] kernel_thread_helper+0x7/0x10

I've uploaded the full log to:

 http://redhat.com/~mingo/misc/100hz.2.log

something i noticed: netconsole output seems to trickle through though, 
but very, very slowly (a packet once every 4 seconds or so). TCP/IP is 
not functional.

also, i'm using netconsole via the command line (both the network driver 
and netconsole is built into the bzImage), maybe that makes a 
difference?

(if there's any other data you'd like to see, let me know.)

	Ingo
