Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXBYXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXBYXOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965217AbXBYXOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:14:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:5702 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbXBYXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NZAyOmXX19AvMZZ7WQJny0v2ExhF7ZomeGcg2OUY/QGRUyZFzeNfkaOJgl3KgnGhI74PMEXV5bPE7BYo3gI82aVGjtPt9CE3lnCkD89SeGXf/5AqjAYk4yzkCO0ztgGFlLggCgcD2jb34OMB8JL/BBicbeFgmP6e+DR9MWmVrUo=
Message-ID: <f2b55d220702251514y2531931ag8fe880b9b1402361@mail.gmail.com>
Date: Sun, 25 Feb 2007 15:14:11 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070225190414.GB6460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221233111.GB5895@elte.hu> <20070222074044.GA4158@elte.hu>
	 <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
	 <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu>
	 <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu>
	 <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> Fundamentally a kernel thread is just its
> EIP/ESP [on x86, similar on other architectures] - which can be
> saved/restored in near zero time.

That's because the kernel address space is identical in every
process's MMU context, so the MMU doesn't have to be touched _at_all_.
 Also, the kernel very rarely touches FPU state, and even when it
does, the FXSAVE/FXRSTOR pair is highly optimized for the "save state
just long enough to move some memory around with XMM instructions"
case.  (I know you know this; this is for the benefit of less
experienced readers.)  If your threadlet model shares the FPU state
and TLS arena among all threadlets running on the same CPU, and
threadlets are scheduled in bursts belonging to the same process (and
preferably the same threadlet entrypoint), then you will get similarly
efficient userspace threadlet-to-threadlet transitions.  If not, not.

> scheduling only relates to the minimal context that is in the CPU. And
> most of that context we save upon /every system call entry/, and restore
> it upon every system call return. If it's so expensive to manipulate,
> why can the Linux kernel do a full system call in ~150 cycles? That's
> cheaper than the access latency to a single DRAM page.

That would be the magic of shadow register files.  When the software
does things that hardware expects it to do, everybody wins.  When the
software tries to get clever based on micro-benchmarks, everybody
loses.

Cheers,
- Michael
