Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYJUBva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYJUBva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJUBvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:51:21 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:30625 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751596AbYJUBvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:51:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WvHeirxPkXkNAa0FpSkQd0WxPP4u1P+nH+y+G1Je+BHBI4Yca2Mb/Q5oB6sbg/xHBt1P+l/y2m61ceWRUbI3vTlBFc9PMstb8fqnScD5hTXbM3fncYeqgmP/+ERN4XgakAcGKk27UgMOTTlCF5nW8rHGLf92wApQb1+WEe/GW+g=  ;
X-YMail-OSG: fhYdrz8VM1lrE7UD_SQbs7f5gs.pe4W5r6WAC0NRy8mXOxpF4iRA60u7LsUS5NIHJvrjG8qiemd58DgZjOJSD563mmsUAGxu1ak6KC0WreZTatOwMamodfOk_Z4AX89DjhSOdJvOfqfX_5z206NUUYB.uxIWxr8ztWQ.WxuM
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: RFC: one-bit mutexes (was: Re: [PATCH 2/3] Memory management livelock)
Date: Tue, 21 Oct 2008 12:51:07 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810112306.18118.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0810201612210.22845@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810201612210.22845@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211251.07579.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2008 07:14, Mikulas Patocka wrote:
> > > If you are concerned about the size of an inode, I can convert other
> > > mutexes to bit mutexes: i_mutex and inotify_mutex.
> >
> > I wouldn't worry for now. mutexes can be unlocked much faster than bit
> > mutexes, especially in the fastpath. And due to slab, it would be
> > unlikely to actually save any space.
>
> Maybe inotify_mutex. You are right that i_mutex is so heavily contended
> that slowing it down to save few words wouldn't be good. Do you know about
> any inotify-intensive workload?

Don't really know, no. I think most desktop environments use it to
some extent, but no idea how much.


> > > I could also create
> > > bit_spinlock (one-bit spinlock that uses test_and_set_bit) and save
> > > space for address_space->tree_lock, address_space->i_mmap_lock,
> > > address_space->private_lock, inode->i_lock.
> >
> > We have that already. It is much much faster to unlock spinlocks than
> > bit spinlocks in general (if you own the word exclusively, then it's
> > not, but then you would be less likely to save space), and we can also
> > do proper FIFO ticket locks with a larger word.
>
> BTW. why do spinlocks on x86(64) have 32 bits and not 8 bits or 16 bits?
> Are atomic 32-bit instuctions faster?

In the case of <= 256 CPUs, they could be an unsigned short I think.
Probably it has never been found to be a huge win because they are
often beside other ints or longs. I think I actually booted up the
kernel with 16-bit spinlocks when doing the FIFO locks, but never
sent a patch for it... Don't let me stop you from trying though.


> Can x86(86) system have 256 CPUs?

Well, none that I know of which actually exist. SGI is hoping to have
4096 CPU x86 systems as far as I can tell.
