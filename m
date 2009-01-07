Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZAGGCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZAGGCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZAGGCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:02:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:34952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZAGGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bedZEXD4gjVEsY5U7TaGozPkKrTZJdTAIKA3AdJRGSP+65xizM7nO3z81MsIdRuQJA
         Xd6bweehqnsEoM9wMPHNxm22CnKTXds+yoMJrxAB07NuFmckVhiYTqKBxjmgQF/2HbOs
         0LnuplaJjvmZnrP8YnRWXukydb+Fdzn91ZVIs=
Subject: Re: powerpc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0901062122100.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org>
	 <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop>
	 <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
	 <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
	 <alpine.LFD.2.00.0901062122100.3057@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 22:02:28 -0800
Message-Id: <1231308148.14442.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 21:37 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Nicolas Pitre wrote:
> 
> > On Tue, 6 Jan 2009, Linus Torvalds wrote:
> > > On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> > > 
> > > Can you also verify that it works for you (not just compiles), just so 
> > > that I can commit it?
> > 
> > Tested OK on ARM (using LE mode with networking, etc.)
> 
> Ok, I committed it as a quick-fix. I'm not sure that is necessarily the 
> final one, but at least it is better than not compiling.

Yes, your fix should be all that is needed to fix it.  My apologies for not
rerunning all the compile tests (only did x86 but did a compile test with
x86 faking itself as a big endian arch)

> 
> For example, it's kind of silly to use two __fswab32()'s with other 
> oddness if that one just falls back on __constant_swab32: maybe we'd want 
> to make sure that we'd use ___constant_swab64() in that case, and only do 
> the whole __SWAB_64_THRU_32__ if we really have a __arch_swab32() 
> function.
> 
> Of course, I do hope that anybody who #defines __SWAB_64_THRU_32__ already 
> has that __arch_swab32() thing, so it's likely fine.

Hmm, this is a direct holdover from the old swab.h/swabb.h pieces.  I
came this close to eliminating that case too, but didn't have disassembly
to justify it.  You're right I think that changing that to:

#elif defined(__SWAB_64_THRU_32__) && defined(__arch_swab32)

makes a lot of sense, but I'd like to here from some arch guys.

The following arches define __SWAB_64_THRU_32__ and have __arch_swab32
arm, blackfin, avr32, cris, m68knommu, m68k, mips, sh, xtensa

And the following define __SWAB_64_THRU_32__ and don't have __arch_swab32
h8300
s390 (conditional on _ifndef __s390x__)
sparc (32-bit only)
frv
m32r
mn10300

Cheers,

Harvey


