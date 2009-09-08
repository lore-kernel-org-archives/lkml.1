Return-Path: <linux-kernel-owner+w=401wt.eu-S1751015AbZIHOhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbZIHOhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZIHOhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:37:04 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60982 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbZIHOhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:37:03 -0400
Date: Tue, 8 Sep 2009 10:36:33 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
In-Reply-To: <4AA5FF9D.10703@snapgear.com>
Message-ID: <alpine.DEB.1.10.0909080930580.28351@dr-wily.mit.edu>
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com> <4AA49946.2000804@snapgear.com> <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu> <4AA4B104.7040507@snapgear.com> <alpine.DEB.1.10.0909071017001.17860@dr-wily.mit.edu>
 <4AA5FF9D.10703@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Greg Ungerer wrote:

> But now the bss section doesn't looked properly aligned (at
> least it is not on a page boundary any longer after the init.data):
> 
> Sections:
> Idx Name          Size      VMA       LMA       File off  Algn
>   0 .text         00124ab8  40020000  40020000  00002000  2**4
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>   1 .data         00011540  40144ac0  40144ac0  00126ac0  2**4
>                   CONTENTS, ALLOC, LOAD, DATA
>   2 .init.text    0000a96c  40156000  40156000  00138000  2**2
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>   3 .init.data    00000b7c  4016096c  4016096c  0014296c  2**2
>                   CONTENTS, ALLOC, LOAD, DATA
>   4 .bss          0000a9e8  401614f0  401614f0  001434e8  2**4
>                   ALLOC
>   5 .comment      00001c8c  00000000  00000000  001434e8  2**0
>                   CONTENTS, READONLY
> 
> Seems kind of odd because:
> 
> 40156000 A __init_begin
> 40162000 A __init_end
> 401614f0 B _sbss

Yes, that is quite odd.  

> The resulting kernels don't boot.

Right, presumably a big chunk of the .sbss code is being freed since _sbss 
is before __init_end.

I'm guessing the issue here is that the __init_begin and __init_end 
markers are now not actually in a section (and thus don't have a memory 
region marker attached).  Does the following patch cause _sbss to not 
overlap the init region?

	-Tim Abbott

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index c380040..81b54cb 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -154,12 +154,16 @@ SECTIONS {
 		_edata = . ;
 	} > DATA
 
-	. = ALIGN(PAGE_SIZE);
-	__init_begin = .;
+	.init_begin : {
+		. = ALIGN(PAGE_SIZE);
+		__init_begin = .;
+	} > INIT
 	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
 	INIT_DATA_SECTION(16) > INIT
-	. = ALIGN(PAGE_SIZE);
-	__init_end = .;
+	.init_end : {
+		. = ALIGN(PAGE_SIZE);
+		__init_end = .;
+	} > INIT
 
 	/DISCARD/ : {
 		EXIT_TEXT
