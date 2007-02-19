Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbXBSPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbXBSPB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXBSPB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:01:56 -0500
Received: from mail.screens.ru ([213.234.233.54]:34338 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbXBSPBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:01:55 -0500
Date: Mon, 19 Feb 2007 18:04:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219150445.GC75@tv-sign.ru>
References: <20070218214359.GA4226@tv-sign.ru> <20070219110021.GA2190@ff.dom.local> <20070219120353.GC91@tv-sign.ru> <20070219132703.GC2190@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219132703.GC2190@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Jarek Poplawski wrote:
>
> On Mon, Feb 19, 2007 at 03:03:53PM +0300, Oleg Nesterov wrote:
> > On 02/19, Jarek Poplawski wrote:
> ...
> > kfree() doesn't check WORK_STRUCT_PENDING, it makes no
> > difference if it is set or not when work->func() runs.
> 
> It looks like it's to be checked before kfree.

Here,
	br_add_if:

		schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE);

schedule_delayed_work() fails if this bit is set. So the only difference with
this patch is:

	before:
		schedule_delayed_work() fails unless port_carrier_check() passed
		work_release() (before rtnl_lock())

	after:
		schedule_delayed_work() fails unless run_workqueue() cleared this
		bit (before calling port_carrier_check())

> > We are going to kill _NAR stuff.
> 
> If you're sure nobody uses this in any way then it
> seems the right decision.

Yes, this series converts all users.

Oleg.

