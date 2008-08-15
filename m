Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYHOFhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYHOFhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYHOFhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:37:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:51834 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYHOFhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:37:05 -0400
Date: Thu, 14 Aug 2008 22:36:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
In-Reply-To: <alpine.DEB.1.10.0808142149030.12859@asgard.lang.hm>
Message-ID: <alpine.DEB.1.10.0808142233460.12859@asgard.lang.hm>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com>
 <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm> <20080815020400.GG13048@mit.edu> <20080814204134.23c88f6c@infradead.org>
 <alpine.DEB.1.10.0808142149030.12859@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, david@lang.hm wrote:

> On Thu, 14 Aug 2008, Arjan van de Ven wrote:
>
>> On Thu, 14 Aug 2008 22:04:00 -0400
>> Theodore Tso <tytso@mit.edu> wrote:
>> 
>>> On Thu, Aug 14, 2008 at 06:44:33PM -0700, david@lang.hm wrote:
>>>> could you do something like defining a namespace inside posix
>>>> attributes and then setting up a mechanism in the kernel to alert
>>>> if the attributes change (with the entire namespace getting cleared
>>>> if the file gets dirtied)?
>>> 
>>> According to Eric Paris the clean/dirty state is only stored in
>>> memory.  We could use the extended attribute interface as a way of not
>>> defining a new system call, or some other interface, but I'm not sure
>>> it's such a great match given that the extended attributes interface
>>> are designed for persistent data.
>>> 
>>> I agree that doesn't actually work very well for the tracker use case,
>>> where you the clean/dirty bit to be persistent (in case the tracker is
>>> disabled due to the fact you are running on battery, for example, and
>>> then you reboot).
>>> 
>> 
>> but we need a "give me all dirty files" solution, not a "is this file
>> dirty" solution.
>> 
>> I do not want a virus scanner to constantly have to poll the whole fs
>> for dirty files ;-)
>
> I'm not sure.
>
> there are two situations (with the transition between them)
>
> 1. unscanned system, we want to do everything. (this happens immediatly after 
> a new signature file is deployed)
>
> here you do just want to filter out the files that have been scanned from the 
> list of everything, and you probably want to check at the time of scanning 
> the file in case it was opened (and scanned) in the meantime.
>
> 2. mostly scanned system, we only want to scan files that have been dirtied.
>
> here you don't need to scan everything, you only need to scan in two cases
>
> 2a. the file was dirtied (you learn about it and add it to the queue of files 
> to scan when you get around to it)
>
> 2b. an unscanned file is opened (the library detects that the file was not 
> marked approved by all the current scanners, so it invokes the scanners on 
> this file before completing the open, or copy for mmap, or whatever)
>
>
>
> In the first case the attributes work "don't bother scanning me".
>
> In the second case they also work (becouse you aren't trying to scan 
> everything)
>
>
> the only time there is a headache is in the transition between them when you 
> have scanned a lot of the system, but not all of it, and the machine was 
> rebooted so you lost track of what you had scanned.
>
> it shouldn't be too hard to deal with this. even if you never resume the scan 
> you are still safe (becouse of the scan-on-open), but it's also possible to 
> either do a find f(or equivalent) or files without the attribute and store 
> the results (similar to updatedb) and then updating the file to mark the 
> files as being scanned (update in place, change the first character or 
> something to be fairly crash safe). after the full list of files has been 
> scanned shift to the second mode.
>
> the sweep scan should be a background task, possibly disabled when on battery 
> power.
>
> why would this not satisfy the requirements?
>
> David Lang

one way this approach would be a pain is that as signature files got 
updated the attributes would accumulate.

a couple ways of dealing with this.

1. scanners clean up after themselves (when they go to add a new one the 
remove the old one)

2. background sweep through the system removing all tags that aren't in 
the current 'blessed' set

David Lang
