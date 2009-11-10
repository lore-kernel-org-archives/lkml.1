Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZKJRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZKJRsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZKJRso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:48:44 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45841 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbZKJRso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HqLRDZcbrwoaogWt35oTYeIsvHBDYUQaIcw0UCgJ0VEyojrw2Zl4WU0tOpmauUtkdq
         XLt/GrpAiif8W1253CnxTnXiEvT1pC8Vg0fBbwJHAIRLzdBWSYCgxRIrccqxSIjEKI3c
         pqaaC1IqU2R32NEmrHvxzhvZfuSWtIxJIt4YI=
MIME-Version: 1.0
In-Reply-To: <20091110170453.GA11771@redhat.com>
References: <20091110170453.GA11771@redhat.com>
Date: Wed, 11 Nov 2009 02:48:49 +0900
X-Google-Sender-Auth: 0f95517989e02b51
Message-ID: <2f11576a0911100948o79970e44t197cd2978428de1a@mail.gmail.com>
Subject: Re: + prctl-add-pr_set_proctitle_area-option.patch added to -mm tree
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>, Timo Sirainen <tss@iki.fi>,
       Ulrich Drepper <drepper@redhat.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/11 Oleg Nesterov <oleg@redhat.com>:
> @@ -1424,6 +1424,28 @@ static void k_getrusage(struct task_stru
>                        } while (t != p);
>                        break;
>
> +               case PR_SET_PROCTITLE_AREA: {
> +                       struct mm_struct *mm = current->mm;
> +                       unsigned long addr = arg2;
> +                       unsigned long len = arg3;
> +                       unsigned long end = arg2 + arg3;
> +
> +                       if (len > PAGE_SIZE)
> +                               return -EINVAL;
> +
> +                       if (addr >= end)
> +                               return -EINVAL;
> +
> +                       if (!access_ok(VERIFY_READ, addr, len))
> +                               return -EFAULT;
> +
> +                       mutex_lock(&mm->arg_lock);
> +                       mm->arg_start = addr;
> +                       mm->arg_end = end;
> +                       mutex_unlock(&mm->arg_lock);
>
> This looks like the merging error, I guess this code should go into
> sys_prct(), not k_getrusage().
>
>
> The patch adds mm_struct->arg_lock mutex. Can't we reuse mm->mmap_sem?
> A bit ugly to have mm->arg_lock just to synchronize sys_prctl() and
> proc_pid_cmdline(), imho.
>
> Yes, we can't do access_process_vm() under ->mmap_sem, but we can add
> the new helper, say, access_process_vm_locked(tsk, mm, ...) which does
> the actual work. Then proc_pid_cmdline() can take mmap_sem for reading,
> read arg_start/arg_end and call access_process_vm_locked().
>
> No?

There is unwritten reason. I hope to add /proc/[pid]/cmdline cache. It
help to avoid
ps getting stuck by mmap_sem.
But, I can accept your proposal on 2.6.32 timeframe. so, I'll make
this patch again.

Andrew, can you please drop this patch at once?
