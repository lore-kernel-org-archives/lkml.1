Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYDXVmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYDXVmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYDXVmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:42:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:47664 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYDXVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fmdvaPWSCxQKYpc3aELdKmaQnI6HI4qRkZW1pNXLynVdlVBOflCxZdCRA1xyEaLJ15gac6agN6LFUZSIoYBXYbzIsCPBgX0WipFKHc+KK6KPmO7ro883oU0e5RxVf4YJBec42dKpYF4ouBYYzbeTdf9Jj0mZcWUZvSPk/jmvcOY=
Message-ID: <ed038eb20804241442g7f6779aep90ede66ac5c961a8@mail.gmail.com>
Date: Thu, 24 Apr 2008 23:42:01 +0200
From: "Carl Henrik Lunde" <chlunde@ping.uio.no>
To: "Soeren Sandmann" <sandmann@daimi.au.dk>
Subject: Re: stat benchmark
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
X-Google-Sender-Auth: 23d4b9842cfd14fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 10:59 PM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
[ about programs reading all inodes after readdir ]

>  Unfortunately, performance of that operation kinda sucks. On my system
>  (ext3), it produces:
>
>     c-24-61-65-93:~% sudo ./a.out
>     Time to readdir(): 0.307671 s
>     Time to stat 2349 files: 8.203693 s
>
>  8 seconds is about 80 times slower than what a user perceives as
>  "instantly" and slow enough that we really should display a progress
>  bar if it can't be fixed.
>
>  So I am looking for ways to improve this.
>
>  Under the theory that disk seeks are killing us, one idea is to add a
>  'multistat' system call that would allow statting of many files at a
>  time, which would give the disk scheduler more to work with.

I have experimented with the same problem, and another idea is to
reorder the result from readdir, which I've gotten good results by doing.

This works because:
 - For most filesystems there is a high correlation between the inode
   number and the sector on the disk.

 - Most programs like your example handle the files in the order that
   they are returned from readdir

 - The time spent sorting is very small compared to the disk seeks

There are several possible ways to implement this:

 - reorder the dirents in the kernel for each getdents call

 - reorderi the dirents in user space, for example by running
   qsort in a libc wrapper

 - in the file system, optimize the order before writing back a dirty directory

This does not only apply to programs only stating files, but also reading
them, such as indexing files, backups (tar), and Nautilus getting thumbnails
from JPGs.

-- 
Carl Henrik
