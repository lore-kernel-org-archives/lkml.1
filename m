Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXE3UgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXE3UgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXE3UgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:36:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbXE3UgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:36:12 -0400
Date: Wed, 30 May 2007 13:31:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mark Lord <lkml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DD97D.9010807@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0705301327090.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org>
 <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
 <20070530160913.GA14261@elte.hu> <465DCAE4.1010206@rtr.ca>
 <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
 <465DD97D.9010807@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Eric Dumazet wrote:
> 
> So yes, reimplement sendfile() should help to find last splice() bugs, and as
> a bonus it could add non blocking disk io, (O_NONBLOCK on input file ->
> socket)

Well, to get those kinds of advantages, you'd have to use splice directly, 
since sendfile() hasn't supported nonblocking disk IO, and the interface 
doesn't really allow for it.

In fact, since nonblocking accesses require also some *polling* method, 
and we don't have that for files, I suspect the best option for those 
things is to simply mix AIO and splice(). AIO tends to be the right thing 
for disk waits (read: short, often cached), and if we can improve AIO 
performance for the cached accesses (which is exactly what the threadlets 
should hopefully allow us to do), I would seriously suggest going that 
route.

But the pure "use splice to _implement_ sendfile()" thing is worth doing 
for all the other reasons, even if nonblocking file access is not likely 
one of them.

		Linus
