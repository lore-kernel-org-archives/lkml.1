Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZH1HD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZH1HD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZH1HD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:03:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZH1HD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:03:27 -0400
Message-ID: <4A9780EF.1030102@kernel.org>
Date: Fri, 28 Aug 2009 16:02:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dhowells@redhat.com
Subject: Re: [PATCH 0/3] Convert libata pio task to slow-work
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <4A967DD7.20603@kernel.org> <20090827124927.GJ12579@kernel.dk> <4A96830F.9040805@kernel.org> <20090827184939.GK12579@kernel.dk>
In-Reply-To: <20090827184939.GK12579@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 07:02:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
>> Almost all operations are per-cpu so cache lines shouldn't bounce too
>> much.  The only part I worry about is the part which checks whether a
>> work is currently executing on the current cpu which currently is
>> implemeted as a hash table.  The hash table is only 16 pointers long
>> and will be mostly empty so hopefully it doesn't add any significant
>> overhead.
> 
> OK, we'll let time and experimentation be the judge.

Yeap.

>>> Care to post it? I know you don't think it's perfect yet, but it would
>>> make a lot more sense to throw effort into this rather than waste time
>>> on partial solutions.
>> I have this printed out code with full of red markings from proof
>> reading and flush implementation is mostly broken.  Please give me a
>> couple of days.  I'll post a rough unsplit version which at least
>> compiles with the planned changes applied by the end of the week.  :-)
> 
> Alright, fair enough.
> 
> One question - do the 'exposed' workqueues (the ones that drivers
> allocate/create) sitting in front of the global cpu queue allow more
> than one thread per cpu, or is that property retained for the global cpu
> queue (where it is a necessity)?

The exposed workqueues basically just play the gateway and don't have
threads associated with it, well, at least not the normal ones.  It
may have single dedicated thread which usually isn't used but only
gets summoned when a queue stall is detected (new thread needs to be
created but blocks on allocation kind of situation).  So, only the
global cpu queue has normal workers and there are multiple per cpu and
they're shared by all exported workqueues.

Thanks.

-- 
tejun
