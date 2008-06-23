Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYFWMg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYFWMg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYFWMgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:36:48 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:34503 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752819AbYFWMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:36:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LTD7gCHNzqm2WRCLzbuNIK7UPucYv2024lTfOCaNJ7I+ID+NaLcU6eVAtMwSuIFBpsIkd8O7b19l56Qu2k2Wopxo6TM6AeMWuNCatHHf65iKuBekh17mBI4gezuW/jkyGzB6J2ePR3XjZ9W0GkDUgitIErKATCp//Yd6ZPIN41U=  ;
X-YMail-OSG: z1ruvRoVM1nuz0VkZ.l.o4Y0Ntbw1V5Wkn584lSdvrmVvsHU5O624KKxHDnucmkkPW7lcPjvpdDZmRf0PAGNweQxoj7p70b3zZEXqKpG8Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a write error
Date: Mon, 23 Jun 2008 22:36:30 +1000
User-Agent: KMail/1.9.5
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, akpm@linux-foundation.org,
       sct@redhat.com, adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
References: <485F8822.5030205@hitachi.com> <200806232146.28379.nickpiggin@yahoo.com.au> <20080623123116.GL26743@duck.suse.cz>
In-Reply-To: <20080623123116.GL26743@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232236.30961.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 22:31, Jan Kara wrote:
> On Mon 23-06-08 21:46:27, Nick Piggin wrote:

> > I don't know why it was done like this, or if anybody actually tested
> > any of it, but AFAIKS the best way to fix this is to simply not
> > clear any uptodate bits upon write errors.
>
>   That would be non-trivial effort because there are lots of places which
> do things like:
>   wait_on_buffer(bh);
>   if (!buffer_uptodate)
>     /* IO error handling */
>
>   But what you say sounds like a reasonable thing from a logical
> perspective.

For reads, that's obviously a common pattern, although even that's
broken in some cases where it is used. But definitely uptodate should
not be set on a read error (although does it need to be explicitly
cleared? I would hope we don't submit a read anyway if the page/buffer
is already uptodate).

But you're right, even changing this for writes would not be a trivial
effort.
