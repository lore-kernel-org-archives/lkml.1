Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbXIEBoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbXIEBoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 21:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbXIEBoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 21:44:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXIEBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 21:44:04 -0400
Message-ID: <46DE08EA.1050705@zytor.com>
Date: Wed, 05 Sep 2007 02:39:54 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Ehrhardt <lk@c--e.de>
Subject: Re: [GIT PULL] x86 setup: work around bug in Xen HVM
References: <200709041655.l84GtjiJ008962@tazenda.hos.anvin.org> <20070904223303.GA22306@infradead.org>
In-Reply-To: <20070904223303.GA22306@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Sep 04, 2007 at 09:55:45AM -0700, H. Peter Anvin wrote:
>>     
>>     Apparently XEN does not keep the contents of the 48-bit gdt_48 data
>>     structure that is passed to lgdt in the XEN machine state. Instead it
>>     appears to save the _address_ of the 48-bit descriptor
>>     somewhere. Unfortunately this data happens to reside on the stack and
>>     is probably no longer availiable at the time of the actual protected
>>     mode jump.
>>     
>>     This is Xen bug but given that there is a one-line patch to work
>>     around this problem, the linux kernel should probably do this.  My fix
>>     is to make the gdt_48 description in setup_gdt static (in setup_idt
>>     this is already the case). This allows the kernel to boot under
>>     Xen HVM again.
> 
>> -	struct gdt_ptr gdt;
>> +	static struct gdt_ptr gdt;
> 
> It might make sense to add your above commit message to the code as a comment.

Good point; I have amended the commit with a brief comment:

diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 6be9ca8..09fb342 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -122,7 +122,11 @@ static void setup_gdt(void)
                 /* DS: data, read/write, 4 GB, base 0 */
                 [GDT_ENTRY_BOOT_DS] = GDT_ENTRY(0xc093, 0, 0xfffff),
         };
-       struct gdt_ptr gdt;
+       /* Xen HVM incorrectly stores a pointer to the gdt_ptr, instead
+          of the gdt_ptr contents.  Thus, make it static so it will
+          stay in memory, at least long enough that we switch to the
+          proper kernel GDT. */
+       static struct gdt_ptr gdt;

         gdt.len = sizeof(boot_gdt)-1;
         gdt.ptr = (u32)&boot_gdt + (ds() << 4);

	-hpa
