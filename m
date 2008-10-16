Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYJPMWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYJPMWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYJPMWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:22:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:2047 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYJPMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=adWiPmTIfhkIBgwVRe4LSLe+R9sl4iZPX6mzcQw0IcSc1f5wol9d/ttFQjE5csp4Pl
         PN0rlNuBbMrN5Y1tkTLlHJ1yMhNnWQnV4haAXmRxTiiFvjO/TctxjxhEJ/6+mMeqw4O0
         pG5UlpBHLTSL9LNx47+jHEyfUcHmDsuK+3XNk=
Message-ID: <48F73200.10903@tuffmail.co.uk>
Date: Thu, 16 Oct 2008 13:22:24 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo
 stress test
References: <gbiduj$9p3$1@ger.gmane.org> <200810152319.17925.laurent.pinchart@skynet.be> <48F710F7.9030608@tuffmail.co.uk> <200810161403.49267.laurent.pinchart@skynet.be>
In-Reply-To: <200810161403.49267.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Alan,
>
> On Thursday 16 October 2008, Alan Jenkins wrote:
>   
>> Laurent Pinchart wrote:
>>     
>>> On Wednesday 15 October 2008, Alan Jenkins wrote:
>>>       
>>>> Laurent Pinchart wrote:
>>>>         
>>>>> On Wednesday 15 October 2008, Alan Jenkins wrote:
>>>>>           
>>>>>> If you look at the trace, it happens as "hald-probe-video" opens the
>>>>>> video device.  This is from Ubuntu 8.04.  Possibly it's significant
>>>>>> that I use the camera first, to make sure it works (I use Kopete, the
>>>>>> settings dialogue includes a video test).
>>>>>>             
>>>>> The NULL pointer (or rather 0x00000030 pointer) dereference happens in
>>>>> video_open:
>>>>>
>>>>>         file->f_op = fops_get(vfl->fops);
>>>>>         if (file->f_op->open)
>>>>>                 err = file->f_op->open(inode, file);
>>>>>
>>>>> file->f_op ends up being NULL. Either vfl->fops is NULL to begin with,
>>>>> or fops_get failed to get a reference to the file_operations structure.
>>>>>
>>>>> I'd be surprised if vfl->fops was NULL. To rule out that case, can you
>>>>> add a BUG_ON(vfl->fops == NULL) before the call to fops_get ?
>>>>>
>>>>> I'm not too familiar with the module loader, but a quick look at the
>>>>> code shows that the module could be marked as being unloaded
>>>>> (MODULE_STATE_GOING) before its exit function is called. If this is the
>>>>> case video_open would still be called, as the video device would still
>>>>> be registered, but fops_get would fail in try_module_get and return a
>>>>> NULL pointer. It seems the pointer returned by fops_get should be
>>>>> tested in video_open.
>>>>>
>>>>> I've CC'ed the v4l maintainer to get his opinion on this.
>>>>>           
>>>> I put one before and one after
>>>>
>>>> 134    BUG_ON(vfl->fops == NULL);
>>>> 135    file->f_op = fops_get(vfl->fops);
>>>> 136    BUG_ON(file->f_op == NULL);
>>>>
>>>> and the second one triggered
>>>>         
>>> This confirms my suspicion. Could you please try the attached patch ?
>>>       
>> Yup, that seems to fix it.
>>     
>
> Great.
>
>   
>> I wonder if there are more instances of this error in other subsystems.
>>     
>
> From a quick grep it seems the following subsystems are affected:
>
> drivers/media/video
> drivers/media/video/dvb/dvb-core
> drivers/gpu/drm
> sound/core
>
> Unless the issue is critical and should be fixed before 2.6.28, 
> drivers/media/video won't matter as the v4l core has already been moved to 
> the cdev API in the kernel tree, removing the offending code.
>
> Will you submit patches for the other three subsystems or would you like me to 
> take care of that ?
>   

I need to start concentrating on project work.  Feel free to take all
the hard work^W^W patch credits :).

It's not critical to me.  This only happens in the stress test because
it unloads the module "too soon" after loading it, while HAL tries to
open the new device.

It's a completely artificial test.  I ran it to see what happens with
input devices - the device numbers don't seem to be reallocated like
e.g. usb storage devices.  Continually reloading the uvcvideo driver
means the number assigned to input device increments each time, and you
get "input67" and so on.  I haven't worked out whether this is a bug
though.  For all I know the numbers are reused eventually, once they've
run through the entire device minor space.

Alan
