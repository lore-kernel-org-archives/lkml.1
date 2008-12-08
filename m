Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYLHJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYLHJl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLHJlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:41:19 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:38279 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbYLHJlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:41:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAD96PEnCTsYx/2dsb2JhbACBbMtngwU
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linux-mtd@lists.infradead.org, dedekind@infradead.org
Subject: Re: UBI/DVB ioctl conflict?
Date: Mon, 8 Dec 2008 10:41:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, v4l-dvb-maintainer@linuxtv.org,
       LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de
References: <20081207095811.13b51cca@zod.rchland.ibm.com> <1228717226.13686.89.camel@sauron>
In-Reply-To: <1228717226.13686.89.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081041.14178.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 December 2008 07:20:26 Artem Bityutskiy wrote:
> On Sun, 2008-12-07 at 09:58 -0500, Josh Boyer wrote:
> > I received a bug report where someone noticed that the UBI ioctls can
> > conflict with the dvb subsystem.  Looking it over, it seems that both
> > subsystems use 'o' as the magic, and do have a set of somewhat
> > conflicting sequence numbers as the secondary arg.
> >
> > Is this a problem?
>
> Hmm, thanks for noticing.
>
> I've looked at this, and thankfully it looks like we were lucky and do
> not use the same 'ioctl()' numbers, by chance.
>
> Ioctl number has the following structure:
>
> bits 0-15: command (or sequence number)
> bits 16-29: parameter size
> bits 30-31: mode (read, write, etc).
>
> We have the following overlaps with DVB subsystem:
>
> #define AUDIO_STOP   _IO('o', 1)
> #define UBI_IOCRMVOL _IOW('o', 1, int32_t)
>
> #define AUDIO_PLAY   _IO('o', 2)
> #define UBI_IOCRSVOL _IOW('o', 2, struct ubi_rsvol_req)
>
> #define AUDIO_PAUSE  _IO('o', 3)
> #define UBI_IOCRNVOL _IOW('o', 3, struct ubi_rnvol_req)
>
> These are fine because parameter sizes are different, and because UBI
> uses _IOW and DVB uses _IO, so the mode bits are "01" and "00".
>
> And:
>
> #define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64,
>                                         struct dvb_diseqc_slave_reply)
> #define UBI_IOCATT _IOW('o', 64, struct ubi_attach_req)
>
> #define FE_DISEQC_SEND_BURST _IO('o', 65)
> #define UBI_IOCDET _IOW('o', 65, int32_t)
>
> are also fine because parameter sizes are different and the mode bits
> are different.
>
> However, we have to be very careful in the future. It seems like DVB
> has been in the kernel long before UBI, so this potential conflict
> would be my fault.
>
> Neither DVB nor UBI seem not to be documented in
> Documentation/ioctl/ioctl-number.txt. Should we do this?
>
> P.S. Added Arnd to CC for suggestions, as well as LKML and DVB
> maintainers.

Correct me if I'm wrong, but doesn't this only matters for devices that would 
implement both the UBI and DVB API on the same inode ? That would be quite 
unlikely.

Best regards,

-- 
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
F +32 (2) 387 42 75
