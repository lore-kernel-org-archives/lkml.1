Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXI1S10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXI1S10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXI1S1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:27:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbXI1S1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:27:18 -0400
Date: Fri, 28 Sep 2007 11:26:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - Fix locking in skb alloction failure fix
Message-Id: <20070928112634.0bef9525.akpm@linux-foundation.org>
In-Reply-To: <20070928154314.GA7185@c2.user-mode-linux.org>
References: <20070928154314.GA7185@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 11:43:14 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> Add _irqsave/_irqrestore to the locking in update_drop_skb to keep
> uml_net_rx out while the drop skb is being messed with.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  arch/um/drivers/net_kern.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22/arch/um/drivers/net_kern.c
> ===================================================================
> --- linux-2.6.22.orig/arch/um/drivers/net_kern.c	2007-09-28 11:10:19.000000000 -0400
> +++ linux-2.6.22/arch/um/drivers/net_kern.c	2007-09-28 11:13:58.000000000 -0400
> @@ -49,9 +49,10 @@ static int drop_max;
>  static int update_drop_skb(int max)
>  {
>  	struct sk_buff *new;
> +	unsigned long flags;
>  	int err = 0;
>  
> -	spin_lock(&drop_lock);
> +	spin_lock_irqsave(&drop_lock, flags);
>  
>  	if (max <= drop_max)
>  		goto out;
> @@ -68,7 +69,7 @@ static int update_drop_skb(int max)
>  	drop_max = max;
>  	err = 0;
>  out:
> -	spin_unlock(&drop_lock);
> +	spin_unlock_irqrestore(&drop_lock, flags);
>  
>  	return err;
>  }

Doesn't this assume that the arch is only ever uniprocessor, which I don't think is
true on i386 UML??
