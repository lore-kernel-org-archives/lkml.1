Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308Ab0ARWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0ARWZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110Ab0ARWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:25:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0ARWZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:25:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
Date: Mon, 18 Jan 2010 23:25:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Alek Du <alek.du@intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de> <201001182223.49764.arnd@arndb.de> <Pine.LNX.4.64.1001182235050.30446@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1001182235050.30446@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201001182325.11201.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Rh0DKEKvk8RFXAPeK88teYdukw3Tamk+UnQV
 +ZdEIMj7sgNiP8P0TcY0pNh0D5Ph0wHAlwVCGTn4DcnxqjBGkF
 KpfCsPDemcFCightwKdjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Julia Lawall wrote:
> > That code looks indeed broken as was added las July as part of 331ac6b288d9
> > "USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and
> > support phy low power mode". The reason that this hasn't triggered is
> > probably the lack of Moorestown machines in the field.
> 
> The fix is just msleep -> mdelay?

No, that would just kill the warning but still leave horrible code. There
should really be some way to move the sleeping operation outside of the
spinlock.

>From a brief look at the code, I think the sequence could be converted
from

lock();
suspend();
sleep();
clock_disable();
unlock();

to

lock();
again:
suspend();
unlock();
sleep();
lock();
if (!suspended())
   goto again;
clock_disable();
unlock();

	Arnd
