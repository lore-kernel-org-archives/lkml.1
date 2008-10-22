Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYJVI1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYJVI1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYJVI1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:27:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36860 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbYJVI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:27:29 -0400
Date: Wed, 22 Oct 2008 09:27:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel
 thread
Message-ID: <20081022092736.2a0795d1@lxorguk.ukuu.org.uk>
In-Reply-To: <6775.1224630654@jrobl>
References: <7123.1224602071@jrobl>
	<20081021164619.341f01d9@lxorguk.ukuu.org.uk>
	<6775.1224630654@jrobl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In your first option, write() to the exported tmpfs will produce the
> warning on nfs server even if much memory is left. I don't think it is a

No - the shmem routine would use vm_enough_memory_fs which wouldn't care
if current->mm is NULL, but the others would check.

> good idea.
> I'd suggest to make __vm_enough_memory() would skip the 3% adjustment
> only.
> 
> --- /src/linux-2.6/linux-2.6.27/mm/mmap.c	2008-10-10 07:13:53.000000000 +0900
> +++ /tmp/mmap.c	2008-10-22 08:07:09.000000000 +0900
> @@ -173,9 +173,10 @@
>  		allowed -= allowed / 32;
>  	allowed += total_swap_pages;
>  
> -	/* Don't let a single process grow too big:
> +	/* Don't let a single user process grow too big:
>  	   leave 3% of the size of this process for other processes */
> -	allowed -= mm->total_vm / 32;
> +	if (mm)
> +		allowed -= mm->total_vm / 32;

Doing this means we lose the ability to trap incorrect calls to
vm_enough_memory.

Alan
