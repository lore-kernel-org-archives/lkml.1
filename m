Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYH3Lmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYH3Lmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYH3Lmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:42:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYH3Lme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:42:34 -0400
Message-ID: <48B931B4.1030606@kernel.org>
Date: Sat, 30 Aug 2008 13:40:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, Serge Hallyn <serue@us.ibm.com>,
       greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<1219945263-21074-6-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>
In-Reply-To: <m163pjr5qf.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 11:41:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> Implementation wise it is not too bad.
> 
>            FUSE ----------------
> pid = get_pid(task_tid(current))
>             ^                   |
>             |                   |        kernel
>                           pid_vnr(pid)
>    ------ ioctl ----------- /dev/fuse ------------
>             |                   |       userland
>             |                   v
>      ---------------      -------------
>     | caller        |    | FUSE server |---> reads and writes
>     | with tid CTID |    |             |    /proc/PID/task/TID/mem
>      ---------------      -------------

Ah hah.. thanks for the info.

> However it is a largely an insane idea.
> - Write is not implemented for /proc/PID/task/TID/mem
> - It would be better if the kernel handed you back a file descriptor to the
>   other process memory rather than you having to generate one.

Yeah, that would at least ensure we're not meddling with the wrong
address space.

> - To access /proc/PID/task/TID/mem you need to have CAP_PTRACE.
> - This seems to allow for random ioctls.  With the compat_ioctl
>   thing we have largely stomped on that idea.  So you should only
>   need to deal with well defined ioctls.  At which point why do you
>   need to directly access the memory of another process.

What do you mean by "compat_ioctl" thing?  We still allow random
memory accesses to ioctls.

> So why not just only support well defined ioctls and serialize them
> in the kernel and allow the receiving process to deserialize them?

Yeap, that certainly is an option.

> That would allow all of this to happen with a non-privileged server which
> makes the functionality much more useful.

When !allow_others, there's no reason to prevent one user's FUSE
server to corruption the user's processes.  Everyone has the innate
right to shoot him/herself in the foot.

> Given the pain it is to maintain ioctls I would be very surprised if
> we wanted to open up that pandoras box even wider by allowing
> arbitrary user space processes to support random ioctls.  How would
> you do 32/64bit support and the like?

32/64bit is not really much problem tho.  The kernel just flags the
request as-such and let the userland deal with it.

Miklos, I think Eric's reply pretty much blew the direct access idea
out of water, which leaves us with three options.

1. Support only the proper ioctls.  This would be the simplest but
   someone might run into its limitations in the future.  Given that
   the most probable use cases for CUSE are replacing in-kernel legacy
   code or faking some proprietary interfaces which are likely to be
   somewhat weird, the chance isn't too low IMHO.

2. Do what hpa suggested, that is a simple language to describe the
   needed data regions.  To me, it seems like an overkill.  If there's
   already such infrastructure in kernel, I would be happy to
   piggyback on it but separate serialization language for FUSE ioctl
   support seems extreme.

3. And my favorite (obviously), keep the current implementation.  Ugly
   it may look but given the horror of the problem at hand I think it
   actually hits a pretty good balance between interface peculiarness
   and complexity that a more elegant solution would require.  It's
   only ~250 lines of code which can support any ioctl.  Complex ones
   will have to go through a few duplicate copy operations but I don't
   really think those are gonna hurt anyone when the whole thing is
   being relayed to userland.

So, what do you think?

Thanks.

-- 
tejun
