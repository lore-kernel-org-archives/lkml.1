Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXLUCJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXLUCJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762064AbXLUCEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:04:11 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:42582 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932353AbXLUCEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:04:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RCT/GhDBdfFruXF15OsKdq1vP/HWDySdlJdei36mNBgykEIQiuNtOnJYk5owqktBE9xgNnno+MaFo/sBj6ozCwootrW4YkB8GzXZ1qOH16FlxKHlup+THfADm0gNCLFzwEVpoH4YXPOeH/WwV7MyoU98HA9RwRTu9YIQtqbo+q4=  ;
X-YMail-OSG: z14Xiq4VM1kY.YIvIbpgVJ7BmKsRboCU1LVC.MH_ESPd_G9ztc7GVhzQl7A5QMTgZSocpv88vg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Date: Fri, 21 Dec 2007 12:59:02 +1100
User-Agent: KMail/1.9.5
Cc: Jan Kara <jack@suse.cz>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Krzysztof Oledzki <olel@ans.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
References: <20071215221935.306A5108068@picon.linux-foundation.org> <20071220172551.GE764@atrey.karlin.mff.cuni.cz> <alpine.LFD.0.9999.0712201116510.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712201116510.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211259.02945.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 06:24, Linus Torvalds wrote:
> On Thu, 20 Dec 2007, Jan Kara wrote:
> >   As I wrote in my previous email, this solution works but hides the
> > fact that the page really *has* dirty data in it and *is* pinned in
> > memory until the commit code gets to writing it. So in theory it could
> > disturb the writeout logic by having more dirty data in memory than vm
> > thinks it has. Not that I'd have a better fix now but I wanted to point
> > out this problem.
>
> Well, I worry more about the VM being sane - and by the time we actually
> hit this case, as far as VM sanity is concerned, the page no longer really
> exists. It's been removed from the page cache, and it only really exists
> as any other random kernel allocation.

It does allow the VM to just not worry about this. However I don't
really like this kinds of catch-all conditions that are hard to get
rid of and can encourage bad behaviour.

It would be nice if the "insane" things were made to clean up after
themselves.


> The fact that low-level filesystems (in this case ext3 journaling) do
> their own insane things is not something the VM even _should_ care about.
> It's just an internal FS allocation, and the FS can do whatever the hell
> it wants with it, including doing IO etc.
>
> The kernel doesn't consider any other random IO pages to be "dirty" either
> (eg if you do direct-IO writes using low-level SCSI commands, the VM
> doesn't consider that to be any special dirty stuff, it's just random page
> allocations again). This is really no different.
>
> In other words: the Linux "VM" subsystem is really two differnt parts: the
> low-level page allocator (which obviously knows that the page is still in
> *use*, since it hasn't been free'd), and the higher-level file mapping and
> caching stuff that knows about things like page "dirtyiness". And once
> you've done a "remove_from_page_cache()", the higher levels are no longer
> involved, and dirty accounting simply doesn't get into the picture.

That's all true... it would simply be nice to ask the filesystems to do
this. But anyway I think your patch is pretty reasonable for the moment.
