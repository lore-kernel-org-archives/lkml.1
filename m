Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZKBVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZKBVig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZKBVif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:38:35 -0500
Received: from isilmar.linta.de ([213.133.102.198]:39644 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755860AbZKBVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:38:35 -0500
Date: Mon, 2 Nov 2009 22:38:37 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pcmcia@lists.infradead.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep violation in pcmcia
Message-ID: <20091102213837.GA26200@isilmar.linta.de>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	linux-pcmcia@lists.infradead.org,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0911021610030.28727-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911021610030.28727-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Nov 02, 2009 at 04:21:23PM -0500, Alan Stern wrote:
> I've been getting these warnings for a long, long time, and finally 
> decided to report them:

Thanks!

> [ 1893.036023] other info that might help us debug this:
> [ 1893.036023] 2 locks held by cardmgr/1457:

Wow, cardmgr still in use... I had hoped it had already disappeared on
non-embedded systems...

> The cause is easy enough to track down.  In pcmcia_ioctl.c,
> pcmcia_adjust_resource_info() does a down_read() on
> pcmcia_socket_list_rwsem.  While holding the rwsem, one of the pathways
> calls the s->resource_ops->add_mem method.  On my system this method is
> realized by adjust_memory() in rsrc_nonstatic.c, which does its own
> down_read() on the same rwsem -- i.e., a recursive locking attempt.
> 
> The reason lockdep warns about this behavior is that it can lead to
> deadlock in the wrong circumstances, namely, if another thread were to
> do a down_write() in between the two down_read() calls.
> 
> Would it be correct simply to omit the down_read() in adjust_memory()?

No, for there are other code paths reaching adjust_memory() not holding a
(read) lock on this semaphore. As pcmcia_ioctl.c is on its way out anyways:
would you mind keeping it as it is, for a down_write() call is quite
unlikely during the only time cardmgr actually does this call (system
startup)?

Best,
	Dominik
