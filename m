Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXCASRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXCASRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965480AbXCASRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:17:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbXCASRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:17:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=gh8P0QOMbpgLSkKmLKBLrRRZZ2JIPzE4s/dexiafYmmB6Rd0oZdYAmlxV633wr2+U
	v3uMulcrhKfvgPBT7G7rQ==
Message-ID: <45E71875.4010209@google.com>
Date: Thu, 01 Mar 2007 10:16:21 -0800
From: Markus Gutschke <markus@google.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
CC: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
References: <45D5B2E3.3030607@hitachi.com> <45DFB1C7.1030205@google.com> <45E6C888.4050300@hitachi.com>
In-Reply-To: <45E6C888.4050300@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro wrote:
> Requirements are:
>   (1) a user can change the core dump settings _anytime_
>       - sometimes want to dump anonymous shared memory segments and
>         sometimes don't want to dump them

I might not have been sufficiently clear about this in my previous 
e-mail. Currently, the Google coredumper does not have the feature that 
you asked about, but adding it would be trivial -- it just hadn't been 
needed, yet, as on-the-fly compression was good enough for most users.

Answering your question, I don't see any reason why the new API would 
not be able to make changes at any time.

>   (2) a user can change the core dump settings of _any processes_
>       (although permission checks are performed)
>       - in a huge application which forks many processes, a user
>         hopes that some processes dump anonymous shared memory
>         segments and some processes don't dump them

The Google coredumper is a library that needs to be linked into the 
application and needs to be called from appropriate signal handlers. As 
such, it is the application's responsibility what management API it 
wants to expose externally, and what tools it wants to provide for 
managing a group of processes.

> And reliability of the core dump feature is also important.

We have generally had very good reliability with the Google coredumper. 
In some cases, it even works a little more reliably than the default 
in-kernel dumper (e.g. because we can control where to write the file, 
and whether it should be compressed on-the-fly; or because we can get 
multi-threaded coredumps even in situations where the particular 
combination of libc and kernel doesn't support this), and in other cases 
the in-kernel dumper works a little better (e.g. if an application got 
too corrupted to even run any signal handlers).

Realistically, it just works. But we did have to make sure that we set 
up alternate stacks for signal processing, and that we made sure that 
these stacks have been dirtied in order to avoid problems with memory 
overcomitting.

> And all the software vendors don't necessarily apply
> google-coredumper.  If the vendor doesn't apply it, the user will
> be bothered by huge core dumps or the buggy application which
> remains unfixed.  So I believe that in kernel solution is still
> needed.

I agree that the Google coredumper is only one possible solution to your 
problem. Depending on how your production environment looks like, it 
might help a lot, or it might be completely useless.

If it is cheap for you to modify your applications, but expensive to 
upgrade your kernels, the Google coredumper is the way to go. Also, if 
you need the extra features, such as the ability to compress core files 
on-the-fly, or the ability to send corefiles to somewhere other than an 
on-disk file, you definitely should look at a user-space solution. On 
the other hand, if you can easily upgrade all your kernels, but you 
don't even have access to the source of your applications, then an 
in-kernel solution is much better.


Markus
