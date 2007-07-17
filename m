Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbXGQGy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbXGQGy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXGQGyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:54:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbXGQGyv (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:54:51 -0400
From: Neil Brown <neilb@suse.de>
To: pomac@vapor.com
Date: Tue, 17 Jul 2007 16:54:51 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18076.26555.232024.367903@notabene.brown>
Cc: Linux-kernel@vger.kernel.org
Subject: Re: [BUG] AS io-scheduler.
In-Reply-To: message from Ian Kumlien on Saturday July 14
References: <1184427582.10630.13.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday July 14, pomac@vapor.com wrote:
> Hi, 
> 
> I had emerge --sync failing several times... 
> 
> So i checked dmesg and found some info, attached further down.
> This is a old VIA C3 machine with one disk, it's been running most
> kernels in the 2.6.x series with no problems until now.
> 
> PS. Don't forget to CC me
> DS.
> 
> BUG: unable to handle kernel paging request at virtual address ea86ac54
                                                                 ^^^^^^^^
>  printing eip:
> c022dfec
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: eeprom i2c_viapro vt8231 i2c_isa skge
> CPU:    0
> EIP:    0060:[<c022dfec>]    Not tainted VLI
> EFLAGS: 00010082   (2.6.22.1 #26)
> EIP is at as_can_break_anticipation+0xc/0x190
> eax: dfcdaba0   ebx: dfcdaba0   ecx: 0035ff95   edx: cb296844
       ^^^^^^^^
> esi: cb296844   edi: dfcdaba0   ebp: 00000000   esp: ceff6a70
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process rsync (pid: 1667, ti=ceff6000 task=d59cf5b0 task.ti=ceff6000)
> Stack: cb296844 00000001 cb296844 dfcdaba0 00000000 c022efc8 cb296844
> 00000000 
>        dfcffb9c c0227a76 dfcffb9c 00000000 c016e96e cb296844 00000000
> dfcffb9c 
>        00000000 c022af64 00000000 dfcffb9c 00000008 00000000 08ff6b30
> c04d1ec0 
...
> Code: c0 8b 44 cb 0c 8b 40 08 29 d0 f7 d0 c1 e8 1f 83 f0 01 eb 02 31 c0
> 5b c3 8d b4 26 00 00 00 00 55 57 56 53 83 ec 04 89 c3 89 14 24 <8b> 90
> b4 00 00 00 85 d2 75 04 0f 0b eb fe 83 3c 24 00 74 0c 8b 

Plug that 'Code:' line into ksymoops and you get 
Code;  fffffffb <__kernel_rt_sigreturn+1bbb/????>
  26:   89 c3                     mov    %eax,%ebx
Code;  fffffffd <__kernel_rt_sigreturn+1bbd/????>
  28:   89 14 24                  mov    %edx,(%esp)
Code;  00000000 Before first symbol
  2b:   8b 90 b4 00 00 00         mov    0xb4(%eax),%edx
Code;  00000006 Before first symbol
  31:   85 d2                     test   %edx,%edx
Code;  00000008 Before first symbol
  33:   75 04                     jne    39 <_EIP+0x39>

(etc.).

The "Code;    00000000..." is the current EIP.
So the operation it was performing was
       mov 0xb4(%eax),%edx

Now I am no Pentium, but when I add 0xb4 to dfcdaba0 I don't get
ea86ac54.
My result is more like
dfcdac54.

So it looks like your Pentium (or whatever) got it half-right.
i.e. the bottom 16 bits are right, but the top are wrong by 0ab9.

I'd be taking a very serious look at your hardware.  This is not a
software problem.

NeilBrown
