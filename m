Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYJKMGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYJKMGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 08:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYJKMGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 08:06:31 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:26739 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752302AbYJKMGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:06:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gtNeMYFibl8hXB0AEru59rd3kFkWD8r/+WANmN1M1PwitMqjz78wTiCJ+Gz536hWocJ1LTI+MqXcmKvDb8CjGxTvEsx8pF8u2FWLmpKKQCTFmYmOrVjwTyEshv85RlRqisMQ35a+DOfK6xS3DSasJLw2ceVl1yno8f7VamJ6SOk=  ;
X-YMail-OSG: a5aoHiQVM1kGoPMlXwzrFxPyobfB5Z1nSUTxtPUSbKs_X9s0HtmFt8bQSrP8BCwnL7ex6PzD.DBK7uy7PTERPWNefj2Gn8YmhCXZYA_HJpcP0e0zCc3VOTjE.VHU9uC_1XuE3JFOHimDBoTwWgU7Y2JTlXMkBQGKyNW8nx3V
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: RFC: one-bit mutexes (was: Re: [PATCH 2/3] Memory management livelock)
Date: Sat, 11 Oct 2008 23:06:17 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <20081001225404.4e973465.akpm@linux-foundation.org> <Pine.LNX.4.64.0810051804040.23248@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810051804040.23248@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810112306.18118.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008 09:11, Mikulas Patocka wrote:
> Hi
>
> I removed the repeated code and create a new bit mutexes. They are
> space-efficient mutexes that consume only one bit. See the next 3 patches.

Pretty reasonable to have.


> If you are concerned about the size of an inode, I can convert other
> mutexes to bit mutexes: i_mutex and inotify_mutex.

I wouldn't worry for now. mutexes can be unlocked much faster than bit
mutexes, especially in the fastpath. And due to slab, it would be
unlikely to actually save any space.


> I could also create 
> bit_spinlock (one-bit spinlock that uses test_and_set_bit) and save space
> for address_space->tree_lock, address_space->i_mmap_lock,
> address_space->private_lock, inode->i_lock.

We have that already. It is much much faster to unlock spinlocks than
bit spinlocks in general (if you own the word exclusively, then it's
not, but then you would be less likely to save space), and we can also
do proper FIFO ticket locks with a larger word.


> Look at it and say what you think about the idea of condensing mutexes
> into single bits.

Looks pretty good to me.
