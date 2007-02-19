Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXBSNPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXBSNPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbXBSNPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:15:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbXBSNPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:15:24 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070219115955.GB91@tv-sign.ru> 
References: <20070219115955.GB91@tv-sign.ru>  <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 19 Feb 2007 13:15:00 +0000
Message-ID: <15331.1171890900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > Called by what?  Something outside of br_if.c?
> 
> No. if cancel_delayed_work() fails, the work may sit pending in cwq->worklist,
> or it may be running right now, waiting for rtnl_mutex.

OIC.  I understood "called" to mean "scheduled", but that's not what you meant.

> > Hmmm... cancel_delayed_work() in del_nbp() probably ought to be followed by
> > a flush_scheduled_work().
> 
> Yes, but this deadlocks: we hold rtnl_mutex, and work->func() takes it too.

Oh, yuck!

Hmmm...  You've got a work_struct (well, a delayed_work actually) - can you
just punt the destruction of the object over to keventd to perform, I wonder?

The big problem with that that I see is that the workqueue facility has no
guards in place against a work_struct's handler function running on several
CPUs at once in response to the same work_struct.

> I think the fix should be so that port_carrier_check() does get/put on
> "struct net_bridge_port" (container), but not on "struct net_device", and

I'm not sure how this helps.  You still have to get rid of the net_device at
some point.

David
