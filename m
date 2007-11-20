Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbXKTXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbXKTXmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXKTXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:42:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbXKTXmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:42:21 -0500
Date: Wed, 21 Nov 2007 00:41:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zach Brown <zach.brown@oracle.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
Message-ID: <20071120234151.GD23667@elte.hu>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com> <20071120222227.GH24156@elte.hu> <47436D07.2070203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47436D07.2070203@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> Why not just pin down the current ABI that there's 6 syscall 
>> parameters _and not more_?
>
> Because we have already violated it.  There are system calls that need 
> more than 6 arguments: we need *a* convention.  Worse, we're not 
> actually talking 6 *arguments*, we're talking 6 *words*; on 32-bit 
> platforms a single argument can occupy two words.

i think you are at least partly wrong here. Multiplexing/demultiplexing 
can go on infinitely - for example sys_write(fd, size, buf) can be 
thought of as a function call that passes in fd, size and a variable 
number of arguments of the data to be written.

in that sense capping function arguments at 6 is _sensible_ because it 
prefers _simple_ interfaces. When i wrote syslets i did a syscall number 
of arguments histogram:

  #args   #syscalls
  -----------------
      0       22
      1       51
      2       83
      3       85
      4       40
      5       23
      6        8


Fortunately what we see today is that 80% of all syscalls have 4 or less 
parameters. (yes, there are a few 6-parameter syscalls that arguably 
hurt, but still, it's the exception not the rule)

this histogram shows a healthy bell curve which is _not_ limited by the 
arguments limit of 6, but by common sense! If the 6-arguments limit was 
a problem then we'd see a pile-up of 6-param syscalls.

so i believe you should start thinking about lots-of-arguments syscalls 
as an exception not as something that needs to fit into some generic 
ABI. (Especially as most schemes that were supposed to handle this 
problem would hurt the sane 4-parameter (or less) syscall case too.)

	Ingo
