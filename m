Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbZDJJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbZDJJge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbZDJJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:36:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbZDJJgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:36:24 -0400
Date: Fri, 10 Apr 2009 11:35:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090410093520.GH17962@elte.hu>
References: <20090410023539.GK27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023539.GK27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> +int cr_restore_file(struct cr_context *ctx, loff_t pos)
> +{

I tried to review this code, but it's almost unreadable to me, due 
to basic code structure mistakes like:

> +	struct cr_image_file *i, *tmp;
> +	struct file *file;
> +	struct cr_object *obj;
> +	char *cr_name;
> +	int rv;
> +
> +	i = kzalloc(sizeof(*i), GFP_KERNEL);
> +	if (!i)
> +		return -ENOMEM;
> +	rv = cr_pread(ctx, i, sizeof(*i), pos);
> +	if (rv < 0) {
> +		kfree(i);
> +		return rv;
> +	}
> +	if (i->cr_hdr.cr_type != CR_OBJ_FILE) {
> +		kfree(i);
> +		return -EINVAL;
> +	}
> +	/* Image of struct file is variable-sized. */
> +	tmp = i;
> +	i = krealloc(i, i->cr_hdr.cr_len + 1, GFP_KERNEL);
> +	if (!i) {
> +		kfree(tmp);
> +		return -ENOMEM;
> +	}
> +	cr_name = (char *)(i + 1);
> +	rv = cr_pread(ctx, cr_name, i->cr_name_len, pos + sizeof(*i));
> +	if (rv < 0) {
> +		kfree(i);
> +		return -ENOMEM;
> +	}
> +	cr_name[i->cr_name_len] = '\0';
> +
> +	file = filp_open(cr_name, i->cr_f_flags, 0);
> +	if (IS_ERR(file)) {
> +		kfree(i);
> +		return PTR_ERR(file);
> +	}
> +	if (file->f_dentry->d_inode->i_mode != i->cr_i_mode) {
> +		fput(file);
> +		kfree(i);
> +		return -EINVAL;
> +	}
> +	if (vfs_llseek(file, i->cr_f_pos, SEEK_SET) != i->cr_f_pos) {
> +		fput(file);
> +		kfree(i);
> +		return -EINVAL;
> +	}
> +
> +	obj = cr_object_create(file);
> +	if (!obj) {
> +		fput(file);
> +		kfree(i);
> +		return -ENOMEM;
> +	}

This contains 7 kfree()s of the same thing (!), 3 fput()s of the 
same thing, replicated all over the place obscuring the real essence 
of the code.

This should be restructured to move all the failure exception cases 
into a clean out of line inverse teardown sequence with proper goto 
labels. That way it will be 70% real code 30% teardown - not 10% 
real code mixed into 90% teardown like above.

Also, whoever named a local variable with a type of
"struct cr_image_file *" as 'i' should be sent back to
coding primary school.

You really should not write new kernel code until you know, follow 
and respect basic code cleanliness principles. I am not inserting 
any more review feedback value into this code until it does not meet 
_basic_ quality standards that make review efforts smooth and 
efficient.

Oh, and then i saw this sequence:

> +	/* Known good and unknown bad flags. */
> +	vm_flags &= ~VM_READ;
> +	vm_flags &= ~VM_WRITE;
> +	vm_flags &= ~VM_EXEC;
> +//	vm_flags &= ~VM_SHARED;
> +	vm_flags &= ~VM_MAYREAD;
> +	vm_flags &= ~VM_MAYWRITE;
> +	vm_flags &= ~VM_MAYEXEC;
> +//	vm_flags &= ~VM_MAYSHARE;
> +	vm_flags &= ~VM_GROWSDOWN;
> +//	vm_flags &= ~VM_GROWSUP;
> +//	vm_flags &= ~VM_PFNMAP;
> +	vm_flags &= ~VM_DENYWRITE;
> +	vm_flags &= ~VM_EXECUTABLE;
> +//	vm_flags &= ~VM_LOCKED;
> +//	vm_flags &= ~VM_IO;
> +//	vm_flags &= ~VM_SEQ_READ;
> +//	vm_flags &= ~VM_RAND_READ;
> +//	vm_flags &= ~VM_DONTCOPY;
> +	vm_flags &= ~VM_DONTEXPAND;
> +//	vm_flags &= ~VM_RESERVED;
> +	vm_flags &= ~VM_ACCOUNT;
> +//	vm_flags &= ~VM_NORESERVE;
> +//	vm_flags &= ~VM_HUGETLB;
> +//	vm_flags &= ~VM_NONLINEAR;
> +//	vm_flags &= ~VM_MAPPED_COPY;
> +//	vm_flags &= ~VM_INSERTPAGE;
> +	vm_flags &= ~VM_ALWAYSDUMP;
> +	vm_flags &= ~VM_CAN_NONLINEAR;
> +//	vm_flags &= ~VM_MIXEDMAP;
> +//	vm_flags &= ~VM_SAO;
> +//	vm_flags &= ~VM_PFN_AT_MMAP;

No comment ...

	Ingo
