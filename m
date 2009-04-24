Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZDXGYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZDXGYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDXGYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:24:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZDXGX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:23:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: SIGSTOP && ptrace (Was: ptrace(PTRACE_SYSCALL/CONT/DETACH, ...,
	SIGSTOP) does not work)
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 16:26:27 +0200 <20090423142627.GA31572@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com>
	<20090423142627.GA31572@redhat.com>
X-Zippy-Says: I'm not available for comment..
Message-Id: <20090424062354.A1F88FC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 23:23:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > IOW: strace does NOT want to see this signal reported back to strace -
> > it already saw that, what's the point in seeing it again?
> 
> As I said many times, the second report is not about the signal, it
> reports that the group-stop is completed.

Oleg is correct.  The "second" report, is not "WIFSTOPPED means a ptrace
stop".  It is "WIFSTOPPED means a job control stop".  This is not meant as
a notification to tracer, but a notification to parent.  In case of
PTRACE_ATTACH, this is "unnatural" because the tracer steals the parent's
notifications, but that's just the known crime against nature that is
ptrace semantics.

> I guess, you don't like the fact that finish_stop() always clear ->exit_code
> after wake up. This is why the next ptrace(PTRACE_SYSCALL, SIGSTOP) (called
> when the tracee sleeps in finish_stop) "loses" SIGSTOP.
> 
> I can't say if this really right or not, but I guess it is too late to
> change this behaviour. I may be wrong.

I agree it's unfortunate.  But TBH it's more unfortunate that PTRACE_CONT
et al are allowed here at all.  It's a job control stop, and if the world
were right then it would only be broken by SIGCONT.  But Oleg is right,
it's too late to change it now.  Them's the semantics.

> Perhaps, you should ask how strace can distinguish between "SIGSTOP
> recieved" and "group-stop completed". I am not 100% sure, but at first
> glance this looks possible.

It is, but it's easier than the hack you suggest.  PTRACE_GETSIGINFO only
works for a ptrace stop, not a job control stop.  If wait reported SIGSTOP,
PTRACE_GETSIGINFO will fail with EINVAL for a job control stop but will
succeed for a ptrace stop.


Thanks,
Roland
