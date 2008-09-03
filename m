Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYICVyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYICVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYICVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:54:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35854 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYICVyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:54:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>
	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>
	<E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu> <48BBD9F5.8060906@kernel.org>
	<m163pdb8qx.fsf@frodo.ebiederm.org> <48BEA1D8.9040208@kernel.org>
Date: Wed, 03 Sep 2008 14:51:10 -0700
In-Reply-To: <48BEA1D8.9040208@kernel.org> (Tejun Heo's message of "Wed, 03
	Sep 2008 16:40:24 +0200")
Message-ID: <m1sksg6gq9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0251]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> I really think that if an ioctl is passing through the kernel we
>> should know how to parse and understand it's options.  Otherwise
>> we won't have the option of doing backwards compatibility when something
>> changes, like we can with the 32->64bit ioctls.
>
> There's no reason 32->64bit can't be handled in userland?  What's the
> difference?

Maintenance.  What happens if I go 128bit, if I have some processes
that are big endian and some that are little endian.  Or if I have
some processes that are running a completely different instruction
set with a completely different ABI than other processes.  Or
perhaps different perhaps the processes is in a different network
namespace than your filesystem and so it's arguments refer
to something different entirely.  Is it a userspace bug if userspace
does not anticipate how the kernel will change in the future?

If we don't look at ioctl as a set of system calls that should
be put into an appropriate format for a filesystem we have
a maintenance problem.

If we don't have an interface clean enough we can push data
out to a server on a remote machine have it processes the
arguments and send the data back.  We actually have failed
to properly abstract the interface.

>> That seems to imply that you need a stub in the kernel to handle 
>> really weird ioctls.
>> 
>> The upside is that because you know what the inputs and outputs are
>> and where the inputs and output are you can support that ioctl well
>> into the future, and you can do it with an unprivileged file
>> system server.
>
> Well, kernel stub kind of beats a lot of benefits of FUSE - no
> specific kernel dependencies, easy development and distribution,
> etc...

Of course FUSE has specific kernel dependencies.  It depends
on the implementation of fusefs in the kernel to talk to it.
The reason you don't need a specific kernel today is that
the kernel dependencies are well defined.  You are talking
about using a very poorly defined interface to talk to the
filesystem.  At which point it would be better to open
a separate channel and talk to the filsystem directly.

Being able to add a kernel system call (ioctl) with no review is a
total maintenance disaster.  It is impossible to maintain because
there is not a process to even discover what is going on.

We have to have a kernel stub to support other system calls
and I don't see why individual ioctls should be different.

If you want to support forwards compatibility reserving
some ioctl numbers and saying these numbers will always
be parsed this way.  Which would allow you to write
a common stub that can be implemented before the ioctls
are implemented.

If you really don't want new kernel dependencies you can hook up to
the process via ptrace and intercept the ioctls before they even get
to the kernel.  If you can open /proc/<pid>/mem you have the rights
to ptrace the process.

Eric
