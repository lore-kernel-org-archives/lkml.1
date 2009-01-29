Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZA2XbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZA2XbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZA2XbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:31:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:49557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZA2XbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D7gCxOKEuHjWoYxc1Sn3CcRFQduHwzgHLDcrd6F5imI6OtsANkxvqXAy2YBNP0/14M
         JpOAB0NpR/xApy75N1qpWsBqkVtbbNMScXuwN4UY2VSD45ga7Xnn7E/IR4sQPl/E//iL
         RmlJwqIxqLudFWUS3rFjBkyH8jrap84x50/lw=
MIME-Version: 1.0
In-Reply-To: <4982324B.3050706@oracle.com>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
	 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
	 <4982324B.3050706@oracle.com>
Date: Thu, 29 Jan 2009 15:31:04 -0800
Message-ID: <bb4a86c70901291531k55f52b2vf42eec4c020a7980@mail.gmail.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED 
	file segments
From: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
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

On Thu, Jan 29, 2009 at 2:48 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Maksim Yevmenkin wrote:
>> On Thu, Jan 29, 2009 at 12:48 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Thu, 29 Jan 2009, Linus Torvalds wrote:
>>>> THIS PATCH IS TOTALLY UNTESTED!
>>> Well, it boots. FWIW. I've not really tested anything interesting with it,
>>> but any potential breakage is at least not catastrophic and immediate.
>>>
>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>> index 8d95902..3f78ead 100644
>>>> --- a/mm/mmap.c
>>>> +++ b/mm/mmap.c
>>>> @@ -769,6 +769,10 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>>>>       if (vm_flags & VM_SPECIAL)
>>>>               return NULL;
>>>>
>>>> +     /* Anonymous shared mappings are unsharable */
>>>> +     if ((vm_flags & VM_SHARED) && !file)
>>>> +             return NULL;
>>>> +
>>> .. and I think this part of it is actually unnecessary, because what
>>> happens is that a shared anon mapping is turned into a shmem mapping when
>>> it is inserted, and that actually ends up allocating a file for it. So the
>>> vma->vm_file for anon mappings will not match a NULL file pointer
>>> _anyway_, so there's no way it would end up merging.
>>>
>>> So my patch can be further simplified, I think, to just the following.
>>> Even more total lines removed.
>>>
>>> I still want somebody else to look at and think about it, though.
>>
>> Just to confirm. This patch also appear to fix the immediate issue for us.
>
> Is there a (small) test program available?

Yes, it was in the original (first) email. Here it is again

/*
 * Program to provoke kernel NULL pointer de-reference during
 * mmap(...MAP_LOCKED...) in Linux 2.6.28.
 *
 * 1. Create a 32KB test file in /tmp (avoids mlock limit on all recent
 *    Linuxes).
 * 2. mmap it with MAP_LOCKED from top to bottom.  (Provokes the oops,
 *    since vmas can be merged in this case.)
 * 3. Clean up.
 *
 * Compile:
 *
 *	gcc maplock-bug.c -o maplog-bug
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

#define	SIZE	(32*1024)	/* Will get rounded down to page size if nec. */

static char tmp[] = "./maplock-bug.XXXXXX";
static char junkbuf[SIZE];

int
main(void)
{
    int fd;
    int ps = getpagesize();
    size_t sz = (SIZE / ps) * ps;
    void **addrs;
    off_t off;
    int i;

    if ((addrs = malloc((sz / ps) * sizeof (*addrs))) == 0) {
	perror("malloc");
	exit(1);
    }

    if ((fd = mkstemp(tmp)) < 0) {
	perror("mkstemp");
	exit(1);
    }

    if (write(fd, junkbuf, sz) != sz) {
	perror("write");
	exit(1);
    }

    if (close(fd) < 0) {
	perror("close");
	exit(1);
    }

    if ((fd = open(tmp, O_RDONLY)) < 0) {
	perror("open");
	exit(1);
    }

    for (off = sz - ps, i = 0; off >= 0; off -= ps, i++) {
	if ((addrs[i] =
	     mmap(0, ps, PROT_READ, MAP_SHARED|MAP_LOCKED,
		  fd, off)) == MAP_FAILED) {
	    perror("mmap");
	    exit(1);
	}

	printf("Mapped offset 0x%jx at %p\n",
	       (uintmax_t)off, addrs[i]);
    }

    if (close(fd) < 0) {
	perror("close");
	exit(1);
    }

    for (i = 0; i < sz / ps; i++) {
	if (munmap(addrs[i], ps) < 0) {
	    perror("munmap");
	    exit(1);
	}
	printf("Unmapped %p\n", addrs[i]);
    }

    if (unlink(tmp) < 0) {
	perror("unlink");
	exit(1);
    }

    printf("Done\n");
}

Thanks,
max
