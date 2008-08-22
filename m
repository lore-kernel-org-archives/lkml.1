Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYHVRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYHVRR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYHVRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:17:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYHVRQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:16:59 -0400
Message-ID: <48AEF457.5020100@zytor.com>
Date: Fri, 22 Aug 2008 10:16:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>	<48ADDF4F.2020401@zytor.com>	<48AE5FCF.6030103@zytor.com>	<20080822065012.GV14110@elte.hu>	<20080822113941.147a1db0@doriath.conectiva>	<20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva>
In-Reply-To: <20080822132948.57e47076@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was looking at the code stream, and noticed this:

Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff 
e8 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 
8b 45 bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8

Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff 
e8 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 
8b 45 bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8

The EIP is in the *MIDDLE* of a NOPL instruction:

C012FC46  C00F84            ror byte [edi],0x84
C012FC49  0B01              or eax,[ecx]
C012FC4B  0000              add [eax],al
C012FC4D  B8D0BF41C0        mov eax,0xc041bfd0
C012FC52  C7056CC041C0FFFF  mov dword [dword 0xc041c06c],0xffffffff
          -FFFF
C012FC5C  E87F822100        call dword 0xc0347ee0
C012FC61  E81A030200        call dword 0xc014ff80
C012FC66  8B45B0            mov eax,[ebp-0x50]
C012FC69  50                push eax
C012FC6A  9D                popfd
C012FC6B  0F1F840000000000  nop dword [eax+eax+0x0]
C012FC73  8B45BC            mov eax,[ebp-0x44]
C012FC76  83C460            add esp,byte +0x60
C012FC79  5B                pop ebx
C012FC7A  5E                pop esi
C012FC7B  5F                pop edi
C012FC7C  5D                pop ebp
C012FC7D  C3                ret
C012FC7E  6690              xchg ax,ax
C012FC80  A16CC041C0        mov eax,[0xc041c06c]

There are two possibilities: VirtualBox mis-executes (not merely traps, 
which is what tip:master looks for) the NOPL instruction, or something 
is jumping into the middle of the sequence that is then replaced by the 
NOPL.

So, Luiz: the DEBUG_INFO version of vmlinux would be helpful.  It would 
also help to know the exact version of VirtualBox you're running, what 
source you got it from, and what your host system looks like.

	-hpa
