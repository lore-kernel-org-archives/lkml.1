Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbXJUEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbXJUEeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXJUEeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:34:04 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:28075 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751011AbXJUEeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:34:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=HYI3HyTGGKpesDehAirhmeM9BDha7gAHa0YhZQM+XuMe/FQ1yvMvBL9DPShx3ZhF9x4ibx7w5srclFi1dhe1y/56jTaR8xkX8bcw1C99Zp3ypOVK7e4jnBtLF9053+R9HpqaZDQ1z0eVZ0a4jf6t+dgeZj8WUj9Udezlu/Iksq4=  ;
X-YMail-OSG: .qu3PkUVM1nEBZq0YV862ZCmAtRSEoy6r.HUPRSSRKnVo.Q4GBF.RPhk87Ccqq0qu..OY1njsQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Use a private inode for backing storage
Date: Sun, 21 Oct 2007 14:28:55 +1000
User-Agent: KMail/1.9.5
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710181126.10559.borntraeger@de.ibm.com> <m1lk9yen0h.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lk9yen0h.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710211428.55611.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007 08:51, Eric W. Biederman wrote:
> Currently the ramdisk tries to keep the block device page cache pages
> from being marked clean and dropped from memory.  That fails for
> filesystems that use the buffer cache because the buffer cache is not
> an ordinary buffer cache user and depends on the generic block device
> address space operations being used.
>
> To fix all of those associated problems this patch allocates a private
> inode to store the ramdisk pages in.
>
> The result is slightly more memory used for metadata, an extra copying
> when reading or writing directly to the block device, and changing the
> software block size does not loose the contents of the ramdisk.  Most
> of all this ensures we don't loose data during normal use of the
> ramdisk.
>
> I deliberately avoid the cleanup that is now possible because this
> patch is intended to be a bug fix.

This just breaks coherency again like the last patch. That's a
really bad idea especially for stable (even if nothing actually
was to break, we'd likely never know about it anyway).

Christian's patch should go upstream and into stable. For 2.6.25-6,
my rewrite should just replace what's there. Using address spaces
to hold the ramdisk pages just confuses the issue even if they
*aren't* actually wired up to the vfs at all. Saving 20 lines is
not a good reason to use them.

