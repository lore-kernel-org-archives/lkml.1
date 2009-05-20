Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZETXSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZETXSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZETXSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52789 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbZETXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:07 -0400
X-Sasl-enc: ZMqDIMrLlwH7oDRXMV8KlUidFTqnyP3kQOJmKxY+nuX9 1242861487
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: cleanup
Date: Thu, 21 May 2009 01:17:58 +0200
Message-Id: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and others!

Here is a new batch of patches to the entry code. I started
something similar a few months ago for x86_64, but I lack a
64-bit machine I can use to test at the moment, so I decided
to make a start on i386 instead.

This series takes on the SAVE_ALL macro, which expanded to a
pretty large number of instructions in every interrupt dispatcher
in entry_32.S. Instead, it now expands to a call to a function
(save_entry) that does the register saving and the preparation
needed to call C functions.

This also gets rid of the indirect call used in the interrupt
dispatcher. The old code does some interesting shuffle on the
stack to pass the address of the C handler to a common piece
of code. The new version creates a stub that for each interrupt,
where each stub calls save_entry, does a direct call to the
C handler and the jumps to a common return path.

I did some latency measurements and this code does not perform
significantly better or worse than the old code on a "Sempron
2400+". The original aim was to shrink entry_32.o, but this
goal was not reached. The size has not changes significantly,
mostly due to the due to the check for %ss==__ESPFIX_SS in the
exception stubs and the fact that the SAVE_ALL macro expanded
to a lot of small instructions. On the other hand, entry_32.S
shrunk by more than 10%:

 arch/x86/kernel/cpu/mcheck/mce_32.c |    6 +
 arch/x86/kernel/entry_32.S          |  513 +++++++++++------------------------
 2 files changed, 171 insertions(+), 348 deletions(-)

I'ld very much appreciate some more testing in the -x86 pool.

Greetings,
    Alexander
