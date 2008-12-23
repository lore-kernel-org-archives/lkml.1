Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYLWAFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYLWAFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYLWAFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:05:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46162 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbYLWAFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:05:42 -0500
Date: Tue, 23 Dec 2008 01:03:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 6/6][v3] Protect cinit from blocked fatal signals
Message-ID: <20081223000356.GB7279@redhat.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005529.GF5025@us.ibm.com> <20081222225825.GC1536@redhat.com> <20081222233855.GA13079@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222233855.GA13079@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | > @@ -1907,9 +1943,10 @@ relock:
> | >
> | >  		/*
> | >  		 * Global init gets no signals it doesn't want.
> | > +		 * Container-init gets no signals it doesn't want from same
> | > +		 * container.
> | >  		 */
> | > -		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> | > -		    !signal_group_exit(signal))
> | > +		if (sig_unkillable(signal, signr) && !signal_group_exit(signal))
> | >  			continue;
> | 
> | Again, I do not understand why do we need SIGNAL_UNKILLABLE_FROM_NS.
> | 
> | I thought about the change in get_signal_to_deliver() during the
> | previous discussion, and I think what we need is:
> | 
> | 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> | 		    !sig_kernel_only(sig))
> | 			continue;
> | 
> | and this was yet another reason for "protect init from unwanted signals more".
> 
> I was trying to avoid the clearing of the SIGNAL_UNKILLABLE in
> send_signal() that we had last time.

Well, my plan was to simplify the first series of patches as much
as possible, then I thought we can change get_signal_to_deliver().

But now I tend to agree, we should not clear SIGNAL_UNKILLABLE when
we send the signal, and we should pass same_ns/from_parent_ns to
prepare_signal() from the start. This way is more "clean".

> But yes, you are right. I even had a BUG_ON() to confirm SIGKILL/SIGSTOP
> will never happen for global-init :-). If so, SIGKLL/SIGSTOP to an init
> can come only from parent ns.
>
> So, yes, we can drop this flag.

Great!

Oleg.

