Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYLZSsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYLZSsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYLZSs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:48:29 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:47890 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYLZSs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:48:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1IAEK1VEnVQJ+/PGdsb2JhbACBbIceilgBAQEBNQGpN1iPGIZE
Message-ID: <495526F6.9040704@zappa.cx>
Date: Fri, 26 Dec 2008 19:48:22 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu>
In-Reply-To: <20081226182145.GP9871@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Hmm... ok, to summarize, you are seeing this problem with 2.6.28 (have
> you tried earlier kernel versions) when an LVM volume has a read/only
> snapshot in existence and you try to mount the LVM volume using ext4.
> If you mount the same LVM volume using ext3, you don't see any
> problems.   Is that correct?
>   
Correct, and I have not been using barriers with any earlier kernel.
I stumbled upon this because barriers are enabled by default in ext4.
> Can you try mounting ext3 with barriers enabled?  Booting with the
> command linux option rootflags=barriers should do the trick.  If that
> fails, then it would indicate that trying to enable barriers in a Xen
> guest while the host OS has created a snapshot of volume causes an I/O
> error, thus leading errors which you are seeing.
>
> 						- Ted
>   
Yes, I mounted it with ext3 and barrier=1 and could reproduce the problem.
ext3 did not remount the fs ro though, it seems to only disable barriers:

[    7.681759] blkfront: xvda1: write barrier op failed
[    7.681776] blkfront: xvda1: barriers disabled
[    7.681785] end_request: I/O error, dev xvda1, sector 4584
[    7.681800] end_request: I/O error, dev xvda1, sector 4584
[    7.681886] JBD: barrier-based sync failed on xvda1 - disabling barriers

And then I tested with ext4 and barrier=0 and that also works.

I don't know if this is expected behaviour or not or if it's worth
looking into.
I just wanted to report back what I saw. For me personally it's no issue.
I'll be using ext4 without barriers for a while and see how it goes.

But I'm here if you want something tested or a patch verified or anything,
but I guess this might be a Xen issue rather than vanilla kernel stuff.

Thanks for helping out with the narrowing down of the issue

/Andreas
