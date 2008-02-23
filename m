Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYBWRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYBWRNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYBWRNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:13:44 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42030 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbYBWRNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:13:44 -0500
Date: Sat, 23 Feb 2008 20:17:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com
Subject: Re: + redo-locking-of-tty-pgrp.patch added to -mm tree
Message-ID: <20080223171746.GB7686@tv-sign.ru>
References: <200802230737.m1N7bfLB018553@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802230737.m1N7bfLB018553@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Andrew Morton wrote:
> 
> Subject: redo locking of tty->pgrp
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Historically tty->pgrp and friends were pid_t and the code "knew" they were
> safe.  The change to pid structs opened up a few races and the removal of the
> BKL in places made them quite hittable.  We put tty->pgrp under the ctrl_lock
> for the tty.

tiocgpgrp() still does pid_vnr(real_tty->pgrp) lockless, this is not safe, no?
(the same for do_task_stat).

It can race with tiocspgrp()->put_pid(real_tty->pgrp) which can actually free
that pid. If this memory is reused, pid_nr_ns() can (in theory) crash.

Oleg.

