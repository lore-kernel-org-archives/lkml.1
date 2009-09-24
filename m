Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZIXAQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZIXAQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZIXAQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:16:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41399 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZIXAQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:16:02 -0400
Date: Wed, 23 Sep 2009 20:15:58 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "kmod: fix race in usermodehelper code"
Message-ID: <20090924001558.GA16772@localhost.localdomain>
References: <20090923230255.GA18878@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923230255.GA18878@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 01:02:55AM +0200, Sebastian Andrzej Siewior wrote:
> This reverts commit c02e3f361:
> |Author: Neil Horman <nhorman@tuxdriver.com>
> |Date:   Tue Sep 22 16:43:36 2009 -0700
> |
> |    kmod: fix race in usermodehelper code
> |
> |    The user mode helper code has a race in it.  call_usermodehelper_exec()
> |    takes an allocated subprocess_info structure, which it passes to a
> |    workqueue, and then passes it to a kernel thread which it creates, after
> |    which it calls complete to signal to the caller of
> |    call_usermodehelper_exec() that it can free the subprocess_info struct.
> |
> |    But since we use that structure in the created thread, we can't call
> |    complete from __call_usermodehelper(), which is where we create the kernel
> |    thread.  We need to call complete() from within the kernel thread and then
> |    not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
> |    successfully by me.
> |
> |    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> |    Cc: Rusty Russell <rusty@rustcorp.com.au>
> |    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> |    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The pach is wrong IMHO. UMH_WAIT_EXEC is called with VFORK what ensures
> that the child finishes prior returing back to the parent. No race. The patch
> makes it even worse because it does the thing it claims not do:
Dang, you're right.  I completely missed the use of CLONE_VFORK as a mechanism
to prevent the parent from racing ahead of the child.  Sorry for the noise.
Neil

> 
