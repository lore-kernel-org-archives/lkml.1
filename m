Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753050AbYLQWX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYLQWX3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYLQWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:23:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYLQWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:23:18 -0500
Date: Wed, 17 Dec 2008 14:22:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, zbr@ioremap.net
Subject: Re: [w1] Allow master IO commands.
Message-Id: <20081217142241.e05fff98.akpm@linux-foundation.org>
In-Reply-To: <1229450882-745-2-git-send-email-zbr@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
	<1229450882-745-2-git-send-email-zbr@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 21:07:59 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> This patch allows to start IO not against already found slave devices,
> but against the bus itself, which can be used for example to probe device.
> 
> ...
>
> +static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
> +		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
> +{
> +	int err = -EINVAL;
> +	struct cn_msg *msg;
> +	struct w1_netlink_msg *hdr;
> +	struct w1_netlink_cmd *cmd;
> +
> +	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);

The use of PAGE_SIZE is odd.  It's either too large (inefficient) or
too small (disaster).

Is it not practical to calculate this precisely?

> +	if (!msg)
> +		return -ENOMEM;
> +
> +	msg->id = req_msg->id;
> +	msg->seq = req_msg->seq;
> +	msg->ack = 0;
> +	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
> +
> +	hdr = (struct w1_netlink_msg *)(msg + 1);
> +	cmd = (struct w1_netlink_cmd *)(hdr + 1);
> +
> +	hdr->type = W1_MASTER_CMD;
> +	hdr->id = req_hdr->id;
> +	hdr->len = sizeof(struct w1_netlink_cmd);
> +
> +	cmd->cmd = req_cmd->cmd;
> +	cmd->len = 0;
> +
> +	switch (cmd->cmd) {
> +		case W1_CMD_SEARCH:

checkpatch correctly points out that the body of the switch statement
should be indented one tabstop less than this.

> +		case W1_CMD_ALARM_SEARCH:
> +			err = w1_process_search_command(dev, msg,
> +				PAGE_SIZE - msg->len - sizeof(struct cn_msg));

which would give more room for cleaning this up.

> +			break;
> +		case W1_CMD_READ:
> +		case W1_CMD_WRITE:
> +		case W1_CMD_TOUCH:
> +			err = w1_process_command_io(dev, msg, hdr, cmd);
> +			break;
> +		default:
> +			cmd->res = EINVAL;
> +			cn_netlink_send(msg, 0, GFP_KERNEL);
> +			break;
> +	}
> +
> +	kfree(msg);
> +	return err;
> +}
> +

