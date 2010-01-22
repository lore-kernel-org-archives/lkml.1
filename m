Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726Ab0AVBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0AVBbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197Ab0AVBbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:31:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39456 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0AVBbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:31:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201001212121.50272.rjw@sisk.pl>
References: <20100121091023.3775.A69D9226@jp.fujitsu.com> <201001212121.50272.rjw@sisk.pl>
Message-Id: <20100122100155.6C03.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Jan 2010 10:31:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Probably we have multiple option. but I don't think GFP_NOIO is good
> > option. It assume the system have lots non-dirty cache memory and it isn't
> > guranteed.
> 
> Basically nothing is guaranteed in this case.  However, does it actually make
> things _worse_?  

Hmm..
Do you mean we don't need to prevent accidental suspend failure?
Perhaps, I did misunderstand your intention. If you think your patch solve
this this issue, I still disagree. but If you think your patch mitigate
the pain of this issue, I agree it. I don't have any reason to oppose your
first patch.

> What _exactly_ does happen without the $subject patch if the
> system doesn't have non-dirty cache memory and someone makes a GFP_KERNEL
> allocation during suspend?

Page allocator prefer to spent lots time for reclaimable memory searching than
returning NULL. IOW, it can spent time few second if it doesn't have
reclaimable memory.
In typical case, OOM killer forcely make enough free memory if the system
don't have any memory. But under suspending time, oom killer is disabled.
So, if the caller (probably drivers) call alloc >1000times, the system
spent lots seconds.

In this case, GFP_NOIO doesn't help. slowness behavior is caused by
freeable memory search, not slow i/o.

However, if strange i/o device makes any i/o slowness, GFP_NOIO might help.
In this case, please don't ask me about i/o thing. I don't know ;)




