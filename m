Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbXEMWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbXEMWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXEMWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:32:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:44367 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436AbXEMWcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:32:05 -0400
Date: Mon, 14 May 2007 02:32:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Message-ID: <20070513223207.GA3265@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <200705132350.32582.rjw@sisk.pl> <20070513215425.GA3240@tv-sign.ru> <200705140021.14129.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705140021.14129.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Rafael J. Wysocki wrote:
>
> Hmm, I guess we could add an additional mutex that would only be taken in
> flush_workqueue() and in _cpu_down()/_cpu_up() via workqueue_cpu_callback()
> with CPU_LOCK_ACQUIRE?

This will deadlock if work->func() does flush_workqueue(), because it may
run when _cpu_down() holds this lock (note that it doesn't help if we
re-introduce take_over_work()).

This is a reason why mutex_lock(&workqueue_mutex) was removed from
flush_workqueue().

> It doesn't seem to be a good idea to run flush_workqueue() while CPUs are being
> taken up and down anyway.

We can freeze all tasks :) Otherwise we can't forbid them to call
flush_workqueue().

flush_workqueue() is OK. create/destroy is a problem.

Oleg.

