Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab0BYOxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:53:31 -0500
Received: from mxout.mainstreet.net ([207.5.0.25]:56129 "EHLO
	mxout1.mainstreet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab0BYOx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:53:29 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/7] RapidIO: Add switch locking during discovery
Date: Thu, 25 Feb 2010 06:53:04 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552A54EA1@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4B857A53.30106@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/7] RapidIO: Add switch locking during discovery
thread-index: Acq1hX3KFb2+CAHsSD+6u1j79IJnvAAoDGuQ
References: <20100224152050.GB13661@kaneng01.tundra.com> <4B857A53.30106@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <mporter@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <thomas.moll@sysgo.com>,
       <thomas.moll.ext@nsn.com>, "Alexandre Bounine" <alexb@tundra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > +				/* Attempt to acquire device lock */
> > +				rio_mport_write_config_32(port, destid,
> > +							  hopcount,
> > +
RIO_HOST_DID_LOCK_CSR,
> > +
port->host_deviceid);
> > +				rio_mport_read_config_32(port, destid,
hopcount,
> > +					RIO_HOST_DID_LOCK_CSR, &result);
> > +				while (result != port->host_deviceid) {
> 
> It's better to abstract the locking of a device into a new function,
> rio_lock_device / rio_unlock_device.
> 
> Then you can use those in rio_get_route_entry and rio_add_route_entry.

Agree. Plus, adding a "lock" parameter to
rio_get_route_entry/rio_add_route_entry to avoid excessive locking
requests when scanning entire table. I will do it in next version or as
additional patch: I have to address locking anyway for future changes.
    
> 
> > @@ -1027,6 +1090,13 @@ int __devinit rio_disc_mport(struct rio_
> > +
> > +		/* Read DestID assigned by enumerator */
> > +		rio_local_read_config_32(mport, RIO_DID_CSR,
> > +					 &mport->host_deviceid);
> > +		mport->host_deviceid = RIO_GET_DID(mport->sys_size,
> > +
mport->host_deviceid);
> > +
> 
> This fixes something else, should be a separate patch.

This sets an ID used for locking during discovery. On a startup only
enumerator's ID is set to the specified value. All discovering agents
have this ID set to -1. After enumeration is completed it is safe to
initialize host_deviceid for agents as well.

Alex.

