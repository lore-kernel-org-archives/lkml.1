Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZJDUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZJDUFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZJDUFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:05:06 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37847 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907AbZJDUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X9FtqBDUNKUR6cE5xYl9dS4X0sqmuXMf2WfnVfK2BfADrBboq8Dq0BfMdJV7bdd0c0
         1k1vvO1bvD/LNRuDqd1i5FOhYPnDjTvMVOm8EUAgmFG+tGTfHmB/zXwXHmlbv2gOpBHi
         +mCgmTbYGFfy1fZDkDdgFLghUCEmUeohU8hK4=
Message-ID: <4AC8FFC4.8080207@gmail.com>
Date: Sun, 04 Oct 2009 22:04:20 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits external
 to a process (v3)
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091001171644.GC2456@hmsreliant.think-freely.org> <4AC891B9.7090108@gmail.com> <20091004165045.GB3690@localhost.localdomain>
In-Reply-To: <20091004165045.GB3690@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
>>> +static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
>>> +		size_t count, loff_t *ppos)
>>> +{
>>> +	char *buffer;
>>> +	char *element, *vmc, *vmm;
>>> +	struct rlimit new_rlim;
>>> +	unsigned long flags;
>>> +	int i;
>>> +	int index = -1;
>>> +	size_t wcount = 0;
>>> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
>>> +
>>> +
>>> +	if (*ppos != 0)
>>> +		goto out;
>>> +
>>> +	if (count > 128)
>>> +		goto out;
>>> +	buffer = kzalloc(128, GFP_KERNEL);
>>> +
>>> +	if (!buffer)
>>> +		goto out;
>> element, vmc, vmm are not initialized and you kfree them in this case
>>
> Yep, I'll fix that
> 
>>> +
>>> +	element = kzalloc(sizeof(buffer), GFP_KERNEL);
>>> +	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
>>> +	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);
>> sizeof(buffer) == 4 or 8 - pretty short buffer...
>>
>>> +
>>> +	if (!element || !vmm || !vmc)
>>> +		goto out_free;
>>> +
>>> +	wcount = count - copy_from_user(buffer, buf, count);
>>> +	if (wcount < count)
>>> +		goto out_free;
>> copy_from_user usage usually looks like:
>> if (copy_from_user()) {
>> 	ret = -EFAULT;
>> 	goto err;
>> }
>> you don't seem to use copy_from_user return value for anything useful
>>
> I did at one point, a few versions ago, that can likely be removed now.
> 
>>> +
>>> +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
>> what if user pass strings longer than size of buffers?
>>
> You fail the write, theres a check at the top of the function for that.  By the
> time you get here, buffer is guaranteed to be no more than 128 bytes.

But you allocated only 4/8 bytes (depending on size of void*) for element, vmc, vmm.
It will overflow for string like "xxxxxxxxxxxxxxxxxxx y z".

Marcin
