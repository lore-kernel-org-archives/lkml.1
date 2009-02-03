Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZBCUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZBCUB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZBCUBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:01:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbZBCUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:01:50 -0500
Date: Tue, 3 Feb 2009 12:01:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: add type cast to kzalloc()'d space to avoid
 slab corruption
Message-Id: <20090203120147.dd079ffd.akpm@linux-foundation.org>
In-Reply-To: <20090203182338.GA1770@sgi.com>
References: <20090203182338.GA1770@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 12:23:38 -0600
Dean Nelson <dcn@sgi.com> wrote:

> A missing type cast results in writing way beyond the end of a kzalloc()'d
> memory segment resulting in slab corruption.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> Cc: stable <stable@kernel.org>
> 
> ---
> 
>  drivers/misc/sgi-xp/xpc_uv.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux/drivers/misc/sgi-xp/xpc_uv.c
> ===================================================================
> --- linux.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-01-27 10:53:26.000000000 -0600
> +++ linux/drivers/misc/sgi-xp/xpc_uv.c	2009-01-28 08:51:57.000000000 -0600
> @@ -3,7 +3,7 @@
>   * License.  See the file "COPYING" in the main directory of this archive
>   * for more details.
>   *
> - * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
> + * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
>   */
>  
>  /*
> @@ -1129,8 +1129,8 @@ xpc_allocate_recv_msg_slot_uv(struct xpc
>  			continue;
>  
>  		for (entry = 0; entry < nentries; entry++) {
> -			msg_slot = ch_uv->recv_msg_slots + entry *
> -			    ch->entry_size;
> +			msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)
> +			    ch_uv->recv_msg_slots + entry * ch->entry_size);

So..  ch->entry_size is not equal to sizeof(struct xpc_notify_mq_msg_uv)?

Perhaps ->recv_msg_slots should never have had type struct
xpc_notify_mq_msg_uv *?

>  			msg_slot->hdr.msg_slot_number = entry;
>  		}
> @@ -1438,7 +1438,7 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
>  	/* we're dealing with a normal message sent via the notify_mq */
>  	ch_uv = &ch->sn.uv;
>  
> -	msg_slot = (struct xpc_notify_mq_msg_uv *)((u64)ch_uv->recv_msg_slots +
> +	msg_slot = (struct xpc_notify_mq_msg_uv *)((u8 *)ch_uv->recv_msg_slots +
>  		    (msg->hdr.msg_slot_number % ch->remote_nentries) *
>  		    ch->entry_size);

This hunk doesn't change anything?
