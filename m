Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZLRULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZLRULn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbZLRULf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:11:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932646AbZLRULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:11:10 -0500
Date: Fri, 18 Dec 2009 12:10:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: -tip: origin tree boot crash
In-Reply-To: <20091218164509.GA14574@elte.hu>
Message-ID: <alpine.LFD.2.00.0912181158300.3712@localhost.localdomain>
References: <20091218164509.GA14574@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Ingo Molnar wrote:
> [   75.151208] calling  nas_gpio_init+0x0/0x153 @ 1
> [   75.155860] BUG: unable to handle kernel paging request at 00000000001de7d0
> [   75.159841] IP: [<ffffffff81683c55>] strstr+0x20/0x5f

Ok, the disassembly is

   b:	55                   	push   %rbp
   c:	48 89 f2             	mov    %rsi,%rdx
   f:	48 89 e5             	mov    %rsp,%rbp
  12:	eb 03                	jmp    0x17
  14:	48 ff c2             	inc    %rdx
  17:	80 3a 00             	cmpb   $0x0,(%rdx)
  1a:	75 f8                	jne    0x14
  1c:	29 f2                	sub    %esi,%edx
  1e:	48 89 f8             	mov    %rdi,%rax
  21:	74 45                	je     0x68
  23:	48 89 f9             	mov    %rdi,%rcx
  26:	eb 03                	jmp    0x2b
  28:	48 ff c1             	inc    %rcx
  2b:*	80 39 00             	cmpb   $0x0,(%rcx)     <-- trapping instruction
  2e:	75 f8                	jne    0x28
  30:	48 89 f8             	mov    %rdi,%rax
  33:	4c 63 d2             	movslq %edx,%r10
  36:	eb 26                	jmp    0x5e

so if I read that code right, that's a 'strlen()' on %rdi, which is the 
first argument to strstr().

So it would be that 

	l1 = strlen(s1);

thing, and 's1' is bad.

Which in turn means:

> [   75.159841] Call Trace:
> [   75.159841]  [<ffffffff825f0dfb>] dmi_matches+0x6f/0x8d

that since the call is

	strstr(dmi_ident[s], dmi->matches[i].substr)

that it is the "dmi_ident[]" array itself that is broken.

The DMI code doesn't seem to be very careful about checking the array 
accesses against DMI_STRING_MAX. So I wonder if this is actually a DMI 
bug, not a driver bug - and that the driver just is able to trigger that 
bug somehow where others have not.

		Linus
