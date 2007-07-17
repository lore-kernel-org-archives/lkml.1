Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbXGQLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbXGQLNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXGQLNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:13:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:54728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbXGQLNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:13:11 -0400
From: Neil Brown <neilb@suse.de>
To: David CHANIAL <david.ml@euro-web.fr>
Date: Tue, 17 Jul 2007 21:13:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18076.42052.961808.528867@notabene.brown>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
In-Reply-To: message from David CHANIAL on Monday July 16
References: <200707160638.15750.david.ml@euro-web.fr>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday July 16, david.ml@euro-web.fr wrote:
> Hi,
> 
> I'm not sure is the good place to poste that, and if not - please excuse me.

This is the correct place to post this, thanks.

> 
> I was running nfs server v2 since a year on one server, there is few days, i 
> have update my kernel to 2.6.21.3 with support of nfsv3 server.
> 
> Somes times per days i have somes crash as below, needing i reboot the server 
> to nfs re-become up.
> 
> ************
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000004
  ^^^^^^^^

This says that it tried to access memory at address '4'.  There is no
memory there, so it caused the BUG.


>  printing eip:
> c01e7279
> *pde = 09ecc001
> Oops: 0000 [#1]
> SMP
> CPU:    0
> EIP:    0060:[<c01e7279>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21.3-sdf88-core #9)
                              ^^^^^^^^^^^

What is "-sdf88-core" ?? Are there any extra patches that we should
know about?


> EIP is at encode_fsid+0x67/0x89

This is presumably where the illegal access happened.

> eax: e5bde8c0   ebx: f7593404   ecx: 00000000   edx: 00000006
> esi: dc569048   edi: f75934ec   ebp: f7593404   esp: f75f1f18

Memory accesses are (almost) always relative to the value in some
register.  Of these registers, the most likely is ecx, with edx a
vague possibility.

> Code: e2 08 09 d1 09 c1 eb 10 8b 83 88 00 00 00 8b 40 30 89 c3 89 c1 c1 fb 1f 
> 89 d8 0f c8 89 06 89 c8 eb 1e 

Unfortunately "ksymoops" does seem to decode this into something quite
useful enough.  Normally one of the numbers has <> around it.  Are you
should you copied the number across exactly?

This code decodes as:
   0:   e2 08                     loop   a <_EIP+0xa>
   2:   09 d1                     or     %edx,%ecx
   4:   09 c1                     or     %eax,%ecx
   6:   eb 10                     jmp    18 <_EIP+0x18>
   8:   8b 83 88 00 00 00         mov    0x88(%ebx),%eax
   e:   8b 40 30                  mov    0x30(%eax),%eax
  11:   89 c3                     mov    %eax,%ebx
 ....

 From the 'jmp' onwards, that is what I would expect to see in
 encode_fsid.  The code before there doesn't make a lot of sense, so
 it is hard to pinpoint exactly there the error is.

 In any case, there is no place in encode_fsid where an offset of 4
 from any register is indexed, nor an offset of -2.
 So either there is something wrong with the decoding and displaying
 of this information, or there is something very wrong with your
 hardware.

 I would suggest:
   1/ if possible, run memtest86 on the machine for a while, to make
      sure there isn't a problem with the memory.
   2/ If the problem happens again, post another report with all the
      "oops" information again.  Maybe the next time it will be slightly
      different and will make more sense in some way.

NeilBrown

