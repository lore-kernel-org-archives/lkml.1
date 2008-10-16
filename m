Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYJPKBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYJPKBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYJPKBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:01:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38477 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYJPKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Mfyzd/3dRz6Zq4afVpz/lgNw1A49Zid9qaNUMnc3K6+oKQNzX4gRTM18d7NymU29XQ
         SNcdTnsGTrovRz6Zp4t7867HhkmpBgVImAyAoIWvXw6C/5dwsbvky1AybKcyHNJ+BJ8K
         4RFrEKeGZrV6uVkUVoQNnNHL+2kYDJG8TNFEc=
Message-ID: <48F710F7.9030608@tuffmail.co.uk>
Date: Thu, 16 Oct 2008 11:01:27 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo
 stress test
References: <gbiduj$9p3$1@ger.gmane.org> <200810152017.47347.laurent.pinchart@skynet.be> <48F63C4E.3070103@tuffmail.co.uk> <200810152319.17925.laurent.pinchart@skynet.be>
In-Reply-To: <200810152319.17925.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Alan,
>
> On Wednesday 15 October 2008, Alan Jenkins wrote:
>   
>> Laurent Pinchart wrote:
>>     
>>> On Wednesday 15 October 2008, Alan Jenkins wrote:
>>>       
>>>> If you look at the trace, it happens as "hald-probe-video" opens the
>>>> video device.  This is from Ubuntu 8.04.  Possibly it's significant that
>>>> I use the camera first, to make sure it works (I use Kopete, the
>>>> settings dialogue includes a video test).
>>>>         
>>> The NULL pointer (or rather 0x00000030 pointer) dereference happens in
>>> video_open:
>>>
>>>         file->f_op = fops_get(vfl->fops);
>>>         if (file->f_op->open)
>>>                 err = file->f_op->open(inode, file);
>>>
>>> file->f_op ends up being NULL. Either vfl->fops is NULL to begin with, or
>>> fops_get failed to get a reference to the file_operations structure.
>>>
>>> I'd be surprised if vfl->fops was NULL. To rule out that case, can you
>>> add a BUG_ON(vfl->fops == NULL) before the call to fops_get ?
>>>
>>> I'm not too familiar with the module loader, but a quick look at the code
>>> shows that the module could be marked as being unloaded
>>> (MODULE_STATE_GOING) before its exit function is called. If this is the
>>> case video_open would still be called, as the video device would still be
>>> registered, but fops_get would fail in try_module_get and return a NULL
>>> pointer. It seems the pointer returned by fops_get should be tested in
>>> video_open.
>>>
>>> I've CC'ed the v4l maintainer to get his opinion on this.
>>>       
>> I put one before and one after
>>
>> 134    BUG_ON(vfl->fops == NULL);
>> 135    file->f_op = fops_get(vfl->fops);
>> 136    BUG_ON(file->f_op == NULL);
>>
>> and the second one triggered
>>     
>
> This confirms my suspicion. Could you please try the attached patch ?
>   

Yup, that seems to fix it.

I wonder if there are more instances of this error in other subsystems.

Ta
Alan
