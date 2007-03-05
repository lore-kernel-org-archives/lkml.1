Return-Path: <linux-kernel-owner+w=401wt.eu-S965259AbXCEN2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259AbXCEN2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXCEN2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:28:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43590 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965259AbXCEN2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:28:11 -0500
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
From: Frank Haverkamp <haver@vnet.ibm.com>
Reply-To: haver@vnet.ibm.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <1172441030.13541.21.camel@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
	 <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron>
	 <20070225055828.GC9137@infradead.org>
	 <1172441030.13541.21.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Mon, 05 Mar 2007 14:28:04 +0100
Message-Id: <1173101284.6026.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Mon, 2007-02-26 at 09:03 +1100, Rusty Russell wrote:
> On Sun, 2007-02-25 at 05:58 +0000, Christoph Hellwig wrote:
> > On Tue, Feb 20, 2007 at 03:00:56PM +0200, Artem Bityutskiy wrote:
> > > > > +module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
> > > > > +MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> > > > > +		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
> > > > > +		      "Multiple \"mtd\" parameters may be specified.\n"
> > > > > +		      "MTD devices may be specified by their number or name. "
> > > > > +		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
> > > > > +		      "specify UBI VID header position and data starting "
> > > > > +		      "position to be used by UBI.\n"
> > > > > +		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
> > > > > +		      "with name content using VID header offset 1984 and data "
> > > > > +		      "start 2048, and MTD device number 4 using default "
> > > > > +		      "offsets");
> > > > 

> The reason drivers can use __module_param_call is that they can
> implement their own "types" for module parameters, which will end up
> requiring this.
> 
> Using it directly is only really for backwards compatibility (which is
> important!), but for new parameters, this multi-part self-parsing is
> nasty.  Standard (but admittedly suboptimal) way to do this is having
> three parameters module_param_array(name, ...),
> module_param_array(header_offset, ...),
> module_param_array(data_start, ...).

we wanted to be able to ommit some of the parameters and let UBI use
resonable defaults if needed.

Example where we wanted to explicitly overwrite the offset parameters:
  mtd=content,1984,2048

Example where we did not want it but let instead UBI figure out
resonable parameters:
  mtd=4

With the three arrays we did not see a nice way of achieving this.

  ubimtds=content,4,7
  hdroffs=1984,?,1984
  dataoff=s2048,?,2048

The ? look odd, don't they?

We also looked at the slram parameters which are like this:

  slram=name0,addr0,+size0,name1,addr1,+size1

and found that if we wanted to add one more parameter e.g. width it
cause likely an interface change:

  slram=name0,addr0,+size0,width0,name1,addr1,+size1,width1

Finally we found that we liked the phram parameter parsing (which is
essentially the same) and did it similar to that.

Frank


