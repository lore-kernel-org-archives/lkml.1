Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYFPQZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYFPQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYFPQZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:25:49 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60410
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYFPQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:25:48 -0400
Date: Mon, 16 Jun 2008 18:25:44 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ivana Varekova <varekova@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: Re: PR_SET_SECCOMP and PR_GET_SECCOMP doc (and bug?)
Message-ID: <20080616162543.GA9552@duo.random>
References: <48565951.40603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48565951.40603@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jun 16, 2008 at 02:15:13PM +0200, Michael Kerrisk wrote:
> Andrea,
> 
> Below is my attempt to document the SECCOMP prctl() operations that you added
> in 2.6.23.  Could you please read, and let me know if I have the details
> correct.  Especially take a look at the description of PR_GET_SECCOMP, whose
> operation tends to suggest a thinko:

thanks for this useful doc effort!

> 
>     PR_SET_SECCOMP (since Linux 2.6.23)
>         Set the secure computing mode for the calling  thread.   In
>         the  current  implementation,  arg2  must  be 1.  After the
>         secure computing mode has been set to 1,  the  only  system
>         calls  that  the  thread  is permitted to make are read(2),
>         write(2), _exit(2), and sigreturn(2).  Other  system  calls
>         result in the delivery of a SIGKILL signal.  Secure comput-
>         ing mode is useful for number-crunching  applications  that
>         may  need  to execute untrusted byte code, perhaps obtained
>         by reading from a pipe or socket.  This operation  is  only
>         available  if  the kernel is configured with CONFIG_SECCOMP
>         enabled.
> 
>     PR_GET_SECCOMP (since Linux 2.6.23)
>         Return the secure computing mode  of  the  calling  thread.
>         Not  very  useful: if the caller is not in secure computing
>         mode, this operation returns 0; if the caller is in  secure
>         computing  mode, then the prctl() call will cause a SIGKILL
>         signal to be sent to the process.  This operation  is  only
>         available  if  the kernel is configured with CONFIG_SECCOMP
>         enabled.
> 
> Have I misunderstood something?  Surely it is not really intended that

No, the above is exactly correct.

> PR_GET_SECCOMP be this useless?  The alternatives that I can think of would be
> that

I thought that registering a PR_GET_SECCOMP next to the SET operation
was nicer in case future modes > 1 will allow to enable/disable more
syscalls on demand (so including prctl), if you see the prctl.h file
has get/set and read/drop for all other prctl so retaining that
symmetry looked natural. However I tend to agree that currently
PR_GET_SECCOMP is mostly useless, so perhaps it was better not to
register it at all but it doesn't really make any practical
difference.

> a) at least the call prctl(PR_GET_SECCOMP) would be among the set of permitted
> syscalls in secure computing mode, or

It's very intentional that prctl isn't one of the permitted syscalls
with mode=1. Future modes may vary.

> b) there shouldn't be a prctl(PR_GET_SECCOMP) at all.

I'm not against if somebody wants to nuke GET_SECCOMP, I'm neutral on
this, but it doesn't really waste anything relevant and at least to
me, it looked cleaner to have it even if not useful with current
mode=1.
