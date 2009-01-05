Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZAEPSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZAEPSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZAEPSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:18:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZAEPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:18:38 -0500
Date: Mon, 5 Jan 2009 16:16:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6][v5] Protect cinit from blocked fatal signals
Message-ID: <20090105151608.GE3313@redhat.com>
References: <20081227204658.GA27197@us.ibm.com> <20081227205409.GD27337@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227205409.GD27337@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27, Sukadev Bhattiprolu wrote:
>
> +		 * Container-init gets no signals it doesn't want from same
> +		 * container.
>  		 */
> -		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> -		    !signal_group_exit(signal))
> +		if ((signal->flags & SIGNAL_UNKILLABLE) &&
> +				!sig_kernel_only(signr))

minor, but why did you remove unlikely() ?

And could you improve the changelog a bit? Please explain
that !signal_group_exit() was needed to handle the case
when the mt init does exit/exec and sends SIGKILL to all
sub-threads. Now this is covered by sig_kernel_only().

In short, please explain that if SIGNAL_UNKILLABLE task
sees the sig_kernel_only() signal here, then it was either
sent by the parent namespace or it was generated internally.
In both cases we should not drop it.

But your current changelog mostly explains why do we need
another SIGNAL_UNKILLABLE check in get_signal_to_deliver(),
this is orthogonal to the change itself.

Oleg.

