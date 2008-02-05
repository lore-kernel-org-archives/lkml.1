Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYBEKHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYBEKHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYBEKHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:07:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:15194 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYBEKHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oBCVQHuT0ynzDpwQV/Ge+WDqX2JIbWkUvpMfB1rdahgvGsw7wXVPnWvsTXj9yefhahuEg2CkBGNjpGpCN6MTUsSod+V8wmeKeIBIgGgXm2pFf+QSr8KKen3B7inhMBtT8nNY6O+U03yUPR+xF7HG7gl7s1Ri0q3nHhIpzOUUk5Y=
Message-ID: <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com>
Date: Tue, 5 Feb 2008 02:07:29 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080205091758.GB26618@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204151222.GB25790@localhost.sw.ru>
	 <1202162073.7079.8.camel@pasglop>
	 <20080205091758.GB26618@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 1:17 AM, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> On Tue, Feb 05, 2008 at 08:54:33AM +1100, Benjamin Herrenschmidt wrote:
> >
> > On Mon, 2008-02-04 at 18:12 +0300, Alexey Dobriyan wrote:
> > > Commit c40a22e0ce5eb400f27449e59e43d021bee58b8d aka
> > > "PCI: Fix bus resource assignment on 32 bits with 64b resources"
> > > renders one tg3-equipped box networkless here.
> > >
> > >     tg3.c:v3.87 (December 20, 2007)
> > >     tg3: (0000:02:05.0) phy probe failed, err -19
> > >     tg3: Problem fetching invariants of chip, aborting.
> > >     tg3: (0000:02:05.1) phy probe failed, err -19
> > >     tg3: Problem fetching invariants of chip, aborting.
> > >
> > > It's 32-bit CONFIG_RESOURCES_64BIT=y box.
> > >
> > > Not sure what you need this, but below is some lspci -vvvxxx output:
> >
> > Interesting. It looks like the BAR of the tg3 has a spurrious 0x100000000
> > bit set to it. Can you send me a full dmesg, if possible enabling DEBUG
> > in the pci code (there's some places to turn DEBUG on in drivers/pci/*)
>
> OK, attached data collected on 2.6.24-9ef9dc69d4167276c04590d67ee55de8380bc1ad
> with CONFIG_PCI_DEBUG=y with and without your patch:
> (-000 means vanilla, -001 means with reverted patch)
>
> -rw-r--r-- 1 ad ad 25261 2008-02-05 12:08 tg3-000.dmesg
> -rw-r--r-- 1 ad ad  1112 2008-02-05 12:08 tg3-000.iomem
> -rw-r--r-- 1 ad ad 37785 2008-02-05 12:08 tg3-000.lspci
> -rw-r--r-- 1 ad ad 25495 2008-02-05 12:08 tg3-001.dmesg
> -rw-r--r-- 1 ad ad  1172 2008-02-05 12:08 tg3-001.iomem
> -rw-r--r-- 1 ad ad 37933 2008-02-05 12:08 tg3-001.lspci
>
> dmesg is full of such chunks:
> -  got res [180000000:180ffffff] bus [180000000:180ffffff] flags 200 for BAR 0 of 0000:03:04.0
> +  got res [180000000:180ffffff] bus [80000000:80ffffff] flags 200 for BAR 0 of 0000:03:04.0
>
> which is definitely not difference in formatting.
>

so x86_64 will work well?

the problem is that BIOS does not assign one resource for you tg3. and
kernel pcibios_assign_to_unassign (?) try
to assign resource to your card.

revert the patch happen to work, you only have 2g less RAM (?), so
0x8000000 still can be used.

sometime you could get hang if your MB have two HT chains. ...because
BIOS already allocate two io range for the two chain.
and kernel may assign resource from the range1 belong to HT1 to device
under HT0.
solution: need pci root bios to provide _CRS to replace...
and i have one patch but it only take care of 64 bit kernel for this case.


easy solution for you: try to get one updated BIOS.

YH
