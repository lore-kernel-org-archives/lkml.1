Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZEFMIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZEFMIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbZEFMIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:08:13 -0400
Received: from services106.cs.uwaterloo.ca ([129.97.152.164]:64730 "EHLO
	services106.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273AbZEFMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:08:12 -0400
X-Greylist: delayed 2548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 08:08:11 EDT
Date: Wed, 6 May 2009 07:25:34 -0400 (EDT)
From: Tim Brecht <brecht@cs.uwaterloo.ca>
Reply-To: Tim Brecht <brecht@cs.uwaterloo.ca>
To: Andi Kleen <andi@firstfloor.org>
cc: Elad Lahav <elahav@cs.uwaterloo.ca>, Elad Lahav <elahav@uwaterloo.ca>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
In-Reply-To: <20090504145046.GI23223@one.firstfloor.org>
Message-ID: <Pine.GSO.4.64.0905060714020.880@services108.cs.uwaterloo.ca>
References: <49FE47A1.7070700@uwaterloo.ca> <87eiv5ibnd.fsf@basil.nowhere.org>
 <20090504094431.174745mb0jhhm3s4@www.nexusmail.uwaterloo.ca>
 <20090504145046.GI23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (services106.cs.uwaterloo.ca [129.97.152.132]); Wed, 06 May 2009 07:25:38 -0400 (EDT)
X-Miltered: at mailchk-w02 with ID 4A0173B0.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 4c773090-612f-4072-8cd8-38c39e6b7b44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 May 2009, Andi Kleen wrote:

> On Mon, May 04, 2009 at 09:44:31AM -0400, Elad Lahav wrote:
>>> My guess it's more the copies than the calls?
>> It's a factor of both. This is why we also created the sendgroup()
>> implementation that uses a tight loop of in-kernel calls to sendmsg()
>> as a means for evaluating the cost of mode switches. It is definitely
>> not negligible (exact numbers depend on the size of the group and the
>> size of the payload, of course).
>
> How much is non negligible in your case?

As you can see from Elad's posting it can be pretty
significant.

>>
>>> It sounds like you want sendfile() for UDP.
>> Do you mean by having a per-recipient sendfile() call for the same
>> file? Leaving the cost of the system call aside, this solution does
>> not work well with the kind of real-time data that we've been working
>> with (live streaming, online games). You would have to write the
>> payload to the file as it is being generated and call sendfile() after
>> each such write.
>
> You can mmap the file.

There are a few problem with using mmap and sendfile:

1) One would really want something like sendfilev where
    one could specify multiple recipients in one syscall
    (in order to save on the mode switches).

2) I don't know what it would be like for UDP but for
    TCP one of the big problems with mmap/sendfile
    for zero copy is that the application
    doesn't know when the kernel has finished sending
    the data. As a result one can only reuse the mmapped buffer
    if there is some way for the application to deduce
    that the kernel is finished sending the data.
    Even if the application can deduce this it can
    often be long after the kernel has sent the data
    and as a result memory buffers can accumulate
    unnecessarily. We've had this problem trying to use
    this approach in a high-performance web server.

3) I think that including recipient specific data
    would be cumbersome and would probably require extra
    system calls. Possibly
       write(for prepend)
       sendfile(for common)
       write(for append)
    Unless one copies the common data into prestaged
    areas in user space ... which results in the copying
    we are trying to avoid.

    Perhaps if writev was able to
    write from an mmapped file with zero copies,
    a single recipient could be sent recipient
    specific and common data with one system call.
    However, this approach would still require one system
    call per recipient.

