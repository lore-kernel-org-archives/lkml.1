Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXKIQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXKIQGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762830AbXKIQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:06:30 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56832 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbXKIQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:06:29 -0500
Subject: Re: Module init call vs symbols exporting race?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <200711081310.07697.rusty@rustcorp.com.au>
References: <473031FA.2060707@openvz.org>
	 <200711062341.34566.rusty@rustcorp.com.au>
	 <1194429690.6874.7.camel@localhost.localdomain>
	 <200711081310.07697.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 16:06:12 +0000
Message-Id: <1194624372.5000.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-08 at 13:10 +1100, Rusty Russell wrote:
> On Wednesday 07 November 2007 21:01:30 Jan Glauber wrote:
> > Hi Rusty,
> >
> > I've seen a symbol-resolving race on s390. The qeth module uses symbols
> > from qdio and although the loading order seems correct and the qdio
> > symbols should be available the following error appears:
> >
> > qdio: loading QDIO base support version 2
> > qeth: Unknown symbol qdio_synchronize
> 
> Looks like qdio does something which triggers qeth to load, but of course qdio 
> isn't finished initializing yet so its symbols aren't available.
> 
> It's not obvious what's triggering the load, but you could probably find it by 
> using printk's through qdio.c's init_QDIO().

Digging through the module loader I found what triggers the error...

CPU0 (sys_init_module for qdio)			CPU1 (sys_init_module for qeth)

mutex_lock()
-> load_module()
     mod->state = COMING
mutex_unlock()
						mutex_lock()
init().......takes some time			load_module()
						-> resolve_symbols()
						   -> use_module()
						      -> stong_try_module_get() bails out
							 because state == COMING
						-> simplify_symbols() complains with the warning

mutex_lock()
mod->state = LIVE
mutex_unlock()

So is it correct that sys_init_module() is called for qeth even if qdio is
not yet in MODULE_STATE_LIVE?

-jang

