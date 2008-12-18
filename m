Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752244AbYLRI0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbYLRI0M (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYLRIZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:25:53 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51561 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYLRIZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i8aRoQ9/Xd+/Q+JnCuUBF5o6OwN+U7uQ7pFxaSAStpeQbcRkTay2Rv1H0JyIPAP6iN
         RHw5TwjJhMsmPH5mai3OEQ+e7iox+04M3SNKwcLCYmfcDz4iheumeLQ36hMIzN2DPH1l
         6kFfBGdXzMqJtRKafzQDl/SbqoCaFUiTlaflE=
Message-ID: <494A090A.30107@panasas.com>
Date: Thu, 18 Dec 2008 10:25:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        v4l <video4linux-list@redhat.com>,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] cdev_put() race condition
References: <200812082156.26522.hverkuil@xs4all.nl> <200812171607.41713.hverkuil@xs4all.nl> <49492437.7020105@panasas.com> <200812171833.39735.hverkuil@xs4all.nl>
In-Reply-To: <200812171833.39735.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil wrote:
>>>>> delayin
>>>>> delayout
>>>>> delayout
>> OK Now I do not understand something. How is the double release possible?
>> I guess it is something to do with the complicated chrdev_open() in its
>> inode->i_cdev == NULL case. But still isn't the kref inside kobject
>> suppose to protect me from exactly that?
> 
> Only if there is also proper locking to prevent a kref_get from being called 
> when the release of a kref_put is in progress. And that's missing in cdev.
> 
> Typical scenario: a USB device is disconnected, the driver sees that no 
> applications are using it, then it calls cdev_del. This calls cdev_put, the 
> cdev's refcount goes to 0 and it will call release. BUT, at this moment an 
> application can open the device *again* and chrdev_open() will reuse the 
> i_cdev pointer and call cdev_get(p) on it, and this increases the refcount 
> from 0 to 1 again. And later it calls cdev_put again and release is called 
> a second time.

OK I see. 

> 
>>>>> Note the duplicate 'delayin' messages. Also note that the cdev struct
>>>>> was allocated by sg.c, so the second cdev cleanup will likely poke
>>>>> into already freed memory.
>>>>>

>> I had a similar problem and solved it in a way that I think should be
>> safe. I'll try and run your tests to make sure. Here is a short
>> description of my solution:
>>
>> MyDevice {
>>    ...
>>    embed_cdev;
>>    embed_kref;
>>    ...
>> };
>>
>> OnHotPlug() {
>> 	...
>> 	kref_init(embed_kref); // kref==1
>> 	cdev_add(embed_cdev);  // cdev==1
>> 	get_(embed_cdev);      // cdev++==2
>> }
>>
>> OnFileOpen() { // kernel does // cdev++==n > 2
>> 	kref_get(embed_kref); // kref++==n > 1
>> }
>>
>> OnFileClose() {
>> 	kref_put(embed_kref, __release); // kref++==n >= 0
>> } // kernel does // cdev--==n >= 1
>>
>> OnHotRemove() {
>> 	cdev_del(embed_cdev);  // cdev--==1
>> 	kref_put(embed_kref, __release); // kref--==n >= 0
>> }
>>
>> __release() { // by definition kref==0
>> 	put_(embed_cdev);      // cdev--==0
>> }
>>
>> What do you think?
> 
> This won't help either. __release calls cdev_put, the cdev refcount goes to 
> 0, the cdev release is called, but at this time someone can open the device 
> again. Refcounting in the driver simply won't help since chrdev_open is 
> always called before the driver has a chance to check anything.
> 

No, But at this point cdev_del has already been called before the final put,
so if a chrdev_open is called while in cdev_release it will not find my
device anymore. I have separated the unmapping of the device from it's final put.

> In addition, I think it is nuts to introduce a kref that just shadows the 
> cdev's kref. We should be able to rely on cdev for this.
> 

I agree, that's why I like Tejun's patch because in theory we can get
rid of the shadow kref. (Without a layering violation)

> I expect that when you test your driver with this you should hit the same 
> race condition. Remember that you need to mknod the device. If you rely on 
> udev then this will never happen because udev has removed the device node 
> before cdev_del is called. (At least, I think that is always true. I'm no 
> expert on this.)
> 

OK I see, I do use udev in all my fedora images. I will try to disable it
and test. So far I was unable to reproduce the problem with my device.

>> BTW sg does not use kref and I suspect it might be racy by its own.
> 
> It might, but it has nothing to do with this bug.
> 
> Regards,
> 
> 	Hans
> 

Thanks
Boaz
