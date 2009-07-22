Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZGVAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZGVAzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGVAzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:55:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbZGVAzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:55:35 -0400
Date: Tue, 21 Jul 2009 17:53:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Troy Moure <twmoure@szypr.net>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.00.0907212211040.4630@troy-laptop>
Message-ID: <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Ian Lance Taylor to the cc, he knows the background, and unlike me 
  is competent with gcc. ]

On Tue, 21 Jul 2009, Troy Moure wrote:
> 
> I think I've found something interesting.  Look at the the code generated 
> for edid_checksum() in driver/video/fbmon.c.  This is what I see for the 
> -fno-strict-overflow kernel:

Ooh.

Bingo. You're 100% right, and you definitely found it (of course, there 
may be _other_ cases like this, but that's certainly _one_ of the 
problems, and probably the only one).

Just out of curiosity, how did you find it? Now that I know where to look, 
it's very obvious in the assembler diffs, but I didn't notice it until you 
pointed it out just because there is so _much_ of the diffs...

And yes, that's very much a compiler bug. And I also bet it's very easily 
fixed.

The code in question is this loop:

	#define EDID_LENGTH 128

	unsigned char i, ...

	for (i = 0; i < EDID_LENGTH; i++) {
                csum += edid[i];
                all_null |= edid[i];
        }

and gcc -fno-strict-overflow has apparently decided that that is an 
infinite loop, even though it clearly is not. So then the stupid and buggy 
compiler will compile that loop (and the whole rest of the function) to 
the "optimized" version that is just

	loop:
		jmp loop;

I even bet I know why: it looks at "unsigned char", and sees that it is an 
8-bit variable, and then it looks at "i < EDID_LENGTH" and sees that it is 
a _signed_ comparison (it's signed because the C type rules mean that 
'unsigned char' will be extended to 'int' in an expression), and then it 
decides that in a signed comparison an 8-bit entry is always going to be 
smaller than 128.

Anyway, I bet we can work around the compiler bug by just changing the 
type of "i" from "unsigned char" to be a plain "int".

Krzysztof? Mind testing that?

Ian? This is Linux 2.6.27.27 compiled with gcc-4.2.4. I'm not seeing the 
bug in the gcc I have on my machine (gcc-4.4.0), but the bug is very clear 
(once you _find_ it, which was the problem) in the binaries that Krzysztof 
posted. They're still at:

    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fno-strict-overflow.bz2 (Hangs)
    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fwrapv.bz2 (OK)
    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fnone.bz2 (OK)

and you can clearly see the 'edid_checksum' miscompilation in the objdump 
disassembly.

Thanks Troy,

			Linus

---
Leaving in the context for Ian:

Buggy -fno-strict-overflow compilation:

> ...
> ffffffff803b37ed <edid_checksum>:
> ffffffff803b37ed:       53                      push   %rbx
> ffffffff803b37ee:       48 89 fb                mov    %rdi,%rbx
> ffffffff803b37f1:       e8 8d fd ff ff          callq  ffffffff803b3583 <check_edid>
> ffffffff803b37f6:       85 c0                   test   %eax,%eax
> ffffffff803b37f8:       89 c6                   mov    %eax,%esi
> ffffffff803b37fa:       74 08                   je     ffffffff803b3804 <edid_checksum+0x17>
> ffffffff803b37fc:       48 89 df                mov    %rbx,%rdi
> ffffffff803b37ff:       e8 c0 fe ff ff          callq  ffffffff803b36c4 <fix_edid>
> ffffffff803b3804:       eb fe                   jmp    ffffffff803b3804 <edid_checksum+0x17>
> 
> ffffffff803b3806 <fb_parse_edid>:
> ffffffff803b3806:       41 54                   push   %r12
> ffffffff803b3808:       48 85 ff                test   %rdi,%rdi
> ...
> 
> That last insn in edid_checksum() doesn't look *quite* right to me...
> 
> The -fnone kernel has something a lot more sensible-looking:
> 
> ffffffff803b39dd <edid_checksum>:
> ffffffff803b39dd:       53                      push   %rbx
> ffffffff803b39de:       48 89 fb                mov    %rdi,%rbx
> ffffffff803b39e1:       e8 8d fd ff ff          callq  ffffffff803b3773 <check_$
> ffffffff803b39e6:       85 c0                   test   %eax,%eax
> ffffffff803b39e8:       89 c6                   mov    %eax,%esi
> ffffffff803b39ea:       74 08                   je     ffffffff803b39f4 <edid_c$
> ffffffff803b39ec:       48 89 df                mov    %rbx,%rdi
> ffffffff803b39ef:       e8 c0 fe ff ff          callq  ffffffff803b38b4 <fix_ed$
> ffffffff803b39f4:       31 c9                   xor    %ecx,%ecx
> ffffffff803b39f6:       31 f6                   xor    %esi,%esi
> ffffffff803b39f8:       31 d2                   xor    %edx,%edx
> ffffffff803b39fa:       eb 0a                   jmp    ffffffff803b3a06 <edid_c$
> ffffffff803b39fc:       0f b6 c0                movzbl %al,%eax
> ffffffff803b39ff:       8a 04 03                mov    (%rbx,%rax,1),%al
> ffffffff803b3a02:       01 c1                   add    %eax,%ecx
> ffffffff803b3a04:       09 c6                   or     %eax,%esi
> ffffffff803b3a06:       88 d0                   mov    %dl,%al
> ffffffff803b3a08:       ff c2                   inc    %edx
> ffffffff803b3a0a:       81 fa 81 00 00 00       cmp    $0x81,%edx
> ffffffff803b3a10:       75 ea                   jne    ffffffff803b39fc <edid_c$
> ffffffff803b3a12:       84 c9                   test   %cl,%cl
> ffffffff803b3a14:       0f 94 c0                sete   %al
> ffffffff803b3a17:       40 84 f6                test   %sil,%sil
> ffffffff803b3a1a:       5b                      pop    %rbx
> ffffffff803b3a1b:       0f 95 c2                setne  %dl
> ffffffff803b3a1e:       21 d0                   and    %edx,%eax
> ffffffff803b3a20:       0f b6 c0                movzbl %al,%eax
> ffffffff803b3a23:       c3                      retq
> 
> ffffffff803b3a24 <fb_parse_edid>:
> ffffffff803b3a24:       41 54                   push   %r12
> ffffffff803b3a26:       48 85 ff                test   %rdi,%rdi
> 
> Hope that helps narrow things down ;)
> 
> 	Troy
> 
