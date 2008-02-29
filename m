Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYB2CiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYB2CiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYB2CiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:38:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYB2CiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vwjFXEyMX8FB2fInbX8jIsuwLnFUIW5Rmfa3kVzsnTjOw8t9ZiPBlsvXBQ3jDsZv5ckeS0G9MWtI2M8tn7wMBX4CnXZ6e6JMnK8lBfFdxvICJ8pkdhhEZcvOr+yFCjaOVjM1NoIHeFeNx/BZQkbiC6TEF4IhCq/CwnQSvSM6O6w=
Subject: Re: [PATCH 11/12] Generic semaphore implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1204180441-8540-11-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
	 <1204180441-8540-1-git-send-email-matthew@wil.cx>
	 <1204180441-8540-2-git-send-email-matthew@wil.cx>
	 <1204180441-8540-3-git-send-email-matthew@wil.cx>
	 <1204180441-8540-4-git-send-email-matthew@wil.cx>
	 <1204180441-8540-5-git-send-email-matthew@wil.cx>
	 <1204180441-8540-6-git-send-email-matthew@wil.cx>
	 <1204180441-8540-7-git-send-email-matthew@wil.cx>
	 <1204180441-8540-8-git-send-email-matthew@wil.cx>
	 <1204180441-8540-9-git-send-email-matthew@wil.cx>
	 <1204180441-8540-10-git-send-email-matthew@wil.cx>
	 <1204180441-8540-11-git-send-email-matthew@wil.cx>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 18:37:59 -0800
Message-Id: <1204252679.20280.115.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Because this function is inlined, the 'state' parameter will be constant,
> + * and thus optimised away by the compiler.
> + */

If so, is unlikely() still needed?

> +static inline int __sched __down_common(struct semaphore *sem, long state)
> +{
> +	int result = 0;
> +	struct task_struct *task = current;
> +	struct semaphore_waiter waiter;
> +
> +	list_add_tail(&waiter.list, &sem->wait_list);
> +	waiter.task = task;
> +	waiter.up = 0;
> +
> +	for (;;) {
> +		if (unlikely((state == TASK_INTERRUPTIBLE &&
> +					signal_pending(task)) ||
> +			     (state == TASK_KILLABLE &&
> +					fatal_signal_pending(task))))
> +			goto interrupted;

		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
			goto interrupted;
		if (state == TASK_KILLABLE && fatal_signal_pending(task))
			goto interrupted;

Other than that small bit, looks great, any thoughts to getting rid of
all the likely/unlikely as well?  If they're no longer performance
critical, it would be nice to have it that little bit cleaner.


Harvey

