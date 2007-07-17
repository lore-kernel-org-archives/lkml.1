Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXGQMJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXGQMJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXGQMJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:09:43 -0400
Received: from [212.12.190.106] ([212.12.190.106]:32869 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750881AbXGQMJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:09:42 -0400
From: Al Boldi <a1426z@gawab.com>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 15:08:06 +0300
User-Agent: KMail/1.5
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org> <200707161632.02334.a1426z@gawab.com> <Pine.LNX.4.64.0707162129090.19248@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707162129090.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707171508.06921.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 16 Jul 2007, Al Boldi wrote:
> > We have to go through ACPI, for wakeup functions to succeed.  A simple
> > power-off won't do.
>
> the kexec switch being posted requires ACPI be disabled, so it's clearly
> possible to switch kernels and initialize devices without ACPI

It's a given that kexec works in the absence of ACPI; what we have to handle 
is the ACPI states across kernel invocations, to ensure wakeup functions 
succeed.  If you don't need this, then just power off.

> >> suspend-to-disk-and-ram could be implemented as three
> >> seperate steps
> >>
> >> 1. suspend-to-disk
> >>
> >> 2. resume-from-disk
> >>
> >> 3. suspend-to-ram
> >>
> >> followed by either
> >>
> >> 4. resume-from-ram
> >>
> >> or
> >>
> >> 4. battery dies and loptop powers off completely
> >>
> >> 5. power-on boot.
> >>
> >> 6. resume-from-disk
> >>
> >> all that you need to do is to make sure that the system doesn't run
> >> anything that would affect permanent media or the outside world between
> >> steps #2 and #3
> >
> > Exactly, which is why your scheme would break down on #3, and that's why
> > you need to call S3 from within the kexec'd hibernation kernel after
> > saving the hibernation image.
>
> when a kexec is called, how does the kernel know what to execute?
> something needs to tell it what to do, and I think that something is
> either something in the kexec image, or it's something passed as a
> parameter to that image.
>
> all that would be needed to do #3 safely is to have the kernel that you
> restarted on #2 do a suspend-to-ram before it does anything else.

If you mean by kernel 'the normal kernel', then this won't work, because it 
would imply a change of state after saving its image.

If you mean by kernel 'the kexec'd hibernation kernel', then you wouldn't 
need to do #2, but rather do #3 right after dumping the image in #1.

[...insert from another post...]
> > BTW, it would be really helpful if people would actually try the kexec
> > hibernation patches, as this may yield a much more constructive
> > discussion.
>
> I would love to, but so far I don't see the nessasary pieces
>
> once I kexec to the new kernel, how can it find out what pages of memory
> (and swap) need to be saved?

No need to save the swap, all you need to do is to dump /dev/oldmem onto 
storage, and if that dump image is compatible with swsusp, then a normal 
kernel should be able to resume from this image via /dev/snapshot.


Thanks!

--
Al

