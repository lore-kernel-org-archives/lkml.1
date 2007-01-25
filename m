Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXAYTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXAYTrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030535AbXAYTrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:47:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:34847 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXAYTrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SWKaCzhnKKZpNXd6d2c7+Mi4VxxqiLk9JLybQwWaZDsL/gf3M+9opkXU3UWSLfinxx5k5oerZs/3VPYd8Npbl7bnqF1HY7pFISveT2mThyzSFh+702SY5tsbjL2rbXYxceyhIZOBHe925P0LO6aqiqiGSKMgT3XQunjj7QdbB+k=
Message-ID: <fb6b09f20701251147n76388866tb66a825a5f1041c@mail.gmail.com>
Date: Thu, 25 Jan 2007 14:47:15 -0500
From: "Sue Alfano" <smalfano@gmail.com>
To: linux-kernel@vger.kernel.org, "James Chapman" <jchapman@katalix.com>
Subject: Re: uClibc - waitid()
In-Reply-To: <45AFE875.5040204@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb6b09f20701180318i5f3b2785sd7f3f0931808b849@mail.gmail.com>
	 <45AFE875.5040204@katalix.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I'm back.  I didn't get any help from the uClibc folks, but I eventually
figured out how to get to the waitid function in the kernel using the _syscall4
macro and the right header file.  waitid worked great, but then I started
having problems when more than one child needed to be reaped.

Basically, the parent process registers a SIGCHLD signal handler via sigaction()
with the SA_RESTART option and then sits on a timed select().  All the signal
handler does is set a flag - the waitid processing takes place when the parent
drops out of the select because of the signal or a timeout.  When the waitid
succeeds, the pid is used to do some processing and then is used to call
waitpid to clean up the mess.  This is all in a while loop, so when the waitid
is called again, 0 is returned with si_pid = 0 indicating that there are no
more children to reap.  That's all great.  The problem occurs when there's 2
or more children to reap.  When this occurs, the 2nd waitid call returns -1
and si_pid = 0.  The waitid continues to fail in this manner until the parent
receives another SIGCHLD signal, then it works for the next zombie child in
the waiting line, but only one.  I can send SIGCHLD kills to the parent from
the console and eventually get everything cleaned up.  Sending the kill from
the parent isn't enough - I suppose it wants to be blocking on the select.

I tried registering the signal handler without SA_RESRART and also via signal(),
since there was a posting about SA_RESTART, but that made no difference.  I
also tried not having a signal handler at all, but then I couldn't reap any
children on the timeout.

So, are there known issues with waitid when there are multiple children piled
up waiting to be reaped?  If so, is there a patch or a workaround?

The product that I'm working on is using Linux version 2.6.12-2.0.0-258

Thanks for any help,
Sue

On 1/18/07, James Chapman <jchapman@katalix.com> wrote:
> You're asking the wrong list. Try the uClibc list at uclibc.org.
>
> glibc and uClibc provide C APIs to kernel system calls. uClibc doesn't
> implement all features that glibc supports - there are several kernel
> APIs that uClibc doesn't expose. Ask the uClibc folk for advice.
>
> --
> James Chapman
> Katalix Systems Ltd
> http://www.katalix.com
> Catalysts for your Embedded Linux software development
>
