Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbXCTPdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbXCTPdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933955AbXCTPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:33:22 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46529 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959AbXCTPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:33:21 -0400
Message-ID: <45FFFE72.6000300@bull.net>
Date: Tue, 20 Mar 2007 16:32:02 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH 2.6.21-rc3-mm2 3/4] futex_requeue_pi optimization
References: <20070313095203.154246923@bull.net>	 <20070313095548.003786249@bull.net> <1174040046.7124.27.camel@twins>
In-Reply-To: <1174040046.7124.27.camel@twins>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/03/2007 16:35:17,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/03/2007 16:35:19,
	Serialize complete at 20/03/2007 16:35:19
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
>> +static void *get_futex_address(union futex_key *key)
>> +{
>> +	void *uaddr;
>> +
>> +	if (key->both.offset & 1) {
>> +		/* shared mapping */
>> +		uaddr = (void*)((key->shared.pgoff << PAGE_SHIFT)
>> +				+ key->shared.offset - 1);
>> +	} else {
>> +		/* private mapping */
>> +		uaddr = (void*)(key->private.address + key->private.offset);
>> +	}
>> +
>> +	return uaddr;
>> +}
> 
> This will not work for nonlinear vmas, granted, not a lot of ppl stick
> futexes in nonlinear vmas, but the futex_key stuff handles it, this
> doesn't.

Indeed ! Thanks for pointing me to this.

Since I'm not familiar with vmm, does this code look more correct to you ?

static void *get_futex_address(union futex_key *key)
{
	void *uaddr;
	struct vm_area_struct *vma = current->mm->mmap;

	if (key->both.offset & 1) {
		/* shared mapping */
		struct file * vmf;

		do {
			if ((vmf = vma->vm_file)
			    && (key->shared.inode == vmf->f_dentry->d_inode))
				break;
			vma = vma->vm_next;
		} while (vma);

		if (likely(!(vma->vm_flags & VM_NONLINEAR)))
			uaddr = (void*)((key->shared.pgoff << PAGE_SHIFT)
					+ key->shared.offset - 1);
		else
			uaddr = (void*) vma->vm_start
				+ ((key->shared.pgoff - vma->vm_pgoff)
				   << PAGE_SHIFT)
				+ key->shared.offset - 1;
	} else {
		/* private mapping */
		uaddr = (void*)(key->private.address + key->private.offset);
	}

	return uaddr;
}

Or is there a more direct way to retrieve the vma corresponding to the given inode ?

Thanks,

-- 
Pierre
