Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYBSVvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYBSVvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYBSVv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:51:27 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:15426 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbYBSVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:51:26 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <20080218104025.GA15899@ca-server1.us.oracle.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 21:50:58 +0000
Message-Id: <1203457858.26910.11.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=zLlR5gwAiiGFLLBPA4cA:9 a=9ivSq0Vvk46mcVpxJ9EA:7 a=8GrEbJs_uRa_pnS0KIkvZqIccXcA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
> > I've been seeing similar attempts to map 0xf0 but so far I was the only
> > one (although that made no sense to me). Does the patch below help at
> > all? The problem seems to be that the kernel is trying to map pages at
> > 0xf0000 but these are not reserved in the guest E820 map so they could
> > contain a page table page etc.
> > 
> > A useful tip for getting a backtrace out of a crashed Xen guest is to
> > set "on_crash=preserve" in your domain config. Then once the crash has
> > happened you can use "/usr/lib/xen/bin/xenctx -s System.map <domid>"
> > where System.map is the guest kernel System.map.
> 
> 	That didn't work for me - it gave me "can't trace dom0" for
> whatever reason.  But...

Strange. You gave it the domid of the guest not dom0 I assume. Might be
an older buggy version but it works ok in newer versions:

        # /usr/lib/xen/bin/xenctx -s /boot/System.map-2.6.18.8-x86_32p-xenU 2
        eip: c01013a7 hypercall_page+0x3a7 flags: 00001246 i z p
        esp: c0361f64
        eax: 00000000   ebx: deadbeef   ecx: deadbeef   edx: 00000001
        esi: 00000000   edi: 00000000   ebp: c0361f84
         cs: 00000061    ds: 0000007b    fs: 00000000    gs: 00000000
        
        Stack:
         c01089eb 02d8e984 5cec4d7d 0001f3ea 00000000 000008f1 ffffffff 00000000
         c0361f8c c010436c c0361fa8 c0103263 c03880c0 c03880a0 000008f1 c038a464
         c184f3c4 c0361fbc c0102415 c0102060 00000000 00000a00 c0361ff8 c036687f
         c02ed19c c038e120 c031f000 00000022 c03662a0 c184d000 000023c4 00000000
        
        Code:
        cc cc cc cc cc cc cc cc cc cc cc cc cc cc b8 1d 00 00 00 cd 82 <c3> cc cc cc cc cc cc cc cc cc cc 
        
        Call Trace:
          [<c01013a7>] hypercall_page+0x3a7  <--
          [<c01089eb>] raw_safe_halt+0x9b 
          [<c010436c>] xen_idle+0x2c 
          [<c0103263>] cpu_idle+0x83 
          [<c0102415>] rest_init+0x35 
          [<c0102060>] _stext+0x60 
          [<c036687f>] start_kernel+0x36f 
          [<c03662a0>] parse_early_param+0x70 
        
Ian.

-- 
Ian Campbell

94% of the women in America are beautiful and the rest hang out around
here.

