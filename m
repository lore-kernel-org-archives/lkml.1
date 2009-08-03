Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZHCVtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZHCVtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZHCVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:49:11 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62692 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZHCVtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rU2i2j5p1CTJrsVbK1FJbnS/R/YOmNVKhYUcJYXXYw7juw0FCRbRDSIvW8WumPJ9hJ
         L6xUfDlAf463UshgpqcwvzLBAm7mCm8B5LsTRVuO6IKjbxMzm7Ni5EgII8i1pw7AwkGk
         K7YBSeRXuEM0dMPaxINeRbSBayKHzglwAGCwk=
MIME-Version: 1.0
In-Reply-To: <20090803212015.GC28579@kroah.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
	 <20090803212015.GC28579@kroah.com>
Date: Mon, 3 Aug 2009 17:49:09 -0400
X-Google-Sender-Auth: 5fdcbf0d2c370e18
Message-ID: <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
Subject: Re: Is anyone maintaining (or even using) usbtmc?
From: Andrew Lutomirski <luto@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 5:20 PM, Greg KH<greg@kroah.com> wrote:
> On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
>> Hi all-
>>
>> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
>> have), and it sort of works, but it seems to be both extremely buggy
>> and missing a good deal of rather important functionality.  Is there
>> anyone maintaining it?
>
> Yes, me.
>
>> If the answer is yes, I can describe the bugs (logspam, spurious
>> errors, delayed messages, inability to read status, etc.) in greater
>> detail.
>
> Please do, but also please use the latest version, in 2.6.30.3, we fixed
> some bad problems in it recently.

I am.

Almost anything I do triggers this:

usbtmc 3-1:1.0: Unable to read data, error -110

The easiest way is to write something that wasn't a query and then try
to read.  Of course, the read should fail, but there's no reason it
should spam the logs.

On occasion, sending garbage to the device will cause even a
subsequent USBTMC_IOCTL_CLEAR to fail with ETIMEDOUT.  (Maybe I wanted
USBTMC_IOCTL_ABORT_BULK_IN?  That seems wrong, though, since
presumably the driver should manage pending Bulk-IN requests on its
own.)

On other occasions (usually triggered by sending a garbage command,
but, when this happens, the problem persists across several messages),
every response will be delayed.  That is, if I send a query, I get
back the previous query's answer or ETIMEDOUT if the previous command
wasn't a query.  This persists across closing and reopening the
device.

Sometimes write() fails with ETIMEDOUT.  This failure happens with no
perceivable delay and I have no idea why.

An ioctl for GET_CAPABILITIES would be nice, but is not mandatory.

Finally, I see no way to read the USB488 status byte or detect a
status interrupt.

>
>> Is anyone using usbtmc, or, more specifically, does anyone care about
>> backward compatibility?
>
> What do you want to change in the driver interface?

The main compatibility-breaking change is that I'd like to see
close/reopen go through the whole resynchronization procedure so that
the device starts in a sane state.  Currently I restore sanity by
doing a bunch of reads and ignoring ETIMEDOUT.

--Andy
