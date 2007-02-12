Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXBLWxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXBLWxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030447AbXBLWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:53:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030449AbXBLWxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:53:42 -0500
Date: Mon, 12 Feb 2007 14:53:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Luck <tony.luck@intel.com>
cc: Oleg Verych <olecom@flower.upol.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in
 localversion files
In-Reply-To: <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org>
References: <20070206011819.160359000@flower.upol.cz> 
 <20070206012208.050237000@flower.upol.cz> <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Feb 2007, Tony Luck wrote:
> 
> Git bisect fingers this patch (which is in Linus' tree as commit
> 76c329563c5b8663ef27eb1bd195885ab826cbd0) as the culprit
> for double adding the contents of the localversion file.  E.g.
> 
> $ echo -tiger-smp > localversion
> $ make prepare
> $ make kernelrelease
> 2.6.20-tiger-smp-tiger-smp

Heh. It's because we search for the localversion files in both $objtree 
and $srctree, and normally they are one and the same - so it finds the 
same file twice.

The old code did the same thing, but with the "make" $(sort ..) function, 
which apparently removes duplicates. We should use "sort -u" here.

Both the old code *and* the new code is just horribly complex. The old 
code appears to suffer from GNU $(wildcard ..), the new code is almost as 
ugly in doing an unnecessarily complex "find".

Oh well.

		Linus
