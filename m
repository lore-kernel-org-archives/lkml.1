Return-Path: <linux-kernel-owner+w=401wt.eu-S1161657AbXEEPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161657AbXEEPhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161659AbXEEPha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:37:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1732 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161648AbXEEPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:37:27 -0400
Message-ID: <a781481a0705050648l19b316acyf3d52b0545e18344@mail.gmail.com>
Date: Sat, 5 May 2007 19:18:25 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
Cc: "Florin Malita" <fmalita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1178371103.3659.115.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
	 <1178351711.3659.54.camel@sauron>
	 <a781481a0705050526r13445d60j737a6c2015402dcc@mail.gmail.com>
	 <1178371103.3659.115.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Artem Bityutskiy <dedekind@infradead.org> wrote:
> On Sat, 2007-05-05 at 17:56 +0530, Satyam Sharma wrote:
> > > And it is fine to use list_add_tail() directly in vtbl.c. Will be fixed.
> > Ah, good to know that, but please keep list_add_tail (or whatever is
> > the implementation abstraction of the various ubi_scan_info lists)
> > local to scan.c -- you could expose a version of ubi_scan_add_to_list
> > that does not do kmalloc through scan.h and use that in vtbl.c. That
> > way you won't lose those debug printk's when adding an eraseblock to a
> > list, for example, and it's always much cleaner not exposing an
> > object's implementation innards to others.
>
> It's error path and that print is not really needed. We'll see other
> complaints in that case. And this is _the only_ place outside scan.c, so
> it makes sense to use list_add_tail(). We do not really need to hide
> this behind some other call (ubi_scan_add_to_list())

Well, you're developing / maintaining this right now, so it's your
call. Though I bet most people would find keeping that list_add_tail
local to scan.c more tasteful.

> >  Physical eraseblocks are allocated in ubi_scan_add_to_list
> > (which shouldn't be doing that)
> Yes, per-PEB scanning information is allocated in ubi_scan_add_to_list()
> and ubi_scan_add_to_used(). I do not see why it shouldn't be doing that.
>
> >  and ubi_scan_add_used (which is a maze)
> It actually is rather complex because it does a rather complex thing.

I wish you'd commented it better than "This function returns zero in
case of success and a negative error code in case of failure." in that
case :-)

> But any patch/idea to make it simpler is welcome.
> > and freed pretty much all over the place
> It is only freed in ubi_scan_destroy_si(). Yes, there is one exception
> in create_vtbl, but this is because I did not want to introduce any
> special version of ubi_scan_add_used().
>
> It does not hurt at all that we do one extra allocation, because it is
> called _only_ 2 times (once for each volume table copy).
>
> >  (because we allocate
> > new seb's for ourselves to add to the lists, we need to go about
> > kfree'ing all of them when destroying a ubi_scan_destroy_si too, for
> > example -- perhaps this driver needs to be told about krefs).
>
> Sorry. not sure what you mean. They are allocated in 2 places, and freed
> in one, with one exception in vtbl_create() which does not matter much.
>
> >  So it
> > makes life easier if you know there's only one place when/where an
> > object is born,
> May be it is, but I have 2 places and do not see any problem.

Again, you're developing and maintaining this right now, so it's your
call. Though it would be easier on you if you remove these exceptions
that could be quite easily removed, actually.

Thanks,
Satyam
