Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYI3JJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYI3JJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYI3JJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:09:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYI3JJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:09:33 -0400
Message-ID: <48E1EC90.9010301@redhat.com>
Date: Tue, 30 Sep 2008 12:08:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ioctl: generic ioctl dispatcher
References: <1222530242-1272-1-git-send-email-avi@redhat.com>	<1222530242-1272-2-git-send-email-avi@redhat.com> <87od26q3d8.fsf@basil.nowhere.org>
In-Reply-To: <87od26q3d8.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity <avi@redhat.com> writes:
>
>   
>> +long dispatch_ioctl(struct inode *inode, struct file *filp,
>> +		    unsigned cmd, unsigned long arg,
>> +		    const struct ioctl_handler *handlers,
>> +		    long (*fallback)(const struct ioctl_arg *arg))
>>     
>
> The basic idea is good, but i don't like the proliferation of callbacks,
> which tends to make complicated code and is ugly for simple code
> (which a lot of ioctls are)
>
>   

If the simple calls mostly don't use the argument as a pointer, they are 
better off using a plain switch.  For my own code, I usually leave the 
boilerplate within the switch and the app-specific code in a separate 
function anyway, so there's no big change in style.

The main motivation here was the extensibility (patch 2), which becomes 
much more difficult with a switch.

> How about you make it return an number that can index a switch() instead?
> Then everything could be still kept in the same function.
>
>   

We need to execute code both before and after the handler, so it would 
look pretty ugly:

long my_ioctl_handler(...)
{
    struct ioctl_arg iarg;
    ...
    long ret;

    ret = dispatch_ioctl_begin(&iarg, ...);
    if (ret < 0)
        return ret;
    switch (ret) {
          case _IOC_KEY(MY_IOCTL):
               // your stuff goes here
               break;
          ...
    }
    dispatch_ioctl_end(&iarg, ret);
    return ret;
}

The only clean way to do this without callbacks is with 
constructors/destructors, but we don't have those in C.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

