Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYLPTMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYLPTMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYLPTMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:12:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17082 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYLPTMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:12:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=dYsymijQFEYF0Y8+aaAMedceN0FD4Zs+zOCeio0GLtlgJaeBZIOLcLMKYSKyCm1fF
	U5Jw9rdHfNvE+45MTCuRw==
Message-ID: <4947FBC8.2000601@google.com>
Date: Tue, 16 Dec 2008 11:04:40 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: jeremy@goop.org, arnd@arndb.de, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Linux Torvalds <torvalds@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
 restart
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu> <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
In-Reply-To: <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:

> +/*
> + * Helpers to write(read) from(to) kernel space to(from) the checkpoint
> + * image file descriptor (similar to how a core-dump is performed).
> + *
> + *   cr_kwrite() - write a kernel-space buffer to the checkpoint image
> + *   cr_kread() - read from the checkpoint image to a kernel-space buffer
> + */
> +
> +int cr_kwrite(struct cr_ctx *ctx, void *addr, int count)
> +{
> +	struct file *file = ctx->file;
> +	mm_segment_t fs;
> +	ssize_t nwrite;
> +	int nleft;
> +
> +	fs = get_fs();
> +	set_fs(KERNEL_DS);
> +	for (nleft = count; nleft; nleft -= nwrite) {
> +		nwrite = file->f_op->write(file, addr, nleft, &file->f_pos);
> +		if (nwrite < 0) {
> +			if (nwrite == -EAGAIN)
> +				nwrite = 0;
> +			else

set_fs(fs) here

> +				return nwrite;
> +		}
> +		addr += nwrite;
> +	}
> +	set_fs(fs);
> +	ctx->total += count;
> +	return 0;
> +}
> +
> +int cr_kread(struct cr_ctx *ctx, void *addr, int count)
> +{
> +	struct file *file = ctx->file;
> +	mm_segment_t fs;
> +	ssize_t nread;
> +	int nleft;
> +
> +	fs = get_fs();
> +	set_fs(KERNEL_DS);
> +	for (nleft = count; nleft; nleft -= nread) {
> +		nread = file->f_op->read(file, addr, nleft, &file->f_pos);
> +		if (nread <= 0) {
> +			if (nread == -EAGAIN) {
> +				nread = 0;
> +				continue;
> +			} else if (nread == 0)
> +				nread = -EPIPE;		/* unexecpted EOF */

set_fs(fs) here as well

> +			return nread;
> +		}
> +		addr += nread;
> +	}
> +	set_fs(fs);
> +	ctx->total += count;
> +	return 0;
> +}
> +

