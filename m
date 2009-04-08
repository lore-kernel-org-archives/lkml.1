Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbZDHBcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbZDHBcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZDHBb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:31:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZDHBb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:31:58 -0400
Message-ID: <49DBFEB0.9080308@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 09:32:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@redhat.com
CC: hpa@zytor.com, acme@redhat.com, linux-kernel@vger.kernel.org,
       alan.brunelle@hp.com, jens.axboe@oracle.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/blktrace-v2] blktrace: fix a bug in blk_msg_write()
References: <49D5BB56.7000807@cn.fujitsu.com> <tip-48cefde3c17bbf37fee99e2889bcc718e5805dfa@git.kernel.org>
In-Reply-To: <tip-48cefde3c17bbf37fee99e2889bcc718e5805dfa@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Though Carl <chlunde@ping.uio.no>'s patch has been applied,
(a4b3ada83d06554d307dd54abdc62b2e5648264a), this patch hasn't
been dropped, thus the code in -tip looks like:

static ssize_t blk_msg_write(...)
{
	...
        if (copy_from_user(msg, buffer, count)) {
                kfree(msg);
                return -EFAULT;
        }
        msg[count] = '\0';	<---

        msg[count] = '\0';	<---
	...
}


Li Zefan wrote:
> Commit-ID:  48cefde3c17bbf37fee99e2889bcc718e5805dfa
> Gitweb:     http://git.kernel.org/tip/48cefde3c17bbf37fee99e2889bcc718e5805dfa
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Fri, 3 Apr 2009 15:31:34 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 3 Apr 2009 13:15:53 +0200
> 
> blktrace: fix a bug in blk_msg_write()
> 
> Impact: fix corrupted blkparse output
> 
> This is another long-standing blktrace bug:
> 
>  (console 1)
>  # echo -n 'a' > /sys/kernel/debug/block/sda/msg
>  (console 2)
>  # blktrace -d /dev/sda -a pc -o - | blkparse -i -
>   8,0    0        0     0.000000000     0  m   N a������@��
> 
> We should terminate the msg buffer with '\0'.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: "Alan D. Brunelle" <alan.brunelle@hp.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> LKML-Reference: <49D5BB56.7000807@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/blktrace.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 947c5b3..b7fa92c 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -327,10 +327,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
>  	char *msg;
>  	struct blk_trace *bt;
>  
> -	if (count > BLK_TN_MAX_MSG)
> +	if (count >= BLK_TN_MAX_MSG)
>  		return -EINVAL;
>  
> -	msg = kmalloc(count, GFP_KERNEL);
> +	msg = kmalloc(count + 1, GFP_KERNEL);
>  	if (msg == NULL)
>  		return -ENOMEM;
>  
> @@ -338,6 +338,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
>  		kfree(msg);
>  		return -EFAULT;
>  	}
> +	msg[count] = '\0';
>  
>  	bt = filp->private_data;
>  	__trace_note_message(bt, "%s", msg);
> 
> 

