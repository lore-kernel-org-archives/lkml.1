Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZCXSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZCXSEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZCXSEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:04:33 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:60224 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbZCXSEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:04:31 -0400
Message-ID: <49C9222E.7090100@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 21:10:54 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Guido_G=FCnther?= <agx@sigxcpu.org>
CC: netdev <netdev@vger.kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Allow group ownership of TUN/TAP devices.
References: <498700CD.2030403@msgid.tls.msk.ru> <20090205105456.GA26440@bogon.ms20.nix>
In-Reply-To: <20090205105456.GA26440@bogon.ms20.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Again, resurrecting an old thread...
  lkml added -- this is a policy issue, so to say]

Guido Günther wrote at Thu, 5 Feb 2009 11:54:57 +0100:
> On Mon, Feb 02, 2009 at 05:18:53PM +0300, Michael Tokarev wrote:
> [..snip..] 
>> My first attempt - pretty obvious when I saw -g option of tunctl - is
>> to add group ownership for the tun device and add a supplementary group
>> to each user (their primary group should be different).  But that fails,
>> since kernel only checks for egid, not any other group ids.

It's a bit worse than that.  I.e., there's exactly 2 problems here.

First, currently tun driver only checks primary gid and not any
supplementary gids (this is what my one-line patch addressed).

And second, if both gid and uid is specified for the given tun
device, BOTH should match.  I.e, I can be "owner"(*) of the device
in question, but if my current gid does not match, I still can't
use it.  This one is interesting: currently, one can grant a tun
device to a given "incarnation" of an uid, that is, suppose we've
two processes running under the same uid but with different gids -
this way, I can grant the device to only one of them.  But here,
why to grant to uid anyway, just use that gid.. I think ;)

(*) note the quotes around "owner" here because, unlike with, say,
files, I can't do anything I want with the network device, I only
have very limited set of operations.

> Since others tripped on this it might make sense to change it to also
> check supplementary groups. However I don't think changing the existing
> syscall is an option since it might allow users to access tun/tap
> devices on existing systems that weren't allowed to do so before (which
> might be a security problem).

And this is the question which's the reason why I added Cc LKML.

My point of view is that it's a bug in original design, it was done
not so long ago (around mid-2007, well, 2+ years isn't that short
anymore, right?), this feature isn't used much currently (because
it's less known than, say, user ownership and because of this very
bug), and because fixing it by introducing another mechanism nearby
is even more ugly (IMHO anyway).

The lack of (wide) usage (or anyway, I think that this feature is
not widely used) -- currently, due to the requirement that it must
be primary group, it's almost impossible to use.  A device gets
granted to a user instead, or the group in question becomes his
primary group, without granting it to others.  In most cases anyway.
This is in addition to the fact that group ownership for a net
device isn't very useful to begin with, because it's not intended
for "collective" use in the first place.

But the question remains -- what to do with this mess.

I almost forgot about this issue, -- I added the patch to the
local kernel package and it worked since.  But today I tried
to compile 2.6.29, the patch didn't apply so I skipped it the
first try, and almost immediately trapped to this issue again,
because my scripts and my kvm stuff stopped working... ;)

Thanks!

/mjt
