Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZDXJ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZDXJ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZDXJZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:25:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17051 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZDXJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:25:50 -0400
Date: Fri, 24 Apr 2009 12:25:33 +0300
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TWL4030: add function to send PB messages
Message-ID: <20090424092533.GA4720@codecarver.research.nokia.com>
References: <1240407833-28060-1-git-send-email-peter.de-schrijver@nokia.com> <200904231503.47287.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904231503.47287.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-OriginalArrivalTime: 24 Apr 2009 09:25:35.0472 (UTC) FILETIME=[9F731700:01C9C4BE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -81,6 +82,69 @@ twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
> >  			value, info->base + offset);
> >  }
> >  
> > +static int twl4030_wait_pb_ready(void)
> > +{
> > +
> > +	u8 pb_status;
> > +	int status, timeout = 10;
> > +
> > +	do {
> > +		status = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER,
> > +						&pb_status, 0x14);
> > +		if (status < 0)
> > +			return status;
> > +
> 
> Worth a comment that PB_CFG.BIT(0) == PB_I2C_BUSY ... true if there's
> a word queued for the power bus, but not yet sent.  And that we assume
> no other I2C master is sending such events...
> 

The multi master situation seems inherently racy to me anyway as you
need to write 2 bytes to 2 different registers to send 1 message. Or is there
a way to keep mastership of the bus between transactions ?

> > +	/* Enable I2C access to powerbus */
> > +	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> > +					pb_state | (1<<1), 0x14);
> > +	if (status < 0)
> > +		return status;
> > +
> > +	status = twl4030_wait_pb_ready();
> 
> I'd probably combine wait_pb_ready() with this; not that
> this is wrong, but you should only need to set BIT(1) once,
> and there's no need to re-read that byte to test BIT(0).
> 
> Minor point ... I hate needless I/O.  This isn't a critical
> path though.
> 

Indeed. Exactly why I didn't try to optimize on I/O here :)

Cheers,

Peter.

-- 
goa is a state of mind
