Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZJAIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZJAIBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZJAIBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:01:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44089 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbZJAIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:01:49 -0400
Date: Thu, 1 Oct 2009 10:01:52 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [PATCH] connector: Allow permission checking in the receiver
	callbacks
Message-ID: <20091001080152.GA8018@barkeeper1-xen.linbit>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com> <20090930112057.GA15150@ioremap.net> <20090930132034.GE8032@barkeeper1-xen.linbit> <20090930192928.GA1315@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090930192928.GA1315@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:29:28PM +0400, Evgeniy Polyakov wrote:
> On Wed, Sep 30, 2009 at 03:20:35PM +0200, Lars Ellenberg (lars.ellenberg@linbit.com) wrote:
> > Actually it is the basis for follow-up security fixes.
> > 
> > Without this, unprivileged user space is able to send arbitrary
> > connector requests to kernel subsystems, which have no way to verify the
> > privileges of the sender anymore, because that information, even though
> > available at the netlink layer, has been dropped by the connector.
> 
> It is not. One can add some checks at receiving time which happens in
> process context to get its credentials, but nothing in netlink itself
> carry this info. Getting that connector schedules workqueue this ability
> is lost.

Please correct me if I'm wrong.

My understanding is, that in netlink_sendmsg, the credentials and
capabilities are copied into skb->cb.
During kernel side receive, these can be checked.

If we pass the skb, instead of just the msg, then even an asynchronously
scheduled receive callback, running in any workqueue or other context,
can check for these credentials.

Passing skb instead of just the msg for use in cn_queue_wrapper
is what the fist patch does.

Second patch changes the semantics of the actual callback
to be passed in the msg _and_ the netlink_skb_parms, both
"reconstructed" from the skb.

Now, in the end-user callback, there is the actual msg,
but also the netlink_skb_parms.
So this enables the end-user callback, running in arbitrary context,
to check capabilities and other credentials of the sending process.


> > Once this is applied, the various in-kernel receiving connector
> > callbacks can (and need to) add cap_raised(nsb->eff_cap, cap) where
> > appropriate. For example, you don't want some guest user to be able to
> > trigger a dst_del_node callback by sending a crafted netlink message,
> > right?
> > 
> > So it _is_ a (design-) bug fix.
> > Or am I missing something?
> 
> This patchset is not a bugfix, just a cleanup, since none in patchset
> uses netlink_skb_parms

3. and 4. patch are in fact merely cleanups.

> and currently I see no users which are affected
> by this behaviour in the mainline branch (not counting staging tree).
> 
> But if proposed configuration changes for DM are on the way, then I
> agree and they should force this patchset into the tree as a bugfix.
> 
> -- 
> 	Evgeniy Polyakov
> 

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
