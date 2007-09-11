Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbXIKJ1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbXIKJ1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933668AbXIKJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:26:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:57727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638AbXIKJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:26:49 -0400
From: Neil Brown <neilb@suse.de>
To: Mark Hindley <mark@hindley.org.uk>
Date: Tue, 11 Sep 2007 11:26:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18150.24412.855004.90148@notabene.brown>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: [OOPS] 2.6.23-rc5 in tcp/net/nfsd
In-Reply-To: message from Mark Hindley on Tuesday September 11
References: <20070911083200.GA3409@hindley.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday September 11, mark@hindley.org.uk wrote:
> This oops appeared over night on a box running 2.6.23-rc5 (recent with the
> tcp_input.c fix).
> 
> I can't find a similar one reported.


Okay..... this is weird.
> 
> Mark
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000007e 
                                                                           ^^^^^^^^

That is the bad address,

> EFLAGS: 00010246   (2.6.23-rc5-2-mcyrixiii #1)
> EIP is at ip_fragment+0x7f/0x680
> eax: c3c09c00   ebx: 00000000   ecx: b524d006   edx: 0000007b
                                                  ^^^^^^^^^^^^^

It looks like an offset of 3 from edx.  I got that from decoding:

> Code: .... <00> ba 03 00 00 00 bf a6 ff ff

which is 
   0:   00 ba 03 00 00 00         add    %bh,0x3(%rdx)

However that instruction doesn't appear in ip_fragment.
The code in ip_fragment reads:
  27:   b9 04 00 00 00            mov    $0x4,%ecx
                    ^^
  2c:   ba 03 00 00 00            mov    $0x3,%edx
        ^^^^^^^^^^^^^^

which contains the bytes of the offending instruction.
Note that $0x4 is ICMP_FRAG_NEEDED and $0x3 is ICMP_DEST_UNREACH:
these are args to icmp_send.  So the latter is the correct disassembly
based on the C code.

So somehow the kernel is jumping to a bad address.  I don't know how
that would happening.... maybe a single bit error in memory or a
register???

NeilBrown
