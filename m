Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYLHGXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYLHGXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYLHGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:23:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18242 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYLHGXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:23:43 -0500
Subject: Re: UBI/DVB ioctl conflict?
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-mtd@lists.infradead.org, arnd@arndb.de,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org
In-Reply-To: <20081207095811.13b51cca@zod.rchland.ibm.com>
References: <20081207095811.13b51cca@zod.rchland.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 08 Dec 2008 08:20:26 +0200
Message-Id: <1228717226.13686.89.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Dec 2008 06:22:26.0610 (UTC) FILETIME=[56FC1120:01C958FD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-07 at 09:58 -0500, Josh Boyer wrote:
> I received a bug report where someone noticed that the UBI ioctls can
> conflict with the dvb subsystem.  Looking it over, it seems that both
> subsystems use 'o' as the magic, and do have a set of somewhat
> conflicting sequence numbers as the secondary arg.
> 
> Is this a problem?

Hmm, thanks for noticing.

I've looked at this, and thankfully it looks like we were lucky and do
not use the same 'ioctl()' numbers, by chance.

Ioctl number has the following structure:

bits 0-15: command (or sequence number)
bits 16-29: parameter size
bits 30-31: mode (read, write, etc).

We have the following overlaps with DVB subsystem:

#define AUDIO_STOP   _IO('o', 1)
#define UBI_IOCRMVOL _IOW('o', 1, int32_t)

#define AUDIO_PLAY   _IO('o', 2)
#define UBI_IOCRSVOL _IOW('o', 2, struct ubi_rsvol_req)

#define AUDIO_PAUSE  _IO('o', 3)
#define UBI_IOCRNVOL _IOW('o', 3, struct ubi_rnvol_req)

These are fine because parameter sizes are different, and because UBI
uses _IOW and DVB uses _IO, so the mode bits are "01" and "00".

And:

#define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64,
                                        struct dvb_diseqc_slave_reply)
#define UBI_IOCATT _IOW('o', 64, struct ubi_attach_req)

#define FE_DISEQC_SEND_BURST _IO('o', 65)
#define UBI_IOCDET _IOW('o', 65, int32_t)

are also fine because parameter sizes are different and the mode bits
are different.

However, we have to be very careful in the future. It seems like DVB
has been in the kernel long before UBI, so this potential conflict
would be my fault.

Neither DVB nor UBI seem not to be documented in
Documentation/ioctl/ioctl-number.txt. Should we do this?

P.S. Added Arnd to CC for suggestions, as well as LKML and DVB
maintainers.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

