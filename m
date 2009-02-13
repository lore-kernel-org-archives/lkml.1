Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbZBMSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbZBMSTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZBMSTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:19:45 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36112 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZBMSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=LeQCCa8e/F0exILfsEmG87xbTpT8Uzo33caPMiP2AcrvzsjmLsh6gMwIkd279e1aEI
         CV5canWeoSZLYJGDBAGsYTpCvTWeGIT3DNMMhqqqeMYM3pkHFNvhx2/fEVtJMOlq77qz
         prp5upILObtbYJKBEkxhzZ51x6bqZgfw4Rvh0=
Date: Fri, 13 Feb 2009 20:19:32 +0200
From: Pekka Paalanen <pq@iki.fi>
To: wenji.huang@oracle.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 2/2] tracing: add checks for printing pci devices in
 mmiotrace.
Message-ID: <20090213201932.2dd07f93@daedalus.pq.iki.fi>
In-Reply-To: <49950EB0.907@oracle.com>
References: <1234489192-18594-1-git-send-email-wenji.huang@oracle.com>
	<1234489341-18630-1-git-send-email-wenji.huang@oracle.com>
	<alpine.DEB.1.10.0902130059570.15469@gandalf.stny.rr.com>
	<49950EB0.907@oracle.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 14:09:52 +0800
Wenji Huang <wenji.huang@oracle.com> wrote:

> Steven Rostedt wrote:
> > On Thu, 12 Feb 2009, Wenji Huang wrote:
> > 
> >> This patch is to provide checking return value of trace_seq_printf
> >> so as to keep completeness of mmio_print_pcidev.
> >>
> >> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> >> ---
> >>  kernel/trace/trace_mmiotrace.c |   26 ++++++++++++++++----------
> >>  1 files changed, 16 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> >> index c401b90..ebb0b61 100644
> >> --- a/kernel/trace/trace_mmiotrace.c
> >> +++ b/kernel/trace/trace_mmiotrace.c
> >> @@ -56,17 +56,19 @@ static void mmio_trace_start(struct trace_array *tr)
> >>  	mmio_reset_data(tr);
> >>  }
> >>  
> >> -static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
> >> +static enum print_line_t mmio_print_pcidev(struct trace_seq *s,
> >> +					   const struct pci_dev *dev)
> >>  {
> >>  	int ret = 0;
> >>  	int i;
> >>  	resource_size_t start, end;
> >>  	const struct pci_driver *drv = pci_dev_driver(dev);
> >>  
> >> -	/* XXX: incomplete checks for trace_seq_printf() return value */
> >> -	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
> >> +	ret = trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
> >>  				dev->bus->number, dev->devfn,
> >>  				dev->vendor, dev->device, dev->irq);
> >> +	if (!ret)
> >> +		return TRACE_TYPE_PARTIAL_LINE;
> >>  	/*
> >>  	 * XXX: is pci_resource_to_user() appropriate, since we are
> >>  	 * supposed to interpret the __ioremap() phys_addr argument based on
> >> @@ -74,21 +76,25 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
> >>  	 */
> >>  	for (i = 0; i < 7; i++) {
> >>  		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> >> -		ret += trace_seq_printf(s, " %llx",
> >> +		ret = trace_seq_printf(s, " %llx",
> >>  			(unsigned long long)(start |
> >>  			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
> >> -	}
> >> -	for (i = 0; i < 7; i++) {
> >> +		if (!ret)
> >> +			return TRACE_TYPE_PARTIAL_LINE;
> > 
> > The above looks like a change of logic to me. I'm a bit tired so I can be 
> > wrong. But it looks like the original was:
> > 
> >      for (i = 0; i < 7; i++) {
> >              pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> >              ret += trace_seq_printf(s, " %llx",
> >                      (unsigned long long)(start |
> >                      (dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
> >      }
> >      for (i = 0; i < 7; i++) {
> >              pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> >              ret += trace_seq_printf(s, " %llx",
> >                      dev->resource[i].start < dev->resource[i].end ?
> >                      (unsigned long long)(end - start) + 1 : 0);
> >      }
> > 
> > And the new is:
> > 
> >      for (i = 0; i < 7; i++) {
> >              pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> >              ret = trace_seq_printf(s, " %llx",   
> >                      (unsigned long long)(start |
> >                      (dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
> >              if (!ret)
> >                      return TRACE_TYPE_PARTIAL_LINE;
> >              pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
> >              ret = trace_seq_printf(s, " %llx",
> >                      dev->resource[i].start < dev->resource[i].end ?
> >                      (unsigned long long)(end - start) + 1 : 0);
> >              if (!ret)
> >                      return TRACE_TYPE_PARTIAL_LINE;
> >      }
> > 
> > This changes the output format.
> > 
> > Pekka,
> > 
> > Is this OK?
> > 
> > -- Steve
> 
> oops, output format is changed. Need to update it.

Indeed, don't change the output format, please.

These checks are not enough to actually handle the case, mmio_read()
needs to be updated, too, to do the right thing (I'm looking at Ingo's
tip/master). I.e. it should skip to print_out to flush out old data.
Shouldn't also *ppos be updated in mmio_read()?


Thanks for looking into this.
-- 
Pekka Paalanen
http://www.iki.fi/pq/
