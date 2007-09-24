Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXIXGwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXIXGwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXIXGvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:51:54 -0400
Received: from mx2.go2.pl ([193.17.41.42]:39742 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751123AbXIXGvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:51:53 -0400
Date: Mon, 24 Sep 2007 08:54:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070924065407.GA1776@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F398C3.3000804@bull.net> <20070921110347.GB1758@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921110347.GB1758@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 01:03:47PM +0200, Jarek Poplawski wrote:
...
> I hope not! But, then it would be probably another logical trick:
> ipc_rcu_getref/putref() seems to prevent kfreeing of a structure, so
> if it's used in do_msgsnd() there should be a risk something can do
> this kfree at this moment, and it seems freeque() is the only one,
> which both: can do this and cares for this refcount. Then, e.g., if
> any of them does ipc_rcu_getref() a bit later and sees old (cached)
> value - kfree can be skipped forever. [...]

After rethinking, this scenario seems to be wrong or very unprobable
(I'm not sure of all ways "if (--container...)" could be compiled),
so there should be no such risk - double kfree/vfree is more probable,
so no danger. More likely is such refcount abuse: ipc_rcu_getref() in
do_msgsnd() done a bit after ipc_rcu_putref() in freeque() (msq
pointer acquired by do_msgsend() before freeque() started); then,
after schedule(), do_msgsnd() can work with kfreed msq_queue structure
(at least considering classic RCU).

Regards,
Jarek P.
