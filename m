Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZKQL6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZKQL6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZKQL6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:58:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39374 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZKQL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:58:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
In-Reply-To: <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
References: <20091117161711.3DDA.A69D9226@jp.fujitsu.com> <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
Message-Id: <20091117200618.3DFF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 20:58:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Nov 2009 16:17:50 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
> 
> So now what happens if we are paging and all our memory is tied up for
> writeback to a device or CIFS etc which can no longer allocate the memory
> to complete the write out so the MM can reclaim ?

Probably my answer is not so simple. sorry.

reason1: MM reclaim does both dropping clean memory and writing out dirty pages.
reason2: if all memory is exhausted, maybe we can't recover it. it is
fundamental limitation of Virtual Memory subsystem. and, min-watermark is
decided by number of system physcal memory, but # of I/O issue (i.e. # of
pages of used by writeback thread) is mainly decided # of devices. 
then, we can't gurantee min-watermark is sufficient on any systems.
Only reasonable solution is mempool like reservation, I think.
IOW, any reservation memory shouldn't share unrelated subsystem. otherwise
we lost any gurantee.

So, I think we need to hear why many developer don't use mempool,
instead use PF_MEMALLOC.

> Am I missing something or is this patch set not addressing the case where
> the writeback thread needs to inherit PF_MEMALLOC somehow (at least for
> the I/O in question and those blocking it)

Yes, probably my patchset isn't perfect. honestly I haven't understand
why so many developer prefer to use PF_MEMALLOC.



