Return-Path: <linux-kernel-owner+w=401wt.eu-S1767582AbXCIXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767582AbXCIXMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767627AbXCIXMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:12:23 -0500
Received: from amsfep20-int.chello.nl ([62.179.120.15]:36946 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767582AbXCIXMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:12:21 -0500
Subject: Re: [PATCH 3/7] revoke: core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091014450.32320@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 13:30:13 +0100
Message-Id: <1173443414.4429.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 10:15 +0200, Pekka J Enberg wrote:

> +static int revoke_vma(struct vm_area_struct *vma, struct zap_details *details)
> +{
> +	unsigned long restart_addr, start_addr, end_addr;
> +	int need_break;
> +
> +	start_addr = vma->vm_start;
> +	end_addr = vma->vm_end;
> +
> +	/*
> + 	 * Not holding ->mmap_sem here.
> +	 */
> +	vma->vm_flags |= VM_REVOKED;
> +	smp_mb();

Hmm, i_mmap_lock pins the vma and excludes modifications, but doesn't
exclude concurrent faults.

I guess its save.

> +  again:
> +	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
> +				      details);
> +
> +	need_break = need_resched() || need_lockbreak(details->i_mmap_lock);
> +	if (need_break)
> +		goto out_need_break;
> +
> +	if (restart_addr < end_addr) {
> +		start_addr = restart_addr;
> +		goto again;
> +	}
> +	return 0;
> +
> +  out_need_break:
> +	spin_unlock(details->i_mmap_lock);
> +	cond_resched();
> +	spin_lock(details->i_mmap_lock);
> +	return -EINTR;

I'm not sure this scheme works, given a sufficiently loaded machine,
this might never complete.

> +}
> +
> +static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
> +{
> +	struct vm_area_struct *vma;
> +	struct prio_tree_iter iter;
> +	struct zap_details details;
> +	int err = 0;
> +
> +	details.i_mmap_lock = &mapping->i_mmap_lock;
> +
> +	spin_lock(&mapping->i_mmap_lock);
> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
> +		if (vma->vm_flags & VM_SHARED && vma->vm_file != to_exclude) {

I'm never sure of operator precedence and prefer:

 (vma->vm_flags & VM_SHARED) && ...

which leaves no room for error.

> +			err = revoke_vma(vma, &details);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +
> +	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
> +		if (vma->vm_flags & VM_SHARED && vma->vm_file != to_exclude) {

Idem.

> +			err = revoke_vma(vma, &details);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +  out:
> +	spin_unlock(&mapping->i_mmap_lock);
> +	return err;
> +}


