Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbXGKFE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbXGKFE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbXGKFEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:04:50 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:49372 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXGKFEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HLbF29mCG2uwfCVlEkpbQzSdviWlyZrdwayEvOkdCu+ubB0tFdXbwl0hfoeBKIlCAZ/gYiTE05XWXCaYXH5gIfCb770ru5DePSFhsnDJw5Wx6MP9iVARKmkXEHIBUP2S8fLDwVYBdax1rc5Lf4lN0oIBQxPgoNhl4axovmUprJg=
Message-ID: <469464EC.7030502@gmail.com>
Date: Wed, 11 Jul 2007 14:04:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707101459580.2556-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707101459580.2556-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>> Please also note that currently dev->sem does not protect against adding
>> children.  It says it does in the comment on the definition of the field
>> but it's never acquired during device_add().
> 
> That's why we need the rwsem.

Alright, there's our confusion.  I thought you were gonna use dev->sem
to protect new device addition && driver binding.  We can use the same
rwsem directly for binding protection too but I guess there's no big
difference one way or the other.

>> Yeah, I'm all for centralizing things.  I just didn't see what could be
>> simplified in LLDs by freezing sysfs access.  Can you point me to any
>> example node which can benefit from such thing?
> 
> For USB devices, writes to the /sys/.../bConfigurationValue node will
> call usb_set_configuration(), which registers child devices.  We don't
> want these calls to fail because a suspend is underway, since suspends 
> are supposed to be transparent to userspace.  So they need to block 
> until the suspend is over.
> 
> Access (either read or write) to any sysfs node which actually touches 
> the device hardware will fail while the device is suspended.  Again, 
> for transparency such accesses should block.

Thanks for enlightening me.  Probably what can be done is blocking
regular file sysfs nodes automatically and make it optional (optionally
enable or disable) for bin attrs.

>>> Using a freezable workqueue for the callbacks would also localize the 
>>> suspend handling.
>> But the freezable workqueue thing isn't really necessary if any of the
>> discussed solutions is implemented, right?
> 
> It isn't necessary if the callbacks aren't needed (i.e., if we give
> methods a way to unregister their attribute directly).  But if we do
> keep the callbacks, then for safety's sake their workqueue should be
> freezable.

I see.  Let's see how the direct suicide thing works out.

Thanks.

-- 
tejun
