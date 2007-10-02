Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXJBHhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXJBHhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXJBHgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:36:52 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:60350 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753967AbXJBHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:36:51 -0400
Message-ID: <4701F55D.7040908@sw.ru>
Date: Tue, 02 Oct 2007 11:38:05 +0400
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: kernel coder <lhrkernelcoder@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: cann't dump info to user file from kernel
References: <f69849430710020028l64379652q77e3c9428ef4de79@mail.gmail.com>
In-Reply-To: <f69849430710020028l64379652q77e3c9428ef4de79@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will never work, as you call blocking (non-atomic) functions from
atomic context.

kernel coder wrote:
> hi,
>           I'm trying to dump some information from dev.c to user space
> file.Following is the code which i'm using to write to user spcae
> file.I'm using 2.6.22.x86_64 kernel.
> 
> 
> #define _write(f, buf, sz) (f->f_op->write(f, buf, sz, &f->f_pos))
> #define WRITABLE(f) (f->f_op && f->f_op->write)
> 
> int write_to_file(char *logfile, char *buf,int size)
> {
>         int ret = 0;
>         struct file *f=NULL;
>         mm_segment_t old_fs = get_fs();
>         set_fs(get_ds());
>          f = filp_open(logfile, O_CREAT|O_APPEND,00600);
>         if(IS_ERR(f)){
>                 DPRINT("Error %ld openeing %s\n",-PTR_ERR(f), logfile);
>                 ret = -1;
>         } else {
>                 if (WRITABLE(f))
>                         _write(f, buf, size);
>                 else {
>                         DPRINT("%s does not have a write method\n",
>                                 logfile);
>                         ret = -1;
>                 }
> 
>                 if ((ret = filp_close(f,NULL)))
>                         DPRINT("Error %d closing %s\n", -ret, logfile);
>         }
>         END_KMEM;
> 
>         return ret;
> }
> 
> 
> I'm calling this function from netif_recieve_skb in dev.c
> 
> int netif_recieve_skb(struct sk_buff *skb){
> 
> ---------------------
> write_to_file("/root/kernel_log","hello_world",12);
> ----------------------
> 
> }
> 
> But whenever this function is called ,the kernel simply halts.Please
> tell me what might be the reason.
> 
> I just want to dump some information to user spcace file from dev.c
> .Is there some better way to do it.
use something like ipt_LOG or packet sockets
