Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbYHESkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbYHESkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYHESj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:39:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbYHESj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:39:58 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080805112747.2c3c4650@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	 <1217948212.27684.120.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	 <1217956796.11547.12.camel@paris.rdu.redhat.com>
	 <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805112747.2c3c4650@infradead.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 14:39:34 -0400
Message-Id: <1217961574.27684.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 11:27 -0700, Arjan van de Ven wrote:
> On Tue, 5 Aug 2008 14:04:26 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> 
> > 
> > However, I want to point out that scanning on close is still an
> > integral part of AV protection, even if intercepting opens and execs
> > theoretically catches everything.
> 
> 
> but close is... very limited in value. Open is a discrete event
> traditionally associated withh permission checks.
> Close... not so.  (And if you mmap memory, you can then close the file
> and still write to it via the mmap)

Thankfully my implementation will invalidate that close time check and
caching result.  It does the invalidating the same place we update mtime
and my understanding is that mmap has been updating mtime for quite a
while now.  So again, it might not be perfect, but that situation should
get caught the next time around.  I see close time checking as more of a
performance win and as a way to help close some of the length bad
information could exist than anything since its done in a non-blocking
path.

I think we all agree that open is the most interesting time for scanning
operations, but as Jonathan points out there is some value (even if not
perfect value) in looking at closes as well.

> Lets ask it differently: what will you do if you find something nasty?
> You can't fail the close... so why block for it?
> And if you don't block for it... all you would need is an asynchronous
> notification... something like... inotify

I actually already have an async non-blocking close notification built
in.  Instead of waiting for a userspace response we just queue the close
notification and move along.  When userspace gets around to it scanning
and allow/deny caching can then take place at a later time.

-Eric

