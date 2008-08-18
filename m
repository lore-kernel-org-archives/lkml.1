Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYHRMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYHRMNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYHRMMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:12:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:39901 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYHRMMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:12:52 -0400
Date: Mon, 18 Aug 2008 05:13:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: douglas.leeder@sophos.com
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning
In-Reply-To: <20080818103535.2F4861836B2@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808180508420.12859@asgard.lang.hm>
References: <20080818103535.2F4861836B2@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, douglas.leeder@sophos.com wrote:

>> David Lang wrote on 18/08/2008 01:58:40:
>>
>>> I really think that we need to avoid trying to have a single 'known
>> good'
>>> flag/generationnrwith the inode.
>>>
>>> while that will work for the TALPA use-case of a single anti-virus
>>> scanner, it
>>> can't cope with multiple scanners, and since there are very
>>> different types of
>>> scanners that are interesting (anti-virus and indexing to just name
>> two), and
>>> the fact that some people will want to run more then one anti-virus
>>> program on
>>> a machine, you don't have a 'known good' condition, you have 'known
> good
>>
>>> according to program A/B/C' conditions, and the file should only be
>>> considered
>>> 'good, nothing to do' if it has a full set of flags.
>>
>> How does it make sense to have a 'known good' according to 'one-of'
> status
>> while there is a single access point ie. no relationships between access
>
>> triggers and 'known good' authority points?
>>
>> Or in simpler words - A says a file is safe, B says it isn't and in your
>
>> proposal you store both information. Then a time to access the file
> comes
>> and what do you do, allow or deny?
>>
>> Maybe I am missing something but I just don't see how this could work
> and
>> how single 'known good' flag per inode does not work. In the proposed
>> implementation Eric posted we don't have support for multiple scanners
> but
>> it is quite possible to extend it with that. In which case the only
> model
>> that makes sense is that all of them must declare something clean in
> order
>> for it to be marked as clean. More into the implementation details - any
>
>> of those scanners who wants to revoke it's decision (new malware
> database
>> or whatever) just needs to increment the global counter which will cause
>
>> all inodes (but on-demand, as they are accessed) to be rescanned.
>
> I think the case of interest is an AV scanner + an indexing scanner.
>
> The indexing scanner marks a file when it changes, and doesn't want to
> scan it
> until the file changes.
>
> The AV scanner wants to mark as unclean the file every time the AV data is
> updated.
>
> Of course the only reason you need separate caches is for performance -
> when the AV
> cache marker is updated, and the file is accessed you don't want to
> trigger the
> indexing scanner.
>
> I guess you could have similar effects for two AV scanners:
> AV1 is a white-list scanner
> AV2 is a black-list scanner
>
> AV1 only scans on execution, and only changes its mind when the user
> explicitly allows an executable
> AV2 is updated hourly, and can change its mind after any update
>
> With a single cache marker: AV1 has to scan each execution after every
> hourly update of AV2
>
> With multiple cache markers: AV1 only scans new executables, or all
> executions after an explicit allow

it gets even worse if you have more scanners.

you may have a OS package manager scanner that knows the checksums of the 
files that were installed via packages,plus you may have multiple 
anti-virus scanners (people want to try and run more then one so that what 
one misses another may catch), plus a HIDS scanner to check that config 
files haven't changed (seperate from the package manager scanner)

then you can add on top of this one or more indexers.

you don't want to run all of these just becouse you updated one of them.

and if you subscribe to multiple anti-virus scanner updates, they are not 
going to be in sync with each other, so one may update at noon (triggering 
a full rescan), and another at 12:30 (triggering another)

David Lang
