Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXJWWEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXJWWEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJWWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:03:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:44814 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXJWWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GaUZkW53VCUFW6mngXE77UVJ7cyWLMjUl7JMTMAAR3eYxF+qy5E6Qns977UtQVx3ZSc3QI6etjmMxFUxbfMJiKHHBDb7ZOP70ZOo/beVVxUuTFE1AhYdT56X81DH3dqvdCnbpcDUWYtV1BN3j0RjfJrASYtM9UC/zJVVg1/o6kU=
Message-ID: <471E6FC5.6070301@gmail.com>
Date: Tue, 23 Oct 2007 18:03:49 -0400
From: emist <emistz@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Linux <linux-kernel@vger.kernel.org>, cornelia.huck@de.ibm.com
Subject: Re: [PATCH] Bug fix for the s390 dcssblk driver
References: <200710201451.57138.elendil@planet.nl>	 <471A39D2.1070303@gmail.com> <20071021100926.GA4420@osiris.ibm.com>	 <471C1D29.5020403@gmail.com>	 <20071022133723.089b84db@gondolin.boeblingen.de.ibm.com> <1193145774.5325.27.camel@localhost.localdomain>
In-Reply-To: <1193145774.5325.27.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerald Schaefer wrote:
> On Mon, 2007-10-22 at 13:37 +0200, Cornelia Huck wrote:
>> On Sun, 21 Oct 2007 23:46:49 -0400,
>> emist <emistz@gmail.com> wrote:
>>
>>> # This patch fixes a memory corruption bug in the s390 dcssblk driver.
>>> # The bug occurs when an attempt to change the type of a segment
>>> # returns an error. At this point the driver tries to remove the segment in
>>> # question while some of the device's attributes are in use. This causes the
>>> # driver to hang.
>> Hm, seems we missed another of those device attributes exhibiting
>> suicidal tendencies...
>>
>> Tejun has a patchset allowing device attributes to commit suicide (see
>> http://marc.info/?l=linux-kernel&m=119027371416452&w=2), although I'm
>> not sure what its current status is. Until then, you would need to use
>> device_schedule_callback() to commit suicide.
>>
>> This all of course only applies if killing the segment is better than
>> leaving it in its current state, but others can make a better judgement
>> on that :)
> 
> Hi,
> 
> thanks for reporting this bug, seems like we forgot to consider the
> suicidal behavior of this driver when the device_unregister() stuff was
> changed.
> 
> The best solution for now would be to use the scheduled callback
> function, like Cornelia described. If segment_modify_shared() should
> fail, the DCSS segment will be unloaded. Calling the function again
> with the old "shared" flag will not help because it will not reload
> the segment. So we need to remove/unregister the device in this error
> path, and for now this should be done with device_schedule_callback().
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
> 
>  dcssblk.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.23/drivers/s390/block/dcssblk.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/s390/block/dcssblk.c
> +++ linux-2.6.23/drivers/s390/block/dcssblk.c
> @@ -193,6 +193,12 @@ dcssblk_segment_warn(int rc, char* seg_n
>         }
>  }
> 
> +static void dcssblk_unregister_callback(struct device *dev)
> +{
> +       device_unregister(dev);
> +       put_device(dev);
> +}
> +
>  /*
>   * device attribute for switching shared/nonshared (exclusive)
>   * operation (show + store)
> @@ -276,8 +282,7 @@ removeseg:
>         blk_cleanup_queue(dev_info->dcssblk_queue);
>         dev_info->gd->queue = NULL;
>         put_disk(dev_info->gd);
> -       device_unregister(dev);
> -       put_device(dev);
> +       rc = device_schedule_callback(dev, dcssblk_unregister_callback);
>  out:
>         up_write(&dcssblk_devices_sem);
>         return rc;
> 
> 
Hey,

That makes sense. I no longer have access to an s390 system so I will
not be able to provide a tested patch for this bug. I will however
attempt to fix this issue and submit a patch using the scheduled
callback function and maybe someone could make sure that it works properly.

Have a good one,

Igor H.
