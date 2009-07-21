Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZGUQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZGUQNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZGUQND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:13:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbZGUQNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:13:02 -0400
Date: Tue, 21 Jul 2009 09:11:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Oledzki <olel@ans.pl>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
Message-ID: <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Krzysztof Oledzki wrote:
> 
> OK, there are three kernels, exactly as you requested:
> 
> http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fno-strict-overflow.bz2 (Hangs)
> http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fwrapv.bz2 (OK)
> http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fnone.bz2 (OK)

Perfect.

And interestingly, the "fno-strict-overflow" kernel is actually much 
closer to the "fnone" kernel than to the "fwrapv" one. I have some silly 
scripts based on 'objdump -d' plus a lot of stupid sed scripting to remove 
the trivial differences due to instruction addresses, and then doing a 
'diff -u' between the munged disassembly of the kernels gives me:

  [torvalds@nehalem fno-strict-overflow]$ wc -l fnone-to-fno-strict-overflow fwrapv-to-fno-strict-overflow 
    39309 fnone-to-fno-strict-overflow
    91423 fwrapv-to-fno-strict-overflow
   130732 total

ie the diff from the kernel with no flags is less than twice the size of 
the diff from fwrapv.

Still - it's almost 40kB of diffs of disassembly, so I'm not going to 
guarantee that I can make any sense of it and find the compiler problem in 
it. But I'll try. And send you test-patches to see if I can pinpoint the 
code that causes the problem.

> Kernels are identical and are compiled from the same config, on the same
> server with gcc-4.2.4, binutils-2.19. There is no ccache installed and the
> kernels are not patched with any additonal patches - just vanilla
> linux-2.6.27.27.

Thank you.

> Screenshot from the hanging kernel (-fno-strict-overflow):
>  http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/2.6.27.27-hang.png
> 
> Dmesg from a bootable kernel:
>  http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/dmesg

Great. This is all about as perfect as could be asked for. Now it's just a 
question of trying to find the right code generation difference...

			Linus
