Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYHVRpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYHVRpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYHVRpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:45:32 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46778 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYHVRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:45:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAISXrkhMRKxB/2dsb2JhbACBZbR1gWg
Date: Fri, 22 Aug 2008 13:45:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822174529.GA13020@Krystal>
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com> <48AE5FCF.6030103@zytor.com> <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <48AEF457.5020100@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48AEF457.5020100@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:42:54 up 78 days, 22:23,  6 users,  load average: 0.70, 0.87,
	0.89
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Was looking at the code stream, and noticed this:
>
> Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff e8 
> 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 8b 45 
> bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8
>
> Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff e8 
> 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 8b 45 
> bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8
>
> The EIP is in the *MIDDLE* of a NOPL instruction:
>
> C012FC46  C00F84            ror byte [edi],0x84
> C012FC49  0B01              or eax,[ecx]
> C012FC4B  0000              add [eax],al
> C012FC4D  B8D0BF41C0        mov eax,0xc041bfd0
> C012FC52  C7056CC041C0FFFF  mov dword [dword 0xc041c06c],0xffffffff
>          -FFFF
> C012FC5C  E87F822100        call dword 0xc0347ee0
> C012FC61  E81A030200        call dword 0xc014ff80
> C012FC66  8B45B0            mov eax,[ebp-0x50]
> C012FC69  50                push eax
> C012FC6A  9D                popfd
> C012FC6B  0F1F840000000000  nop dword [eax+eax+0x0]
> C012FC73  8B45BC            mov eax,[ebp-0x44]
> C012FC76  83C460            add esp,byte +0x60
> C012FC79  5B                pop ebx
> C012FC7A  5E                pop esi
> C012FC7B  5F                pop edi
> C012FC7C  5D                pop ebp
> C012FC7D  C3                ret
> C012FC7E  6690              xchg ax,ax
> C012FC80  A16CC041C0        mov eax,[0xc041c06c]
>
> There are two possibilities: VirtualBox mis-executes (not merely traps, 
> which is what tip:master looks for) the NOPL instruction, or something is 
> jumping into the middle of the sequence that is then replaced by the NOPL.
>
> So, Luiz: the DEBUG_INFO version of vmlinux would be helpful.  It would 
> also help to know the exact version of VirtualBox you're running, what 
> source you got it from, and what your host system looks like.
>
> 	-hpa

The patch which turns on this bug this this important change to the
apply paravirt : it disables interrupts _near_ the code patching,
_within_ the loop. Before, interrupts were disabled outside of the loop.
It needs to disable interrupts within the loop to be able to use vmap in
text_poke().

So I bet VirtualBox has a race in the way it handles interrupt
disabling.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
