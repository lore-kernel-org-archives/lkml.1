Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXETP2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXETP2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbXETP2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:28:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbXETP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:28:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46506912.9020904@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 17:28:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: dan@dennedy.org
CC: Arnd Bergmann <arnd@arndb.de>, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705200155.26825.arnd@arndb.de> <464F900A.10900@s5r6.in-berlin.de> <200705201703.37561.arnd@arndb.de>
In-Reply-To: <200705201703.37561.arnd@arndb.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Sunday 20 May 2007, Stefan Richter wrote:
>>> Note that this data structure only needs conversion on x86_64 and ia64, but
>>> not on powerpc and other 64 bit architectures that align __u64 also in
>>> 32 bit mode.
>> Is this conversion just unnecessary or actually harmful on ppc64 and others?
> 
> With the current patch, the compat_ioctl function does not handle the ppc32
> version of the structure at all, so it's broken there, it would at least
> need a 
> 
> 	case RAW1394_IOC_GET_CYCLE_TIMER:
> 		err = raw1394_ioctl(NULL, file, cmd, arg);
> 		break;

Dan,

maybe we should change

/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
struct raw1394_cycle_timer {
	/* contents of Isochronous Cycle Timer register,
	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
	__u32 cycle_timer;

	/* local time in microseconds since Epoch,
	   simultaneously read with cycle timer */
	__u64 local_time;
};

to

/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
struct raw1394_cycle_timer {
	/*
	 * least significant 32 bits are contents of Isochronous Cycle
	 * Timer register, as in OHCI 1.1 clause 5.13 (also with
	 * non-OHCI hosts)
	 */
	__u64 cycle_timer;

	/*
	 * local time in microseconds since Epoch,
	 * simultaneously read with cycle timer
	 */
	__u64 local_time;
};

before a libraw1394 with get-cycle-timer support is released.
Shall I prepare according patches for raw1394 and libraw1394?
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
