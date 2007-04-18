Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXDRIqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXDRIqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXDRIqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:46:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:35510 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030521AbXDRIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uUIL/JeTJ3JF4nVq+Ipz+LnOGgH06T7ZmShyHEI5vhv+5zcu2D/eBs+H1ck3VMcRFcAoVJYOJaDeTf+dBu+uZyRq1C0/l18ohFILhAqlCB7r/Z8ioZbRLth0zI9rqZvXDFCkvPdbxKFkSfmCJG9VP/x+CTgy6xWQdOj/9qYM3O0=
Message-ID: <4625DAD1.2070000@gmail.com>
Date: Wed, 18 Apr 2007 17:46:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>	<20070417184110.GJ10619@htj.dyndns.org>	<4625169D.9020301@gmail.com> <20070418101117.73edb302@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070418101117.73edb302@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Apr 2007 03:49:01 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Oh, one more thing, with proper code audit, we can just make
>> device_unregister() do the waiting instead of adding separate
>> device_unregister_wait().  I think that will be a good step toward
>> immediate-detach driver model.
> 
> Do we really want that? If the release function doesn't sit in the
> module, or if the device_unregister() is done for other reasons in a
> non-module, we don't care about lingering references. There's no need
> to wait (and possibly lock up) there.

It's debatable but I think things will be safer this way.  If we wait by
default, we are forced to check that all references are dropped and will
have a stack dump indicating which object is causing problem when
something goes wrong, which is better than silent object leaking and/or
jumping to non-existent address way later.

I personally think all driver interface should be made this way such
that completion of unregister function guarantees no further access to
the object or module.  IMHO, it's more intuitive and easier to force
correctness.

I'm not sure about kobject_put() but device_unregister() waiting for
release doesn't sound bad to me.

-- 
tejun
