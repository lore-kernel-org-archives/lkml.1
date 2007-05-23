Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbXEWDVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbXEWDVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXEWDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:21:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168AbXEWDVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:21:43 -0400
Date: Tue, 22 May 2007 20:21:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Steven French" <sfrench@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Message-Id: <20070522202133.552d1a94.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705221959i7b01deb7vdd641ef0ed31e63e@mail.gmail.com>
References: <a8e1da0705221750y6f4fb251m53f3efab1f017f4@mail.gmail.com>
	<20070522192231.6d1a94df.akpm@linux-foundation.org>
	<a8e1da0705221959i7b01deb7vdd641ef0ed31e63e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 02:59:07 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Hi,
> maybe we can add if sentence before kthread_stop.
> 
> diff -ur linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
> --- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
> +++ linux.new/fs/cifs/connect.c 2007-05-23 10:58:39.000000000 +0000
> @@ -2070,7 +2070,8 @@
>                         spin_unlock(&GlobalMid_Lock);
>                         if (srvTcp->tsk) {
>                                 send_sig(SIGKILL,srvTcp->tsk,1);
> -                               kthread_stop(srvTcp->tsk);
> +                               if(srvTcp->tsk)
> +                                       kthread_stop(srvTcp->tsk);
>                         }
>                 }

Yeah, that's racy: once we've sent the signal, the kernel thread can write
NULL to srvTcp->tsk at any time.

