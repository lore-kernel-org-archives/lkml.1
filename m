Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbXLCSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbXLCSxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXLCSxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:53:36 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:45683 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXLCSxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:53:35 -0500
Message-ID: <475450A1.9000103@oracle.com>
Date: Mon, 03 Dec 2007 10:53:21 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 BUG] 100% iowait on host while UML is running
References: <E1IzDHv-0003xj-Af@dorka.pomaz.szeredi.hu> <x49ir3fhg5n.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ir3fhg5n.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We could check ctx->reqs_active before scheduling to determine whether
> or not we are waiting for I/O, but this would require taking the
> context lock in order to be accurate.  Given that the test would be
> only for the sake of book keeping, it might be okay to do it outside
> of the lock.
> 
> Zach, what are your thoughts on this?

I agree that it'd be OK to test it outside the lock, though we'll want
some commentary:

	/* Try to only show up in io wait if there are ops in flight */
	if (ctx->reqs_active)
		io_schedule();
	else
		schedule();

It's cheap, safe, and accurate the overwhelming majority of the time :).

We only need it in read_events().  The other two io_schedule() calls are
only reached to wait on pending reqs specifically.

It still won't make sense for iocbs which aren't performing IO, but I
guess that's one more bridge to cross when we come to it.

Do you want to throw this tiny patch together and submit it?

- z
