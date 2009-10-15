Return-Path: <linux-kernel-owner+w=401wt.eu-S935172AbZJOR0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172AbZJOR0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbZJOR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:26:08 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:50398 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZJOR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:26:07 -0400
Message-ID: <4AD75AE3.80803@agilent.com>
Date: Thu, 15 Oct 2009 10:24:51 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Arithmetic overflow in may_expand_vm()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 17:24:53.0787 (UTC) FILETIME=[689E36B0:01CA4DBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code currently reads:

> int may_expand_vm(struct mm_struct *mm, unsigned long npages)
> {
>         unsigned long cur = mm->total_vm;       /* pages */
>         unsigned long lim;
> 
>         lim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> 
>         if (cur + npages > lim)
>                 return 0;
>         return 1;
> }

If npages is stupendously large, the failure predicate may
return a false negative due to (cur + npages) overflowing and
wrapping.

I think it's more robustly written as:

          if (npages > lim - cur)
                  return 0;



