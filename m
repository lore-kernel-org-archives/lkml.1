Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbZHEIIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbZHEIIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbZHEIIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:08:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:27438 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355AbZHEIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=XlpdNWbNbfsqzsXS4v4k33Vrn9Eg/S/Iy0cvaHN6XKoQBks5Qf6bq++VzEFlr/xVqu
         UMc4VUTxKbta3FXp7y3sBEpLyu7ij3rYu9NEZqG8d31f0ub8gcWuGtM3l5GndWpDx/QX
         hKDXJ2cp+XPIbHFeQsTGnJlMEJLAm08+ykbdo=
Date: Wed, 5 Aug 2009 01:07:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       openezx-devel@lists.openezx.org,
       Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [PATCH v2] input: PCAP2 based touchscreen driver
References: <1249291800-15316-1-git-send-email-drwyrm@gmail.com> <20090803172125.2A490526EA5@mailhub.coreip.homeip.net> <20090804225247.8a0bf6d4.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804225247.8a0bf6d4.ospite@studenti.unina.it>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090805080757.0C91D526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

On Tue, Aug 04, 2009 at 10:52:47PM +0200, Antonio Ospite wrote:
> On Mon, 3 Aug 2009 10:21:19 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > Hi Daniel,
> >
> 
> Hi Dmitry, I am handling this review round.
> 
> > > Please note that the driver depends on some changes from the for-next branch
> > > in Samuel Ortiz's mfd tree:
> > > http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=shortlog;h=for-next
> > > 
> > > should this be queued by Samuel or the input people will you take care
> > > to send this mainline only after Samuel's tree has been merged?
> > > 
> > 
> > I don't mind it going through another tree once all the kinks are worked
> > out.
> >
> 
> Fine.
> 
> > > +static int pcap_ts_open(struct input_dev *dev)
> > > +{
> > > +	struct pcap_ts *pcap_ts = input_get_drvdata(dev);
> > > +	int err;
> > > +
> > > +	err = request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> > > +			pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> > > +	if (err)
> > > +		return err;
> > 
> > Normally we try to request IRQ in probe() methods instead of delaying it
> > till open. Open() is supposed to kick-start the device, but not allocate
> > resoirces.
> >
> 
> Ok, will do.
> 
> I must have misunderstood the description of the .open() method in
> linux/input.h:
>  * @open: this method is called when the very first user calls
>  *	input_open_device(). The driver must prepare the device
>  *	to start generating events (start polling thread,
>  *	request an IRQ, submit URB, etc.)
> 
> Does the second sentence here intends that the preparation must be done
> in .probe()?
>

It probably should be changed to "enable IRQ" instead of "request IRQ".

> > > +
> > > +	pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
> > > +	schedule_delayed_work(&pcap_ts->work, 0);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void pcap_ts_close(struct input_dev *dev)
> > > +{
> > > +	struct pcap_ts *pcap_ts = input_get_drvdata(dev);
> > > +
> > > +	cancel_delayed_work_sync(&pcap_ts->work);
> > 
> > So what happens if the device raises IRQ here?
> >
> 
> Swapping the line with the free_irq() should be ok?
> 

I think so, since you are not playing with enable/disable IRQ in this
driver.

> > > +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> > > +
> > > +	pcap_ts->read_state = PCAP_ADC_TS_M_NONTS;
> > > +	pcap_set_ts_bits(pcap_ts->pcap,
> > > +				pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);
> > > +}
> > > +
> > > +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> > > +{
> > > +	struct input_dev *input_dev;
> > > +	struct pcap_ts *pcap_ts;
> > > +	int err = -ENOMEM;
> > > +
> > > +	pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> > > +	if (!pcap_ts)
> > > +		return err;
> > > +
> > > +	pcap_ts->pcap = platform_get_drvdata(pdev);
> > > +	platform_set_drvdata(pdev, pcap_ts);
> > 
> > Ewww... Don't mess with data that does not belong to you. Also I don't
> > see where you restore it so after unloading the driver reload with
> > probably lead to "inetersting" results.
> >
> 
> Dmitry can you suggest a better way to make the pcap_ts pointer get to
> pcap_ts_remove()? We need it in order to remove the input device.
> Or keeping this hack, restoring the original value on remove, can be
> acceptable?

I think I like Mark's 2nd suggestion the best, just fetch reference to
the chip from the parent device.

> 
> We will have to fix this also in all other pcap subdrivers.
> 

*nod*

-- 
Dmitry
