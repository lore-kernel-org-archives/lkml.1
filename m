Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYKQKQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYKQKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 05:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYKQKQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 05:16:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42919 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYKQKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 05:16:49 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <492136A8.5020908@kernel.org> (message from Tejun Heo on Mon, 17
	Nov 2008 18:17:28 +0900)
Subject: Re: [fuse-devel] [PATCHSET] FUSE: extend FUSE to support more
	operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<48F4568B.7000609@kernel.org>
	<E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
	<491BC87F.4050108@kernel.org>
	<E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu>
	<491C1588.2060907@kernel.org>
	<E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu>
	<E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu>
	<491C2A63.1030804@kernel.org>
	<E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu>
	<491C39BD.8050108@kernel.org>
	<E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu>
	<491C436C.6060603@kernel.org>
	<E1L0eUz-0007D0-Tp@pomaz-ex.szeredi.hu> <492136A8.5020908@kernel.org>
Message-Id: <E1L219j-0006iL-AJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 17 Nov 2008 11:16:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 17 Nov 2008, Tejun Heo wrote:
> Hello, Miklos.
> 
> I tried to implement poll as you suggested but it doesn't work because
> poll actually is synchronous.  Please consider the following scenario.
> A file system implements a file which supports poll and other file
> operations and there's a single threaded client which does the
> following.

Hmm, I do see your point.

> 1. open the file
> 2. do polling (timeout == 0) poll on the fd
> 3-1. if POLLIN, consume data and goto #2
> 3-2. if ! POLLIN, do a ioctl (or whatever) on the fd and goto #2
> 
> For a client with single stream of syscalls (single threaded), it's
> generally guaranteed that the attempt to consume data is successful
> after POLLIN unless the fd dies inbetween.  I don't think this is
> something guaranteed in POSIX but for most in-kernel poll
> implementations, this holds and I've seen good amount of code
> depending on it.
> 
> To satisfy the above assumption, if ->poll is always asynchronous,
> FUSE has to cache revents from previous ->poll attempts and clear it
> when something which could have consumed data has occurred.
> Unfortunately, in the above case, FUSE has no idea what constitutes
> "consume data" but, double unfortunately, it can't take big hammer
> approach (clearing on any access) either, because intervening non-data
> consuming call like 3-2 above would mean that poll() will never
> succeed.
> 
> Because data availability should be determined atomically && only the
> filesystem knows when or how data availability changes, revents return
> from ->poll() must be synchronous.
> 
> We can still use req -> reply approach where there's a flag telling
> the FUSE server whether the request is synchronous or not but at that
> point it seems just obfuscating to me.
> 
> So, ->poll() needs to be the combination of synchronous data
> availability check + asynchronous notification which can be spurious
> to implement the required semantics and I think the original interface
> was much more natural for such functionality.

OK, lets do it with the original interface.  There's still room for
optimization, though, because the _normal_ operation of poll() is
absolutely asynchronous.  I think the 'flags' field in poll_in should
be adequate to make the interface extensible in the future.

Thanks,
Miklos
