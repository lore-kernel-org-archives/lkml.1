Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZDBEHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZDBEHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZDBEHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:07:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZDBEHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:07:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ohCmhkFz6LGLRLdLJpJuBSlSSiwLR+BZLsXE8Hjd/vWknFd/NXozLmU1ev9OYfaU2
	Cv1qQ2rFc5OJACnXOmeTw==
MIME-Version: 1.0
In-Reply-To: <1236823015-4183-3-git-send-email-vgoyal@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> 
	<1236823015-4183-3-git-send-email-vgoyal@redhat.com>
Date: Wed, 1 Apr 2009 21:06:40 -0700
Message-ID: <af41c7c40904012106h41d3cb50i2eeab2a02277a4c9@mail.gmail.com>
Subject: Re: [PATCH 02/10] Common flat fair queuing code in elevaotor layer
From: Divyesh Shah <dpshah@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 6:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> +/*
> + * elv_exit_fq_data is called before we call elevator_exit_fn. Before
> + * we ask elevator to cleanup its queues, we do the cleanup here so
> + * that all the group and idle tree references to ioq are dropped. Later
> + * during elevator cleanup, ioc reference will be dropped which will lead
> + * to removal of ioscheduler queue as well as associated ioq object.
> + */
> +void elv_exit_fq_data(struct elevator_queue *e)
> +{
> +       struct elv_fq_data *efqd = &e->efqd;
> +       struct request_queue *q = efqd->queue;
> +
> +       if (!elv_iosched_fair_queuing_enabled(e))
> +               return;
> +
> +       elv_shutdown_timer_wq(e);
> +
> +       spin_lock_irq(q->queue_lock);
> +       /* This should drop all the idle tree references of ioq */
> +       elv_free_idle_ioq_list(e);
> +       spin_unlock_irq(q->queue_lock);
> +
> +       elv_shutdown_timer_wq(e);
> +
> +       BUG_ON(timer_pending(&efqd->idle_slice_timer));
> +       io_free_root_group(e);
> +}
>

Hi Vivek,
        When cleaning up the elv_fq_data and ioqs for the iogs
associated with a device on elv_exit(), I don't see any iogs except
the root group being freed. In io_disconnect_groups() you remove the
ioqs from each of the iog and move them to the root iog and then
delete the root iog. Am I missing something here or are there leftover
iogs at elv_exit?

-Divyesh
