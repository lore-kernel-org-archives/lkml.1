Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXBSOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXBSOx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXBSOx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:53:27 -0500
Received: from mail.screens.ru ([213.234.233.54]:46756 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbXBSOx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:53:26 -0500
Date: Mon, 19 Feb 2007 17:56:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219145613.GB75@tv-sign.ru>
References: <20070219115955.GB91@tv-sign.ru> <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> <15331.1171890900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15331.1171890900@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, David Howells wrote:
>
> Hmmm...  You've got a work_struct (well, a delayed_work actually) - can you
> just punt the destruction of the object over to keventd to perform, I wonder?

Yes, this is close (I think) to what I suggested, see below,

> The big problem with that that I see is that the workqueue facility has no
> guards in place against a work_struct's handler function running on several
> CPUs at once in response to the same work_struct.

Yes. And for this problem WORK_STRUCT_NOAUTOREL does help, but not so much.
It can prevent re-scheduling of the same work, but only if work->func() did
not do work_release() yet.

> > I think the fix should be so that port_carrier_check() does get/put on
> > "struct net_bridge_port" (container), but not on "struct net_device", and
> 
> I'm not sure how this helps.  You still have to get rid of the net_device at
> some point.

Yes, destroy_nbp() does dev_put(dev). del_nbp() sets dev->br_port = NULL,
port_carrier_check() goes to "done" in that case. So everething looks safe
to me (but again, I do not even know what the "bridge" is :), so we should
only take care about container, nothing more.

I'll try to make a patch for illustration on evening.

Oleg.

