Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYGSHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYGSHv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYGSHvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 03:51:50 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56610 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYGSHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 03:51:50 -0400
Message-ID: <48819D92.8050904@keyaccess.nl>
Date: Sat, 19 Jul 2008 09:53:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
References: <20080718151524.5ef9e29b@infradead.org> <20080718151608.46dc17c0@infradead.org>
In-Reply-To: <20080718151608.46dc17c0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-07-08 00:16, Arjan van de Ven wrote:

> +static void __init do_initcalls(void)
> +{
> +	initcall_t *call;
> +	static DECLARE_WORK(async_work, do_async_initcalls);
> +	int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after level 6a */
> +
> +	async_init_wq = create_singlethread_workqueue("kasyncinit");
> +
> +	for (call = __initcall_start; call < __initcall_end; call++) {
> +		if (phase == 0 && call >= __async_initcall_start) {
> +			phase = 1;
> +			queue_work(async_init_wq, &async_work);
> +		}
> +		if (phase == 1 && call >= __async_initcall_end)
> +			phase = 2;
> +		if (phase != 1)
> +			do_one_initcall(*call);
> +	}

I'm not sure about this comment, being not very sure about the semantics 
of late_initcall but shouldn't late_initcall (level 7) wait for 6s to 
have completed?

Rene.
