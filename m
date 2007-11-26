Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXKZTRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXKZTRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXKZTRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:17:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40942 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXKZTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:17:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
References: <20071126142553.GA16525@tv-sign.ru>
Date: Mon, 26 Nov 2007 12:16:21 -0700
In-Reply-To: <20071126142553.GA16525@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 26 Nov 2007 17:25:53 +0300")
Message-ID: <m1zlx0n7ga.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> sys_setsid() still deals with pid_t's from the global namespace. This means
> that the "session > 1" check can't help for sub-namespace init, setsid() can't
> succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.

We can do even better.  We can remove the misguided code from
copy_process(CLONE_NEWPID) that populates the PIDTYPE_PGID/SID links
and generally does set setsid by hand, and the code from kernel_init
that call set_special_pid(), allowing us to remove the special case
entirely.

The set_special_pid() in kernel_init() and the special case check 
is actually a work around for the fact that earlier we could not
use 0 in the pid hash table.  Now that we can use init_struct_pid
directly we don't need the special case at all.

Eric
