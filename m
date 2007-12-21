Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbXLUVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbXLUVTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbXLUVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:18:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:8467 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbXLUVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tur3ExMLPHYGqCBprx++kNd1lI9Pz7z/uRzJrmfcTpEhlAOKh3Mc1jh0JcDs06uef0oj9hDUOimXBsWrhd8EUpSahfojS3KqBZu0d30/E7BHVbjhUqI2xL7MNfZaIKezoC61nopdf1dhzJZO96JCLCWqltc04Vp82zTiDoAMai0=
Message-ID: <a44ae5cd0712211318w12a7ef96wfac757c47aa8b418@mail.gmail.com>
Date: Fri, 21 Dec 2007 16:18:35 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 -- (triggered by "cat /proc/iomem" AFTER suspend-to-disk/resume)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org, "Dave Airlie" <airlied@linux.ie>
In-Reply-To: <20071221120000.b319b735.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	 <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com>
	 <476A703B.50804@gmail.com>
	 <20071220093206.22f319b0.akpm@linux-foundation.org>
	 <a44ae5cd0712202158u31c8b4e1lf5b0df89dde20e7e@mail.gmail.com>
	 <20071220222913.92a2c19f.akpm@linux-foundation.org>
	 <a44ae5cd0712210806i7f020a71k8c552953f7aeef4d@mail.gmail.com>
	 <20071221120000.b319b735.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21, 2007 3:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 21 Dec 2007 11:06:49 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > > >
> > > > How do I determine what comes next?
> > > >
> > >
> > > By comparing it with the /proc/iomem from prior to suspending the machine.
> > >
> >
> > The offending information seems to be "90000000-90000fff : Intel Flush Page"
>
> ah-hah.  git-agpgart.patch
>
> > I hope this helps,
>
> It does, thanks.
>
> Dave, a `cat /proc/iomem' crashes after a suspend/resume cycle when it
> reaches the intel_private.ifp_resource record.
>
>
> intel_i915_configure() is called on each resume and it calls
> intel_i9xx_setup_flush() which zeroes out the already-registered `struct
> resource', causing core kernel to oops over a deref of
> parent/sibling/child.
>
> Probably this:
>
> --- a/drivers/char/agp/intel-agp.c~a
> +++ a/drivers/char/agp/intel-agp.c
> @@ -883,8 +883,6 @@ static void intel_i965_g33_setup_chipset
>  static void intel_i9xx_setup_flush(void)
>  {
>         /* setup a resource for this object */
> -       memset(&intel_private.ifp_resource, 0, sizeof(intel_private.ifp_resource));
> -
>         intel_private.ifp_resource.name = "Intel Flush Page";
>         intel_private.ifp_resource.flags = IORESOURCE_MEM;
>
> _
>
>
> will be enough to prevent the crash, but I suspect a bit more than that
> will be needed.
>

I tested with the patch applied, and the stackdump did not occur.
However, I notice that the values listed for Intel Page Flush is
changed from the pre-suspend values:

Before the suspend:
90000000-90000fff : Intel Flush Page

After the resume:
00000000-90001000 : Intel Flush Page

# patch -p1 < akpm.patch
patching file drivers/char/agp/intel-agp.c
Hunk #1 succeeded at 891 (offset 8 lines).

$ cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-7f68ffff : System RAM
  00100000-0039e4a7 : Kernel code
0039e4a8-004f0983 : Kernel data
00553000-007ecdfb : Kernel bss
7f690000-7f698fff : ACPI Tables
7f699000-7f6fffff : ACPI Non-volatile Storage
7f700000-7fffffff : reserved
88000000-8bffffff : PCI CardBus #05
8c000000-8fffffff : PCI CardBus #05
00000000-90001000 : Intel Flush Page
c0000000-cfffffff : 0000:00:02.0
d0000000-d1ffffff : PCI Bus #02
d2000000-d3ffffff : PCI Bus #03
d4000000-d5ffffff : PCI Bus #02
d4000000-d4003fff : 0000:02:00.0
d4000000-d4003fff : sky2
d6000000-d7ffffff : PCI Bus #03
d6000000-d6000fff : 0000:03:00.0
d6000000-d6000fff : iwl3945
d8000000-d80fffff : PCI Bus #04
d8000000-d8003fff : 0000:04:09.1
d8004000-d8004fff : 0000:04:09.2
d8004000-d8004fff : tifm_7xx1
d8005000-d80057ff : 0000:04:09.1
d8005000-d80057ff : ohci1394
d8006000-d8006fff : 0000:04:09.0
d8006000-d8006fff : yenta_socket
d8100000-d817ffff : 0000:00:02.0
d8180000-d81fffff : 0000:00:02.1
d8200000-d823ffff : 0000:00:02.0
d8240000-d8243fff : 0000:00:1b.0
d8240000-d8243fff : ICH HD audio
d8444000-d84443ff : 0000:00:1d.7
d8444000-d84443ff : ehci_hcd
d8444400-d84447ff : 0000:00:1f.2
d8444400-d84447ff : ahci
e0000000-efffffff : PCI MMCONFIG 0
e0000000-efffffff : reserved
fec00000-fec0ffff : reserved
fed00000-fed003ff : HPET 0
fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
fed1c000-fed8ffff : reserved
fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
