Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYJULMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYJULMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYJULMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:12:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:57595 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYJULMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:12:35 -0400
Message-ID: <48FDB8AC.9020707@windriver.com>
Date: Tue, 21 Oct 2008 19:10:36 +0800
From: Chen Zumeng <zumeng.chen@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0: Introduction
References: <20081017.160950.71109894.ryov@valinux.co.jp>
In-Reply-To: <20081017.160950.71109894.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2008 11:11:54.0132 (UTC) FILETIME=[D3019D40:01C9336D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ryo Tsuruta

I applied your patches(both) into the latest kernel(27), and dm-ioband
looks work well(other than schedule_timeout in alloc_ioband_device);
But I think you are the author of bio_tracking, so it is high
appreciated if you can give your comments and advices for potential
difference between 27-rc5-mm1 and 2.6.27 to me.

And our test team want to test bio_tracking as your benchmark reports,
so would you please send me your test codes? Thanks in advance.

Regards,
Zumeng

P.S. The following are my changes to avoid schedule_timeout:


diff --git a/drivers/md/dm-ioband-ctl.c b/drivers/md/dm-ioband-ctl.c
index a792620..643ca4e 100644
--- a/drivers/md/dm-ioband-ctl.c
+++ b/drivers/md/dm-ioband-ctl.c
@@ -100,6 +100,7 @@ static struct ioband_device 
*alloc_ioband_device(char *name,
                         return dp;
                 }
         }
+       spin_unlock_irqrestore(&ioband_devicelist_lock, flags);

         /*
          * Prepare its own workqueue as generic_make_request() may
@@ -133,9 +134,11 @@ static struct ioband_device 
*alloc_ioband_device(char *name,
         init_waitqueue_head(&new->g_waitq);
         init_waitqueue_head(&new->g_waitq_suspend);
         init_waitqueue_head(&new->g_waitq_flush);
-       list_add_tail(&new->g_list, &ioband_device_list);

+       spin_lock_irqsave(&ioband_devicelist_lock, flags);
+       list_add_tail(&new->g_list, &ioband_device_list);
         spin_unlock_irqrestore(&ioband_devicelist_lock, flags);
+
         return new;
  }
---

Ryo Tsuruta wrote:
> Hi Alasdair and all,
> 
> This is the dm-ioband version 1.8.0 release.
> 
> Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
> driver, which gives specified bandwidth to each job running on the same
> physical device.
> 
> This release is a minor bug fix and confirmed running on the latest
> stable kernel 2.6.27.1.
> 
> - Can be applied to the kernel 2.6.27.1 and 2.6.27-rc5-mm1.
> - Changes from 1.7.0 (posted on Oct 3, 2008):
>   - Fix a minor bug in io_limit setting that causes dm-ioband to stop
>     issuing I/O requests when a large value is set to io_limit.
> 
> Alasdair, could you please review this patch and give me any comments?
> 
> Thanks,
> Ryo Tsuruta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

