Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211Ab0ANPc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0ANPc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387Ab0ANPcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:32:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab0ANPcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:32:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=2r-ASxw-naAA:10 a=7U3hwN5JcxgA:10 a=Iv9AUmjro1caR8ARb8kA:9 a=YIdgQicXJ5Xw9gcfosEA:7 a=z7WSQR9yrZfsUuFwLw-eh88H-pEA:4 a=wLvJier4ib4ikeRE:21 a=5DNQ-Fw6TpTpOLCr:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
 patching without stop_machine
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
References: <cover.1263247113.git.jbaron@redhat.com>
	 <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 10:32:19 -0500
Message-ID: <1263483139.28171.3857.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 11:26 -0500, Jason Baron wrote:

> +/**
> + * text_poke_fixup() -- cross-modifying kernel text with fixup address.
> + * @addr:	Modifying address.
> + * @opcode:	New instruction.
> + * @len:	length of modifying bytes.
> + * @fixup:	Fixup address.
> + *
> + * Note: You must backup replaced instructions before calling this,
> + * if you need to recover it.
> + * Note: Must be called under text_mutex.
> + */
> +void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
> +				void *fixup)
> +{
> +	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
> +	static const int int3_size = sizeof(int3_insn);
> +
> +	/* Replacing 1 byte can be done atomically. */
> +	if (unlikely(len <= 1))
> +		return text_poke(addr, opcode, len);

This part bothers me. The text_poke just writes over the text directly
(using a separate mapping). But if that memory is in the pipeline of
another CPU, I think this could cause a GPF.

-- Steve

> +
> +	/* Preparing */
> +	patch_fixup_addr = fixup;
> +	wmb();
> +	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
> +
> +	/* Cap by an int3 */
> +	text_poke(addr, &int3_insn, int3_size);
> +	sync_core_all();
> +
> +	/* Replace tail bytes */
> +	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
> +		  len - int3_size);
> +	sync_core_all();
> +
> +	/* Replace int3 with head byte */
> +	text_poke(addr, opcode, int3_size);
> +	sync_core_all();
> +
> +	/* Cleanup */
> +	patch_fixup_from = NULL;
> +	wmb();
> +	return addr;
> +}
> +

