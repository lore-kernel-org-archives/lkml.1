Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYH2CU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYH2CU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYH2CUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:20:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:40245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYH2CUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:20:17 -0400
Message-ID: <48B75C94.7030604@kernel.org>
Date: Fri, 29 Aug 2008 04:19:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 02:20:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> Another thing is that as it currently stands, the kernel side FUSE
>> implementation forms a nice safety net taking responsibility of most
>> security concerns and insulating the mistakes the client may make.
>> Letting userland client to access and possibly modify the caller's
>> memory directly weakens that insulation.
> 
> The same stupid mistakes can be done by giving the wrong instructions
> to the kernel about what to modify, thus thrashing the calling
> process.

Yeah, ioctl, by design, has that potential.  Whether it's implemented in
kernel or userland, it's gonna access arbitrary memory regions from deep
down the implementation, and it can corrupt things, but by giving the
responsibility to move data to kernel part of FUSE, we can at least
guarantee that it's only gonna ruin the calling address space even when
it screws up and when that happens it will be easy to track down by
tracing the communication between the kernel and FUSE client.

>> Pushing memory access to userland feels a bit too risky to me.  There
>> seem to be too many loose components in security sensitive path and I
>> have a nagging feeling that someone will come up with something we can't
>> think of at the moment.
> 
> I don't see the difference.  You have to be careful either way, it's
> not possible to do ioctls safely as the rest of fuse unfortunately.
> This obviously also means, that it's impossible to run the filesystem
> as an unprivileged user, as it has to have access to the whole address
> space of the calling process either way (or ioctls have to be
> restricted somehow).

I'm not worried about the client accessing wrong memory regions or even
corrupting it.  It's pointless to try to protect against that.  From the
calling process's POV, it runs the same risk whether it calls an
in-kernel ioctl or a CUSE one and FUSE already has sufficient protection
against allowing unprivileged FS implementation to serve other users.

What I'm worried about is the possibility of CUSE client being able to
break out of that privilege protection which is currently ensured by the
kernel.  Also, what about containers?  How would it work then?

Thanks.

-- 
tejun
