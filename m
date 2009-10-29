Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZJ2ULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZJ2ULI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZJ2ULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:11:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51990 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbZJ2ULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:11:05 -0400
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
From: Mingming <cmm@us.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, Parag Warudkar <parag.lkml@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
In-Reply-To: <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 13:10:38 -0700
Message-Id: <1256847038.4341.0.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:45 +0530, Aneesh Kumar K.V wrote:
> Can you try this patch ?
> 
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Oct 27 15:36:38 2009 +0530
> 
>     ext4: discard preallocation during truncate
>     
>     We need to make sure when we drop and reacquire the inode's
>     i_data_sem we discard the inode preallocation. Otherwise we
>     could have blocks marked as free in bitmap but still belonging
>     to prealloc space.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 

Make sense, reviewed-by: Mingming Cao <cmm@us.ibm.com>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..a1ef1c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +	/*
> +	 * We have dropped i_data_sem. So somebody else could have done
> +	 * block allocation. So discard the prealloc space created as a
> +	 * part of block allocation
> +	 */
> +	ext4_discard_preallocations(inode);
> 
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


