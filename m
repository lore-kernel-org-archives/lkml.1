Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYHTLG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYHTLG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHTLGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:06:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39286 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYHTLGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:06:19 -0400
Date: Wed, 20 Aug 2008 20:05:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [RFC][PATCH 0/2] Quicklist is slighly problematic.
Cc: kosaki.motohiro@jp.fujitsu.com, tokunaga.keiich@jp.fujitsu.com
Message-Id: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph,

Thank you for explain your quicklist plan at OLS.

So, I made summary to issue of quicklist.
if you have a bit time, Could you please read this mail and patches?
And, if possible, Could you please tell me your feeling?


--------------------------------------------------------------------

Now, Quicklist store some page in each CPU as cache.
(Each CPU has node_free_pages/16 pages)

and it is used for page table cache.
Then, exit() increase cache, the other hand fork() spent it.

So, if apache type (one parent and many child model) middleware run,
One CPU process fork(), Other CPU process the middleware work and exit().

At that time, One CPU don't have page table cache at all,
Others have maximum caches.

	QList_max = (#ofCPUs - 1) x Free / 16
	=> QList_max / (Free + QList_max) = (#ofCPUs - 1) / (16 + #ofCPUs - 1)

So, How much quicklist spent memory at maximum case?
That is #CPUs proposional because it is per CPU cache but cache amount calculation doesn't use #ofCPUs.

	Above calculation mean

	 Number of CPUs per node            2    4    8   16
	 ==============================  ====================
	 QList_max / (Free + QList_max)   5.8%  16%  30%  48%


Wow! Quicklist can spent about 50% memory at worst case.
More unfortunately, it doesn't have any cache shrinking mechanism.
So it cause some wrong thing.

1. End user misunderstand to memory leak happend.
	=> /proc/meminfo should display amount quicklist

2. It can cause OOM killer
	=> Amount of quicklists shouldn't be proposional to #ofCPUs.





