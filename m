Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZA2WrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZA2WrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZA2WrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:47:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:44398 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZA2WrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OIHJNZezEQrj0KJ4qDlyVCJL51vsJ5FO1BD7n88aK3BKQI0aRuuskncpLyXadwqSwR
         s1Vlq1KXuKejGoycpHX0BBqUtsqqlS3yNwL/HsY5Dew151wI3Ns3SL2NrP2NDaI+Jg3O
         28zydi0XRaSlMjS7z98TG//7KZ4X8URXKpWD8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
Date: Thu, 29 Jan 2009 14:47:05 -0800
Message-ID: <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED 
	file segments
From: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 12:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, 29 Jan 2009, Linus Torvalds wrote:
>>
>> THIS PATCH IS TOTALLY UNTESTED!
>
> Well, it boots. FWIW. I've not really tested anything interesting with it,
> but any potential breakage is at least not catastrophic and immediate.
>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 8d95902..3f78ead 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -769,6 +769,10 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>>       if (vm_flags & VM_SPECIAL)
>>               return NULL;
>>
>> +     /* Anonymous shared mappings are unsharable */
>> +     if ((vm_flags & VM_SHARED) && !file)
>> +             return NULL;
>> +
>
> .. and I think this part of it is actually unnecessary, because what
> happens is that a shared anon mapping is turned into a shmem mapping when
> it is inserted, and that actually ends up allocating a file for it. So the
> vma->vm_file for anon mappings will not match a NULL file pointer
> _anyway_, so there's no way it would end up merging.
>
> So my patch can be further simplified, I think, to just the following.
> Even more total lines removed.
>
> I still want somebody else to look at and think about it, though.

Just to confirm. This patch also appear to fix the immediate issue for us.

thanks,
max
