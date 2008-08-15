Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYHOBbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYHOBbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYHOBbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:31:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:49483 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYHOBbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:31:15 -0400
Date: Thu, 14 Aug 2008 18:31:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, tytso@mit.edu, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
In-Reply-To: <20080813103951.1e3e5827@infradead.org>
Message-ID: <alpine.DEB.1.10.0808141821150.13400@asgard.lang.hm>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Arjan van de Ven wrote:

> 2) We very likely should have a mechanism for a userspace app to
> request a scan on a file, both sync or async (O_SYNC flag?). This is
> useful regardless because it allows the source of many things to do the
> right thing.
> 3) we need a mechanism in the kernel to track "scanned with generation
> X of signatures" that invalidates on any dirty operation. The syscall
> from 2) will use this as a cache to be quick.
>
> I think few people will disagree about this.
>
> Open questions now are
> 4) do we have the kernel kick off an async scan in open() or do we have
> glibc do this

the kernel should not kick off a scan, instead it should check to see 
an open/read should not kick off a scan, instead it should check to see if 
the scan generation tag(s) are current should be enough (remember, you may 
have more then one type of scanner running on the system)

> 5) do we have the kernel do the sync scan on read/mmap/.. or do we have
> glibc do this

definantly not the kernel. the intent of this is to keep linux from being 
a storage repository for malware used by other systems. there is no need 
to penalize linux-only apps by making them wait for a scan to take place. 
If it lives in glibc there should be a way for linux apps that know that 
they will not be exporting files to other systems to tell the library not 
to do a scan.

for example, why should a log analysis program looking at apache logs be 
forced to wait while multiple 'virii scanners' go through several gigs of 
logs before it can start looking at them.

you are going to need some way to bypass the checks anyway so that you can 
avoid the recursive case of the scanners triggering scans on files that 
they open.

by keeping the scans all in userspace it also simplifies things greatly. 
All the kernel should do is to maintain the tags with the file (posix 
attributes??) and have a mechanism to clear them when the file is dirtied.

> I think this is where the whole debate is about now.
>
> And a few hard ones
> 6) how do we deal with multiple scanning agents in parallel

not a problem, in fact multiple agents scanning in parallel is a good 
thing, it lets them all see the data with one pass through the disk.

they will all need to set different tags anyway (the fact that agent1 
blessed the data doesn't mean that it's safe if agent2 hasn't done so)

> 7) how do we prevent malware from pretending to be a virus scanner

this is not part of the threat model.

David Lang
