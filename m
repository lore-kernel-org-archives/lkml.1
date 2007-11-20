Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXKTKrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXKTKrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXKTKro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:47:44 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:45025 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752124AbXKTKro (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:47:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tQu+G9yPe+CtWseTokFKRQQoiDlkU6vgea8OIjM408w/f1SWosCTZfjvvroktfILTCUn51QMRKSI3h/lwHfSvGh2SGJKRLRFcrK7E5dtrv0zxJrqbAFv3DgQ2l9fb9ecIVz6sGZayJOSrDUHAJlfNdMl76RWv7fgnL0FQN4ibeM=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: pomac@vapor.com
Subject: Re: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
Date: Tue, 20 Nov 2007 21:47:32 +1100
User-Agent: KMail/1.9.5
Cc: Linux-kernel@vger.kernel.org
References: <1195520355.8601.14.camel@localhost> <200711201513.36711.nickpiggin@yahoo.com.au> <1195549767.8601.22.camel@localhost>
In-Reply-To: <1195549767.8601.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711202147.32354.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 20:09, Ian Kumlien wrote:
> On tis, 2007-11-20 at 15:13 +1100, Nick Piggin wrote:

> > It's also used up all your 2.5GB of swap. The output of your `free` shows
> > a fair bit of disk cache there, but it also shows a lot of swap free,
> > which isn't the case at oom-time.
>
> Yes, as i said those was from several hours later...

OK, missed that.


> > Unfortunately, we don't show NR_ANON_PAGES in these stats, but at a
> > guess, I'd say that the file cache is mostly shrunk and you still don't
> > have enough memory. trackerd probably has a memory leak in it, or else is
> > just trying to allocate more memory than you have. Is this a regression?
>
> I have had it happen twice before, without tracker running...

Does the machine recover afterward, or is the memory freed up after
the OOM kill? How about if you kill X and do a sysrq+E then sysrq+I
(to kill all tasks)?

If the memory still isn't freed after that, then we could have a
kernel memory leak.


> It didn't quite get to the oom stage, it just failed alot of allocations
> while having 1.5 or more memory locked in cache.
>
> http://marc.info/?l=linux-kernel&m=118895576924867&w=2

OK, yes this is a different case, and it is very far off the OOM
killing stage. Atomic allocations can fail quite easily, but
kswapd will have started up and will start freeing memory.

Actually there are some patches gone into 2.6.24 that have fixed
some corner cases with the network stack making order-1 allocations
when it should be order-0. That might help your atomic allocation
failures, but they aren't really a bug anyway (unless networking
fails to recover).

Thanks for reporting all this...
