Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0BXUR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:17:26 -0500
Received: from edu-smtp-01.edutel.nl ([88.159.1.221]:38735 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0BXURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:17:25 -0500
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 15:17:24 EST
Message-ID: <4B85894A.6040406@neli.hopto.org>
Date: Wed, 24 Feb 2010 21:17:14 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Alexandre Bounine <alexb@tundra.com>
CC: mporter@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, thomas.moll.ext@nsn.com,
       thomas.moll@sysgo.com
Subject: Re: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
References: <20100224152401.GC13661@kaneng01.tundra.com>
In-Reply-To: <20100224152401.GC13661@kaneng01.tundra.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
>  /**
> + * rio_em_set_ops- Sets Error Managment operations for a particular vendor switch
> + * @rdev: RIO device
> + *
> + * Searches the RIO EM ops table for known switch types. If the vid
> + * and did match a switch table entry, then set the em_init() and
> + * em_handle() ops to the table entry values.

Shouldn't any RIO device be able to support error management, not just 
switches?

> +/**
> + * rio_pw_enable - Enables/disables port-write handling by a master port
> + * @port: Master port associated with port-write handling
> + * @enable:  1=enable,  0=disable
> + */
> +static void rio_pw_enable(struct rio_mport *port, int enable)
> +{
> +	if (port->ops->pwenable)
> +		port->ops->pwenable(port, enable);
> +}
> +

Maybe this can be done by switch->init function?

> +/**
> + * rio_inb_pwrite_handler - process inbound port-write message
> + * @pw_msg: pointer to inbound port-write message
> + *
> + * Processes an inbound port-write message. Returns 0 if the request
> + * has been satisfied.
> + */
> +int rio_inb_pwrite_handler(u32 *pw_msg)
> +{

Perhaps map this pw_msg to a struct? Or read it into named variables?

> +	/* Clear Port Errors */
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
> +			err_status & 0x07120204);

Hardcoded value!

> +
> +	if (rdev->rswitch->port_ok & (1 << portnum)) {
> +		if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) {
> +			rdev->rswitch->port_ok &= ~(1 << portnum);
> +			rio_mport_read_config_32(mport, destid, hopcount,
> +				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
> +				&regval);
> +			rio_mport_write_config_32(mport, destid, hopcount,
> +				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
> +				regval | RIO_PORT_N_CTL_LOCKOUT);

You have a function for this?

> +			rio_mport_write_config_32(mport, destid, hopcount,
> +				rdev->phys_efptr +
> +					RIO_PORT_N_ACK_STS_CSR(portnum),
> +				RIO_PORT_N_ACK_CLEAR);

This doesn't work for the 568; but the 568 has no special handling?

> +	/* Clear Port-Write Pending bit */
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
> +			RIO_PORT_N_ERR_STS_PW_PEND);
> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI572, tsi57x_em_init, tsi57x_em_handler);
> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI574, tsi57x_em_init, tsi57x_em_handler);
> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI577, tsi57x_em_init, tsi57x_em_handler);
> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_em_init, tsi57x_em_handler);

Why not declare these along with the other ops?

Micha
