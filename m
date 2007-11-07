Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXKGKBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXKGKBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 05:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXKGKBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 05:01:45 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3605 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXKGKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:01:44 -0500
Subject: Re: Module init call vs symbols exporting race?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200711062341.34566.rusty@rustcorp.com.au>
References: <473031FA.2060707@openvz.org>
	 <200711062341.34566.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 10:01:30 +0000
Message-Id: <1194429690.6874.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I've seen a symbol-resolving race on s390. The qeth module uses symbols
from qdio and although the loading order seems correct and the qdio
symbols should be available the following error appears:

qdio: loading QDIO base support version 2
qeth: Unknown symbol qdio_synchronize
qeth: Unknown symbol do_QDIO
qeth: Unknown symbol qdio_initialize
qeth: Unknown symbol qdio_cleanup
qeth: Unknown symbol qdio_activate
qeth: Unknown symbol qdio_synchronize
qeth: Unknown symbol do_QDIO
qeth: Unknown symbol qdio_initialize
qeth: Unknown symbol qdio_cleanup
qeth: Unknown symbol qdio_activate
qeth: loading qeth S/390 OSA-Express driver
qeth: Device 0.0.f5f0/0.0.f5f1/0.0.f5f2 is a OSD Express card (level: 087a) with link type OSD_1000 (portname: OSAPORT)
qeth: Hardware IP fragmentation not supported on eth0
qeth: VLAN enabled 
qeth: Multicast enabled
qeth: IPV6 enabled 
qeth: Broadcast enabled 
qeth: Using SW checksumming on eth0.
qeth: Outbound TSO enabled

After that both drivers work fine but I'm curious why this happens.
Cheers,
Jan


On Tue, 2007-11-06 at 23:41 +1100, Rusty Russell wrote:
> On Tuesday 06 November 2007 20:20:58 Pavel Emelyanov wrote:
> > Hi.
> >
> > I looked at the sys_init_module() and found that the ->init callback
> > for the module is called without the module_mutex held and *after*
> > the module's symbols are exported. Doesn't this create the race when
> > loading two modules in parallel? Like this.
> 
> Hi Pavel,
> 
> 	In a word, no.  See "strong_try_module_get()".
> 
> Cheers,
> Rusty.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

