Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbXEaWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbXEaWI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbXEaWIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:08:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11560 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358AbXEaWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:08:47 -0400
Date: Thu, 31 May 2007 15:07:16 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070531220716.GL5488@mami.zabbo.net>
References: <20070531181923.GA9904@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531181923.GA9904@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> cachemiss_thread should explicitly return 0 or error instead of
> task_ret_reg(current) (which is -ENOSYS anyway) because
> async_thread_helper is careful to put the return value in eax anyway.

Can you explain what motivated you to send out this patch?

It used to return 0.  It was changed because, unlike the syslet
syscalls, sys_io_submit() doesn't have a simple 0 value to indicate
success.  The current implementation wants to return the number of iocbs
that were processed, including the one which blocked, from the cachemiss
thread.  So before calling into an operation it sets task_ret_ret() so
that the cachemiss thread can return it if it takes over.
task_ret_reg() is holding a return value that is being returned by the
cachemiss thread on behalf of a sys_io_submit() which blocked.

When I made the change I didn't really audit its effect on the other
paths.  I suppose it's time to do that, and you could help by telling me
if you saw something bad happen :).

- z
