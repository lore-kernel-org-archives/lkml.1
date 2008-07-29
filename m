Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYG2K7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYG2K7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbYG2K7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:59:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60485 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbYG2K7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:59:00 -0400
Date: Tue, 29 Jul 2008 15:02:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, minor]  workqueue: consistently use 'err' in __create_workqueue_key()
Message-ID: <20080729110250.GA177@tv-sign.ru>
References: <1217277694.20627.9.camel@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217277694.20627.9.camel@earth>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Dmitry Adamushko wrote:
> 
> I guess error handling is a bit illogical in __create_workqueue_key()

Please see below,

>  		for_each_possible_cpu(cpu) {
>  			cwq = init_cpu_workqueue(wq, cpu);
> -			if (err || !cpu_online(cpu))
> +			if (!cpu_online(cpu))
>  				continue;
>  			err = create_workqueue_thread(cwq, cpu);
> +			if (err)
> +				break;

This was done on purpose. The code above does init_cpu_workqueue(cpu)
for each possible cpu, even if we fail to create cwq->thread for some
cpu. This way destroy_workqueue() (called below) shouldn't worry about
the partially initialized workqueues.

The patch above should work, but it assumes that destroy_workqueue()
must do nothing with cwq if cwq->thread == NULL, this is not very
robust.


And, more importantly. Let's suppose __create_workqueue_key() does
"break" and drops cpu_add_remove_lock. Then we race with cpu-hotplug
which can hit the uninitialized cwq. This is fixable, but needs other
complication.

Oleg.

