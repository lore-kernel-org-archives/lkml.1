Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0BBN0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:26:15 -0500
Received: from mga10.intel.com ([192.55.52.92]:52628 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191Ab0BBN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:26:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,390,1262592000"; 
   d="scan'208";a="769357833"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 6/6] xen/hybrid: Enable grant table and xenbus
Date: Tue, 2 Feb 2010 21:24:40 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com> <1265098747-10117-7-git-send-email-sheng@linux.intel.com> <1265110390.2965.22456.camel@zakaz.uk.xensource.com>
In-Reply-To: <1265110390.2965.22456.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022124.41019.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 19:33:10 Ian Campbell wrote:
> On Tue, 2010-02-02 at 08:19 +0000, Sheng Yang wrote:
> > Notice one memory region(0xfbfe0000ul - 0xfc000000ul) would be reserved
> > in the bios E820 table. This memory region would be used as grant table.
> 
> I queried this requirement in a reply to the hypervisor patch.
> 
> > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > index 05a31e5..d7dfba9 100644
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> > @@ -1071,6 +1071,9 @@ static int __init xlblk_init(void)
> >  	if (!xen_domain())
> >  		return -ENODEV;
> >
> > +	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
> > +		return -ENODEV;
> > +
> 
> This seems ugly, at the very least the check should be something like
> xen_evtchn_enabled() 

Yeah, seems indeed ugly... 

> but preferable would be to hook up evtchn's by
> demuxing the PCI device IRQ (the exiting PVonHVM drivers mechanism) in
> the case where hybrid evtchn's are not available and encapsulating the
> differences inside the evtchn code, there should be no need to scatter
> these sorts of checks throughout every driver.
> 
> If you don't want to demux the PCI device IRQ for the non-hybrid case
> another option might be simply return failure from the evtchn operations
> if hybrid evtchns are not available and to ensure that the drivers
> handle that sort of error gracefully (which they should in any case). At
> least the difference in mode would be encapsulated that way.
> 
> (same for netfront).

I am not sure if I understand you right, but I think the issue is, there is no 
PVonHVM drivers in Linux upstream. The drivers are currently maintained by 
OSVs, and the one in Xen upstream code only support 2.6.18. So I didn't take 
them into consideration at the time.

I think the "xen_evtchn_enable()" looks much better. Would replace these ugly 
lines in the next version. 
> 
> >  	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
> >  		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
> >  		       XENVBD_MAJOR, DEV_NAME);
> > diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
> > index c721c0a..74cbb25 100644
> > --- a/drivers/input/xen-kbdfront.c
> > +++ b/drivers/input/xen-kbdfront.c
> > @@ -341,6 +341,10 @@ static int __init xenkbd_init(void)
> >  	if (!xen_domain())
> >  		return -ENODEV;
> >
> > +	/* Xen Hybrid domain don't need vkbd */
> > +	if (xen_hybrid_domain())
> > +		return -ENODEV;
> > +
> 
> Why disallow it if the platform has specified it (same for fbfront)?

Well.. The direct reason is I didn't test them and don't know what would 
happen... I would give it a try later.
> 
> > diff --git a/include/xen/xen.h b/include/xen/xen.h
> > index aace9cc..632e76f 100644
> > --- a/include/xen/xen.h
> > +++ b/include/xen/xen.h
> > @@ -5,6 +5,7 @@ enum xen_domain_type {
> >  	XEN_NATIVE,		/* running on bare hardware    */
> >  	XEN_PV_DOMAIN,		/* running in a PV domain      */
> >  	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
> > +	XEN_HYBRID_DOMAIN,	/* running in a Xen hybrid hvm domain */
> >  };
> 
> I don't think you should need to distinguish HYBRID from HVM mode...

The only purpose is for event channel of hybrid... Yes, I think I can find 
other way to indicate the availability of event channel. :)

-- 
regards
Yang, Sheng
