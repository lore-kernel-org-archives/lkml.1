Return-Path: <linux-kernel-owner+w=401wt.eu-S1161079AbXB0JWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbXB0JWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161080AbXB0JWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:22:17 -0500
Received: from mail.screens.ru ([213.234.233.54]:45625 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161079AbXB0JWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:22:15 -0500
Date: Tue, 27 Feb 2007 12:22:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ____call_usermodehelper: don't flush_signals()
Message-ID: <20070227092204.GA315@tv-sign.ru>
References: <20070226215330.GA403@tv-sign.ru> <1172533536.13541.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172533536.13541.64.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Rusty Russell wrote:
>
> On Tue, 2007-02-27 at 00:53 +0300, Oleg Nesterov wrote:
> > ____call_usermodehelper() has no reason for flush_signals(). It is a fresh
> > forked process which is going to exec a user-space application or exit on
> > failure.
> 
> And the flush_signal_handlers() call?

Well... flush_old_exec() calls flush_signal_handlers(force_default = 0),
this is not enough. We don't want to start user-space application with
SIGKILL ignored (yes, parent doesn't ignores it currently).

> Your patch looks correct; this code was presumably lying around from
> before someone (I?) adapted this code to use kthread.

Thanks! What I can't understand is why kthread/daemonize block all signals.
This doesn't look good to me. This can't prevent signal delivery, this only
blocks signal_wake_up(). We can even set SIGNAL_GROUP_EXIT for the kernel
thread. Of course, only root can do that, but isn't it better to just ignore
all signals instead of blocking them?

Note that we can't free the memory if we send a signal to (for example)
khelper.

Oleg.

