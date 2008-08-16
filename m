Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYHPKOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYHPKOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHPKOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:14:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:52065 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYHPKOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:14:32 -0400
Date: Sat, 16 Aug 2008 03:14:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Arjan van de Ven <arjan@infradead.org>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl, capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <20080816102846.37b104a7@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0808160248340.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com> <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm> <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
 <20080815210942.4e342c6c@infradead.org> <alpine.DEB.1.10.0808152115210.12859@asgard.lang.hm> <20080816102846.37b104a7@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Alan Cox wrote:

>> I really think that we need to avoid trying to have a single 'known good'
>> flag/generationnrwith the inode.
>
> I don't think we should have anything in the inode. We don't want to
> bloat inode objects for this cornercase.

no problem

>> if you store generation numbers for individual apps (in posix attributes
>> to pick something that could be available across a variety of
>> filesystems), you push this policy decision into userspace (where it
>
> Agreed
>
>> 1. define a tag namespace associated with the file that is reserved for
>> this purpose for example "scanned-by-*"
>
> What controls somewhat writing such a tag on media remotely ? Locally you
> can do this (although you are way too specialized in design - an LSM hook
> for controlling tag setting or a general tag reservation sysfs interface
> is more flexible than thinking just about scanners.

there are multiple approaches to this (i.e. a policy issue that belongs in 
userspace)

1. you trust the machines the media comes from, so you trust the scan 
results.

2. you don't trust the remote machines and you then either extend this 
model into a per filesystem approach (and invalidate/increment/change the 
genration key on the new media that's loaded), or you tryand make the 
generation key be cryptograhicly random, so that the odds of the 
generation key on the media being valid for the machine it's plugged into 
is next to impossible (generating a good GUID as the generation key as the 
signature/scanner is loaded would be pretty close to random for example)

you could do a LSM hook, but in many (if not most) cases it makes sense to 
have the tags stored across boots, so if you do it through LSM you have to 
figure out how/where to store it. if you can put it in posix extended 
attibutes most filesystems will handle it for you.

>> 2. have an kernel option that will clear out this namespace whenever a
>> file is dirtied
>
> That will generate enormous amounts of load if not carefully handled.

will it? if it's already empty trying to clear it should be cheap. it's 
like maintaining the dirty bit on a chunk of memory.

>> 3. have a kernel mechanism to say "set this namespace tag if this other
>> namespace tag is set" (this allows a scanner to set a 'scanning' tag when
>> it starts and only set the 'blessed' tag if the file was not dirtied while
>
> User space problem. Set flags 'dirty', then set bit 'scanning'
> clear 'dirty' then clear 'scanning' when finished. If the dirty flag got
> set while you were scanning it will still be set now you've cleared you
> scanning flag. Your access policy depends upon your level of paranoia (eg
> "dirty|scanning == BAD")

this still leaves a window between the time you last check that the dirty 
flag is still set, while you clear the dirty flag and set the clean flag 
that modifications could be made to the file and it will still get marked 
clean. if this race is small enough this feature can be skipped

>> programs can set the "scanned-by-*" flags on that the 'libmalware' library
>
> We've already proved libmalware doesn't make sense

I missed that part of the discussion. what I was reading was that people 
were saying that it worked for everything except staticly compiled 
binaries and knfsd.

why would it not make sense to have the checking in a userspace library 
(libmalware could be seperate or loaded from glibc or be part of glibc, 
depending on your level of concern

>> L. the fact that knfsd would not use this can be worked around by running
>> FUSE (which would do the checks) and then exporting the result via knfsdw
>
> Not if you want to get any work done.
>
>> what did I over complicate in this design? or is it the minimum feature
>> set needed?
>>
>> are any of the features I list impossible to implement?
>
> Go write it and see, provide benchmarks ?  I don't see from this how you
> handled shared mmap ?

the kernel detects writes to mmap and dirties the file (clearing the 
flags), the next time the file is accessed it will be re-scanned (assuming 
that the background scanner doesn't get there first) do the checks at the 
time of mmap, don't try to do it for each memory read.

as for two programs having the file open at the same time and the risk of 
passing bad data from one to the other. the risk model specifies we are 
not trying to protect against running programs. shared mmap is a 
communications channel between them just like a pipe, we aren't trying to 
protect inter-process communication (just like we aren't trying to protect 
network communication)

there are probably better answers, but I'm leaving that up to the folks 
who want to write all the scanning tools. I'm just trying to help by 
assembling the ideas different people mentioned during this thread into a 
minimaly invasive set of hooks that are useful beyond the AV space into 
other things that are needed (like HSM, indexing, or for that matter a 
backup daemon could gather the list of files it needs for an incrimental 
backup by listening for the kernel to tell it every file that changes 
instead of needing to scan TB worth of filesystems for them)

David Lang
