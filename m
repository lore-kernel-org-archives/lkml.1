Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYH1W7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYH1W7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYH1W70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:59:26 -0400
Received: from quackingmoose.com ([63.73.180.143]:36254 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752959AbYH1W7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:59:25 -0400
Date: Thu, 28 Aug 2008 15:59:24 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: mpm@selenic.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/random.c line 728 BUG
Message-ID: <20080828225924.GD6432@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826225918.GC5452@merfinllc.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Aug 26 03:59 PM, Aaron Straus wrote:
> kernel BUG at drivers/char/random.c:728!

OK so that's (outside spinlock):

   BUG_ON(r->entropy_count > r->poolinfo->POOLBITS); 

in credit_entropy_bits we do (inside spinlock):

	r->entropy_count += nbits;
	if (r->entropy_count < 0) {
		DEBUG_ENT("negative entropy/overflow\n");
		r->entropy_count = 0;
	} else if (r->entropy_count > r->poolinfo->POOLBITS)
		r->entropy_count = r->poolinfo->POOLBITS;

I wonder if we got unlucky and did the:

  r->entropy_count += nbits

 - overflowed the entropy_count THEN
 - another thread hits the BUG before this thread reaches

   r->entropy_count = r->poolinfo->POOLBITS;

--

I notice before this commit:

commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
Author: Matt Mackall <mpm@selenic.com>
Date:   Tue Apr 29 01:03:07 2008 -0700

    random: simplify and rename credit_entropy_store

The credit_entropy_store function looks like this:

	spin_lock_irqsave(&r->lock, flags);

	if (r->entropy_count + nbits < 0) {
		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
			  r->entropy_count, nbits);
		r->entropy_count = 0;
	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
		r->entropy_count = r->poolinfo->POOLBITS;
	} else {
		r->entropy_count += nbits;
		if (nbits)
			DEBUG_ENT("added %d entropy credits to %s\n",
				  nbits, r->name);
	}


Notice the old version is careful not to overflow r->entropy_count at
any point (even within the spinlock).  So perhaps that's why we didn't
hit this BUG() in the past?

Thanks!

					=a=


-- 
===================
Aaron Straus
aaron@merfinllc.com
