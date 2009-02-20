Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZBTOSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZBTOSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZBTOSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:18:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34934 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZBTOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:18:16 -0500
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <20090220140157.GA12799@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu>  <20090220140157.GA12799@elte.hu>
Date: Fri, 20 Feb 2009 16:18:12 +0200
Message-Id: <1235139492.29813.53.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 15:01 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ah, indeed:
> > 
> >         list_del_rcu(&va->list);
> > 
> > i suspect it could be hit big time in a workload that opens 
> > more than 512 files, as expand_files() uses a 
> > vmalloc()+vfree() pair in that case.
> 
> hm, perhaps it's not a problem after all. The freeing is done 
> via rcu, and list_del_rcu() leaves the forward pointer intact.
> 
> So how did it happen that the entry got kfree()d before the loop 
> was done? We are in a spinlocked section so the CPU should not 
> have entered rcu processing.

RCU. Lets CC Paul.

Looking at it, Documentation/RCU/checklist.txt states that:

7.      If the updater uses call_rcu(), then the corresponding readers
        must use rcu_read_lock() and rcu_read_unlock().

which we don't do for this loop. I fail to see how it could be a
kmemcheck false positive, so it's probably a real bug.

			Pekka

