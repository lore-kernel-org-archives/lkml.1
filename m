Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXK0BYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXK0BYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXK0BXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:23:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXK0BXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:23:52 -0500
Message-ID: <474B7175.3030002@zytor.com>
Date: Mon, 26 Nov 2007 17:23:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <474B1C6D.6080405@zytor.com> <474B55F5.1050706@redhat.com> <474B6179.4040508@zytor.com> <474B6810.6070703@redhat.com>
In-Reply-To: <474B6810.6070703@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> H. Peter Anvin wrote:
>> No.
>>
>> I already said I'm not looking at changing the calling convention for
>> existing syscalls.
> 
> I did not suggest or ask for that at all.
> 
> I was asking you to consider the real implementation details for a new
> syscall mechanism.
> 
> We do not want to abandon the use of syscall/sysenter and go back to int
> (on x86/x86-64).  This means that you have to come up with a mechanism
> which hooks into the current syscall/sysenter path while preserving full
> backward compatibility.
> 
> Now it's your turn.  How do you do this without additional costs?
> 

- Add sys_new_call to the syscall table
- Create a stub thunk:

asmlinkage long sys_old_call(long parm1, long parm2, long parm3)
{
	return sys_new_call(parm1, parm2, parm3, 0);
}

We have 2^n examples on this in the kernel already.

Or, if the new syscall requires more than 6 parameters (with the current 
convention):

asmlinkage long sys_new_call6(long parm1, long parm2, long parm3,
			      long parm4, long parm5,
			      long __user *additional)
{
	long xparm[3];	/* 8 parameters, total */

	if (copy_from_user(xparm, additional, sizeof xparm)
	    != sizeof xparm)
		return -EFAULT;

	return sys_new_call(parm1, parm2, parm3, parm4, parm5,
			    xparm[0], xparm[1], xparm[2]);
}

This is a fixed-size copy from userspace, which obviously cannot be avoided.

The C version isn't optimal, obviously, hence my mentioning the 
possibility of doing it in the arch layer.

	-hpa
