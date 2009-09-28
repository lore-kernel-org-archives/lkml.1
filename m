Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZI1VoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZI1VoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZI1VoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:44:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZI1VoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:44:16 -0400
Message-ID: <4AC12B6E.7010805@zytor.com>
Date: Mon, 28 Sep 2009 14:32:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
References: <20090924132626.485545323@polymtl.ca>	<20090924133359.218934235@polymtl.ca>	<20090924212013.d27226c4.akpm@linux-foundation.org>	<20090928012337.GC1656@one.firstfloor.org>	<20090928104617.9c4b868a.akpm@linux-foundation.org>	<20090928200317.64a419ff@infradead.org>	<20090928195444.GF1656@one.firstfloor.org> <20090928223735.74267e3e@infradead.org>
In-Reply-To: <20090928223735.74267e3e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 01:37 PM, Arjan van de Ven wrote:
> 
> this makes me wonder what happens when a variable is used in multiple
> places... that makes the icache overhead multiply right?
> 

On x86, the icache overhead can often be zero or close to zero -- or
even negative in a fairly common subcase[1] -- simply because you are
dropping a displacement used to fetch a global variable with an
immediate in the code itself.

For 8- or 16-bit data items this is even more of a win in terms of
icache space; for 64-bit data it is always a lose.

It is also worth noting that the way this is implemented as a graft-on
rather than with compiler support means that the full instruction set
cannot exploited -- x86 can often use a memory operand or immediate as
part of an operation.  This adds icache pressure.

	-hpa

[1] Common subcase:

	movl global, %reg	; 6 bytes (unless reg is eax on 32 bits)
	movl $immed, %reg	; 5 bytes

