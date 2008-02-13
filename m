Return-Path: <linux-kernel-owner+w=401wt.eu-S1765139AbYBMX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765139AbYBMX1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYBMX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:26:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbYBMX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:26:54 -0500
Date: Wed, 13 Feb 2008 15:26:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 7/8] IPMI: convert locked counters to atomics
Message-Id: <20080213152645.9e589d0c.akpm@linux-foundation.org>
In-Reply-To: <20080213163220.GG9830@minyard.local>
References: <20080213163220.GG9830@minyard.local>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:32:20 -0600
Corey Minyard <minyard@acm.org> wrote:

> From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
> 
> Atomics are a lot more efficient and neat than using a lock.
>   

Yes, but...

> +struct ipmi_stats
> +{
> +	/* Commands we got that were invalid. */
> +	atomic_t sent_invalid_commands;
> +
> +	/* Commands we sent to the MC. */
> +	atomic_t sent_local_commands;
> +	/* Responses from the MC that were delivered to a user. */
> +	atomic_t handled_local_responses;
> +	/* Responses from the MC that were not delivered to a user. */
> +	atomic_t unhandled_local_responses;
> +
> +	/* Commands we sent out to the IPMB bus. */
> +	atomic_t sent_ipmb_commands;
> +	/* Commands sent on the IPMB that had errors on the SEND CMD */
> +	atomic_t sent_ipmb_command_errs;
> +	/* Each retransmit increments this count. */
> +	atomic_t retransmitted_ipmb_commands;
> +	/* When a message times out (runs out of retransmits) this is
> +           incremented. */
> +	atomic_t timed_out_ipmb_commands;
> +
> +	/* This is like above, but for broadcasts.  Broadcasts are
> +           *not* included in the above count (they are expected to
> +           time out). */
> +	atomic_t timed_out_ipmb_broadcasts;
> +
> +	/* Responses I have sent to the IPMB bus. */
> +	atomic_t sent_ipmb_responses;
> +
> +	/* The response was delivered to the user. */
> +	atomic_t handled_ipmb_responses;
> +	/* The response had invalid data in it. */
> +	atomic_t invalid_ipmb_responses;
> +	/* The response didn't have anyone waiting for it. */
> +	atomic_t unhandled_ipmb_responses;
> +
> +	/* Commands we sent out to the IPMB bus. */
> +	atomic_t sent_lan_commands;
> +	/* Commands sent on the IPMB that had errors on the SEND CMD */
> +	atomic_t sent_lan_command_errs;
> +	/* Each retransmit increments this count. */
> +	atomic_t retransmitted_lan_commands;
> +	/* When a message times out (runs out of retransmits) this is
> +           incremented. */
> +	atomic_t timed_out_lan_commands;
> +
> +	/* Responses I have sent to the IPMB bus. */
> +	atomic_t sent_lan_responses;
> +
> +	/* The response was delivered to the user. */
> +	atomic_t handled_lan_responses;
> +	/* The response had invalid data in it. */
> +	atomic_t invalid_lan_responses;
> +	/* The response didn't have anyone waiting for it. */
> +	atomic_t unhandled_lan_responses;
> +
> +	/* The command was delivered to the user. */
> +	atomic_t handled_commands;
> +	/* The command had invalid data in it. */
> +	atomic_t invalid_commands;
> +	/* The command didn't have anyone waiting for it. */
> +	atomic_t unhandled_commands;
> +
> +	/* Invalid data in an event. */
> +	atomic_t invalid_events;
> +	/* Events that were received with the proper format. */
> +	atomic_t events;
> +};

The code forgot to initialise all of these.

It just so happens that the all-bits-zero pattern works correctly for all
current architectures, so the code should work OK.  But there is no reason
(I hope) why an architecture cannot implement atomic_t as

struct atomic_t {
	int counter;
	spinlock_t lock;
};

in which case the results of ATOMIC_INIT() may _not_ be all-zeroes, in
which case the code will deadlock.

So.  It works, but it's grubby.   Do you still wish to proceed?
