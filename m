Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXJ3UZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXJ3UZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbXJ3UYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:24:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:10853 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbXJ3UYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Tug9g7am+ZFgp5pEfoRHOqsvZfgJQ50CE4EiKHlNaPvxxv1DeVaVGLopsl/iaC9HIdjEeJ5tVTkCkgK249WupKZC6yo1ad8ddbHvVhr7kzgz7Sjnm7kV9MuIzMD+V6X2pW99Sv7yQYv54zCJa3WYErMX26tVXwEl/Vn5tPxtUSU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [IDE] Fix build bug
Date: Tue, 30 Oct 2007 21:30:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
References: <20071025135334.GA23272@linux-mips.org> <200710301134.30087.vda.linux@googlemail.com> <20071030124155.GA7582@linux-mips.org>
In-Reply-To: <20071030124155.GA7582@linux-mips.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710302130.55225.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 30 October 2007, Ralf Baechle wrote:
> On Tue, Oct 30, 2007 at 11:34:29AM +0000, Denys Vlasenko wrote:
> 
> > On Thursday 25 October 2007 22:41, Bartlomiej Zolnierkiewicz wrote:
> > > > -static const struct ide_port_info generic_chipsets[] __devinitdata = {
> > > > +static struct ide_port_info generic_chipsets[] __devinitdata = {
> > > >  	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
> > > >  
> > > >  	{	/* 1 */
> > > 
> > > I would prefer to not remove const from generic_chipsets[] so:
> > > 
> > > [PATCH] drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n
> > > 
> > > It turns out that const and __{dev}initdata cannot be mixed currently
> > > and that generic IDE PCI host driver is also affected by the same issue:
> > > 
> > > On Thursday 25 October 2007, Ralf Baechle wrote:
> > > >   CC      drivers/ide/pci/generic.o
> > > > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > > > +section type conflict
> > > 
> > > [ Also reported by Martijn Uffing <mp3project@sarijopen.student.utwente.nl>. ]
> > > 
> > > This patch workarounds the problem in a bit hackish way but without
> > > removing const from generic_chipsets[] (it adds const to __setup() so
> > > __setup_str_ide_generic_all becomes const).
> > 
> > You wouldn't believe how much const data is not marked as const because
> > we don't have __constinitdata etc. Literally megabytes.
> 
> The gain from marking it const is very little and once any non-const
> __initdata object is added to a compilation unit all other const declarations
> will have to be removed.  Bad tradeoff.

In this case (struct ide_port_info) and probably few others having const
is important (maybe even more important than having __{dev}initdata since
majority of people use CONFIG_HOTPLUG=y) because it allows developers to
catch subtle yet hard to find bugs very early in the development process.

We had a few such cases in IDE - struct ide_port_info _template_ was being
modified because some quirk was needed for one version of the hardware which
was of course incorrect if another version of the hardware was also present
in the system.

Some other potential gains of using const like the better optimized code
or the protection of read-only kernel data are only an extra bonuses. :)

I agree that we need __const{dev}initdata but until then the workaround
that all __{dev}initdata must be const is an acceptable temporary solution
for IDE host drivers.

Thanks,
Bart
