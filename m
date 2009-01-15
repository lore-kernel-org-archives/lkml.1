Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZAOLr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZAOLr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZAOLro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:47:44 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48558 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZAOLrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:47:43 -0500
Message-ID: <496F224A.9080100@cosmosbay.com>
Date: Thu, 15 Jan 2009 12:47:22 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, Volker.Lendecke@SerNet.DE,
       linux-kernel@vger.kernel.org, sfrench@us.ibm.com, jens.axboe@oracle.com,
       netdev@vger.kernel.org
Subject: Re: maximum buffer size for splice(2) tcp->pipe?
References: <20090113123702.ad29cd13.akpm@linux-foundation.org>	<496D2078.9080302@cosmosbay.com>	<496D25F8.2080505@cosmosbay.com> <20090114.205839.20689555.davem@davemloft.net>
In-Reply-To: <20090114.205839.20689555.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 15 Jan 2009 12:47:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Wed, 14 Jan 2009 00:38:32 +0100
> 
>> [PATCH] net: splice() from tcp to socket should take into account O_NONBLOCK
>>
>> Instead of using SPLICE_F_NONBLOCK to select a non blocking mode both on
>> source tcp socket and pipe destination, we use the underlying file flag (O_NONBLOCK)
>> for selecting a non blocking socket.
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> This needs at least some more thought.
> 
> It seems, for one thing, that this change will interfere with the
> intentions of the code in splice_dirt_to_actor which goes:
> 
> 	/*
> 	 * Don't block on output, we have to drain the direct pipe.
> 	 */
> 	sd->flags &= ~SPLICE_F_NONBLOCK;

Reading splice_direct_to_actor() I see nothing wrong with the patch

(Patch is about splice from socket to pipe, while the sd->flags you mention
in splice_direct_to_actor() only applies to the splice from internal pipe to
something else, as splice_direct_to_actor() allocates an internal pipe to perform
its work.

Also, the meaning of SPLICE_F_NONBLOCK, as explained in include/linux/splice.h is :

#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing (but */
	/* we may still block on the fd we splice */
	/* from/to, of course */

If the comment is still correct, SPLICE_F_NONBLOCK only applies to the pipe implied in
splice() syscall.

For the other file, either its :
- A regular file : nonblocking mode is not available, like a normal read()/write() syscall

- A socket : We should be able to specify if its blocking or not, independantly from
             the SPLICE_F_NONBLOCK flag that only applies to the pipe. Normal way
             is using ioctl(FIONBIO) or other fcntl() call to change file->f_flags O_NONBLOCK


In order to be able to efficiently use splice() from a socket to a file, we need
to do a loop of :

{
splice(from blocking tcp socket to non blocking pipe, SPLICE_F_NONBLOCK); /* nonblocking pipe or risk deadlock */
splice(from pipe to file)
}


