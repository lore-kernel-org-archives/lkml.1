Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbXH2EwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbXH2EwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXH2Ev6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:51:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbXH2Ev5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:51:57 -0400
Date: Tue, 28 Aug 2007 21:51:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-Id: <20070828215128.d8147a43.akpm@linux-foundation.org>
In-Reply-To: <20070828141318.GC5869@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 16:13:18 +0200 Jan Kara <jack@suse.cz> wrote:

> +static void send_warning(const struct dquot *dquot, const char warntype)
> +{
> +	static unsigned long seq;
> +	struct sk_buff *skb;
> +	void *msg_head;
> +	int ret;
> +
> +	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
> +	if (!skb) {
> +		printk(KERN_ERR
> +		  "VFS: Not enough memory to send quota warning.\n");
> +		return;
> +	}
> +	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);

The access to seq is racy, isn't it?

If so, that can be solved with a lock, or with atomic_add_return().
