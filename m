Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYH2INt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYH2INt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYH2INe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYH2INc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:13:32 -0400
Message-ID: <48B7AF60.8040709@kernel.org>
Date: Fri, 29 Aug 2008 10:12:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 08:13:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Fri, 29 Aug 2008, Tejun Heo wrote:
>> I'm not worried about the client accessing wrong memory regions or even
>> corrupting it.  It's pointless to try to protect against that.  From the
>> calling process's POV, it runs the same risk whether it calls an
>> in-kernel ioctl or a CUSE one and FUSE already has sufficient protection
>> against allowing unprivileged FS implementation to serve other users.
> 
> Yes and no.  Fuse allows this protection to be relaxed
> (-oallow_other), because it does provide quite good privilege
> separation.  This ioctl thing breaks that, so we should disable ioctls
> with 'allow_other' or require the filesystem to be privileged.  But
> the latter is not easy because mount(2) is always privileged, we don't
> know if the process calling fusermount was privileged or not.
> 
> So, your current patch actually _introduces_ a security vulnerability
> with the 'allow_other' mount option.

Ah.. right.  allow_other.  Yeah, restricting ioctl implementation only
to root or !allow_other sounds like a good idea.

>> What I'm worried about is the possibility of CUSE client being able to
>> break out of that privilege protection which is currently ensured by the
>> kernel.
> 
> What do you call client?  If you mean the app using the char dev, then
> I don't see how it could break out of any protection.

I first used 'server' for userland [FC]USE server but then I noticed
there were places in FUSE they were referred as clients so now I use
'client' for those and call the app using the FUSE fs the 'caller'.
What are the established terms?

Anyways, doing it directly from the server (or is it client) opens up a
lot of new possibilities to screw up and I'd really much prefer staying
in similar ballpark with other operations.  Maybe we can restrict it to
two stages (query size & transfer) and linear consecutive ranges but
then again adding retry doesn't contribute too much to the complexity.
Oh.. and BTW, the in-ioctl length coding is not used universally, so it
can't be depended upon.

>>  Also, what about containers?  How would it work then?
> 
> Dunno.  Isn't there some transformation of pids going on, so that the
> global namespace can access pids in all containers but under a
> different alias?  I do hope somethinig like this works, otherwise it's
> not only fuse that will break.

I'm not sure either.  Any idea who we should be asking about it?

Thanks.

-- 
tejun
