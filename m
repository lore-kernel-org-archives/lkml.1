Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbXB1UB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbXB1UB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXB1UB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:01:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXB1UB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:01:27 -0500
Message-ID: <45E5DF8E.80109@redhat.com>
Date: Wed, 28 Feb 2007 15:01:18 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com> <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> While these entry points do not actually modify the file itself,
>> as was pointed out, they are handy points at which the kernel gains
>> control and could actually notice that the contents of the file are
>> no longer the same as they were, ie. modified.
>>
>>  From the operating system viewpoint, this is where the semantics of
>> modification to file contents via mmap differs from the semantics of
>> modification to file contents via write(2).
>>
>> It is desirable for the file times to be updated as quickly as
>> possible after the actual modification has occurred.
>>     
>
> I disagree.
>
> You don't worry about the timestamp being updated _during_ a large
> write() call, even though the file is constantly being modified.
>
>   

No, but you do worry about the timestamps being updated after
every write() call, no matter how large or small.

> You think of write() as something instantaneous, while you think of
> writing to a shared mapping, then doing msync() as something taking a
> long time.  In actual fact both of these are basically equivalent
> operations, the differences being, that you can easily modify
> non-contiguous parts of a file with mmap, while you can't do that with
> write.  The disadvantage from mmap comes from the cost of setting up
> the page tables and handling the faults.
>
> Think of it this way:
>
>   shared mmap write + msync(MS_ASYNC)  ==  write()
>   msync(MS_ASYNC) + fsync()  ==  msync(MS_SYNC)
>
>   

I don't believe that this is a valid characterization because the
changes to the contents of the file, made through the mmap'd region,
are immediately visible to any and all other applications accessing
the file.  Since the contents of the file are changing, then so
should the timestamps to reflect this.

>> A better design for all of this would be to update the file times
>> and mark the inode as needing to be written out when a page fault
>> is taken for a page which either does not exist or needs to be made
>> writable and that page is part of an appropriate style mapping.
>>     
>
> I think this would just be a waste of CPU.

I think that we are going to have to agree to disagree because
I don't agree either with your characterizations of the desirable
semantics associated with shared mmap or that maintaining the
correctness in the system is a waste of CPU.

I view mmap as a way for an application to treat the contents of
a file as another segment in its address space.  This allows it to
manipulate the contents of a file without incurring the overhead
of the read and write system calls and the double buffering that
naturally occurs with those system calls.  I think that:

    char *p = mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    *p = 1;
    *(p + 4096) = 2;

should have the same effect as:

    char c = 1;
    pwrite(fd, &c, 1, 0);
    c = 2;
    pwrite(fd, &c, 1, 4096);

Clearly, the two can't be equivalent since the operating system
can only become involved at certain times in order to update the
timestamps.  That's why there are specifications about the
timestamps for things like msync.  They should be as close as
possible though.

However, since I seem to be the only one presenting a different
viewpoint, then I will agree to disagree and commit.  I will see
if I can sell your semantics to my customer and find out if that
will satisfy them.

    Thanx...

       ps
