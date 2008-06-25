Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYFYTyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYFYTyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYFYTyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:54:13 -0400
Received: from smtp.fullrate.dk ([89.150.129.5]:63819 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYFYTyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:54:12 -0400
Message-ID: <4862A25C.2060703@agner.org>
Date: Wed, 25 Jun 2008 21:54:04 +0200
From: Agner Fog <agner@agner.org>
Organization: agner@agner.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org>
In-Reply-To: <20080625092224.736c2541@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
 >Let me repeat this loud and clear:
 >It is not allowed to use floating point, SSE of AVX in device drivers.

Thank you for a clear answer. Re-reading the ABI:
 >A.2.4 Miscellaneous Remarks
 >Linux Kernel code is not allowed to change the x87 and SSE units. If 
those are
 >changed by kernel code, they have to be restored properly before 
sleeping or leaving
 >the kernel. On preemptive kernels also more precautions may be needed.

This states your point, but certainly not "loud and clear" :-)

This ABI statement has to be amended, however, because it is allowed to 
use any register as long it is "restored properly". A programmer can 
save a single XMM register, use it, and restore it. A programmer might 
think that it is possible to do the same with a YMM register, but this 
will not work on future systems that extend the 256-bit YMM registers to 
512-bit ZMM or whatever. This has to be said "loud and clear" because 
nobody would discover the error until a distant future when we have ZMM.

Let me explain the background for this as I understand it:
Intel have decided to make two versions of every existing XMM 
instruction in the new AVX: A legacy version that leaves the upper half 
of the YMM register unchanged, and a new AVX version that clears the 
upper part of the YMM register in order to avoid false dependencies. 
This very expensive decision was necessary for only one reason: To 
prevent existing device drivers from destroying the upper part of the 
YMM registers. Learning from past mistakes, they are saying already now 
that they will not use the same fix next time the registers are made 
bigger. When ZMM and still bigger registers are introduced, the YMM 
instructions will clear bit number 256 and up of the ZMM or whatever 
registers.

Note: Please Cc: me of any replies. I am not on the mailing list.

