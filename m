Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYJaQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYJaQfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYJaQfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:35:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:55691 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJaQf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GKrcTgChAyedTyNKICxTQAJ0klzVq+bNMlyB8WNn2OjJ3HEHgYYp3fv6hKpKY8Ci7P
         bZ2WGpCkIN2XtNhe8QKwoaQqVXpp8/RFJmwuQfuRn3UrWoRWx++zgJlXfOgsZ+wr14GK
         DvsM5RLJ5+QvTkZF6u/jPpJEc8s7EcOdK81os=
Message-ID: <86802c440810310935w2f739679s9deaf28f6d9e64c9@mail.gmail.com>
Date: Fri, 31 Oct 2008 09:35:28 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Robert Hancock" <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	 <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net>
	 <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
	 <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
	 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
	 <20081031100040.1f0cf34f@bike.lwn.net>
	 <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
X-Google-Sender-Auth: 619d552aaa1fda7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 9:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 31 Oct 2008, Jonathan Corbet wrote:
>>
>> Things change a bit with this patch, but the e1000e still fails to
>> initialize:
>
> Ahahhh! My bad. I think this was actually discussed back when the whole
> reserved-memory-handling thing was being worked on, but it got ignored
> because none of the developers actually ever had any machines with this
> issue, and the whole (and only) reason for the change was some odd sound
> card initialization issue if I recall correctly.
>
> The problem (I think) is that the e820 resource handling doesn't insert
> the resources as some kind of magic PCI resource, but it inserts them as a
> "I am a driver, and I actively _use_ this resource".
>
> Which means that it all ends up being very busy, and then when a PCI
> driver says "I now want to use this", you get EBUSY.
>
> Does this patch work for you?
>
> A resource doesn't have to be busy for the resource allocator to try to
> avoid it, so the only thing that BUSY bit does is to not allow people who
> _do_ want to use the resources they know about from using them.
>
> So we should mark the resources busy only if we _really_ use them (like
> the kernel *RAM* resources).
>
> Oh, and this time the patch even compiles. It includes the previous
> change, obviously.
>
> Btw, this shows another (unrelated) issue: the BUSY bit (along with
> various other resource flags) doesn't show up in /proc/iomem, so these
> kinds of issues end up being debugged totally "blind". Not good.
>
>                Linus
>
> ---
>  arch/x86/kernel/e820.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index ce97bf3..7aafeb5 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1290,15 +1290,17 @@ void __init e820_reserve_resources(void)
>                res->start = e820.map[i].addr;
>                res->end = end;
>
> -               res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +               res->flags = IORESOURCE_MEM;
>
>                /*
>                 * don't register the region that could be conflicted with
>                 * pci device BAR resource and insert them later in
>                 * pcibios_resource_survey()
>                 */
> -               if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
> +               if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
> +                       res->flags |= IORESOURCE_BUSY;
>                        insert_resource(&iomem_resource, res);
> +               }
>                res++;
>        }
>
> @@ -1318,7 +1320,7 @@ void __init e820_reserve_resources_late(void)
>        res = e820_res;
>        for (i = 0; i < e820.nr_map; i++) {
>                if (!res->parent && res->end)
> -                       reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
> +                       insert_resource_expand_to_fit(&iomem_resource, res);
>                res++;
>        }
>  }

then we don't need e820_reserve_resources_late, right?

BIOS is not supposed to put the regions that are allocated to BARs
into RESERVED in e820.
and os is not supposed to use other regions in reserved entries...

so it seems need to way to take out the BAR areas from e820 map's
reserved entries before calling e820_reserve_resources_late(). this
way is seems much clean... agree?

YH
