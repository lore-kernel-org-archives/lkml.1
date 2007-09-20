Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXITRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXITRgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXITRgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:36:11 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:39067 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752056AbXITRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:36:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ttsiLUiYIUaP3ayJ5knRViZ3ME7sHL1WMAe1Q8xPOtWWhaJ5pFYh86pQfgvh23N8LwAS1+OwTV8cEyJ/22RTybrr8gucq7LNT7Q2k017/E73fhP4DQLiLpdI7jmkp8/V6fmobpx1WxTbK6kamst2OmRPLfFEtZev0KEjIekz1Ic=  ;
X-YMail-OSG: sRE_1OsVM1lU6R9UGtfk.dDgjwiNrV6i6f4ndO1VkGxjbUek7TeQz82Hc_QFKkK6qi2tMVt88d2zIHQMebTEzRwhIa3lFT2U9rbDJQx5dJrGWf.jhJ8Ks1l7qbL3Tx53brINaePbOcmlKHc-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1
Date: Thu, 20 Sep 2007 10:36:06 -0700
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709192143.14635.david-b@pacbell.net> <20070919231121.e481445c.akpm@linux-foundation.org>
In-Reply-To: <20070919231121.e481445c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201036.06658.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007, Andrew Morton wrote:
> Head still spinning.
> 
> a) "rtc0" != "rtc" ??

One key difference between any of the numerous legacy RTC drivers
and the new framework is that the legacy drivers tended to think
(wrongly!) they would be the only RTC in the system, while the
framework recognizes that other configurations are important.

Hence names "rtc0", "rtc1", "rtc2" ... etc in framework drivers,
versus just "rtc" in legacy code.  Easily tweaked with "udev" if it
matters, but current versions of "hwclock" (in util-linux and also
in busybox) don't require a /dev/rtc file any more ... they check
for /dev/rtc0, and can be told to look at other RTCs too.


> b) The kernel is trying to register two procfs files of the same name! 
>    If that's a configuration error then we have a Kconfiguration bug.

Not so much an "error" as minor awkwardness.  The end result is
that only one driver will be active.


> > It's not a wrong thing, at any rate.  This is a fairly basic task
> > in any filesystem:  mutual exclusion.  Code is allowed to rely on
> > filesystems acting correctly...
> > 
> 
> We're relying on procfs behaviour to prevent registration of two rtc
> devices?

Not at all.  But if two chunks of code try to create /proc/x/y/z,
only one of them should succeed.  Today, there's a clear bug in
procfs whereby both of them will succeed...


> That's a strange means of arbitration.   And what happens 
> when CONFIG_PROC_FS=n?

Then nothing gets stored there; procfs is nonessential.  The same
code executes as when creating the /proc/x/y/z file fails.


> > > Yes, procfs should have been checking for this.  But it is too late now for
> > > us to just fail out of the procfs registration code.  Because this can
> > > cause previously buggy-but-works-ok code to now fail completely.
> > 
> > What do you mean by too late "now" ... just-before-2.6.23?
> 
> No.
> 
> What I mean is that we cannot change procfs as you propose until we have
> located and fixed all places in the kernel which can cause duplicated
> procfs names.

But causing duplicated names doesn't need any "fix" when that code
handles the error sanely -- by using its "PROCFS=n" code paths.

If you're arguing that you think such fault handling code may have
a lot of bugs, I might agree:  not all fault handling code gets even
basic testing.  But that would seem to be nothing more than a reason
to want some code auditing (to see how common such bugs really are,
and fix at least a few of them), and perhaps to let such bugfixes sit
in a moderately well-exposed testing tree for a while.


> (Good luck with that). 

Evidently there's no procfs maintainer ... you've said there are
patches in MM to detect and report such duplication.  What is it
turning up?


> Because we've had this happening before, and *the driver kept working*
> (apart from, presumably, some of their procfs features which, presumably,
> nobody used much). 
> 
> With the change which you propose, these drivers will probably stop
> working, because they will newly find their procfs registration failed.

The last time I had occasion to look at such stuff I observed that procfs
users were generally sane.  If they couldn't create a file, they just
continued ... after all, procfs can never be the primary interface.


> > And what would an example be of buggy-but-works code, which would
> > then be broken if the procfs stopped being buggy?
> > 
> 
> A driver which checks the return value from procfs registration and which
> then errors out (as it should) if that registration fails.

Erroring out is appropriate for fatal errors ... but procfs errors
generally can't be fatal.  (Code which uses procfs for its primary
userspace interface would be the exception.)  So most code should
never error out on such faults.

As I commented above, most code I've happend across will proceed
just fine if the extra procfs support is unavailable.  After all,
it needs to work with CONFIG_PROCFS=n so those code paths aren't
going to suddenly stop working!

- Dave

