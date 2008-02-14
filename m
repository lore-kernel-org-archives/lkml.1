Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbYBNTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbYBNTMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYBNTMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:12:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278AbYBNTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:12:09 -0500
Date: Thu, 14 Feb 2008 11:11:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>
Subject: Re: [PATCH 3/4] IPMI: convert locked counters to atomics
Message-Id: <20080214111143.7e0937ea.akpm@linux-foundation.org>
In-Reply-To: <20080214183051.GC20148@minyard.local>
References: <20080214183051.GC20148@minyard.local>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	for (i = 0; i < IPMI_NUM_STATS; i++)
> +		atomic_set(&intf->stats[i], 0);

And this is why it would be very hard for any architecture to ever
implement atomic_t as

struct atomic_t {
	int counter;
	spinlock_t lock;
};

The interface assumes that atomic_set() fully initialises the atomic_t, and
that atomic_set() can be used agaisnt both an uninitialised atomic_t and
against an already-initialised atomic_t.  IOW, we don't have atomic_init().

So would our hypothetical future architcture's atomic_set() do spin_lock(),
or would it do spin_lock_init()?  Either one is wrong in many atomic_set
callsites.

Oh well.
