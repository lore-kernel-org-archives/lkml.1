Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYFDIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYFDIk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYFDIkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:40:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:28041 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYFDIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SpE3LzhUOsNO/8Y+kslCL3dlNKAS4RRnEb9G5LczWdDzI5gozez9AdxrVOo0s3tcdtMfOYLq2Fba/PLjJjr0msNZ76OFNNjs1JoqD+IX2LInrlGeYSzTrZHNSPfIxD1flhI2v0i2cDuQFN365OkS/hIrVyQ9f4NDHe4FXjweb98=
Message-ID: <cfd18e0f0806040140g15524e5w3f464f3da9dbd3de@mail.gmail.com>
Date: Wed, 4 Jun 2008 10:40:11 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       viro@zeniv.linux.org.uk, jamie@shareable.org, drepper@redhat.com,
       linux-fsdevel@vger.kernel.org, subrata@linux.vnet.ibm.com
In-Reply-To: <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4845C4D2.8050408@gmail.com>
	 <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 6:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> The POSIX.1 draft spec for futimens()/utimensat() says:
>>
>>         Only a process with the effective user ID equal to the
>>         user ID of the file, *or with write access to the file*,
>>         or with appropriate privileges may use futimens() or
>>         utimensat() with a null pointer as the times argument
>>         or with both tv_nsec fields set to the special value
>>         UTIME_NOW.
>>
>> The important piece here is "with write access to the file", and
>> this matters for futimens(), which deals with an argument that
>> is a file descriptor referring to the file whose timestamps are
>> being updated,  The standard is saying that the "writability"
>> check is based on the file permissions, not the access mode with
>> which the file is opened.  (This behavior is consistent with the
>> semantics of FreeBSD's futimes().)  However, Linux is currently
>> doing the latter -- futimens(fd, times) is a library
>> function implemented as
>>
>>        utimensat(fd, NULL, times, 0)
>>
>> and within the utimensat() implementation we have the code:
>>
>>                 f = fget(dfd);  // dfd is 'fd'
>>                 ...
>>                 if (f) {
>>                         if (!(f->f_mode & FMODE_WRITE))
>>                                 goto mnt_drop_write_and_out;
>>
>> The check should instead be based on the file permissions.
>>
>> Thanks to Miklos for pointing out how to do this check.
>>
>> CC: Miklos Szeredi <miklos@szeredi.hu>
>> CC: Al Viro <viro@zeniv.linux.org.uk>
>> CC: Ulrich Drepper <drepper@redhat.com>
>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>>
>> --- linux-2.6.26-rc4/fs/utimes.c      2008-06-03 23:13:31.000000000 +0200
>> +++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c     2008-06-03 23:15:12.000000000 +0200
>> @@ -137,7 +137,8 @@
>>
>>               if (!is_owner_or_cap(inode)) {
>>                       if (f) {
>> -                             if (!(f->f_mode & FMODE_WRITE))
>> +                             error = permission(inode, MAY_WRITE, NULL);
>> +                             if (error)
>>                                       goto mnt_drop_write_and_out;
>>                       } else {
>>                               error = vfs_permission(&nd, MAY_WRITE);
>
> At which point the "if (f)" and the "else" branches become equivalent
> (the nameidata isn't interesting in the other case either).  So that
> could be written as:
>
>                if (!is_owner_or_cap(inode)) {
>                        error = permission(inode, MAY_WRITE, NULL);
>                        if (error)
>                                goto mnt_drop_write_and_out;
>                }

Okay -- thanks Miklos.  I'll change that, and test.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
