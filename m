Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZGCBJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZGCBJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGCBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:08:59 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48331 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752380AbZGCBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:08:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XnIPbJRUW3grMjHs+wGli5u6Rz4CAVULUeGjU+Ejwx+oMn4uYQkGucDhxazZgDWQW/KiAVvP8oDUSVg7lDLKji2WJ/PDIV/F66i8Wq2mKj+Qedsu+27RQlg6k6DyxWyyPhvtnlJwdKtONhOS1CnhWWEnwUv3UeVX1oMeZ6cfNII=  ;
X-YMail-OSG: QpuX2_oVM1n2dXS4poiR.lBec01qLEFoChewA14cAeF5zpbgn6.Fo64mGgXHx_Va.MB2NsrnaQBPhFZveL69IAJc0CseLYULaoAWZ64Z0wQ67u7pWaOxDQLkVqgcSlX0ebXDmfEai0hRAfMRXSQnSATFMES8wLvPWU2HzfyUspb8ge6HSIGTgcTizE1TmZgxcVubbwfjgDIw.Z90N6wO.K.L9mdh4Rb3ZWWEWrPgXTzm0iCT7eQKIHdrRFxYf63FdukP2ZwfNFOzHVxr
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [RESEND][PATCH] SPI: xilinx_spi: Added platform driver and support for DS570
Date: Thu, 2 Jul 2009 18:09:01 -0700
User-Agent: KMail/1.9.10
Cc: Richard =?iso-8859-1?q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4A366622.2050606@mocean-labs.com> <200906231237.54278.david-b@pacbell.net> <4A41DF44.4060705@mocean-labs.com>
In-Reply-To: <4A41DF44.4060705@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907021809.01990.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Richard Röjfors wrote:
> On 09-06-23 21.37, David Brownell wrote:
> > On Monday 15 June 2009, Richard Röjfors wrote:
> >> This patch splits xilinx_spi into three parts, an OF and a platform
> >> driver and generic part.
> >>
> >> The generic part now also works on X86 and also supports the Xilinx
> >> SPI IP DS570
> > 
> > Your Kconfig still mentions only DS464.
> 
> Correct, will update.

Just checking -- you didn't send an update yet, right?


> >> +	  See the "OPB Serial Peripheral Interface (SPI) (v1.00e)"
> >> +	  Product Specification document (DS464) for hardware details.
> >> +
> >> +config SPI_XILINX_PLTFM
> >> +	tristate "Xilinx SPI controller platform device"
> >> +	depends on SPI_XILINX
> > 
> > This should go first in the Kconfig, so that you don't goof up
> > the dependency display ... the OF bits depend on it.
> 
> The OF parts only depend on SPI_XILINX, not SPI_XILINX_PLTFM. But
> I can change the order anyway(?)

Maybe I misread something.  Make sure the Kconfig doesn't goof.


> >> +	/* devices to add to the bus when the host is up */
> >> +	struct spi_board_info *devices;
> >> +	u8 num_devices;
> > 
> > This is duplicating functionality in the SPI core code.
> > That's not really the way to fly.
> 
> I have discussed the same problem in the I2C list.
> 
> We have a PCIe device which is a MFD (multifunction device).
> 
> Several MFD devices could be connected to a standard PC ->
> we don't know the bus numbers in advance, and there could be
> several PCIe devices connected. Which mean the we can not use
> spi_register_board_info.

You could, actually, given metadata about those devices.
That's one of the things ACPI does -- in a way that many
of us find ugly! -- and the "device tree" some PPCs use.


> We can not call spi_add_device from the MFD because when it's
> probed the drivers for the SPI bus might not be available.

And you can't call spi_register_board_info() there since
the init section is gone.

 
> So the solution in the I2C case was to add this into the driver
> and if this tend to be a generic problem some generic solution might
> be implemented.
> 
> So I would like to have the same thing in here.

What I've done in such cases is make sure the bus adapter
driver (in this case, for the spi_master) can issue some
callback to code which makes spi_add_device(), or similar,
calls.

But if your initialization doesn't have that sort of
clean structure, it's probably kind of awkward to add
it just now...  :(

- Dave

