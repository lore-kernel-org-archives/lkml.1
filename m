Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXC3Ouv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXC3Ouv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXC3Ouv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:50:51 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7262 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXC3Out (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:50:49 -0400
Date: Fri, 30 Mar 2007 16:52:51 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <460D178F.4000500@gmail.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
	<460D178F.4000500@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 22:58:39 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> It's a little bit more convoluted than that.  Module reference count of
> zero doesn't indicate that there is no one referencing the module.  It
> just means that the module can be unloaded.  ie. There still can be any
> number of kobjects with release function backed by the module but as
> long as all of them can be deleted and released by module exit function,
> the module is unloadable at that point.
> 
> IOW, module reference count does not count number of objects depending
> on the module.  It counts the number of active usages of those objects.

We must make sure that the module is never deleted while there may be
calls to ->release functions - the exit function can only return when
all ->release calls have returned. This can be guaranteed if we (1)
don't allow the module to unload if there are outstanding kobjects (we
may need a "self destruct" knob then) or (2) make sure the ->release
functions are outside of the module (see, for example,
drivers/s390/s390_rdev.c).

(Gah, that stuff is always giving me headaches. Sorry if I'm not making
sense...)
