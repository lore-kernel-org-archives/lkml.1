Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab0BYVCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:02:55 -0500
Received: from edu-smtp-01.edutel.nl ([88.159.1.221]:42236 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab0BYVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:02:54 -0500
Message-ID: <4B86E572.6090101@neli.hopto.org>
Date: Thu, 25 Feb 2010 22:02:42 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: mporter@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, thomas.moll.ext@nsn.com,
       thomas.moll@sysgo.com, Alexandre Bounine <alexb@tundra.com>
Subject: Re: [PATCH 3/7] RapidIO: Add Port-Write handling for EM
References: <20100224152401.GC13661@kaneng01.tundra.com> <4B85894A.6040406@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552A5508A@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552A5508A@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen wrote:
>> Alexandre Bounine wrote:
>>>  /**
>>> + * rio_em_set_ops- Sets Error Managment operations for a particular
> vendor switch
>>> + * @rdev: RIO device
>>> + *
>>> + * Searches the RIO EM ops table for known switch types. If the vid
>>> + * and did match a switch table entry, then set the em_init() and
>>> + * em_handle() ops to the table entry values.
>> Shouldn't any RIO device be able to support error management, not just
>> switches?
> 
> Only if a device reports this capability by having Error Management
> Extended Features block.
> Ideally, we have to provide default handler for every such device (I am
> planning it for some future updates). It should be the same as for
> routing operations - if the standard feature exists, it has to be used
> unless something else takes over.

Yes, therefore I thought that: or the EM_OPS are per driver, or they can 
be integrated in the switch hooks list.

> For now I keep all port-write messages from end-points serviced by their
> individual drivers. One of reasons for this: the EM PW message format

Maybe have a generic rio function that can be called by any driver that 
knows a particular port-write was due to error management causes? This 
function would read the standard defined EF block registers. Then the 
driver part can be quite small.

>>> +	if (port->ops->pwenable)
>>> +		port->ops->pwenable(port, enable);
>>> +}
>>> +
>> Maybe this can be done by switch->init function?
> 
> This is not per-switch function. This function enables mport to receive
> incoming PW messages. Per-switch PW enable is done in switch->init as
> for Tsi57x. 

Oops, I meant this comment for the em_init function call.

>>> +			rio_mport_write_config_32(mport, destid,
> hopcount,
>>> +				rdev->phys_efptr +
>>> +					RIO_PORT_N_ACK_STS_CSR(portnum),
>>> +				RIO_PORT_N_ACK_CLEAR);
>> This doesn't work for the 568; but the 568 has no special handling?
> 
> Tsi568 will not send EM PW message. Tsi568 PWs are disabled in its
> em_init().

Why?

>>> +DECLARE_RIO_EM_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_em_init,
> tsi57x_em_handler);
>> Why not declare these along with the other ops?
> 
> Because the EM extensions is a separate capability. It is not guaranteed
> to be in every switch.

They might initialize them with NULL to indicate they don't support it?

Micha
