Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbZDCN6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbZDCN6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932111AbZDCN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:58:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765998AbZDCN6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:58:05 -0400
Date: Fri, 3 Apr 2009 15:57:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>, "Alan D. Brunelle" <alan.brunelle@hp.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: fix pdu_len when tracing packet command
	requests
Message-ID: <20090403135736.GC8875@elte.hu>
References: <49D42036.5010102@cn.fujitsu.com> <49D4507E.2060602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4507E.2060602@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
> large command support"), struct request->cmd has been changed from
> unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.
> 
> v1 -> v2:
> - make sure rq->cmd_len is always intialized, and then we can use
>   rq->cmd_len instead of BLK_MAX_CDB.

Thanks. I've added a 'v2-by: FUJITA Tomonori' and the Ack from 
Fujita-san as well to document the precise lineage of the fix.

Note: there's an important robustness and security issue to check 
before we can apply this fully.

variable-size records are always tricky and need a full audit of the 
software stack.

rq->cmd_len comes from sg device ioctls, and the sg command header 
can have an arbitrary value for sg_io_v4::header_len. The only limit 
in the block layer at the moment is that it must fit into a single 
kmalloc() - and that - in theory - can be very large.

So:

1) the ftrace ring-buffer code has to be checked (does it work well 
   with larger than 4K records). Steve .. how well will it work?

2) and the user-space blktrace+blkparse code has to be checked for 
   overflows and static sizes as well. Jens, Alan?

   I had a quick look at the user-space code. It seems mostly fine. 
   There appears to be one minor bug in blkrawverify.c:

                        pdu_buf = malloc(bit->pdu_len);
                        n = fread(pdu_buf, bit->pdu_len, 1, ifp);
                        if (n == 0) {
                                INC_BAD("bad pdu");

   malloc() can return NULL under memory pressure - shouldnt we
   check it for NULL instead of passing it to fread()?

   Oh, there does seem to be a buffer-overflow problem in 
   blkparse_fmt.c:

   static char *dump_pdu(unsigned char *pdu_buf, int pdu_len)
   {
        static char p[4096];
        int i, len;

        if (!pdu_buf || !pdu_len)
                return NULL;

        for (len = 0, i = 0; i < pdu_len; i++) {
                if (i)
                        len += sprintf(p + len, " ");

                len += sprintf(p + len, "%02x", pdu_buf[i]);
   [...]

   that p[4096] is a buffer-overflow if the pdu_len goes over 4096. 
   This is a small potential security issue if we apply this patch. 
   Should be changed to malloc(pdu_len) instead.

   ( Relatively small because SG_IO ioctls are not normally allowed
     to unprivileged users so generating intentionally large packets 
     to exploit a sysadmin running blkparse seems like a stretch of 
     a threat model. )

Anyway, this needs to be fixed and fully audited, as we can 
literally get a 128K packet traced here - even though the hardware 
itself wont be able to do much with it - most packet commands are in 
the few bytes range up to 16 bytes typically - but the blktrace 
layer will forward it.

Please double-check that blkparse is not surprised by the 
(now-again-) variable length packet command output either.

>From v2.6.26 on we only emitted the first 4/8 bytes depending on 
bitness.

Thanks,

	Ingo
