Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYAPDFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYAPDFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbYAPDEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:04:55 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:27594 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYAPDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:04:54 -0500
Date: Tue, 15 Jan 2008 19:02:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: implement merging printk
Message-Id: <20080115190257.f0546a63.randy.dunlap@oracle.com>
In-Reply-To: <12004452113770-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
	<12004452113770-git-send-email-htejun@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 10:00:09 +0900 Tejun Heo wrote:


> ---
>  include/linux/kernel.h |   71 ++++++++++++++++
>  kernel/printk.c        |  215 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 286 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index ade3ac9..f92a4a1 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -175,6 +175,29 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>  extern void dump_thread(struct pt_regs *regs, struct user *dump);
>  
>  #ifdef CONFIG_PRINTK
> +struct mprintk {
> +	char *		header;
> +	char *		body;
> +	char *		cur;
> +	char *		prv;
> +	char *		end;

We aren't very consistent about this, but I think that we would prefer

	char		*header;

etc. there.


> +	int		overflowed;
> +};
> +
> +#define MPRINTK_INITIALIZER(_buf, _size)				\
> +	{								\
> +		.header		= NULL,					\
> +		.body		= _buf,					\
> +		.cur		= _buf,					\
> +		.prv		= NULL,					\
> +		.end		= _buf + _size,				\
> +		.overflowed	= 0,					\
> +	}
> +
> +#define DEFINE_MPRINTK(name, size)					\
> +	char __##name##_buf[size];					\
> +	struct mprintk name = MPRINTK_INITIALIZER(__##name##_buf, size)

---
~Randy
