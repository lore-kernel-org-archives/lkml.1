Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab0BYUaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:30:55 -0500
Received: from mxout.mainstreet.net ([207.5.0.25]:60037 "EHLO
	mxout1.mainstreet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab0BYUax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:30:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
Date: Thu, 25 Feb 2010 12:30:21 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552A5508A@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4B85894A.6040406@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
thread-index: Acq1jmgUcfVVRLTkSJ2g29OZs0Q24gArzdHQ
References: <20100224152401.GC13661@kaneng01.tundra.com> <4B85894A.6040406@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <mporter@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <thomas.moll.ext@nsn.com>,
       <thomas.moll@sysgo.com>, "Alexandre Bounine" <alexb@tundra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> >  /**
> > + * rio_em_set_ops- Sets Error Managment operations for a particular
vendor switch
> > + * @rdev: RIO device
> > + *
> > + * Searches the RIO EM ops table for known switch types. If the vid
> > + * and did match a switch table entry, then set the em_init() and
> > + * em_handle() ops to the table entry values.
> 
> Shouldn't any RIO device be able to support error management, not just
> switches?

Only if a device reports this capability by having Error Management
Extended Features block.
Ideally, we have to provide default handler for every such device (I am
planning it for some future updates). It should be the same as for
routing operations - if the standard feature exists, it has to be used
unless something else takes over.

For now I keep all port-write messages from end-points serviced by their
individual drivers. One of reasons for this: the EM PW message format
definitions lacks any hint that allows to identify type of the message.
In theory endpoints may send port-writes of any format (up to max size
of 64 bytes), what makes unifying handling of endpoints more difficult
(at least at this stage of SRIO evolution).     
 
> > +/**
> > + * rio_pw_enable - Enables/disables port-write handling by a master
port
> > + * @port: Master port associated with port-write handling
> > + * @enable:  1=enable,  0=disable
> > + */
> > +static void rio_pw_enable(struct rio_mport *port, int enable)
> > +{
> > +	if (port->ops->pwenable)
> > +		port->ops->pwenable(port, enable);
> > +}
> > +
> 
> Maybe this can be done by switch->init function?

This is not per-switch function. This function enables mport to receive
incoming PW messages. Per-switch PW enable is done in switch->init as
for Tsi57x. 

> 
> > +/**
> > + * rio_inb_pwrite_handler - process inbound port-write message
> > + * @pw_msg: pointer to inbound port-write message
> > + *
> > + * Processes an inbound port-write message. Returns 0 if the
request
> > + * has been satisfied.
> > + */
> > +int rio_inb_pwrite_handler(u32 *pw_msg)
> > +{
> 
> Perhaps map this pw_msg to a struct? Or read it into named variables?

Agree - this is not nice. The best way may be defining it as a union
which combines different message formats (EM at this point) and raw
array. Will change for next update.

> 
> > +	/* Clear Port Errors */
> > +	rio_mport_write_config_32(mport, destid, hopcount,
> > +			rdev->phys_efptr +
RIO_PORT_N_ERR_STS_CSR(portnum),
> > +			err_status & 0x07120204);
> 
> Hardcoded value!

Agree. Tagged for next drop.

> 
> > +
> > +	if (rdev->rswitch->port_ok & (1 << portnum)) {
> > +		if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) {
> > +			rdev->rswitch->port_ok &= ~(1 << portnum);
> > +			rio_mport_read_config_32(mport, destid,
hopcount,
> > +				rdev->phys_efptr +
RIO_PORT_N_CTL_CSR(portnum),
> > +				&regval);
> > +			rio_mport_write_config_32(mport, destid,
hopcount,
> > +				rdev->phys_efptr +
RIO_PORT_N_CTL_CSR(portnum),
> > +				regval | RIO_PORT_N_CTL_LOCKOUT);
> 
> You have a function for this?

Yes, I do. Will be fixed for the next drop.

> 
> > +			rio_mport_write_config_32(mport, destid,
hopcount,
> > +				rdev->phys_efptr +
> > +					RIO_PORT_N_ACK_STS_CSR(portnum),
> > +				RIO_PORT_N_ACK_CLEAR);
> 
> This doesn't work for the 568; but the 568 has no special handling?

Tsi568 will not send EM PW message. Tsi568 PWs are disabled in its
em_init().

> 
> > +	/* Clear Port-Write Pending bit */
> > +	rio_mport_write_config_32(mport, destid, hopcount,
> > +			rdev->phys_efptr +
RIO_PORT_N_ERR_STS_CSR(portnum),
> > +			RIO_PORT_N_ERR_STS_PW_PEND);
> > +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI572, tsi57x_em_init,
tsi57x_em_handler);
> > +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI574, tsi57x_em_init,
tsi57x_em_handler);
> > +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI577, tsi57x_em_init,
tsi57x_em_handler);
> > +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_em_init,
tsi57x_em_handler);
> 
> Why not declare these along with the other ops?

Because the EM extensions is a separate capability. It is not guaranteed
to be in every switch.

Alex.

