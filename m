Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYIDAMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYIDAMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYIDAL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:11:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYIDAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:11:58 -0400
Message-ID: <48BF2757.3090805@kernel.org>
Date: Thu, 04 Sep 2008 02:09:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>	<E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu> <48BBD9F5.8060906@kernel.org>	<m163pdb8qx.fsf@frodo.ebiederm.org> <48BEA1D8.9040208@kernel.org> <m1sksg6gq9.fsf@frodo.ebiederm.org>
In-Reply-To: <m1sksg6gq9.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Sep 2008 00:11:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Maintenance.  What happens if I go 128bit, if I have some processes
> that are big endian and some that are little endian.  Or if I have
> some processes that are running a completely different instruction
> set with a completely different ABI than other processes.  Or
> perhaps different perhaps the processes is in a different network
> namespace than your filesystem and so it's arguments refer
> to something different entirely.  Is it a userspace bug if userspace
> does not anticipate how the kernel will change in the future?

What I don't see is how anything becomes different whether that part
is implemented in kernel or not.  For ioctls, only the implementing
code knows what the data structure should look like that's why we
can't handle 64/32 bit problems generically and has ->compat_ioctl
hook.  To me, splitting it to two pieces looks like more maintenance
overhead than the other way around.

> If we don't look at ioctl as a set of system calls that should
> be put into an appropriate format for a filesystem we have
> a maintenance problem.
>
> If we don't have an interface clean enough we can push data
> out to a server on a remote machine have it processes the
> arguments and send the data back.  We actually have failed
> to properly abstract the interface.

I don't think that's a possible goal in generic manner.  We can't even
do that for read/writes.  At least not at FUSE's level.  We need
higher abstraction for that.  e.g. /dev/oss via CUSE, ioctl specified
machine endian 16bit format.  Supporting that in the way you described
would require a lot of logic in the kernel and I don't really see any
benefit over, say, forward the sound via pulseaudio after getting it
to userland.  I don't think the problem can or should be solved at
FUSE interface level.

>> Well, kernel stub kind of beats a lot of benefits of FUSE - no
>> specific kernel dependencies, easy development and distribution,
>> etc...
> 
> Of course FUSE has specific kernel dependencies.  It depends
> on the implementation of fusefs in the kernel to talk to it.
> The reason you don't need a specific kernel today is that
> the kernel dependencies are well defined.  You are talking
> about using a very poorly defined interface to talk to the
> filesystem.  At which point it would be better to open
> a separate channel and talk to the filsystem directly.

The difference is that FUSE servers depend on FUSE and each server
doesn't require separate new pieces to get working and ioctl is poorly
defined by nature.

> Being able to add a kernel system call (ioctl) with no review is a
> total maintenance disaster.  It is impossible to maintain because
> there is not a process to even discover what is going on.

How about adding whole FSes w/o a review?  That's the whole point of
FUSE.  Seriously, there are infinite number of ways to break the
regular defined filesystem semantics using FUSE.  FUSE should provide
mechanism and protects against certain fundamental things.  It can't
enforce correct semantics on everything.

> We have to have a kernel stub to support other system calls
> and I don't see why individual ioctls should be different.
> 
> If you want to support forwards compatibility reserving
> some ioctl numbers and saying these numbers will always
> be parsed this way.  Which would allow you to write
> a common stub that can be implemented before the ioctls
> are implemented.

ioctls is most likely to be used to emulate legacy or proprietary
devices.  If you're worried about filesystems abusing it, maybe the
solution is to only allow CUSE to use ioctls but I really don't see
what the problem is here.  If the userland FS server wants to shoot
itself in the foot, it's not really the kernel's problem.

> If you really don't want new kernel dependencies you can hook up to
> the process via ptrace and intercept the ioctls before they even get
> to the kernel.  If you can open /proc/<pid>/mem you have the rights
> to ptrace the process.

Aieee.. The same goes for the whole FUSE.

Thanks.

-- 
tejun
