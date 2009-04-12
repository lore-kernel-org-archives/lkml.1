Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZDLAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZDLAzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZDLAzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:55:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbZDLAzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:55:23 -0400
Date: Sat, 11 Apr 2009 17:49:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <49E12D03.5070906@garzik.org>
Message-ID: <alpine.LFD.2.00.0904111725570.4583@localhost.localdomain>
References: <49E0D47B.9070205@garzik.org> <20090411203246.513a0892@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain> <da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com> <20090412002527.631a5a89@lxorguk.ukuu.org.uk>
 <49E12D03.5070906@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Jeff Garzik wrote:
> 
> Or just ignore the extra length, thereby excising the 'read-modify' step...
> Total storage is halved or worse, but you don't take as much of a performance
> hit.

Well, the people who want > 4kB sectors usually want _much_ bigger (ie 
32kB sectors), and if you end up doing the "just use the first part" 
thing, you're wasting 7/8ths of the space. 

Yes, it's doable, and yes, it obviously makes for a simple driver thing, 
but no, I don't think people will consider it acceptable to lose that much 
of their effective size of the disk.

I suspect people would scream even with a 8kB sector.

Treating all writes as read-modify-write cycles on a driver level (and 
then opportunistically avoiding the read part when you are lucky and see 
bigger contiguous writes) is likely more acceptable. But it _will_ suck 
dick from a performance angle, because no regular filesystem will care 
enough, so even with nicely behaved big writes, the two end-points will 
have a fairly high chance of requiring a rmw cycle.

Even the journaling ones that might have nice logging write behavior tend 
to have a non-logging part that then will behave badly. Rather few 
filesystems are _purely_ log-based, and the ones that are tend to have 
various limitations. Most commonly read performance just sucks.

We just merged nilfs2, and I _think_ that one is a pure logging filesystem 
with just linear writes (within a segment). But I think random read 
performance (think: loading executables off the disk) is bad.

And people tend to really dislike hardware that forces a particular 
filesystem on them. Guess how big the user base is going to be if you 
cannot format the device as NTFS, for example? Hint: if a piece of 
hardware only works well with special filesystems, that piece of hardware 
won't be a big seller. 

Modern technology needs big volume to become cheap and relevant.

And maybe I'm wrong, and NTFS works fine as-is with sectors >4kB. But let 
me doubt that.

			Linus
