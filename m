Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYLVXkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYLVXkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbYLVXkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:40:23 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42231 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYLVXkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:40:22 -0500
Date: Mon, 22 Dec 2008 15:38:55 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 6/6][v3] Protect cinit from blocked fatal signals
Message-ID: <20081222233855.GA13079@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005529.GF5025@us.ibm.com> <20081222225825.GC1536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222225825.GC1536@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| > @@ -1907,9 +1943,10 @@ relock:
| >
| >  		/*
| >  		 * Global init gets no signals it doesn't want.
| > +		 * Container-init gets no signals it doesn't want from same
| > +		 * container.
| >  		 */
| > -		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
| > -		    !signal_group_exit(signal))
| > +		if (sig_unkillable(signal, signr) && !signal_group_exit(signal))
| >  			continue;
| 
| Again, I do not understand why do we need SIGNAL_UNKILLABLE_FROM_NS.
| 
| I thought about the change in get_signal_to_deliver() during the
| previous discussion, and I think what we need is:
| 
| 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
| 		    !sig_kernel_only(sig))
| 			continue;
| 
| and this was yet another reason for "protect init from unwanted signals more".

I was trying to avoid the clearing of the SIGNAL_UNKILLABLE in
send_signal() that we had last time.

But yes, you are right. I even had a BUG_ON() to confirm SIGKILL/SIGSTOP
will never happen for global-init :-). If so, SIGKLL/SIGSTOP to an init
can come only from parent ns.

So, yes, we can drop this flag.
