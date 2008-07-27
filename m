Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYG0Aer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYG0Aer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 20:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYG0Aeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 20:34:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756199AbYG0Aef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:34:35 -0400
Date: Sat, 26 Jul 2008 17:34:34 -0700 (PDT)
Message-Id: <20080726.173434.48036095.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080726131838.GA2873@ami.dom.local>
References: <20080725200137.GC3107@ami.dom.local>
	<20080726.021846.236624483.davem@davemloft.net>
	<20080726131838.GA2873@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Sat, 26 Jul 2008 15:18:38 +0200

> I guess some additional synchronization will be added yet to prevent
> parallel freeze and especially unfreeze.

Yes, that could be a problem.  Using test_and_set_bit() can
guard the freezing sequence itself, but it won't handle
letting two threads of control freeze and unfreeze safely
without a reference count.

We want this thing to be able to be used flexbly, which means
we can't just assume that this is a short code sequence and
the unfreeze will come quickly.  That pretty much rules
out using a new lock around the operation or anything
like that.

So I guess we could replace the state bit with a reference
count.  It doesn't even need to be atomic since it is set
and tested under dev_queue->_xmit_lock

