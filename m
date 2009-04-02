Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbZDBD3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbZDBD3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZDBD3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:29:02 -0400
Received: from sh.osrg.net ([192.16.179.4]:34178 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDBD3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:29:00 -0400
Date: Thu, 2 Apr 2009 12:28:12 +0900
To: lizf@cn.fujitsu.com
Cc: mingo@elte.hu, jens.axboe@oracle.com, acme@redhat.com, rostedt@goodmis.org,
       fweisbec@gmail.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blktrace: fix pdu_len when tracing packet command
 requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D42036.5010102@cn.fujitsu.com>
References: <49D42036.5010102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090402122807K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 02 Apr 2009 12:28:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Apr 2009 10:17:26 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> This bug has been here since 2.6.26.
> 
> =======
> 
> Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
> large command support"), struct request->cmd has been changed from
> unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index fd1ff49..bafb8d3 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -642,7 +642,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
>  	if (blk_pc_request(rq)) {
>  		what |= BLK_TC_ACT(BLK_TC_PC);
>  		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
> -				sizeof(rq->cmd), rq->cmd);
> +				max_t(int, rq->cmd_len, BLK_MAX_CDB), rq->cmd);
>  	} else  {
>  		what |= BLK_TC_ACT(BLK_TC_FS);
>  		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
> -- 

The patch works however it would be cleaner to simply use cmd_len?

diff --git a/block/blk-core.c b/block/blk-core.c
index 996ed90..54765d7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,6 +132,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
+	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
 }
diff --git a/block/blktrace.c b/block/blktrace.c
index 028120a..90b9ca4 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -583,7 +583,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				sizeof(rq->cmd), rq->cmd);
+				rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
