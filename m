Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYDOIDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYDOIDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYDOIDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:03:20 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:12703 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbYDOIDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xxqQvPZ0+XGdkGDYImbka2WvGByKKyQz2JvloVBMkPO0NKtSTFaxhhnMt8oN2hvceGYqQYB+jxmu8ca1nBGlvvlLHEI9LnN3v6FCvQj9A8fNKPRNBmiXBD0oDxZYcRL8tvf9MNjdnSE9BGu7i3sfU1tHSrBN3RWzZRdvbEO4/XQ=
Message-ID: <86802c440804150103s59f6fe16ncf08a3154c03d2bb@mail.gmail.com>
Date: Tue, 15 Apr 2008 01:03:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080415004400.bb941191.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	 <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
	 <1207899030.15605.1.camel@x61.ebiederm.org>
	 <86802c440804111122x5c106779g60f1c04ae21fed94@mail.gmail.com>
	 <86802c440804111248je6dfa99va8eec42531f4b689@mail.gmail.com>
	 <20080415004400.bb941191.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:44 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 11 Apr 2008 12:48:43 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Fri, Apr 11, 2008 at 11:22 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > > On Fri, Apr 11, 2008 at 12:30 AM, Eric W. Biederman
>  > >  <ebiederm@xmission.com> wrote:
>  > >  >
>  > >  >
>  > >
>  > >
>  > > >  On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
>  > >  >  > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > >  >  > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > >  >  > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  > >  >  > >  >  > last week found:
>  > >  >  > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  > >  >  > >  >  > forcedeth doesn't work anymore.
>  > >  >  > >  >  >
>  > >  >  > >  >  > I stared at forcedeth.c two days. and revert every patches about that
>  > >  >  > >  >  > doesn't help.
>  > >  >  > >  >
>  > >  >  > >  >  So forcedeth does not come up again, when you kexec from linus.git
>  > >  >  > >  >  into an older distro kernel. Or is it the other way round ?
>  > >  >  > >  RHEL 5.1 kexec RHEL 5.1 : works
>  > >  >  > >  RHEL 5.1 kexec linus kernel: works
>  > >  >  > >  linus (after -rc2) kexec linus tree: works:
>  > >  >  > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
>  > >  >  > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
>  > >  >  > >
>  > >  >  > the forcedeth can not get IP address...
>  > >  >
>  > >  >  Sounds like you are not getting any interrupts when you receive a
>  > >  >  packet.  (i.e. The interrupt line is staying disabled).
>  > >  >
>  > >  >  Is MSI an option here?  I'm wondering if we disable the MSI and
>  > >  >  something is not enabling it.
>  > >
>  > >
>  > >
>  > >  after
>  > >  setpci -s 0x00:08.0 0x60.b=0xfe
>  > >
>  > >  the eth0 can get ip address with ifup eth0.
>  >
>  > it is RHEL 5.1 problem...with msi.
>  >
>  > somehow msi entry msi_attrib_maskbit=is_mask_bit_support always get
>  > 0...., and use msi_irq_wo_maskbit_type instead of
>  > msi_irq_w_maskbit_type
>  >
>  > so when load that directly without kexec
>  > that 0x60 always to 0x00.
>  >
>  > and this time kernel after 2.6.25-rc2 ( not included) really shutdown
>  > the msi with 0xff the all maskbit...
>  >
>
>  So... where did this end up?   It's a post-2.6.24 regression, isn't it?
>
>  Do we think it's a bug in the RHEL 5.1 kernel?  Even so, that's a problem
>  for the 2.6.25 kernel.

it is RHEL 5.1 kernel problem, it has code for maskbit with msi there,
but that does work...

I sent out patch for 2.6.25 so it can be used to kexec old kernel that
doesn't support maskbit for MSI.

please comment...

[PATCH] x86_64: restore mask_bits in msi shutdown


for MSI, default_shutdown will call mask_bit for msi device. so all
mask bits will
left disabled after free_irq.
then if kexec next kernel that only can use msi_enable bit.
all device's MSI can not be used.

So try to restore MSI mask bits that is saved before using msi in first kernel.

http://lkml.org/lkml/2008/4/11/369

YH
