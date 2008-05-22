Return-Path: <linux-kernel-owner+w=401wt.eu-S934904AbYEVMH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbYEVMH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbYEVMHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:07:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:65483 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759884AbYEVMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=docytjzrqexg9iYekzIrtS9wuWr4Ss8dFa0cw0dXjZpd57hU9W8TeE3UeKXdy1ycJ7KzbD3n+3epCeAdQD0J1VaSQL1ivrlVYVtdayGwZ8HQhl4UJJT9wVG00AH7bpE5RFJl1Mp+dmSPK8eo8or8adFrswdk6jlmiRKpf4ch3oQ=
Message-ID: <19f34abd0805220507w31e152ar5c9dd04f9774d0e1@mail.gmail.com>
Date: Thu, 22 May 2008 14:07:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] x86: don't destroy %rbp on kernel-mode faults
Cc: "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@linux.intel.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <4831EE48.5050908@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519200230.GA12210@damson.getinternet.no>
	 <4831EE48.5050908@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Vegard Nossum wrote:
>> Hi,
>>
>> The RFC part of this patch is: Does anybody see why touching %rcx would
>> be bad? It certainly looks like %ecx is free. This fixes the stacktrace
>> problem I was seeing, and Pekka tested a bootup to userspace. (Pekka also
>> did half of the debugging. When will git allow multiple authors for a
>> patch? :-))
>
> The patch is ok, but I'm sure there's lots of other assembler code that
> destroys %rbp when it was saved elsewhere.

Thanks, The real intention of this code (you might have guessed it)
was to fix kmemcheck on 64-bit, and it did, so I'm happy. If we (or
others) hit another similar case, I'm sure we'll be able to fix those
too.

The problem seems to be that %rbp was never restored before it was
used again, and that's what I consider the real error in this case. I
changed it to use a different register for the temporary computation,
but restoring %rbp from wherever it was stored would also have been a
valid, albeit less efficient, solution.

> When I wrote all the assembler the assumption was always that a real
> unwinder would be used for backtraces, not frame pointer.

Hm, I am not sure exactly what a "real unwinder" would be. But I do
think it's fair to say that it is the assembly code in this case that
is violating the binary interface, and not the stack tracer code.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
