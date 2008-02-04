Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYBDWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYBDWlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYBDWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:41:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbYBDWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:41:29 -0500
Date: Mon, 4 Feb 2008 14:40:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: bwalle@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       paulus@samba.org
Subject: Re: 2.6.24-mm1: ppc32: too few arguments to function
 'reserve_bootmem'
Message-Id: <20080204144036.cf22a402.akpm@linux-foundation.org>
In-Reply-To: <200802042129.03065.m.kozlowski@tuxland.pl>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<200802042129.03065.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 21:29:02 +0100
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This is from ppc32:
> 
>   CC      arch/powerpc/mm/mem.o
> arch/powerpc/mm/mem.c: In function 'do_init_bootmem':
> arch/powerpc/mm/mem.c:256: error: too few arguments to function 'reserve_bootmem'
> arch/powerpc/mm/mem.c:261: error: too few arguments to function 'reserve_bootmem'
> 
> Leftover from introduce-flags-for-reserve_bootmem.patch?
> 

Yes, I've had to fix that patch many times.

--- a/arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem-powerpc-fix
+++ a/arch/powerpc/mm/mem.c
@@ -253,12 +253,13 @@ void __init do_init_bootmem(void)
 				     lmb_size_bytes(&lmb.reserved, i) - 1;
 		if (addr < total_lowmem)
 			reserve_bootmem(lmb.reserved.region[i].base,
-					lmb_size_bytes(&lmb.reserved, i));
+					lmb_size_bytes(&lmb.reserved, i),
+					BOOTMEM_DEFAULT);
 		else if (lmb.reserved.region[i].base < total_lowmem) {
 			unsigned long adjusted_size = total_lowmem -
 				      lmb.reserved.region[i].base;
 			reserve_bootmem(lmb.reserved.region[i].base,
-					adjusted_size);
+					adjusted_size, BOOTMEM_DWEFAULT);
 		}
 	}
 #else
_

We did this wrong.  We should have introduced a new reserve_bootmem_foo()
and migrated over to that in stages.  Once all callers are migrated, remove
the old interface.

