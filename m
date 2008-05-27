Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYE0SHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYE0SHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYE0SHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:07:09 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:23367 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbYE0SHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:07:07 -0400
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="72742751"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       scottwood@freescale.com, torvalds@linux-foundation.org,
       tpiepho@freescale.com, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com>
	<1211906268.3435.44.camel@localhost.localdomain>
	<adad4n71wb3.fsf@cisco.com>
	<1211910825.7160.1.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 May 2008 11:07:05 -0700
In-Reply-To: <1211910825.7160.1.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 27 May 2008 12:53:45 -0500")
Message-ID: <adamymbvcxi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 18:07:05.0771 (UTC) FILETIME=[78C6CFB0:01C8C024]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Um, OK, you've said write twice now ... I was assuming you meant read.
 > Even on an x86, writes are posted, so there's no way a spin lock could
 > serialise a write without an intervening read to flush the posting
 > (that's why only reads have a relaxed version on altix).  Or is there
 > something else I'm missing?

Writes are posted yes, but not reordered arbitrarily.  If I have code like:

	spin_lock(&mmio_lock);
	writel(val1, reg1);
	writel(val2, reg2);
	spin_unlock(&mmio_lock);

then I have a reasonable expectation that if two CPUs run this at the
same time, their writes to reg1/reg2 won't be interleaved with each
other (because the whole section is inside a spinlock).  And Altix
violates that expectation.

 - R.
