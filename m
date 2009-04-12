Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZDLRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZDLRCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZDLRCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:02:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:9029 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZDLRCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=T/EPdk7o5DXWnxeRgAKm5pvTvZ5J32U1NFqu3188106rnBE0rukGT0SYFbNc6TaENl
         FdWgwT6SuWWTU0THbEkcfFYttyNY2E0/7cHBPAj34ljX+7VW+iAYpopC/tCrJJo9TllM
         NFquj+X0eb99vLS0umMNPsxXnRZlrL6GeGEbQ=
Message-ID: <49E21E8A.2040005@gmail.com>
Date: Sun, 12 Apr 2009 11:02:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 12 Apr 2009, Szabolcs Szakacsits wrote:
>> I did not hear about NTFS using >4kB sectors yet but technically 
>> it should work.
>>
>> The atomic building units (sector size, block size, etc) of NTFS are 
>> entirely parametric. The maximum values could be bigger than the 
>> currently "configured" maximum limits. 
> 
> It's probably trivial to make ext3 support 16kB blocksizes (if it doesn't 
> already).
> 
> That's not the problem. The "filesystem layout" part is just a parameter.
> 
> The problem is then trying to actually access such a filesystem, in 
> particular trying to write to it, or trying to mmap() small chunks of it. 
> The FS layout is the trivial part.
> 
>> At present the limits are set in the BIOS Parameter Block in the NTFS
>> Boot Sector. This is 2 bytes for the "Bytes Per Sector" and 1 byte for 
>> "Sectors Per Block". So >4kB sector size should work since 1993.
>>
>> 64kB+ sector size could be possible by bootstrapping NTFS drivers 
>> in a different way. 
> 
> Try it. And I don't mean "try to create that kind of filesystem". Try to 
> _use_ it. Does Window actually support using it it, or is it just a matter 
> of "the filesystem layout is _specified_ for up to 64kB block sizes"?
> 
> And I really don't know. Maybe Windows does support it. I'm just very 
> suspicious. I think there's a damn good reason why NTFS supports larger 
> block sizes in theory, BUT EVERYBODY USES A 4kB BLOCKSIZE DESPITE THAT!

I can't find any mention that any formattable block size can't be used, 
other than the fact that "The maximum default cluster size under Windows 
NT 3.51 and later is 4K due to the fact that NTFS file compression is 
not possible on drives with a larger allocation size. So format will 
never use larger than 4k clusters unless the user specifically overrides 
the defaults".

It could be there are other downsides to >4K cluster sizes as well, but 
that's the reason they state.

What about FAT? It supports cluster sizes up to 32K at least (possibly 
up to 256K as well, although somewhat nonstandard), and that works.. We 
support that in Linux, don't we?

> 
> Because it really is a hard problem. It's really pretty nasty to have your 
> cache blocking be smaller than the actual filesystem blocksize (the other 
> way is much easier, although it's certainly not pleasant either - Linux 
> supports it because we _have_ to, but sector-size of hardware had 
> traditionally been 4kB, I'd certainly also argue against adding complexity 
> just to make it smaller, the same way I argue against making it much 
> larger).
> 
> And don't get me wrong - we could (fairly) trivially make the 
> PAGE_CACHE_SIZE be bigger - even eventually go so far as to make it a 
> per-mapping thing, so that you could have some filesystems with that 
> bigger sector size and some with smaller ones. I think Andrea had patches 
> that did a fair chunk of it, and that _almost_ worked.
> 
> But it ABSOLUTELY SUCKS. If we did a 16kB page-cache-size, it would 
> absolutely blow chunks. It would be disgustingly horrible. Putting the 
> kernel source tree on such a filesystem would waste about 75% of all 
> memory (the median size of a source file is just about 4kB), so your page 
> cache would be effectively cut in a quarter for a lot of real loads.
> 
> And to fix up _that_, you'd need to now do things like sub-page 
> allocations, and now your page-cache size isn't even fixed per filesystem, 
> it would be per-file, and the filesystem (and the drievrs!) would hav to 
> handle the cases of getting those 4kB partial pages (and do r-m-w IO after 
> all if your hardware sector size is >4kB).
> 
> IOW, there are simple things we can do - but they would SUCK. And there 
> are really complicated things we could do - and they would _still_ SUCK, 
> plus now I pretty much guarantee that your system would also be a lot less 
> stable. 
> 
> It really isn't worth it. It's much better for everybody to just be aware 
> of the incredible level of pure suckage of a general-purpose disk that has 
> hardware sectors >4kB. Just educate people that it's not good. Avoid the 
> whole insane suckage early, rather than be disappointed in hardware that 
> is total and utter CRAP and just causes untold problems.
> 
> Now, for specialty uses, things are different. CD-ROM's have had 2kB 
> sector sizes for a long time, and the reason it was never as big of a 
> problem isn't that they are still smaller than 4kB - it's that they are 
> read-only, and use special filesystems. And people _know_ they are 
> special. Yes, even when you write to them, it's a very special op. You'd 
> never try to put NTFS on a CD-ROM, and everybody knows it's not a disk 
> replacement.
> 
> In _those_ kinds of situations, a 64kB block isn't much of a problem. We 
> can do read-only media (where "read-only" doesn't have to be absolute: the 
> important part is that writing is special), and never have problems. 
> That's easy. Almost all the problems with block-size go away if you think 
> reading is 99.9% of the load. 
> 
> But if you want to see it as a _disk_ (ie replacing SSD's or rotational 
> media), 4kB blocksize is the maximum sane one for Linux/x86 (or, indeed, 
> any "Linux/not-just-database-server" - it really isn't so much about x86, 
> as it is about large cache granularity causing huge memory fragmentation 
> issues).
> 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

