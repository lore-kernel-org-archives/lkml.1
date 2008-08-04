Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYHDJCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYHDJCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYHDJCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:02:36 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:37027 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754585AbYHDJCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:02:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bIYZOMrC8982TcGnxKJvN9IFYneGiEPWMn5Xyq6giOJ8KrM746aG5/t5kmTOWC+qytXUSb8J2nXZ24hGTLC/Gd3y99UTQyfGKUxb8UmMhUTtfot76MXw50R/pQgXpRcQ+3SR48ScKM5rV/WW2N8f8kYfm0XbyttorQ7sMXaigts=  ;
X-YMail-OSG: 1kFACPAVM1k8NAY7pr8V_4_sijPEBTeKiRmR5Y09_RgxXMxQnCgyXyWWjE6pRg0PdHi0vgnG772at.K.nXewC2bJRjCS_orUv11lNGZ49udKe6TnLf1iHQiW3i6pIc6B8ls-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Mon, 4 Aug 2008 19:02:23 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <20080801205052.GA28747@infradead.org> <1217814896.23437.420.camel@koto.keithp.com>
In-Reply-To: <1217814896.23437.420.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041902.23970.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 11:54, Keith Packard wrote:
> On Fri, 2008-08-01 at 16:50 -0400, Christoph Hellwig wrote:
> > Nope.  Let the userspace protion create a file in shmfs instead of
> > adding fugly kernel interfaces hdiing this fact.
>
> shmem_file_setup is already public, just not exposed to kernel modules.

This is not an argument. shmem_file_setup is public because that's
how ipc is implemented, not because it makes sense to be used
anywhere else. Lots of other things in mm/ are public that should
never be used outside that directory for example.


> I suppose we could have user space allocate the shmem file (either via
> tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
> runs up against the SHMMAX value.

This is how I'd suggested it work as well. I think a little bit
more effort should be spent looking at making this work.


> The other interface we use, shmem_getpage, doesn't seem supported
> through existing interfaces though. I don't want to map the file into
> any address space, I just need a pointer to the physical pages which
> underlie it. I'll take those pages and hand them to the graphics engine.
> shmem_getpage performs precisely the operation needed here.

Mapping the file into an address space might be a way to make it
work (using get_user_pages to get the struct page). splice might
also work. read_mapping_page or similar could also be something to
look at. But using shmem_getpage seems wrong because it circumvents
the vfs API.

If you genuinely have problems that can't be fit into existing
APIs without significant modification, and that is specific just to
your app, then we could always look at making special cases for you.
But it would be nice if we generically solve problems you have with
processes manipulating thousands of files.
