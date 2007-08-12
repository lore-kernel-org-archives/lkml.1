Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbXHLVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbXHLVdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbXHLVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:33:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46750 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbXHLVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:33:04 -0400
Date: Sun, 12 Aug 2007 23:33:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Finding out socket/pipe connectivity status
In-Reply-To: <20070812194210.210db3a3@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0708122328070.28963@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
 <20070812170018.6f56a0dd@the-village.bc.nu>
 <Pine.LNX.4.64.0708121808470.28963@fbirervta.pbzchgretzou.qr>
 <20070812194210.210db3a3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 19:42, Alan Cox wrote:
>> 	write(stdout, request);
>> 	/* reference point [A] */
>> 	read(stdin, response);
>> 
>> So my idea had been to launch another thread that monitors stdin for
>> 'breakage' and unmount the fs before a user can start an operation on
>> myfs. So I've been trying to complete the idea to code. You say a
>> broken socket raises the read flag, so:
>
>Your connection can break at any point even mid-write so you must handle
>it. You have no real choice.

Yes, of course. I was just saying that when the filesystem is in an operation,

	`df` -> sys_statvfs() -> [fuse magic] -> my_fuse_fs_statfs()

I cannot cancel that operation in a way such that df (or /proc/mounts if you
like) does not show the mount anymore when the peer is dead. I have to return
something. I am fine with that.

>You can try and spot it earlier by using select/poll and checking for
>error. In which case I'd use poll() as it is a bit more clear about what
>event you get
>
>Then poll stdin and stdout. The kernel will give you back 
>
>POLLERR - an error condition
>POLLHUP - a hangup
>
>if at the point you poll an error has already occurred. You can do this
>with select and the socket error and related stuff buts its uglier

poll() alone seems to do just what I want, thank you very much.

When the socket breaks, poll raises POLLIN, POLLHUP and POLLRDHUP, but not
POLLERR. What exactly is the difference between HUP and RDHUP? The manpage is
not too verbose on that. (A guess would be that RDHUP is only for sockets,
not pipes.)


thanks,
	Jan
-- 
