Return-Path: <linux-kernel-owner+w=401wt.eu-S1422754AbXDRJz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754AbXDRJz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXDRJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:55:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:38473 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422754AbXDRJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HED3vnEpId7VTLcwGNkPTrVET9sQdIO4RgraY/9BuQON7PAEQKXq4g+31JFq1FAxE3bC4ym31T1vWln/ScErU06ylirI9DrKJE9tSSvtQ4hbRywQht0Td7vyR/wv4c2/VVo70nTeVt/gw/GQ8yih7Dy+Vnfq0OC1mnmukBWIzVM=
Message-ID: <4625EB20.5000306@gmail.com>
Date: Wed, 18 Apr 2007 18:55:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>	<20070417184110.GJ10619@htj.dyndns.org>	<4625169D.9020301@gmail.com>	<20070418101117.73edb302@gondolin.boeblingen.de.ibm.com>	<4625DAD1.2070000@gmail.com> <20070418113506.06df2d21@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070418113506.06df2d21@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Apr 2007 17:46:09 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> It's debatable but I think things will be safer this way.  If we wait by
>> default, we are forced to check that all references are dropped and will
>> have a stack dump indicating which object is causing problem when
>> something goes wrong, which is better than silent object leaking and/or
>> jumping to non-existent address way later.
> 
> I agree that oopsing is bad. However, lingering references are not
> always coding errors. What if it will just take long for a reference to
> be given up? You'd have a hanging device_unregister(), with no
> particular gain.

It's more like future plan than immediately applicable.  I think most 
high-level driver related interfaces can be converted as sysfs was 
converted such that they disconnect immediately from the device - 
resolving conflicts between higher layer using reference counts and 
device driver layer which expects immediate disconnect is responsibility 
of those interfaces - just as sysfs does it.

If you have lingering reference to struct device after driver is 
detached, you're already screwed.  If there's outstanding reference to 
it from the previous driver, how are you gonna load the next one? 
You're gonna have to wait somewhere for all the references to go away. 
Actually, your patch series is doing exactly this during module 
unloading.  Problem is that you'll need to do the same thing before 
attaching the next driver for the same device.

Immediate-disconnect from all higher interface for device drivers is my 
goal for driver model as I wrote in the RFD about lifetime rules.  I 
think it's doable and should result in easier model to get right, but I 
might be missing something big time, so please point out if you can spot 
holes or don't agree.

>> I personally think all driver interface should be made this way such
>> that completion of unregister function guarantees no further access to
>> the object or module.  IMHO, it's more intuitive and easier to force
>> correctness.
> 
> If we really did this, we should also provide a non-waiting alternative.

For transitional purpose, sure.  In the long term, I think it's better 
if we can do without it.

Thanks.

-- 
tejun
