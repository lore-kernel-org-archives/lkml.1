Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966041Ab0BZUVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:21:07 -0500
Received: from mxout.mainstreet.net ([207.5.0.25]:57057 "EHLO
	mxout1.mainstreet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021Ab0BZUVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:21:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
Date: Fri, 26 Feb 2010 12:20:30 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552A553AA@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4B86E572.6090101@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
thread-index: Acq2XexmFPYoUnGHTgWgGl/K1iJBiQAvb8GA
References: <20100224152401.GC13661@kaneng01.tundra.com> <4B85894A.6040406@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552A5508A@CORPEXCH1.na.ads.idt.com> <4B86E572.6090101@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <mporter@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <thomas.moll.ext@nsn.com>,
       <thomas.moll@sysgo.com>, "Alexandre Bounine" <alexb@tundra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> Bounine, Alexandre wrote:
> > Micha Nelissen wrote:
> >> Alexandre Bounine wrote:
> >>>  /**
> >>> + * rio_em_set_ops- Sets Error Managment operations for a
particular
> > vendor switch
> >>> + * @rdev: RIO device
> >>> + *
> >>> + * Searches the RIO EM ops table for known switch types. If the
vid
> >>> + * and did match a switch table entry, then set the em_init() and
> >>> + * em_handle() ops to the table entry values.
> >> Shouldn't any RIO device be able to support error management, not
just
> >> switches?
> >
> > Only if a device reports this capability by having Error Management
> > Extended Features block.
> > Ideally, we have to provide default handler for every such device (I
am
> > planning it for some future updates). It should be the same as for
> > routing operations - if the standard feature exists, it has to be
used
> > unless something else takes over.
> 
> Yes, therefore I thought that: or the EM_OPS are per driver, or they
can
> be integrated in the switch hooks list.

Or combination of both methods as I implemented it. I want to have it
flexible enough to be adopted to further development of RapidIO
ecosystem.   
 
> > For now I keep all port-write messages from end-points serviced by
their
> > individual drivers. One of reasons for this: the EM PW message
format
> 
> Maybe have a generic rio function that can be called by any driver
that
> knows a particular port-write was due to error management causes? This
> function would read the standard defined EF block registers. Then the
> driver part can be quite small.

I think this echoes what I mentioned above as default handler.

> 
> >>> +	if (port->ops->pwenable)
> >>> +		port->ops->pwenable(port, enable);
> >>> +}
> >>> +
> >> Maybe this can be done by switch->init function?
> >
> > This is not per-switch function. This function enables mport to
receive
> > incoming PW messages. Per-switch PW enable is done in switch->init
as
> > for Tsi57x.
> 
> Oops, I meant this comment for the em_init function call.
> 
> >>> +			rio_mport_write_config_32(mport, destid,
> > hopcount,
> >>> +				rdev->phys_efptr +
> >>> +					RIO_PORT_N_ACK_STS_CSR(portnum),
> >>> +				RIO_PORT_N_ACK_CLEAR);
> >> This doesn't work for the 568; but the 568 has no special handling?
> >
> > Tsi568 will not send EM PW message. Tsi568 PWs are disabled in its
> > em_init().
> 
> Why?

Because Tsi568 requires special handling which is not implemented
(yet?). 
  
> 
> >>> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578,
tsi57x_em_init,
> > tsi57x_em_handler);
> >> Why not declare these along with the other ops?
> >
> > Because the EM extensions is a separate capability. It is not
guaranteed
> > to be in every switch.
> 
> They might initialize them with NULL to indicate they don't support
it?

My preference is to keep unrelated capabilities separately. Otherwise,
these long ops lists may become unmanageable later when new extensions
will be added into RIO spec.

Cheers,

Alex.

