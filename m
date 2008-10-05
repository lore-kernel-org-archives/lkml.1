Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYJEMmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYJEMmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYJEMmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:42:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:21284 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYJEMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L+o+qOjc//GUrcRxtl14xbUOsSkz+LjRjQQosXdLcEeA7FzcKMV81Wib8mL97rnUK5
         ryLUY18YLZG6rv80q8PGpeMK1jCWkfGtts6X5N2sM0IRyvRMXNFKIrFTtQb6zewKU0Us
         hettUBB2ir4JoolI8zIl5ASXdnAqjdeVZ8QIA=
Message-ID: <19f34abd0810050542k607221acs526b38aaba36b501@mail.gmail.com>
Date: Sun, 5 Oct 2008 14:42:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: kmemcheck: Caught 32-bit read from uninitialized memory (f6038ec0)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080929131411.GA26442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080928180652.GA8500@localhost.localdomain>
	 <20080929085512.GA2190@elte.hu>
	 <19f34abd0809290213m54a2c485p5917fcd46747ad6@mail.gmail.com>
	 <20080929092546.GB7735@elte.hu> <20080929094308.GA18887@elte.hu>
	 <20080929111314.GA28154@elte.hu> <20080929115757.GA3430@elte.hu>
	 <20080929131411.GA26442@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> another crash is below - config attached.
>
>        Ingo
>
> ----------------->
> initcall 0xc08eabf0 returned 0 after 7 msecs
> calling  0xc08eae70 @ 1
> PnPBIOS: Scanning system for PnP BIOS support...
> PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
> PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
> BUG: unable to handle kernel paging request at 0000c6ef

Thanks, I can reproduce it. And that's very interesting. Look at the
faulting address and the line just above:

    PnP BIOS version 1.0, entry 0xf0000:0xc580

When I run it, I get something similar:

    PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x67ba, dseg 0xf0000
    BUG: unable to handle kernel paging request at 000068ac

Enabling debug information also gives me the location of the crash. It
happens in kmemcheck's opcode decoder, when we dereference regs->eip.
Is it possible that PnPBIOS is executing some code which is located at
these weird addresses (like 16-bit code) and requires a different
segment register?

Maybe we should just check regs->flags to make sure that we are not in
VM86 mode or similar. Will experiment a bit with it. Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
