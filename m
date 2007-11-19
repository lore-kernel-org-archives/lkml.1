Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXKSOSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXKSOSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXKSOSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:18:10 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:42119 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXKSOSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:18:09 -0500
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 09:18:09 EST
Date: Mon, 19 Nov 2007 14:52:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
Message-Id: <20071119145224.31ee5242.dada1@cosmosbay.com>
In-Reply-To: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 00:31:36 -0500
Ulrich Drepper <drepper@redhat.com> wrote:


> 
>   union indirect_params i;
>   i.file_flags.flags = O_CLOEXEC;

This setup forbids future addons to file_flags

In three years, when we want to add a new indirect feature to socket() 
call, do we need a new indirect2() syscall ?

So I suggest using :

   union indirect_params i = {
      .file_flags.flags = O_CLOEXEC,
   };
fd = syscall (__NR_indirect, &r, &i, sizeof (i));

Or better, you could avoid using 'union indirect_params' in user code, and 
only use the substructs for each function.
/* define this in some include file of course */
  struct file_flags {
	int flags;
  };
/* use it */
struct file_flags ff = { .flags = O_CLOEXEC};
fd = syscall (__NR_indirect, &r, &ff, sizeof(ff));

This to avoid to copy to kernel un-necessary data, and permitting futures changes.

