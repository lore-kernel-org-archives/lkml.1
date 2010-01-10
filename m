Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797Ab0AJVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0AJVNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171Ab0AJVNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:13:06 -0500
Received: from mailout-venus.uni-duesseldorf.de ([134.99.128.32]:42266 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752762Ab0AJVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:13:05 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 16:13:05 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 10 Jan 2010 21:12:59 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and
  old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new
  email address)
In-reply-to: <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
 <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

> > > The order of symbols in the system map is different (as you would expect)
> > > but I don't see what implicit assumption would be violated.
> > 
> > Tim, any clues? Michael is using gcc 3.3.6 and binutils 2.16.
> > It works fine with my 4.1.2/2.18 vombo.
> 
> I think to debug this, we'll want to split the patch into the various 
> small changes that make it up and determine which change caused the 
> problem.  Michael, are you willing to do that debugging?  I'd be happy to 
> generate for you a patch series of like a dozen patches broken out for 
> bisecting if that'd help.

Forgot to mention - I did (manually) revert the patch by pieces (throwing out
the macros and putting back the code that was replaced by the macros). Nothiing 
short of a complete reversal would fix the problem.

Seeing as I'm not a toolchain expert, I may have made mistakes in dissecting
the patch. If you can send a series of patches I'd be happy to test them (just 
tell me whether they're all relative to git head, or need to be applied strictly 
in order). 

Absence or misplacement of bootinfo data as suggested by Andreas seems a good 
candidate - here's the symbols that are explicitly mentioned in the old LD 
script, for the new (non-booting) kernel:

00001000 A _text
00002000 T _start
00212dc6 A _etext
00212dd0 R __start___ex_table
00215590 R __stop___ex_table
002f0d14 A _edata
002f1000 A __init_begin
002f1000 T _sinittext
0030610e T _einittext
0030aa80 T __setup_start
0030ad14 T __initcall_start
0030ad14 T __setup_end
0030afcc T __con_initcall_start
0030afcc T __initcall_end
0030afd0 T __con_initcall_end
0030b000 T __initramfs_start
0030b200 D __start_fixup
0030b200 T __initramfs_end
0030bed0 D __stop_fixup
0030c000 A _end
0030c000 T __init_end

And this is the same list for the kernel generated using the old LD script:

00001000 A _text
00002000 T _start
00212dc6 A _etext
00212dd0 A __start___ex_table
00215590 A __stop___ex_table
002edd14 A _edata
002ee000 A __init_begin
002ee000 T _sinittext
0030310e T _einittext
00307a80 A __setup_start
00307d14 A __initcall_start
00307d14 A __setup_end
00307fcc A __con_initcall_start
00307fcc A __initcall_end
00307fd0 A __con_initcall_end
00307fd0 D __start_fixup
00308ca0 D __stop_fixup
0030a000 A __initramfs_start
0030a200 A __initramfs_end
0030c000 A __init_end
0030e000 A _end

The only difference I can spot is the placement of the fixup section.

FWIW: when stripping the new kernel, I get this warning:

BFD: st7CwWnM: warning: allocated section `.init_end' not in segment

And indeed, the old script places the init task data between .init_end and _end.

Binutils bug, or meaningless? 

	Michael
