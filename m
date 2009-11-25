Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbZKYO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbZKYO2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbZKYO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:28:16 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44701 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456AbZKYO2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XcSXOIhrrk1/wBEkkdGdMeRQDeTr22O+JOP5ouLI15tRMOCZmuunsBEaWpsJnbBuFm
         pNyvPvqYc5QZX/4Zmbtt9Xp4vizfR1aDiccF3Yd0X8X53/4eZLbTT2eTeaMUgqH2Z2ui
         1DddgJUKDn+StOLIPAESWC4yU5fpjyePgctHs=
MIME-Version: 1.0
In-Reply-To: <20091125123534.GA17486@suse.de>
References: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com> 
	<20091125123534.GA17486@suse.de>
From: eran liberty <eran.liberty@gmail.com>
Date: Wed, 25 Nov 2009 16:27:59 +0200
Message-ID: <ffc2b1d40911250627q6c7e459v89a580d793b24fcf@mail.gmail.com>
Subject: Re: kobjects: mark cleaned up kobjects as unitialized
To: Greg KH <gregkh@suse.de>
Cc: balajirrao@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Nov 25, 2009 at 2:35 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Nov 25, 2009 at 11:27:58AM +0200, eran liberty wrote:
>> Hi Greg & Balaji,
>>
>> After diving into the LDKM and failed to spot the point where you
>> actually un-initialize the 'state_initialized' of a kobject... and
>> since I have statically allocated object which trip over this very
>> same trap...
>
> Ah, there's your problem, don't statically allocate a kobject.  Fix that
> and your issue goes away, right?

right... but... I want to :).

Is there a Linux directive saying 'thus shall not statically allocate
(or reuse in any other way) kobjects"?

>
>> Google-ing for others who fell into this trap, I found your thread/patch at:
>> http://lkml.org/lkml/2008/3/8/155
>> and
>> http://lkml.indiana.edu/hypermail/linux/kernel/0902.0/01969.html
>>
>> I noticed this patch did not make it into the mainline.
>>
>> Is this patch still valid?

Why was your proposed patch not merged?
Is there some logic behind not having it?

>> Is there some other, better way to do it by the book?
>
> Do not statically allocate a kobject.
>
>> Right now I by-pass the problem by memset-ing the whole object after I
>> release it... but I feel this is a bit brutal.

Assuming I will keep it static and clear the status_initialize bit (by
memset-ing the whole object) after the kobject was released... am I
doing something wrong? should i expect other bad phenomena?

>
> You should be freeing your memory in your release function.
>
Should I free the object itself in release() function?
In OO-like thinking I would expect release() to be a cleanup function
for the device to be used, while the kfree() be done by the same
object which did the kmalloc()

> Do you have a pointer to your code somewhere?
>

I will pack something and send you (i dont think Mr. vger will
tolerate attachments :) )
but basically you can demonstrate the problem with this simple code:

struct device dev;
while(1) {
  dev->release = dummy_release_function_that_does_nothing;
  device_register(&dev); /* will fail on second iteration without the
memset!! ?? */
  device_unregister(&dev);
  memset(&dev,0,sizeof(struct device)); /* should be unnecessary  */
}

> thanks,
>
> greg k-h
>

thanks,
-- Liberty
