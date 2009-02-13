Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZBMEQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZBMEQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZBMEPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:15:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:52640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbZBMEPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:15:51 -0500
Subject: Re: [PATCH 3/7][RFC] powerpc64, tracing: add function graph tracer
 with dynamic tracing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090212011343.074329920@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
	 <20090212011343.074329920@goodmis.org>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 15:15:09 +1100
Message-Id: <1234498509.26036.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -55,8 +56,9 @@ static unsigned char *ftrace_call_replace(unsigned
> long ip, unsigned long addr)
>  	 */
>  	addr = GET_ADDR(addr);
>  
> -	/* Set to "bl addr" */
> -	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> +	/* if (link) set op to 'bl' else 'b' */
> +	op = 0x48000000 | (link ? 1 : 0);
> +	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);

Any reason why you aren't using the code in
arch/powerpc/lib/code-patching.c here ?

> 	new = ftrace_call_replace(ip, stub, 0);
> +	memcpy(old, new, MCOUNT_INSN_SIZE);
> +	new = ftrace_call_replace(ip, addr, 0);
> +
> +	return ftrace_modify_code(ip, old, new);
> +}

Heh, memcpy of 4 bytes :-) I hope gcc is smart enough to turn that into
a simple load/store ..

Cheers,
Ben.

