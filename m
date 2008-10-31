Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYJaPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYJaPIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYJaPId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:08:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYJaPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:08:32 -0400
Date: Fri, 31 Oct 2008 08:07:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>  <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Oct 2008, Yinghai Lu wrote:

> On Thu, Oct 30, 2008 at 7:58 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> >
> > /proc/iomem looks like this with 2.6.28-rc2:
> >
> > 00000000-0009fbff : System RAM
> > 000f0000-000fffff : reserved
> > 00100000-be4ff7ff : System RAM
> >  00200000-004a6e45 : Kernel code
> >  004a6e46-00649b77 : Kernel data
> >  006c4000-007585ff : Kernel bss
> > be4ff800-be553bff : ACPI Non-volatile Storage
> > be553c00-be555bff : ACPI Tables
> > be555c00-beffffff : reserved
> > c0000000-cfffffff : 0000:00:02.0
> > d0000000-d3ffffff : PCI Bus 0000:02
> >  d0000000-d3ffffff : 0000:02:00.0
> >    d0000000-d07fffff : ivtv encoder
> >    d2000000-d200ffff : ivtv registers
> > d4000000-d4000fff : Intel Flush Page
> > e0000000-fe7fffff : reserved
> > fe800000-fe8fffff : PCI Bus 0000:01
> >  fe800000-fe8fffff : reserved
> > fe900000-fe9d9aff : reserved
> > fe9d9b00-fe9d9bff : 0000:00:1f.3
> >  fe9d9b00-fe9d9bff : reserved
> > fe9d9c00-fe9d9fff : 0000:00:1a.7
> >  fe9d9c00-fe9d9fff : reserved
> > fe9da000-fe9dafff : 0000:00:03.3
> >  fe9da000-fe9dafff : reserved
> > fe9db000-fe9dbfff : 0000:00:19.0
> >  fe9db000-fe9dbfff : reserved
> > fe9dc000-fe9dffff : 0000:00:1b.0
> >  fe9dc000-fe9dffff : reserved
> > fe9e0000-fe9fffff : 0000:00:19.0
> >  fe9e0000-fe9fffff : reserved
> 
> your BIOS allocate that to your nic, and also it put that in reserved
> in e820 table.

Yeah. I advocated using 'insert_resource_expand_to_fit()' instead of using 
'reserve_region_with_split()'. There was some reason Yinghai didn't like 
that, though. 

The important part is that we should put the reserved resource _outside_ 
the ones that it conflicts with, not inside.

> for 2.6.28, it change to honor PCI BAR than others...and at same time
> use reserve_region_with_split ...
> put the overlapping to reserved..
> 
> so solution will be:
> 1.rework reserve_region_with_split not to put the overlapping to reserved...

This would certainly be acceptable - we don't care that it's reserved, 
since we already know about it. 

> 2. or update pci_request_region to check if conflicts is with name "reserved"

No, that would be horribly wrong. 

Jonathan, what do things look like with the simple "use 'expand_to_fit'" 
patch instead, ie something like this:

			Linus

---
 arch/x86/kernel/e820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index ce97bf3..ebe712c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1318,7 +1318,7 @@ void __init e820_reserve_resources_late(void)
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
 		if (!res->parent && res->end)
-			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
+			insert_resource_expand_to_fit(&iomem_resource, res->start, res->end, res->name);
 		res++;
 	}
 }
