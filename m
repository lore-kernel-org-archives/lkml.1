Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYBXTls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYBXTls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBXTlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:41:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYBXTlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:41:39 -0500
Date: Sun, 24 Feb 2008 20:41:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
Message-ID: <20080224194121.GA26451@elte.hu>
References: <20080224174605.GA21661@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224174605.GA21661@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Hi Andi,
> 
> My eyes fell on the following table in the boot messages:
> 
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-374557] TEXT DATA BSS
> early res: 3 [9fc00-a0bff] EBDA
> early res: 4 [8000-afff] PGTABLE
> 
> The memory reserved for the EBDA overflows into the area normally 
> reserved for the VGA adaptor. It seems that you wanted to force the 
> allocation to cover whole pages, like:

well, that's what your EBDA descriptor says - it's set to 9fc00 which is 
512 bytes below the VGA range. This behavior didnt really change over 
v2.6.24 (which reserved 'into' the VGA range too), it's just that in 
v2.6.25 we also print out these early reservations. Can you see any 
regression? There should be no harm from overlapping into the VGA range 
- these "reservations" only make RAM unavailable for normal allocations.

your patch on the other hand rounds the EBDA area down which could in 
theory be unsafe on other boxes (where there could be real RAM above the 
EBDA area): the safest approach is to round the beginning of it down, 
the end of it up (to page boundary). Your patch _should_ be OK, but in 
practice it doesnt hurt to reserve a bit more around the edges than to 
accidentally give a page to the OS that the BIOS might rely upon.

	Ingo
