Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891Ab0AUAr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0AUAr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311Ab0AUArT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:47:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37846 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0AUArR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:47:17 -0500
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
In-Reply-To: <201001202221.34804.rjw@sisk.pl>
References: <20100120085053.405A.A69D9226@jp.fujitsu.com> <201001202221.34804.rjw@sisk.pl>
Message-Id: <20100121091023.3775.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 Jan 2010 09:47:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Rafael,
> > 
> > Do you mean this is the unrelated issue of nVidia bug?
> 
> The nvidia driver _is_ buggy, but Maxim said he couldn't reproduce the
> problem if all the allocations made by the nvidia driver during suspend
> were changed to GFP_ATOMIC.
> 
> > Probably I haven't catch your point. I don't find Maxim's original bug
> > report. Can we share the test-case and your analysis detail?
> 
> The Maxim's original report is here:
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-January/023982.html
> 
> and the message I'm referring to is at:
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-January/023990.html

Hmmm...

Usually, Increasing I/O isn't caused MM change. either subsystem change
memory alloc/free pattern and another subsystem receive such effect ;)
I don't think this message indicate MM fault.

And, 2.6.33 MM change is not much. if the fault is in MM change
(note: my guess is no), The most doubtful patch is my "killing shrink_all_zones"
patch. If old shrink_all_zones reclaimed memory much rather than required. 
The patch fixed it. IOW, the patch can reduce available free memory to be used
buggy .suspend of the driver. but I don't think it is MM fault.

As I said, drivers can't use memory freely as their demand in suspend method.
It's obvious. They should stop such unrealistic assumption. but How should we fix
this?
 - Gurantee suspend I/O device at last?
 - Make much much free memory before calling .suspend method? even though
   typical drivers don't need.
 - Ask all drivers how much they require memory before starting suspend and
   Make enough free memory at first?
 - Or, do we have an alternative way?


Probably we have multiple option. but I don't think GFP_NOIO is good
option. It assume the system have lots non-dirty cache memory and it isn't
guranteed.



