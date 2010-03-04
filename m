Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0CDSNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:13:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35953 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0CDSNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ei7t/oBdbSXgryM5aPcbdmORf78rO3TS7tJOlk8Ah9PAMQgh2qclNKu7E1OhjSF0xj
         On1moWGY/fw7cDxjySjRtd7hEUo41ISz0zxXLG6UAoV6AbXljHEdURU2ql14fo8cNCpI
         v2Uy132DhHfec2XUyXCBiGo2MlweGCv0ANEgw=
MIME-Version: 1.0
In-Reply-To: <201003041631.o24GVl51005720@alien.loup.net>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
	 <201003041631.o24GVl51005720@alien.loup.net>
Date: Thu, 4 Mar 2010 13:12:59 -0500
Message-ID: <f875e2fe1003041012m680ffc87i50099ed011526440@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: s ponnusa <foosaa@gmail.com>
To: Mike Hayward <hayward@loup.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write cache is turned off at the hdd level. I am using O_DIRECT
mode with aligned buffers of the 4k page size. I have turned off the
page cache and read ahead during read as well using the fadvise
function.

As you have mentioned, the program grinds the hdd when it hits the bad
sector patch. It retries to remap / write again until it (hdd) fails.
It then finds the hdd does not respond and finally resets the device.
(This goes on and the program eventually moves on the next sector
because write call returned success. No errno value was set. Is this
how a write will function in linux? It does not propagate the error to
the user mode program for any reasons related to the disk failures
during a write process even with the O_DIRECT flag.

Is there any specific location, that can be used to turn off the
sector remapping, retrying option at the libata level (I don't want to
change it at the public repository, rather I would like to change in
my kernel for testing / debugging purposes) and propagating the error
to the usermode programs? The messages in syslog are due to the printk
calls at the libata-eh.c file in the drivers/ata section of the kernel
code. But I have not spend much analysing it though.

Thanks.

On Thu, Mar 4, 2010 at 11:31 AM, Mike Hayward <hayward@loup.net> wrote:
> I have seen a couple of your posts on this and thought I'd chime in
> since I know a bit about storage.
>
> I frequently see io errors come through to user space (both read and
> write requests) from usb flash drives, so there is a functioning error
> path there to some degree.  When I see the errors, the kernel is also
> logging the sector and eventually resetting the device.
>
> There is no doubt a disk drive will slow down when it hits a bad spot
> since it will retry numerous times, most likely trying to remap bad
> blocks.  Of course your write succeeded because you probably have the
> drive cache enabled.  Flush or a full cache hangs while the drive
> retries all of the sectors that are bad, remapping them until finally
> it can remap no more.  At some point it probably returns an error if
> flush is timing out or it can't remap any more sectors, but it won't
> include the bad sector.
>
> I would suggest turning the drive cache off.  Then the drive won't lie
> to you about completing writes and you'll at least know which sectors
> are bad.  Just a thought :-)
>
> - Mike
>
