Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbXJOXTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbXJOXTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXJOXSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:18:53 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:40000 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752973AbXJOXSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:18:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tovUEqy0xRtv1ujbjFnvqSPRuCFq+iSdS9TVDeBu4V+b1QxE+xwOjKbgWZdeZfpMiSFrsQR7Tr+MH/cFvE2Fso3zquUd/LsQaU7B8oZPJdwMo9p5rqNs+/Ekr2Eu4s3zRrbniAtQPVJfSKld1yBQMqFPTeYnH4tDBHOIqtYiiS8=  ;
X-YMail-OSG: qUwU8EYVM1np_Tg6XqM4wTnwCtTZYVfZN_dMROdB5RtsX52BwtLxLIiHduoocP_VIvvs3KzKMg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
Date: Tue, 16 Oct 2007 11:46:33 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
References: <1192451324.27435.71.camel@twins> <20071011213126.cf92efb7.akpm@linux-foundation.org> <21859.1192457172@redhat.com>
In-Reply-To: <21859.1192457172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161146.33508.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 00:06, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> > I get funny SIGBUS' like so:
> >
> > fault
> >   if (->page_mkwrite() < 0)
> >     nfs_vm_page_mkwrite()
> >       nfs_write_begin()
> >         nfs_flush_incompatible()
> >           nfs_wb_page()
> >             nfs_wb_page_priority()
> >               nfs_sync_mapping_wait()
> >                 nfs_wait_on_request_locked()
> >                   nfs_wait_on_request()
> >                     nfs_wait_bit_interruptible()
> >                       return -ERESTARTSYS
> >     SIGBUS
> >
> > trying to figure out what to do about this...
>
> Hmmm...  It sounds like the fault handler should deliver the appropriate
> signal, should ->page_mkwrite() return ERESTARTSYS, and then retry the
> access instruction that caused the fault when the signal handler has
> finished running.

I don't think the fault handler is currently in any position to do
that ATM. It is possible to make it interruptible in some contexts,
but faults from kernel code may not be able to cope.
