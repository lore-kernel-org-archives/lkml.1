Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbZD3Nfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbZD3Nfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbZD3Nf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:35:27 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37710 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZD3Nf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RuN3kgUgPkYTerrIEB4MVKuFHl2jTdiMbj2EnYhx/qDbmiu/uP7PJZUKZS7N/RMzcm
         zU7SCHrWzF2UKV+yHOXSSpgGsH02CzCCKIs0vORMENYpaesDMTTVR0KtxHKadT8mqDxc
         RP0el2XDVhSP6uV04UmxzxwWNQVwJ1J2qig+8=
MIME-Version: 1.0
In-Reply-To: <20090430120354.5689.75240.stgit@rabbit.intern.cm-ag>
References: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag>
	 <20090430120354.5689.75240.stgit@rabbit.intern.cm-ag>
Date: Thu, 30 Apr 2009 15:35:24 +0200
Message-ID: <19f34abd0904300635v2d8af8eeh1a8aa9cf6f4eb1c9@mail.gmail.com>
Subject: Re: [splice PATCH 3/3] splice: added support for pipe-to-pipe 
	splice()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, w@1wt.eu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/30 Max Kellermann <mk@cm4all.com>:
> This patch enables the splice() system call to copy buffers from one
> pipe to another.  This obvious and trivial use case for splice() was
> not supported until now.
>
> It reuses the functions link_ipipe_prep() and link_opipe_prep() from
> the tee() system call implementation.
>
> Signed-off-by: Max Kellermann <mk@cm4all.com>
> ---
>
>  fs/splice.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 166 insertions(+), 0 deletions(-)
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 96135eb..f69a88f 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -902,6 +902,156 @@ ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
>
>  EXPORT_SYMBOL(generic_splice_sendpage);
>
> +static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags);
> +static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags);
> +
> +/**
> + * Returns the nth pipe buffer after the current one.
> + *
> + * @i the buffer index, relative to the current one
> + */
> +static inline struct pipe_buffer *
> +pipe_buffer_at(struct pipe_inode_info *pipe, unsigned i)
> +{
> +       BUG_ON(i >= PIPE_BUFFERS);
> +
> +       return pipe->bufs + ((pipe->curbuf + i) & (PIPE_BUFFERS - 1));
> +}
> +
> +/**
> + * Splice pages from one pipe to another.
> + *
> + * @ipipe the input pipe
> + * @opipe the output pipe
> + * @len the maximum number of bytes to move
> + * @flags splice modifier flags
> + */
> +static long do_splice_pipes(struct pipe_inode_info *ipipe,
> +                           struct pipe_inode_info *opipe,
> +                           size_t len, unsigned int flags)
> +{
> +       struct pipe_buffer *ibuf, *obuf;
> +       long ret;
> +       int do_wakeup = 0;
> +
> +       if (ipipe == opipe)
> +               /* cannot splice a pipe to itself */
> +               return -EINVAL;
> +

What happens if you splice two pipes, in separate threads, to each other? :-)


Vegard
