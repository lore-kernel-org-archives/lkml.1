Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbYEBOH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbYEBOH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYEBOHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:07:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57653 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbYEBOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:07:47 -0400
Date: Fri, 2 May 2008 16:07:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Enrico Weigelt <weigelt@metux.de>
cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: API for changing UIDs of other processes
In-Reply-To: <20080502121641.GB7997@nibiru.local>
Message-ID: <alpine.LNX.1.10.0805021602160.6463@fbirervta.pbzchgretzou.qr>
References: <20080502121641.GB7997@nibiru.local>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-02 14:16, Enrico Weigelt wrote:
>Hi folks,
>
>
>I'd like to build some authentication daemon which alters the
>privileges of another process (like factotum does on plan9).
>But I couldn't find any interface for that (setuid() and friends
>only operate on the current process). So I'm now going to create
>my own interface.
>
>As a little learning example I just added a few files to the
>per-pid dirs: uid, euid, suid, fsuid. This was trivial :)
>
>Now I'd like to add an write capability to these files: 
>simply writing another number changes the (|s|fs)uid.
>
>But this doesnt seem that trivial. Perhaps someone could give
>me some advice ?

Not really hard, is it? Just look at something like oom_adj

static ssize_t myprocpid_euid_write(struct file *file,
    const char __user *inbuf, size_t size)
{
	struct task_struct *task;
	char buf[sizeof("4294967296")];
	unsigned int amount = min(size, sizeof(buf) - 1);

	if (copy_from_user(buf, inbuf, amount) != 0)
		return -EFAULT;
	buf[amount] = '\0';

	task = get_proc_task(file->f_path.dentry->d_inode);
	if (task == NULL)
		return -ESRCH;

	/* do error checking */
	task->euid = simple_strtoul(buf, NULL, 0);
	put_task_struct(task);
	return size;
}

So far the theory..
