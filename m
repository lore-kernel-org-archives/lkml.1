Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab0CKFQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 00:16:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59842 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0CKFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 00:16:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Mar 2010 14:13:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       Andrea Righi <arighi@develer.com>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH mmotm 2.5/4] memcg: disable irq at page cgroup lock (Re:
 [PATCH -mmotm 3/4] memcg: dirty pages accounting and limiting
 infrastructure)
Message-Id: <20100311141300.90b85391.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100311135847.990eee62.nishimura@mxp.nes.nec.co.jp>
References: <20100308105641.e2e714f4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308111724.3e48aee3.nishimura@mxp.nes.nec.co.jp>
	<20100308113711.d7a249da.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308170711.4d8b02f0.nishimura@mxp.nes.nec.co.jp>
	<20100308173100.b5997fd4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100309001252.GB13490@linux>
	<20100309091914.4b5f6661.kamezawa.hiroyu@jp.fujitsu.com>
	<20100309102928.9f36d2bb.nishimura@mxp.nes.nec.co.jp>
	<20100309045058.GX3073@balbir.in.ibm.com>
	<20100310104309.c5f9c9a9.nishimura@mxp.nes.nec.co.jp>
	<20100310035624.GP3073@balbir.in.ibm.com>
	<20100311133123.ab10183c.nishimura@mxp.nes.nec.co.jp>
	<20100311134908.48d8b0fc.kamezawa.hiroyu@jp.fujitsu.com>
	<20100311135847.990eee62.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 13:58:47 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > I'll consider yet another fix for race in account migration if I can.
> > 
> me too.
> 

How about this ? Assume that the race is very rare.

	1. use trylock when updating statistics.
	   If trylock fails, don't account it.

	2. add PCG_FLAG for all status as

+	PCG_ACCT_FILE_MAPPED, /* page is accounted as file rss*/
+	PCG_ACCT_DIRTY, /* page is dirty */
+	PCG_ACCT_WRITEBACK, /* page is being written back to disk */
+	PCG_ACCT_WRITEBACK_TEMP, /* page is used as temporary buffer for FUSE */
+	PCG_ACCT_UNSTABLE_NFS, /* NFS page not yet committed to the server */

	3. At reducing counter, check PCG_xxx flags by
	TESTCLEARPCGFLAG()

This is similar to an _used_ method of LRU accounting. And We can think this
method's error-range never go too bad number. 

I think this kind of fuzzy accounting is enough for writeback status.
Does anyone need strict accounting ?

Thanks,
-Kame

