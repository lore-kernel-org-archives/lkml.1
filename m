Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZJDXLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZJDXLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbZJDXLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:11:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34945 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbZJDXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:11:12 -0400
Date: Sun, 4 Oct 2009 19:10:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits
	external to a process (v3)
Message-ID: <20091004231027.GA5701@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091001171644.GC2456@hmsreliant.think-freely.org> <4AC891B9.7090108@gmail.com> <20091004165045.GB3690@localhost.localdomain> <4AC8FFC4.8080207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC8FFC4.8080207@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 10:04:20PM +0200, Marcin Slusarz wrote:
> Neil Horman wrote:
> >>> +static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
> >>> +		size_t count, loff_t *ppos)
> >>> +{
> >>> +	char *buffer;
> >>> +	char *element, *vmc, *vmm;
> >>> +	struct rlimit new_rlim;
> >>> +	unsigned long flags;
> >>> +	int i;
> >>> +	int index = -1;
> >>> +	size_t wcount = 0;
> >>> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> >>> +
> >>> +
> >>> +	if (*ppos != 0)
> >>> +		goto out;
> >>> +
> >>> +	if (count > 128)
> >>> +		goto out;
> >>> +	buffer = kzalloc(128, GFP_KERNEL);
> >>> +
> >>> +	if (!buffer)
> >>> +		goto out;
> >> element, vmc, vmm are not initialized and you kfree them in this case
> >>
> > Yep, I'll fix that
> > 
> >>> +
> >>> +	element = kzalloc(sizeof(buffer), GFP_KERNEL);
> >>> +	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
> >>> +	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);
> >> sizeof(buffer) == 4 or 8 - pretty short buffer...
> >>
> >>> +
> >>> +	if (!element || !vmm || !vmc)
> >>> +		goto out_free;
> >>> +
> >>> +	wcount = count - copy_from_user(buffer, buf, count);
> >>> +	if (wcount < count)
> >>> +		goto out_free;
> >> copy_from_user usage usually looks like:
> >> if (copy_from_user()) {
> >> 	ret = -EFAULT;
> >> 	goto err;
> >> }
> >> you don't seem to use copy_from_user return value for anything useful
> >>
> > I did at one point, a few versions ago, that can likely be removed now.
> > 
> >>> +
> >>> +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
> >> what if user pass strings longer than size of buffers?
> >>
> > You fail the write, theres a check at the top of the function for that.  By the
> > time you get here, buffer is guaranteed to be no more than 128 bytes.
> 
Crud, you're right, that only works with static arrays, I'll fix that up.
Thanks!
> 
