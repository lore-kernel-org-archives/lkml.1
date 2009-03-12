Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZCLLin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZCLLin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZCLLie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:38:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZCLLid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BtQGnlsa8NPSO//TPzhvKnjNCpFTd7u6uMjWmM9Ywj04tEAoL28Jvgkf+Ln6p6Khdg
         dM0d3fQSfKU5T9P9tRaAkXXcE4oqUGncnpDUcGrYzhF2r8Lb3njScd/MY65eehEWw6Yk
         xLEG+J173Et0HXrXut2rdtjUotPlrSWmsBS5o=
Date: Thu, 12 Mar 2009 14:45:33 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
Message-ID: <20090312114533.GA2407@x200.localdomain>
References: <20090312113308.6fe18a93@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312113308.6fe18a93@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:33:08AM +0100, Martin Schwidefsky wrote:
> --- linux-2.6/fs/proc/task_mmu.c
> +++ linux-2.6-patched/fs/proc/task_mmu.c
> @@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
>  	 * user buffer is tracked in "pm", and the walk
>  	 * will stop when we hit the end of the buffer.
>  	 */
> +	down_read(&mm->mmap_sem);
>  	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
> +	up_read(&mm->mmap_sem);

This will introduce "put_user under mmap_sem" which is deadlockable.
