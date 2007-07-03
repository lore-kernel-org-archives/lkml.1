Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXGCLtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXGCLtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXGCLtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:49:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:55737 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbXGCLtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:49:39 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707031307.41366.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707030944.18702.oliver@neukum.org>
	 <E1I5fug-0003ZS-00@dorka.pomaz.szeredi.hu>
	 <200707031307.41366.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 21:44:13 +1000
Message-Id: <1183463053.10386.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem is not with fuse. The problem is generic in nature.
> 
> If you remove the freezer, user space remains active until the last CPU
> goes into suspend. It can do syscalls. Or do you know a clean way to exempt
> only the tasks fuse might use?
>
> Now device drivers have a guaranteed temporal sequence:
> 
> last io -> suspend() -> resume() [or disconnect()] -> new io

No, that's always been bullshit. You can have IOs emitted by kernel
threads (think knfsd, and that's just one among many others). Beside,
relying on having userland frozen means that your driver will be unable
to be "live" suspended/resumed for more ambitious dynamic power
management schemes.

So it's always been wrong, imho, to rely on that. I've had powermac STR
work fine without the freezer for years, and few drivers have been a
problem, and we just fixed them.

The freezer thingy, at best, hides problems, causing them not to be
fixed.

> This is because suspend() is called after the freezer goes into action. If
> you remove the freezer, you need to deal with
> 
> 1. io to suspended devices
> 2. resume() assuming that the device is in the state suspend() left it
> 3. io changing a device's state while suspend is saving it
> 
> and you need to fix this for all device drivers, not just those fuse is
> involved with. Removing the freezer means doing a more or less full
> audit of every driver and additional locking in many drivers.

Yes, more or less.

The good news is that a whole lot of drivers don't really care much, and
in some cases, things can be done trivially with a bit of help from the
upper layers. But yeah, as I've been explaining over and over again, the
lazy approach here doesn't work.

Ben.


