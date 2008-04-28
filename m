Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbYD1QNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbYD1QNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935643AbYD1QNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:13:25 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:55046 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934665AbYD1QNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:13:24 -0400
Message-ID: <4815F7A2.7060605@oracle.com>
Date: Mon, 28 Apr 2008 09:13:22 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Benjamin LaHaise <bcrl@kvack.org>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [PATCH] vfs: reduce stack usage by shrinking struct kiocb
References: <200804270617.36629.vda.linux@googlemail.com>
In-Reply-To: <200804270617.36629.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi Al, Benjamin, David,
> 
> struct kiocb is placed on stack by, for example, do_sync_write().
> Eventually it contributes to xfs writeout path's stack usage, among others.
> This is *the* path which causes 4k stack overflows on i386 with xfs.
> 
> This patch trivially reorders fields of this structure,
> and makes some of them smaller.

Great, thanks for doing this.  I see one fatal bug, though.  Can you fix
it up and resubmit?

-	unsigned long		ki_flags;
+	unsigned short		ki_flags; /* range: 0..2 */

Careful, ki_flags is used by the bitops routines which require an
unsigned long.  I'd just leave ki_flags as is.

> ki_nr_segs: ulong -> uint: nobody uses 4 billion element writev's
>                            (and it would not work anyway)

Indeed.  Maybe explicitly mention that it's safe 'cause we pass
ki_nbytes to rw_copy_check_uvector() for comparison against UIO_MAXIOV
before we store it in the kiocb.

+	/*unsigned short	ki_opcode; - moved up for denser packing */

Don't bother commenting out fields that are moved, just move 'em.

Otherwise it looks great, thanks.

- z
