Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXKNAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXKNAeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbXKNAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:34:13 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:39035 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760071AbXKNAeM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:34:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAM/QOUdMROHU/2dsb2JhbACBW45t
Date: Tue, 13 Nov 2007 19:34:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update)
Message-ID: <20071114003409.GA18032@Krystal>
References: <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <473A26A2.7090007@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:29:50 up 10 days,  5:35,  5 users,  load average: 0.48, 1.11,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Andi seemed to trust gas stability and you answered:
>> "The comment was referring to x86-64, but I incorrectly remembered that 
>> applying to "movq $imm,%reg" as opposed to loading from an absolute 
>> address.  gas actually has a special opcode (movabs) for the 64-bit 
>> version of the latter variant, which is only available with %rax and its 
>> subregisters.
>> Nevermind, in other words.  It's still true, though, that the immediate 
>> will always be the last thing in the instruction -- that's a fixture of 
>> the instruction format."
>> So, in the end, is there a way to make x86_64 use a fixed-size opcode
>> for the 1, 2, 4 and 8 bytes load immediates or we will have to force the
>> use of a specific register ?
>> (and we can't take a pointer from the end of the instruction, because we
>> need to align the immediate value correctly)
>
> For a 64-bit load, you'll always have a REX prefix.  For 8-, 16- and 32-bit 
> load, the length of the instruction will depend on the register chosen, 
> unless you constrain to either all legacy or all upper registers, or you 
> force gas to generate a prefix, but I don't think there is a way to do that 
> that will work with assemblers all the way back to 2.12, which is at least 
> what we officially support (I have no idea if assemblers that far back 
> actually *work*, mind you.)
>
> 	-hpa

Ok, so the most flexible solution that I see, that should fit for both
i386 and x86_64 would be :


1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
2, 4 bytes : "=R" : Legacy register—the eight integer registers available
                 on all i386 processors (a, b, c, d, si, di, bp, sp). 
8 bytes : (only for x86_64)
          "=r" : A register operand is allowed provided that it is in a
                 general register.

That should make sure x86_64 won't try to use REX prefixed opcodes for
1, 2 and 4 bytes values.

Does it make sense ?

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
