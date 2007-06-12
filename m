Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXFLEan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXFLEan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXFLEaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:30:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbXFLEae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:30:34 -0400
Date: Mon, 11 Jun 2007 21:30:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Litke <agl@us.ibm.com>
Cc: dean gaudet <dean@arctic.org>, William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
Message-Id: <20070611213020.b3d91757.akpm@linux-foundation.org>
In-Reply-To: <1181597696.22671.2.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
	<20070516061259.GZ19966@holomorphy.com>
	<Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
	<1181597696.22671.2.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 16:34:54 -0500 Adam Litke <agl@us.ibm.com> wrote:

> Here's another breakage as a result of shared memory stacked files :(
> 
> The NUMA policy for a VMA is determined by checking the following (in the order
> given):
> 
> 1) vma->vm_ops->get_policy() (if defined)
> 2) vma->vm_policy (if defined)
> 3) task->mempolicy (if defined)
> 4) Fall back to default_policy
> 
> By switching to stacked files for shared memory, get_policy() is now always set
> to shm_get_policy which is a wrapper function.  This causes us to stop at step
> 1, which yields NULL for hugetlb instead of task->mempolicy which was the
> previous (and correct) result.
> 
> This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for the
> wrapped vm_ops.  Andi and Christoph, does this look right to you?
> 

Can we just double-check the refcounting please?

> index 4fefbad..8d2672d 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
>  
>  	if (sfd->vm_ops->get_policy)
>  		pol = sfd->vm_ops->get_policy(vma, addr);

afacit this takes a ref on the underlying policy

> -	else
> +	else if (vma->vm_policy)
>  		pol = vma->vm_policy;
> +	else
> +		pol = current->mempolicy;

but these two do not.

>  	return pol;
>  }
>  #endif

Is is all correct?
