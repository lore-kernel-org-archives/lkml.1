Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226Ab0AHP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0AHP2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196Ab0AHP2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:28:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0AHP2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:28:48 -0500
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
From: James Bottomley <James.Bottomley@suse.de>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: =?ISO-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <4B4632BF.4070806@pobox.com>
References: <4B3BDB66.6000008@googlemail.com>  <4B4632BF.4070806@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 09:28:39 -0600
Message-Id: <1262964519.3025.614.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
> On 12/30/2009 05:59 PM, René Bolldorf wrote:
> > We don't need this ;-).
> >
> > Best regards René Bolldorf & a happy new year in advance.
> >
> > --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
> > +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
> > @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
> >
> > DPRINTK("ATAPI request sense\n");
> >
> > - /* FIXME: is this needed? */
> > - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
> 
> I need a little bit more detail than an unqualified statement...  Did 
> you audit all paths leading to this code point?

There are two code paths coming into here.  One directly from the scsi
sense buffer:

		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
			tmp = atapi_eh_request_sense(qc->dev,
						qc->scsicmd->sense_buffer,
						qc->result_tf.feature >> 4);

Which is fine because SCSI zeros the sense buffer.

But one also here:

		u8 *sense_buffer = dev->link->ap->sector_buf;
		[...]
		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);

Which doesn't look OK because it looks like the sector_buf isn't cleared
(and it is reused).

James


