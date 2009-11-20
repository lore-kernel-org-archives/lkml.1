Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZKTVyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZKTVyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZKTVyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:54:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZKTVyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:54:52 -0500
Message-ID: <4B071000.9080408@zytor.com>
Date: Fri, 20 Nov 2009 13:54:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com>
In-Reply-To: <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 02:43 PM, Jason Baron wrote:
> Add text_poke_fixup() which takes a fixup address to where a processor
> jumps if it hits the modifying address while code modifying.
> text_poke_fixup() does following steps for this purpose.
> 
>  1. Setup int3 handler for fixup.
>  2. Put a breakpoint (int3) on the first byte of modifying region,
>     and synchronize code on all CPUs.
>  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>  4. Modify the first byte of modifying region, and synchronize code
>     on all CPUs.
>  5. Clear int3 handler.
> 
> Thus, if some other processor execute modifying address when step2 to step4,
> it will be jumped to fixup code.
> 
> This still has many limitations for modifying multi-instructions at once.
> However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
> because;
>  - Replaced instruction is just one instruction, which is executed atomically.
>  - Replacing instruction is a jump, so we can set fixup address where the jump
>    goes to.
> 

I just had a thought about this... regardless of if this is safe or not
(which still remains to be determined)... I have a bit more of a
fundamental question about it:

This code ends up taking *two* global IPIs for each instruction
modification.  Each of those requires whole-system synchronization.  How
is this better than taking one IPI and having the other CPUs wait until
the modification is complete before returning?

	-hpa
