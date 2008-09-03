Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYICAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYICAQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYICAQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:16:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51364
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYICAQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:16:36 -0400
Date: Tue, 02 Sep 2008 17:16:30 -0700 (PDT)
Message-Id: <20080902.171630.193505044.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
 CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080831173349.GA15393@linux.vnet.ibm.com>
References: <20080831173349.GA15393@linux.vnet.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 31 Aug 2008 10:33:49 -0700

> Make sparc64 refrain from clearing a given to-be-offlined CPU's bit in the
> cpu_online_mask until it has processed pending irqs.  This change
> prevents other CPUs from being blindsided by an apparently offline CPU
> nevertheless changing globally visible state.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I wonder what the 'call_lock' thing protects :-)

That lock is a cobweb from the sparc64 code before I switched it over
to use the generic smp_call_function() code in kernel/smp.c

So this lock doesn't protect anything any more.

kernel/smp.c has a call_function_lock, which isn't marked static
but isn't declared in any header file.

My instinct is that the intention is that I could use this lock
for the synchronization previously provided by sparc64's local
"call_lock", and it even seems the author of kernel/smp.c intended
this kind of usage.

Anyways, if this code is still using the worthless call_lock, it
isn't protecting against anything.

So I'd like to hold off on this patch until this locking issue is
resolved.
