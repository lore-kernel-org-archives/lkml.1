Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYHFXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYHFXUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 19:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYHFXUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:20:42 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:25303 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYHFXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qK3MHEZY3H0Gjwv9PAL1FlRNbwVx8OCTIiqmWg2vdX9x8cKPT5RB8z91Fosgq244Qk
         x8nXBMRvjXVwvVKFRBxUlCcYaauLlgGFPEvbNU9GI2lds9x0MkNvdi1VzsDCfunNO/KG
         USmVSQbOTqMGfB16xC8IJGWhQvT0Y+UYhBnv0=
Message-ID: <e7d8f83e0808061620j111b6cf8w8eded1e6a3325a4b@mail.gmail.com>
Date: Thu, 7 Aug 2008 09:20:38 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: davecb@sun.com
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon access scanning
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       "Rik van Riel" <riel@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <48998BA3.3080804@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805205129.37d873f0@bree.surriel.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
	 <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
	 <e7d8f83e0808060657v6723510fma8ca6defbdbb65aa@mail.gmail.com>
	 <48998BA3.3080804@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/08, David Collier-Brown <davecb@sun.com> wrote:
>
>
> Peter Dolding wrote:
>  > My main issue is TALPA, dazuko and so on of Anti-Virus Filesystem
>> monitoring are all going to break anyhow when
>> http://lwn.net/Articles/251224/ Credentials get added and common
>> filesystem caching gets added.
>>
>> You want to change a permissions on a file/object before its opened.
>> So does the Credential user space daemon on file systems that cannot
>> store secuirty information.  We only really need 1 location in the
>> source base for this.  Expand Credentials slightly to allow anti
>> viruses to operate by by problem.   Even better when FS-Cache can sit
>> on top of Credentials correctly no need for anti virus software to
>> have independent caching of blocked and allowed files.  FS-Cache picks
>> a large amount of this up.
>>
>> Basically TALPA, dazuko and so on of Anti-Virus Filesystem monitoring
>> don't fit in the future design of Linux.   All they will be is
>> duplication of a existing interface.  A interface that complete avoids
>> the stacking issue.
>
> Then in a real sense you've solved much of their problem for them (;-))
> After this comes engineering, so that they can re-use the scanning
> mechanisms they already have, but from a different caller.
>
> The requirements are probably that they know
> - is this an open for read or write (somewhat less time-sensitive)?
> - is the data present, or do we have to wait?
> - if so, for what?
> as of the time they start looking at the file.  Having a race-free
> mechanism using credentials and RCU is, IMHO, A Really Good Thing.
>
> Another thing they and we will likely need is a way to discover
> if a file is inacessable due to an AV operation, and if the time
> it has been inacessable is less than or equal to a scanning
> upper bound by file size or beyond it.  The latter is for repair
> of broken state introduced by the AV process failing.
>
> --dave
>
Failed daemon support has to exist in Credentials for filesystems that
cannot store all the security data and needing third party support.
This is the issue same features basically required to do the same
things.  Different reasons.

One to virus scan.  One to fix up security lacking file systems.  From
what I see exactly the same set of features are needed.

At most only 1 feature is missing a form of copy on write.   Adding
this at credentials level over the complete system would not be a bad
thing.  A option to cache writes for scanning even write to like a
journal for latter applying once scanned.   This could even come as
part of the generic file system cache.

This is why I am kinda scratching my head.   Creating new files also
have to go past Credentials.  Even creating and editing files have to
go past Credentials.

It seams like the best place to look to hook in correctly even better
most of the hook is already there.  Hooking into Credentials is far
better than hooking into syscalls.   Since if a new special feature
filesystem access syscall is added it will still enter Credentials.
On top Credentials interface is under the VFS.  Its between the raw
filesystem and the VFS.   So no more path based errors.

Yes deeper into the OS to the correct location.  Anti-virus methods
are too shallow.  AppArmor and some other secuirty systems like it
have the same path based issue because LSM is too shallow.
Anti-Virus company answer has been to root kit out of the LSM API
wrong answer.  Correct answer is get to the correct location in the
OS.

Note clamfs is on the right path using fuse since this goes under the
VFS and not effected by path issues and is not root kitting the OS.
Of course credentials do the job better.

Really Anti-Virus guys give as a shopping list of exactly what you
need to do.   Key word need.   Hooking syscall's most likely is not a
need but a want.   Even worse a want in the wrong location to give 100
percent coverage.  Ie when a new syscall is added it creates a
backdoor around you scanners.

Peter Dolding

PS I really wound not mind a better paid job.   The developers who
have to created all these incorrect ways have to been paid more than
me.
