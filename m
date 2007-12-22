Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbXLVK1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbXLVK1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXLVK1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:27:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbXLVK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:27:08 -0500
Date: Sat, 22 Dec 2007 02:27:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ipc: Convert handmade 'max' to max().
Message-Id: <20071222022701.1ddd2ae2.akpm@linux-foundation.org>
In-Reply-To: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
References: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 03:35:55 +0100 (MET) Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Convert handmade 'max' to max().
> 
> ...
>
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -473,7 +473,7 @@ asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
>  		up_read(&msg_ids(ns).rw_mutex);
>  		if (copy_to_user(buf, &msginfo, sizeof(struct msginfo)))
>  			return -EFAULT;
> -		return (max_id < 0) ? 0 : max_id;
> +		return max(max_id, 0);

I don't think I like that much.

I tend to think of max() as being an arithmetic sort of thing: pick the
largest of two scalars.

But the code which you're changing is a _logical_ operation.  It says "if
ipc_get_maxid() returned an error, then return zero.  Otherwise return
whatever ipc_get_maxid() returned".

Yes, max() will do the right thing here, but I think it's a bit of weird
trick?


I mean, if ipc_get_maxid() were a better function, it would return a -ve
errno when something failed rather than the present dopey hard-coded -1. 
In which case the code would read 

	return IS_ERR_VALUE(max_id) ? 0 : max_id;

in which case, converting it to max() would be even less appropriate.  If
you see what I mean...

