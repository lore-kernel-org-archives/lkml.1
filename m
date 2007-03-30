Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXC3N6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXC3N6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXC3N6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:58:48 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:4461 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXC3N6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=W9rVM65zjZ9bMdyvieN+bryBx/+7Xbzxn0nbWTo6gBncvvodawTbuqRjmxvbvmFWcHnED+6lHQpbtC77ZbCytildcM+L+XyaDW0afoUmnMbTBF+XFS0d6+Y5zXRMOPgBVQgl22ep9DNQyTjYGAzXQXI1fEBChicoS5sh+WEbkWw=
Message-ID: <460D178F.4000500@gmail.com>
Date: Fri, 30 Mar 2007 22:58:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <460CDBA6.5030608@gmail.com>	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>	<460D0E78.3040200@gmail.com> <20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Fri, 30 Mar 2007 22:19:52 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>>> Shouldn't getting/putting the module refcount be solely done in
>>> kobject.c? Grab the module reference when the kobject is created and
>>> release the module reference in kobject_cleanup() after the release
>>> function has been called. This doesn't make kobject_get() heavier, and
>>> it ensures we don't delete the module until after the last kobject it is
>>> supposed to clean up has been released.
>> If we do that, we wouldn't be able to unload a module if there is any
>> kobject referencing it even when the node has no openers, so no easy way
>> out there.  :-(
> 
> But we must not unload the module when there is still a kobject around
> referencing a release function in the module, or we will oops if the
> kobject is finally released. If needed, the module must clean up its
> kobjects in its exit function.

It's a little bit more convoluted than that.  Module reference count of
zero doesn't indicate that there is no one referencing the module.  It
just means that the module can be unloaded.  ie. There still can be any
number of kobjects with release function backed by the module but as
long as all of them can be deleted and released by module exit function,
the module is unloadable at that point.

IOW, module reference count does not count number of objects depending
on the module.  It counts the number of active usages of those objects.

-- 
tejun
