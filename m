Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbXGSVUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbXGSVUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbXGSVUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:20:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761985AbXGSVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:20:41 -0400
Date: Thu, 19 Jul 2007 14:20:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Use patched rxrpc_kernel_send_data() correctly
In-Reply-To: <20070719180631.8684.65977.stgit@warthog.cambridge.redhat.com>
Message-ID: <alpine.LFD.0.999.0707191417530.27249@woody.linux-foundation.org>
References: <20070719180631.8684.65977.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, David Howells wrote:
>
> @@ -806,8 +807,9 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
>  	msg.msg_flags		= 0;
>  
>  	call->state = AFS_CALL_AWAIT_ACK;
> -	switch (rxrpc_kernel_send_data(call->rxcall, &msg, len)) {
> -	case 0:
> +	n = rxrpc_kernel_send_data(call->rxcall, &msg, len);
> +	switch (n) {
> +	case 0 ... INT_MAX:
>  		_leave(" [replied]");
>  		return;

Please don't do this. There's no reason to. Why not just use the much 
simpler

	if (n >= 0) {
		_leave(" [replied]");
		return;
	}
	if (n == -ENOMEM) {
		_debug("oom");
		rxrpc_kernel_abort_call(call->rxcall, RX_USER_ABORT);
	}

rather than have a silly and totally pointless case-statement with three 
really odd cases?

			Linus
