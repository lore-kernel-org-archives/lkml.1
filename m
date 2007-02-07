Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXBGBxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXBGBxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbXBGBxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:53:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXBGBxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:53:12 -0500
Date: Tue, 6 Feb 2007 17:51:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: stable@kernel.org, nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] knfsd: Fix a race in closing NFSd connections.
Message-Id: <20070206175152.39d767dd.akpm@linux-foundation.org>
In-Reply-To: <1070207001026.9413@suse.de>
References: <20070207110636.9166.patches@notabene>
	<1070207001026.9413@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 11:10:26 +1100
NeilBrown <neilb@suse.de> wrote:

> If you lose this race, it can iput a socket inode twice and you
> get a BUG in fs/inode.c
> 
> When I added the option for user-space to close a socket,
> I added some cruft to svc_delete_socket so that I could call
> that function when closing a socket per user-space request.
> 
> This was the wrong thing to do.  I should have just set SK_CLOSE
> and let normal mechanisms do the work.
> 
> Not only wrong, but buggy.  The locking is all wrong and it openned
> up a race where-by a socket could be closed twice.
> 
> So this patch:
>   Introduces svc_close_socket which sets SK_CLOSE then either leave
>   the close up to a thread, or calls svc_delete_socket if it can
>   get SK_BUSY.
> 
>   Adds a bias to sk_busy which is removed when SK_DEAD is set,
>   This avoid races around shutting down the socket.
> 
>   Changes several 'spin_lock' to 'spin_lock_bh' where the _bh 
>   was missing.
> 

This patch assumes the presence of
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch which
obviously isn't appropriate for -stable.

Please confirm that the patch which I merged is still OK, thanks.
