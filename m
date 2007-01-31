Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbXAaOsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbXAaOsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbXAaOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:48:16 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:51865 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933301AbXAaOsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:48:15 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <601753fa5bab1585521hc0qm0003olph@thunder.lp0.eu>
Subject: Re: [PATCH 1/3] usbatm: Allow sub-drivers to handle calls to atm_proc_read.
Date: Wed, 31 Jan 2007 15:48:12 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45BFB6F1.2070303@simon.arlott.org.uk>
In-Reply-To: <45BFB6F1.2070303@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311548.13076.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> usbatm only outputs basic information via the per-device /proc/net/atm/ file,
> this patch allows the device specific USB ATM drivers to replace the
> atm_proc_read function with their own.  

I'm still meditating on this.  The reason I didn't do this originally is
because of potential problems with modem disconnection and/or module
unloading (the cxacru module can be unloaded at any time - it's the usbatm
module that can't be unloaded when a connection is open - so you've got to
be careful that no-one can call into cxacru after or while it's being
destroyed).  I think it will be OK as long as usbatm calls unbind after
shutting down the ATM layer (since otherwise your read method could be
called after you've freed your cxacru private data) which is not the case
right now, but should be easy to arrange.  Horrible things may happen
if proc_read can still be running after atm_dev_deregister has returned,
but, if so, horrible things can already happen right now.  I don't understand
why this is impossible; maybe it is possible.  The worst that will happen
(given that none of the proc_read methods sleeps) is that freed memory will
be accessed and the contents spat out in the proc file (if proc_read sleeps,
that could result in trying to run code inside a destroyed module).

Ciao,

Duncan.
