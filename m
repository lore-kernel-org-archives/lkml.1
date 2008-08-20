Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYHTIXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYHTIXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYHTIWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:22:51 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:2572 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYHTIWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wwMRAZJ89Ffoq2zzWqqYbgSjsuJaVORn4ie0zl/edk1TZj07ay3/6K6z1B1IJ2vQlC
         L8SFRt3Luc6zhjWpeLFPrNPOJCMTwF5mECE22mVqzuQkjXI1u0qQyKSX0M0dm3bSscRj
         yxfiFM6KEwzW8CuDLfmYHTA9jRxSlqUnyt+qU=
Message-ID: <84144f020808200122w3e5adc4ci4eec761a1e570bda@mail.gmail.com>
Date: Wed, 20 Aug 2008 11:22:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Cc: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080820004326.519405a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808200245.AA00210@capsicum.lab.ntt.co.jp>
	 <20080820004326.519405a2.akpm@linux-foundation.org>
X-Google-Sender-Auth: b66cb1c09f796bdc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:43 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> It is not yet divided into pieces (sorry).  Unlike original code
>> available at [4], many code lines to support past kernel versions and
>> peculiar debug code are removed in this patch.
>
> Yes, please do that splitup and let's get down to reviewing it.

Hmm, this looks bit scary:

> +/*
> + * Low-level nilfs pages, page functions
> + * Reviews should be made to adapt these to the common pagemap and buffer code.
> + */
> +static struct nilfs_pages {
> +       spinlock_t              lru_lock;
> +       struct list_head        active;
> +       struct list_head        inactive;
> +       unsigned long           nr_active;
> +       unsigned long           nr_inactive;
> +       struct rw_semaphore     shrink_sem;
> +} nilfs_pages;
> +
> +/*
> + * XXX per-cpu pagevecs may be able to reduce the overhead of list handlings
> + *
> + * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_active) = { 0, };
> + * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_inactive) = { 0, };
> + */
> +
> +void nilfs_pages_init(void)
> +{
> +       INIT_LIST_HEAD(&nilfs_pages.active);
> +       INIT_LIST_HEAD(&nilfs_pages.inactive);
> +       spin_lock_init(&nilfs_pages.lru_lock);
> +       init_rwsem(&nilfs_pages.shrink_sem);
> +       nilfs_pages.nr_active = 0;
> +       nilfs_pages.nr_inactive = 0;
> +}

(a) why does NILFS need this and (b) why aren't these patches against
generic mm/*.c?

                                    Pekka
