Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZDLSgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZDLSgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZDLSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:35:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:29669 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZDLSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ErWe1tVQ0JyvwECSU9bsmopwOKXGaPtLsIiDCvn75tTDBYzepqrIs983GOu8jNe+VS
         NTfkztcduaWr4XexSiSFOQT4v/ahrv8SXxzqUeZvjM8LU1R+Ib0YWRvfp1UXfgcSomCM
         WCMZEYgt1XTeMrC+oY7mHEwYBIuL4AGcUUPGs=
Message-ID: <49E23485.4020904@gmail.com>
Date: Sun, 12 Apr 2009 12:35:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain> <49E21E8A.2040005@gmail.com> <alpine.LFD.2.00.0904121012500.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904121012500.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> IOW, when you allocate a new 32kB cluster, you will have to allocate 8 
> pages to do IO on it (since you'll have to initialize the diskspace), but 
> you can still literally treat those pages as _individual_ pages, and you 
> can write them out in any order, and you can free them (and then look them 
> up) one at a time.
> 
> Notice? The cluster size really only ends up being a disk-space allocation 
> issue, not an issue for actually caching the end result or for the actual 
> size of the IO.

Right.. I didn't realize we were actually that smart (not writing out 
the entire cluster when dirtying one page) but I guess it makes sense.

> 
> The hardware sector size is very different. If you have a 32kB hardware 
> sector size, that implies that _all_ IO has to be done with that 
> granularity. Now you can no longer treat the eight pages as individual 
> pages - you _have_ to write them out and read them in as one entity. If 
> you dirty one page, you effectively dirty them all. You can not drop and 
> re-allocate pages one at a time any more.
> 
> 				Linus

I suspect that in this case trying to gang together multiple pages 
inside the VM to actually handle it this way all the way through would 
be insanity. My guess is the only way you could sanely do it is the 
read-modify-write approach when writing out the data (in the block layer 
maybe?) where the read can be optimized away if the pages for the entire 
hardware sector are already in cache or the write is large enough to 
replace the entire sector. I assume we already do this in the md code 
somewhere for cases like software RAID 5 with a stripe size of >4KB..

That obviously would have some performance drawbacks compared to a 
smaller sector size, but if the device is bound and determined to use 
bigger sectors internally one way or the other and the alternative is 
the drive does R-M-W internally to emulate smaller sectors - which for 
some devices seems to be the case - maybe it makes more sense to do it 
in the kernel if we have more information to allow us to do it more 
efficiently. (Though, at least on the normal ATA disk side of things, 4K 
is the biggest number I've heard tossed about for a future expanded 
sector size, but flash devices like this may be another story..)
