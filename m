Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXBWXtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXBWXtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbXBWXtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:49:36 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:10591 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXBWXtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cZCLmuCw4CslRXdyaAuZ1/j2Bo7Ga+d83A4wBbrEe21bZ7u1Pw4Z10iPy9fZgU8qMkDQMHUju+9PHSd432U7Zk8yUIeSc3KwUIFOnvcDB1O3FLSpOdksf1Z/DrS8LS5gkNYRbNIp5Dq3cPkHPVHrzirs3rnshgz1n7qr2LCLytc=
Message-ID: <f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
Date: Fri, 23 Feb 2007 15:49:30 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu> <20070221233111.GB5895@elte.hu>
	 <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
	 <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
	 <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
	 <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > Do you not understand that real user code touches FPU state at
> > unpredictable (to the kernel) junctures?  Maybe not in a database or a
>
> We don't care. We don't have to care. The kernel threadlets don't execute
> in user space and don't do FP.

Blocked threadlets go back out to userspace, as new threads, after the
first blocking syscall completes.  That's how Ingo described them in
plain English, that's how his threadlet example would have to work,
and that appears to be what his patches actually do.

> > web server, but in the GUIs and web-based monitoring applications that
> > are 99% of the potential customers for kernel AIO?  I have no idea
> > what a %cr3 is, but if you don't fence off thread-local stuff from the
>
> How about you go read the intel architecture manuals then you might know
> more.

Y'know, there's more to life than x86.  I'm no MMU expert, but I know
enough about ARM TLS and ptrace to have fixed ltrace -- not that that
took any special wizardry, just a need for it to work and some basic
forensic skill.  If you want me to go away completely or not follow up
henceforth on anything you write, say so, and I'll decide what to do
in response.  Otherwise, you might consider evaluating whether there's
a way to interpret my comments so that they reflect a perspective that
does not overlap 100% with yours rather than total idiocy.

> Last time I checked glibc was in userspace and the interface for kernel
> AIO is a matter for the kernel so errno is irrelevant, plus any
> threadlets doing system calls will only be living in kernel space anyway.

Ingo's original example code:

long my_threadlet_fn(void *data)
{
       char *name = data;
       int fd;

       fd = open(name, O_RDONLY);
       if (fd < 0)
               goto out;

       fstat(fd, &stat);
       read(fd, buf, count)
       ...

out:
       return threadlet_complete();
}

You're telling me that runs entirely in kernel space when open()
blocks, and doesn't touch errno if fstat() fails?  Now who hasn't read
the code?

Cheers,
- Michael
