Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYGUAKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYGUAKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbYGUAIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:08:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906AbYGUAIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:08:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coredump: exit_mm: clear ->mm first, then play with ->core_state
In-Reply-To: Oleg Nesterov's message of  Sunday, 20 July 2008 16:23:54 +0400 <20080720122354.GD143@tv-sign.ru>
References: <20080716135359.GA1219@tv-sign.ru>
	<20080720023258.26D2015421D@magilla.localdomain>
	<20080720122354.GD143@tv-sign.ru>
Emacs: the road to Hell is paved with extensibility.
Message-Id: <20080721000842.94DAE15421D@magilla.localdomain>
Date: Sun, 20 Jul 2008 17:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, oom_kill.c in turn need fixes but still this is not nice, and I
> personally hate this coredump code in the middle of exit_mm().

I agree.  I think what we should work towards is having the coredump
synchronization take place earlier (the tracehook_report_exit point should
be fine, i.e. before PF_EXITING).  Then have the dumping and the waiting
for it be killable.  I don't think we can get there in only one or two
steps, though.

[The rest if quite off-topic, please do it separately.]

> btw, arch/sparc64/kernel/ptrace.c has a lot of
> 
> 	if (target == current)
> 		copy_xxx_user();
> 	else
> 		access_process_vm();
> 
> perhaps it make sense to make a helper. 

Dave actually has get_from_target and set_to_target helpers for that.
The places they aren't used, I assume are either just older code not
yet streamlined, or places where the separate get/put_user calls perform
especially better than copy_xxx_user (you'd have to ask Dave).  If multiple
arch ports find such helpers useful, they could move into common code later.

> Just curious (I don't know what regset is), is it possible that ->get()
> is called when target->mm == NULL?

It should not happen.  It's only kosher to use user_regset calls on a task
in a known state (like ptrace stop, or current), and never on kernel threads.


Thanks,
Roland
