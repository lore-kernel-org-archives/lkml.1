Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbXBSMAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbXBSMAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbXBSMAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:00:00 -0500
Received: from mail.screens.ru ([213.234.233.54]:34794 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbXBSL77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:59:59 -0500
Date: Mon, 19 Feb 2007 14:59:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219115955.GB91@tv-sign.ru>
References: <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8462.1171884453@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, David Howells wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Afaics, noautorel work_struct buys nothing for "struct net_bridge_port".
> 
> You may be right.
> 
> > If del_nbp()->cancel_delayed_work(&p->carrier_check) fails, port_carrier_check
> > may be called later anyway.
> 
> Called by what?  Something outside of br_if.c?

No. if cancel_delayed_work() fails, the work may sit pending in cwq->worklist,
or it may be running right now, waiting for rtnl_mutex.

> > So the reading of *work in port_carrier_check() is equally unsafe with or
> > without this patch.
> 
> Hmmm... cancel_delayed_work() in del_nbp() probably ought to be followed by a
> flush_scheduled_work().

Yes, but this deadlocks: we hold rtnl_mutex, and work->func() takes it too.

I think the fix should be so that port_carrier_check() does get/put on
"struct net_bridge_port" (container), but not on "struct net_device", and

del_nbp(struct net_bridge_port *p)

	if (cancel_delayed_work(&p->carrier_check))
-		dev_put(p->dev);
+		kobject_put(&p->kobj);

Oleg.

