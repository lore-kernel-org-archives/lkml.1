Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbXGaWXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbXGaWXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXGaWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:23:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46682 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbXGaWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:23:09 -0400
Subject: Re: [PATCH] add check do_direct_IO() return val
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
In-Reply-To: <20070731043554.GA3393@joejin-pc.cn.oracle.com>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	 <46A9E6F9.20603@oracle.com>
	 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
	 <20070730135316.2ce21b28.akpm@linux-foundation.org>
	 <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
	 <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
	 <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
	 <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
	 <20070731005348.GA8308@joejin-pc.cn.oracle.com>
	 <46AEB055.9050607@us.ibm.com>
	 <20070731043554.GA3393@joejin-pc.cn.oracle.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 15:25:11 -0700
Message-Id: <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 12:35 +0800, Joe Jin wrote:
> > Hmm.. in this config file, whats causing DIO to panic ? Which test actually
> > passing faulty buffer ?
> > 
> 
> By my testing, just defined job3 and job10 will also get the panic, but if
> only have one of them, panic will not appear. the faulty buffer maybe passed
> by mmap.

Okay. Here is the fix for the problem.

Here is whats happening in this case:

Faulty user-buffer caused -EFAULT to be returned from do_direct_IO().
We go into dio_zero_block() to see if we need to zero out sections of
the block (if IO size < blocksize case). It checks if the buffer is
newly allocation by doing buffer_new(bh). map_bh is NOT initialized and
never went through get_block() code. So, its possible to pass the check
and end up submitting a page wrongly and causing the oops.

Fix is to initialize the buffer state. 

Thanks,
Badari

Need to initialize map_bh.b_state to zero. Otherwise, in case of
a faulty user-buffer its possible to go into dio_zero_block()
and submit a page by mistake - since it checks for buffer_new().

http://marc.info/?l=linux-kernel&m=118551339032528&w=2

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 fs/direct-io.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23-rc1/fs/direct-io.c
===================================================================
--- linux-2.6.23-rc1.orig/fs/direct-io.c	2007-07-22 13:41:00.000000000 -0700
+++ linux-2.6.23-rc1/fs/direct-io.c	2007-07-31 15:13:44.000000000 -0700
@@ -974,6 +974,7 @@ direct_io_worker(int rw, struct kiocb *i
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->map_bh.b_private = NULL;
+	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 


