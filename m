Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZDGCJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZDGCJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZDGCJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:09:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZDGCJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:09:30 -0400
Message-ID: <49DAB5F4.8000500@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 10:09:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Alan D. Brunelle" <alan.brunelle@hp.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: fix pdu_len when tracing packet command	requests
References: <49D42036.5010102@cn.fujitsu.com> <49D4507E.2060602@cn.fujitsu.com> <20090403135736.GC8875@elte.hu>
In-Reply-To: <20090403135736.GC8875@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
>> large command support"), struct request->cmd has been changed from
>> unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.
>>
>> v1 -> v2:
>> - make sure rq->cmd_len is always intialized, and then we can use
>>   rq->cmd_len instead of BLK_MAX_CDB.
> 
> Thanks. I've added a 'v2-by: FUJITA Tomonori' and the Ack from 
> Fujita-san as well to document the precise lineage of the fix.
> 
> Note: there's an important robustness and security issue to check 
> before we can apply this fully.
> 
> variable-size records are always tricky and need a full audit of the 
> software stack.
> 
> rq->cmd_len comes from sg device ioctls, and the sg command header 
> can have an arbitrary value for sg_io_v4::header_len. The only limit 
> in the block layer at the moment is that it must fit into a single 
> kmalloc() - and that - in theory - can be very large.
> 
> So:
> 
> 1) the ftrace ring-buffer code has to be checked (does it work well 
>    with larger than 4K records). Steve .. how well will it work?
> 

There is a check:

ring_buffer_lock_reserve(length)
{
	...
	length = rb_calculate_event_length(length);
	if (length > BUF_PAGE_SIZE)
		goto out;
	...
}

so if the record is around PAGE_SIZE, the event will not be recorded.

> 2) and the user-space blktrace+blkparse code has to be checked for 
>    overflows and static sizes as well. Jens, Alan?
> 
>    I had a quick look at the user-space code. It seems mostly fine. 
>    There appears to be one minor bug in blkrawverify.c:
> 
>                         pdu_buf = malloc(bit->pdu_len);
>                         n = fread(pdu_buf, bit->pdu_len, 1, ifp);
>                         if (n == 0) {
>                                 INC_BAD("bad pdu");
> 
>    malloc() can return NULL under memory pressure - shouldnt we
>    check it for NULL instead of passing it to fread()?
> 
>    Oh, there does seem to be a buffer-overflow problem in 
>    blkparse_fmt.c:
> 

and this can be fixed easily.

>    static char *dump_pdu(unsigned char *pdu_buf, int pdu_len)
>    {
>         static char p[4096];
>         int i, len;
> 
>         if (!pdu_buf || !pdu_len)
>                 return NULL;
> 
>         for (len = 0, i = 0; i < pdu_len; i++) {
>                 if (i)
>                         len += sprintf(p + len, " ");
> 
>                 len += sprintf(p + len, "%02x", pdu_buf[i]);
>    [...]
> 
>    that p[4096] is a buffer-overflow if the pdu_len goes over 4096. 
>    This is a small potential security issue if we apply this patch. 
>    Should be changed to malloc(pdu_len) instead.
> 
>    ( Relatively small because SG_IO ioctls are not normally allowed
>      to unprivileged users so generating intentionally large packets 
>      to exploit a sysadmin running blkparse seems like a stretch of 
>      a threat model. )
> 
