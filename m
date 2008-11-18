Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYKRNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYKRNoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYKRNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:44:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:6101 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYKRNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=ZEA3ZZ+dKi+mBomGnL1iDWOIkN2CT4rJ84sas1qxNnuXdDIRph5n6LWIZUWrgFsNlR
         CGnVmltMVbdO+xvDl3AuIJo3XNpNJlL/XjJVggUZN16MbLf5h86e/hJABdFG7BEcEF6c
         gl4X71MXoqzcHE0l/zmfqHk48SRFyD331fqEU=
Message-ID: <4922C6BB.5020203@panasas.com>
Date: Tue, 18 Nov 2008 15:44:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org> <49221D23.8040904@kernel.org>
In-Reply-To: <49221D23.8040904@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> (lkml was missing, adding it back and quoting whole body for reference)
> 
> Tejun Heo wrote:
>> Greg KH wrote:
>>> On Mon, Nov 17, 2008 at 06:18:45PM +0900, Tejun Heo wrote:
>>>> (this is a private message)
>>>>
>>>> PING.  :-)
>>> Heh.
>>>
>>> I've lost this out of my tree, as I didn't know you still wanted this
>>> applied.  If you need it for your char-fuse code, then I don't have an
>>> objection to it, and you can take it through your tree.
>>>
>>> Or do you want me to take it through mine?
>>>
>>> Your choice :)
>> I'll push it through Miklos' tree w/ your ACK then.
>>
>> Thanks.  :-)
>>
> 
> 

Tejun Hi.

I just saw this thread for the first time and it left me confused.
What was the final verdict. Is this patch going in at the end?
Which incarnation of it? is there a public git tree I can try?

The reason I ask is because I have just the same principal work in one of
my test trees. What I have is a Filesystem, osdfs, that is mounted
on an OSD scsi-device, which is a char-device. Now the osdfs when mounting
an OSD device does not use __open, like user mode it needs some kernel
reference counting to keep the char-device up. On the other hand
the actual teardown and unmap of the char-device is done from the scsi-ml
remove vector. So just like in sd, sr and other scsi ULDs I need to unmap
the device but keep the memory allocated and available until the last reference.
All this is usually done using the Release() of the block-device. But for me
I only have a char-device. Currently what I had to do is keep another kref
to govern the device's lifecycle and sync every thing together. A Release() at
the char-dev would let me reuse what's there and let me clean all that code up.

While Investigating the problem and compering what was done on the block-device
side, I've seen more then a few places that private reference counting could be
dropped completely, and the char-dev could be used. Off my head some of these places
are: 
	- UBI used by UBIFS 
	- sg.c which does not have a Kernel user but needs it's char device until
	  scsi-Remove and/or __close()

and other places as well.

Thanks for doing this
Boaz
