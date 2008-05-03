Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbYECRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbYECRCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762154AbYECRCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:02:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:12204 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761372AbYECRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=nYE1eLckVS+vkqswF5zLBkOAc5tLPU+Ywo9RfNepfo6+PPziE7H6VNpFe6NZo+4ueQg7wrXym6CD7oqt5K74XMYEi+xgWM1piLnjM2P341FvM4Gmsp1kRaYzh/R0JjwzYRAABSi5HQmsEgoEqVvZQ5aWtMG4QNhduwhWCw5q/kY=
Subject: Re: i387/FPU init issues...
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
In-Reply-To: <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost>
	 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 03 May 2008 13:02:03 -0400
Message-Id: <1209834123.6972.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-05 at 17:31 +0200, Thomas Gleixner wrote:
> On Sat, 3 May 2008, jamal wrote:
> >  =======================
> > Code: 8d 74 26 00 8d bc 27 00 00 00 00 55 89 c2 8b 40 04 89 e5 f6 40 0c
> > 01 74 32 8b 82 60 02 00 00 0f ae 00 0f ba 60 02 07 73 02 db e2 <0f> 1f
> > 00 90 8d b4 26 00 00 00 00 89 f6 8b 42 04 83 60 0c fe 0f
> 
> This looks bad.
> 
>   0f ae 00		fxsave (%eax)
>   0f ba 60 02 07       	btl    $0x7,0x2(%eax)
>   73 02                	jae    (skip fnclex)
>   db e2                	fnclex 
>   0f 1f 00             	nopl   (%eax)
> 
>  ^^^^ This is a P4+ instruction. So it's not surprising that the P2
>  chokes. The question is where this comes from.
> 
> we have:
> #define P6_NOP3 ".byte 0x0f,0x1f,0x00\n"

Dang - I feel i should have saved myself all that git bisecting
and just posted the oops ;->

> So the alternatives code applies the wrong nop padding for your
> CPU. This was probably introduced with commit
> 32c464f5d9701db45bc1673288594e664065388e. 
> 
> Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
> have to dig up the manuals.
> 
> Jamal, does the following patch solve your problem ? 


Indeed it does - thanks.

> Please provide
> also output of /proc/cpuinfo.

mambo:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 3
model name      : Pentium II (Klamath)
stepping        : 3
cpu MHz         : 1063.771
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 sep pge cmov mmx fxsr
sse sse2
bogomips        : 2160.92
clflush size    : 32
power management:

cheers,
jamal

