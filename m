Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZAKGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZAKGRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZAKGRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:17:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZAKGRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:17:05 -0500
Date: Sun, 11 Jan 2009 07:15:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [PATCH 6/7][v6] Protect cinit from blocked fatal signals
Message-ID: <20090111061505.GB9014@redhat.com>
References: <20090107074558.GA27881@us.ibm.com> <20090107075214.GF27985@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107075214.GF27985@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Sukadev Bhattiprolu wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1890,9 +1890,16 @@ relock:
>
>  		/*
>  		 * Global init gets no signals it doesn't want.
> +		 * Container-init gets no signals it doesn't want from same
> +		 * container.
> +		 *
> +		 * Note that if global/container-init sees a sig_kernel_only()
> +		 * signal here, the signal must have been generated internally
> +		 * or must have come from an ancestor namespace. In either
> +		 * case, the signal cannot be dropped.
>  		 */
>  		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> -		    !signal_group_exit(signal))
> +				!sig_kernel_only(signr))

Just for record. We still have small problem with fatal_signal_pending(cinit),
we should add a similar change to complete_signal to ensure that the pending
SIGKILL implies SIGNAL_GROUP_EXIT. But this needs another patch, and this
series is imho fine.

Oleg.

