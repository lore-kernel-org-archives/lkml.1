Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYKRDcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYKRDcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYKRDcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:32:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:58305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYKRDcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:32:35 -0500
Message-ID: <4922373F.90105@kernel.org>
Date: Tue, 18 Nov 2008 12:32:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCHSET] FUSE: extend FUSE to support more	operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<48F4568B.7000609@kernel.org>	<E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>	<491BC87F.4050108@kernel.org>	<E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu>	<491C1588.2060907@kernel.org>	<E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu>	<E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu>	<491C2A63.1030804@kernel.org>	<E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu>	<491C39BD.8050108@kernel.org>	<E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu>	<491C436C.6060603@kernel.org>	<E1L0eUz-0007D0-Tp@pomaz-ex.szeredi.hu> <492136A8.5020908@kernel.org> <E1L219j-0006iL-AJ@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L219j-0006iL-AJ@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Nov 2008 03:32:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> OK, lets do it with the original interface.  There's still room for
> optimization, though, because the _normal_ operation of poll() is
> absolutely asynchronous.

Hmm... I'm not sure I understand what you're saying but if you're
talking about optimizing async case where notification occurs while the
poller is sleeping, I don't think it really matters.  That could be
common but they're not performance sensitive path.  As select/poll users
become busy, ->poll operation becomes more and more synchronous.

If the client is using better interface like epoll, sending revents via
notification could help a bit but again the problem is that the ->poll
vfs interface is not ready for that.  e.g. How do you tell whether
->poll is for epoll polling after the notification or an asynchronous
poll(2) being called after a read(2) after the notification arrived.
There simply isn't enough information to determine when the cached
revents (no matter how short the period of caching is) can be used or
not.  One thing we can do is to invalidate the received revents value on
every file operation and then reverting to synchronous call only when
cached revents is not available, but I don't really see good
justifications for such over complexity.

Thanks.

-- 
tejun
