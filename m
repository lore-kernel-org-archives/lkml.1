Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYHZRdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYHZRdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYHZRdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:33:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYHZRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:33:12 -0400
Message-ID: <48B43E2E.5000207@zytor.com>
Date: Tue, 26 Aug 2008 10:32:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Gerhard Brauer <gerhard.brauer@web.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Colin Ian King <colin.king@ubuntu.com>
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal>
In-Reply-To: <20080826171822.GB14906@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been unable to replicate this on my own hardware mostly because 
my testing machine decided to blow its DVD drive in some very strange 
way, but I did pick apart the data from Luiz, and found it very interesting:

The code sequence before patching looks like:

c012fc69:       51                      push   %ecx
c012fc6a:       52                      push   %edx
c012fc6b:       ff 15 40 b9 41 c0       call   *0xc041b940
c012fc71:       5a                      pop    %edx
c012fc72:       59                      pop    %ecx

After patching:

50 9d 0f 1f 84 00 00 00 <00> 00

... which disassembles to (in Intel notation):

C012FC69  50                push eax
C012FC6A  9D                popfd
C012FC6B  0F1F840000000000  nop dword [eax+eax+0x0]

We do, indeed have a return point that falls in the *middle* of a 
patched instruction, and if the patching happens in the middle of the 
instruction call, then, well, bad things happen.

Furthermore, why on Earth is %ecx/%edx pushed and popped in-line here? 
Surely it should be the responsibility of the PV call to present a 
no-clobber interface (using an assembly wrapper if necessary[*]), rather 
than bloating every callsite like this?

	-hpa


[*] One can compile gcc code with -fcall-saved-* to use nonstandard 
register conventions.  Unfortunately stock gcc only lets you do this 
with a file parameter, and doesn't support doing this with attributes.
