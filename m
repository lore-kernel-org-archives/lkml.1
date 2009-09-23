Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZIWGnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZIWGnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZIWGm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:42:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:38393 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZIWGm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:42:59 -0400
Date: Wed, 23 Sep 2009 08:43:14 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Xavier Roche <roche+kml2@exalead.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inter-process send()/recv() using zero-copy ?
Message-ID: <20090923084314.78283f24@infradead.org>
In-Reply-To: <4AB9B9B7.1020309@exalead.com>
References: <4AB9B9B7.1020309@exalead.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 08:01:27 +0200
Xavier Roche <roche+kml2@exalead.com> wrote:

> Hi folks,
> 
> I was wondering if there was a way to have zero-copy send()/recv(),
> when the socket is connected to the local machine (to another process
> on the same machine, for example) ?
> 
> Such feature would be only feasible with page-aligned blocks, from an
> a mmap'ed block to another one, I guess.
> 
> Typical case:
> 
> Process #1 (uid A)
> buff = mmap(0, size, ..) /* anonymous or not */
> ...
> send(s, buff, size, 0)
> munmap(buff, size)
> 
> Process #2 (uid B)
> buff = mmap(0, size, .. | MAP_ANONYMOUS, ..)
> recv(s, buff, size, 0)
> 
> In an ideal fantasy world, the first process would use send() to 
> transmit the complete page-aligned memory block to the other side,
> and the second process would use recv() to get the memory block on a
> similar anonymously mmap'ed block, and the only operation the kernel
> would do would be to share the memory block between the two processes
> with copy-on-write.
> 
> On the real world, the same operation requires a first read of the
> whole memory block (possibly partially on disk) and a complete write
> (possibly partially on disk, too) with two copies of the same memory
> region at the end.
> 
> Two solutions can be used to 

the problem you have is that
1) memory copies are cheap
   (say, 3000 cycles/page or less)
2) page table operations (mmap etc) are very expensive.

these two combined tend to not make it a win to substitute simple
copies with complex pagetable tricks.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
