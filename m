Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbXELOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbXELOS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXELOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:18:20 -0400
Received: from mail.screens.ru ([213.234.233.54]:51445 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXELOST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:18:19 -0400
Date: Sat, 12 May 2007 18:18:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512141813.GA98@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org> <200705121101.40795.rjw@sisk.pl> <200705121245.50715.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705121245.50715.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Rafael J. Wysocki wrote:
>
> ... user space tasks that call deamonize() can also be frozen prematurely.
> We didn't take this possibility into consideration before, which was obviously
> wrong.

No, no, sorry for the confusion. User space tasks never call deamonize().

Kernel threads call daemonize, because when we are doing kernel_thread()
on behalf of user-space task, the new kernel thread (child) shares its
->mm with the caller (parent). So it is considered as "is_user_space()"
until it does daemonize().

Definitely, is_user_space() should have another name.

When a user space task exits, it does exit_mm() and becomes "a kernel thread"
from the freezer POV. In its current from, freezer can do nothing with this.
The exiting task won't call try_to_freeze() after that, so try_to_freeze_tasks()
will wait until it dissapears (actually, until it calls exit_notify(), note
the ->exit_state check in freezeable()).

I do not think we can improve things if exit_mm() clears TIF_FREEZING.
We should clear TIF_FREEZING when we set PF_NOFREEZE, I think. This was
discussed before iirc, but I forgot the result.

Oleg.

