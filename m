Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYH2H7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYH2H7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYH2H7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:59:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39663 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYH2H7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:59:37 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <48B75C94.7030604@kernel.org> (message from Tejun Heo on Fri, 29
	Aug 2008 04:19:00 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org>
Message-Id: <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Aug 2008 09:59:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Tejun Heo wrote:
> I'm not worried about the client accessing wrong memory regions or even
> corrupting it.  It's pointless to try to protect against that.  From the
> calling process's POV, it runs the same risk whether it calls an
> in-kernel ioctl or a CUSE one and FUSE already has sufficient protection
> against allowing unprivileged FS implementation to serve other users.

Yes and no.  Fuse allows this protection to be relaxed
(-oallow_other), because it does provide quite good privilege
separation.  This ioctl thing breaks that, so we should disable ioctls
with 'allow_other' or require the filesystem to be privileged.  But
the latter is not easy because mount(2) is always privileged, we don't
know if the process calling fusermount was privileged or not.

So, your current patch actually _introduces_ a security vulnerability
with the 'allow_other' mount option.

> What I'm worried about is the possibility of CUSE client being able to
> break out of that privilege protection which is currently ensured by the
> kernel.

What do you call client?  If you mean the app using the char dev, then
I don't see how it could break out of any protection.

>  Also, what about containers?  How would it work then?

Dunno.  Isn't there some transformation of pids going on, so that the
global namespace can access pids in all containers but under a
different alias?  I do hope somethinig like this works, otherwise it's
not only fuse that will break.

Miklos
