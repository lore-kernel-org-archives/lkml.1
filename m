Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753452AbYLQXOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYLQXOe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLQXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:14:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbYLQXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:14:22 -0500
Date: Wed, 17 Dec 2008 15:14:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [w1] Allow master IO commands.
Message-Id: <20081217151418.f17cee7c.akpm@linux-foundation.org>
In-Reply-To: <20081217223352.GA28283@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
	<1229450882-745-2-git-send-email-zbr@ioremap.net>
	<20081217142241.e05fff98.akpm@linux-foundation.org>
	<20081217223352.GA28283@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 01:33:52 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Hi Andrew.
> 
> On Wed, Dec 17, 2008 at 02:22:41PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > > +static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
> > > +		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
> > > +{
> > > +	int err = -EINVAL;
> > > +	struct cn_msg *msg;
> > > +	struct w1_netlink_msg *hdr;
> > > +	struct w1_netlink_cmd *cmd;
> > > +
> > > +	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > 
> > The use of PAGE_SIZE is odd.  It's either too large (inefficient) or
> > too small (disaster).
> > 
> > Is it not practical to calculate this precisely?
> 
> It is not possible to calculate it in advance for the search commands,
> since we do not know how many slave devices are attached to the bus.
> This buffer is used as temporal area where IDs are stored and when
> number of IDs is large enough message is emmitted to the userspace and
> buffer becomes empty again. Sending one message per slave ID is a too
> big overhead, so this could be half of a page or one third or whatever
> else, I selected a page, which is the maximum guaranteed allocation
> buffer size.

OK.

Do we have checks in there to ensure that we can't run off the end of
the buffer?

> > > +	if (!msg)
> > > +		return -ENOMEM;
> > > +
> > > +	msg->id = req_msg->id;
> > > +	msg->seq = req_msg->seq;
> > > +	msg->ack = 0;
> > > +	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
> > > +
> > > +	hdr = (struct w1_netlink_msg *)(msg + 1);
> > > +	cmd = (struct w1_netlink_cmd *)(hdr + 1);
> > > +
> > > +	hdr->type = W1_MASTER_CMD;
> > > +	hdr->id = req_hdr->id;
> > > +	hdr->len = sizeof(struct w1_netlink_cmd);
> > > +
> > > +	cmd->cmd = req_cmd->cmd;
> > > +	cmd->len = 0;
> > > +
> > > +	switch (cmd->cmd) {
> > > +		case W1_CMD_SEARCH:
> > 
> > checkpatch correctly points out that the body of the switch statement
> > should be indented one tabstop less than this.
> > 
> > > +		case W1_CMD_ALARM_SEARCH:
> > > +			err = w1_process_search_command(dev, msg,
> > > +				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
> > 
> > which would give more room for cleaning this up.
> 
> Ok, I will space it to the left. Should I sent patch on top of it or
> instead of?

Is OK, I'll fix it.  That change messes up the following patches so I
fixed them as well.

