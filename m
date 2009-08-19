Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZHSQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZHSQtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZHSQtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZHSQtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:49:17 -0400
Message-ID: <4A8C2CDE.1010405@zytor.com>
Date: Wed, 19 Aug 2009 09:48:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make use of inc/dec conditional
References: <4A8BCA850200007800010836@vpn.id2.novell.com>
In-Reply-To: <4A8BCA850200007800010836@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 12:48 AM, Jan Beulich wrote:
> According to gcc's instruction selection, inc/dec can be used without
> penalty on most CPU models, but should be avoided on others. Hence we
> should have a config option controlling the use of inc/dec, and
> respective abstraction macros to avoid making the resulting code too
> ugly. There are a few instances of inc/dec that must be retained in
> assembly code, due to that code's dependency on the instruction not
> changing the carry flag.

One thing: I doubt it matters one measurable iota when it comes to
locked operations.

Furthermore:

-		     "decl %2	;\n"
+		     _ASM_DECL "%2	;\n"
 		     "jne 1b		;\n"
 		     "adcl $0, %0	;\n"

It looks to me that the carry flag is live across the dec there.  The
other csum code look scary to me too.

The rest of them look technically okay, but you're bloating them by two
bytes (one byte in 64-bit mode) for every instance.  You may want to
consider if any particular instance is more icache-critical than
stall-critical.  This is probably more of a concern for inlines than for
regular single-instance code like the string operations.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

