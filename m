Return-Path: <linux-kernel-owner+w=401wt.eu-S1765182AbXEVCPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765182AbXEVCPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbXEVCPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:15:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbXEVCO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:14:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=N9Z8ft1WaEGfhNI1S4VSNHq91O5PD/fQ2lQ/2ZMJAyIxtQGK3wz929LrPB55yoRWL
	HZSqreptKOrTcZGUSQDfA==
Message-ID: <b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com>
Date: Mon, 21 May 2007 19:14:50 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20070522014822.GF4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
	 <20070522001851.GE4095@ftp.linux.org.uk>
	 <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
	 <20070522014822.GF4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> No, it doesn't.  Really.  It's easy to split; untested incremental to your
> patch follows:
>
>         for (i = 0; i < nr; i++) {
> -               if (!loop_init_one(i))
> -                       goto err;
> +               lo = loop_alloc(i);
> +               if (!lo)
> +                       goto Enomem;
> +               list_add_tail(&lo->lo_list, &loop_devices);
>         }

ah, yes, use the loop_device list_head to link all the pending devices.


> +       /* point of no return */
> +
> +       list_for_each_entry(lo, &loop_devices, lo_list)
> +               add_disk(lo->lo_disk);
> +
> +       blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> +                                 THIS_MODULE, loop_probe, NULL, NULL);
> +
>         printk(KERN_INFO "loop: module loaded\n");
>         return 0;
> -err:
> -       loop_exit();
> +
> +Enomem:
>         printk(KERN_INFO "loop: out of memory\n");
> +
> +       while(!list_empty(&loop_devices)) {
> +               lo = list_entry(loop_devices.next, struct loop_device, lo_list);
> +               loop_del_one(lo);
> +       }
> +
> +       unregister_blkdev(LOOP_MAJOR, "loop");
>         return -ENOMEM;
>  }

I suppose the loop_del_one call in Enomem label needs to be split up
too since in the error path, it hasn't done add_disk() yet?
