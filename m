Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXFDD5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXFDD5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 23:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFDD5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 23:57:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:8096 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFDD5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 23:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H79HQvCtSRY6u4M1fNWa0+cQG/P70bxRtp2W9NlguNA+XRBzYQQcYoxjx6Nvc/XSGUUg+/KCrNCVEXh5xcKC2zWqH7UYBUPCFcCEvQ8i8Rs185KNq3l9KnTmIYH/ZumJrJV7WPCR1sRCxP8Iuc8ZGv19rXESYMEcYTMZTeagXaQ=
Message-ID: <787b0d920706032057q2ed5fa06yc05907990cb2c0f0@mail.gmail.com>
Date: Sun, 3 Jun 2007 23:57:11 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, davids@webmaster.com, epiphani@gmail.com,
       viro@ftp.linux.org.uk
Subject: RE: slow open() calls and o_nonblock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz writes:
> [Aaron Wiebe]

>> open("/somefile", O_WRONLY|O_NONBLOCK|O_CREAT, 0644) = 1621 <0.415147>
>
> How could they make any difference? I can't think of any
> conceivable way they could.
>
>> Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
>> call with a nonblocking flag return EAGAIN if its going to take
>> anywhere near 415ms?  Is there a way I can force opens to EAGAIN if
>> they take more than 10ms?
>
> There is no way you can re-try the request. The open must either
> succeed or not return a handle. It is not like a 'read' operation
> that has an "I didn't do anything, and you can retry this request"
> option.
>
> If 'open' returns a file handle, you can't retry it (since it must
> succeed in order to do that, failure must not return a handle).
> If you 'open' doesn't return a file handle, you can't retry it
> (because, without a handle, there is no way to associate a future
> request with this one, if it creates a file, the file must not be
> created if you don't call 'open' again).
>
> The 'open' function must, at minimum, confirm that the file exists
> (or doesn't exist and can be created, or whatever). This takes
> however long it takes on NFS.

This is not the case, though we might need to allocate a new
flag to avoid breaking things.

Let open() with O_UNCHECKED always return a file descriptor,
except perhaps when failure can be identified without doing IO.
The "real" open then proceeds in the background.

>From poll() or select(), you can see that the file descriptor
is not ready for anything. Eventually it becomes ready for IO
or reports an error condition. Both select() and poll() are
capable of reporting errors. If the "real" (background) open()
fails, then the only valid operation is close(). Attempts to
do anything else get EBADFD or ESTALE.

You'll also need a background close().
