Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXGOPOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXGOPOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 11:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbXGOPOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 11:14:04 -0400
Received: from [212.12.190.163] ([212.12.190.163]:32828 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756819AbXGOPOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 11:14:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Hibernation considerations
Date: Sun, 15 Jul 2007 18:10:33 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm
References: <200707151433.34625.rjw@sisk.pl>
In-Reply-To: <200707151433.34625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151810.33554.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> (3) There are memory regions that must not be saved or restored
>
>     Some memory regions contain data that shouldn't be overwritten during
> the restore, because that might lead to the system not working correctly
> afterwards.  Also, on some systems there are valid 'struct pages'
> structures that in fact corresond to memory holes and we should not
> attempt to save those pages.

That's only true if we use the current swsusp code to restore the image.  If 
this becomes an issue, we can always use the kexec approach to restore the 
image, even if that required a double kexec boot to slot in the hibernation 
kernel, as kexec boot overhead is low.

> (5) Hibernation should be transparent from the applications' point of view
>
>     Generally, applications should not notice that hibernation took place.
>     [Note that I don't regard all processes as applications and I think
> that there may be processes which need to handle the hibernation in a
> special way.]  Ideally, for example, if some audio is being played when a
> hibernation starts, the audio player should be able to continue playing
> the same audio after the restore from the point in which it has been
> interrupted by the hibernation.  Also, the CPU affinities and similar
> settings requested by the applications before a hibernation should be
> binding after the restore.

Using kexec may be as transparent as it gets.  What's critical here, is to 
never try memory dependent operations from within the normal kernel, not 
even backup, as that would get you into an inter-dependency mess we dearly 
want to avoid.

> (6) State of devices from before hibernation should be restored, if
> possible
>
>     If possible, during a restore devices should be brought back to the
> same state in which they were before the corresponding hibernation.  Of
> course in some situations it might be impossible to do that (eg. the user
> connected the hibernated system to a different IP subnet and then
> restored), but as a general rule, we should do our best to restore the
> state of devices, which is directly related to point (5) above.

This part could easily be handled by the normal kernel before and after 
resume.

> (7) On ACPI systems special platform-related actions have to be carried
> out at the right points, so that the platform works correctly after the
> restore
>
>     The ACPI specification requires us to invoke some global ACPI methods
>     during the hibernation and during the restore.  Moreover, the ordering
> of code related to these ACPI methods may not be arbitrary (eg. some of
> them have to be executed after devices are put into low power states
> etc.).

This should be the responsibility of the kexec'd hibernating kernel.  Note 
though in (6), the normal kernel takes care of preparing devices, then the 
hibernating kernel dumps the image and either calls S4 or S3.  On resume 
from S3 it can immediately switch over to the normal kernel, and from S4 the 
known bootup would occur.

> (8) Hibernation and restore should not be too slow
>
>     In my opinion, if more than one minute is needed to hibernate the
> system with the help of certain hibernation framework, then this framework
> is not very useful in practice.  It might be useful to perform some
> special tasks (eg. moving a server to another place without taking it
> down), but it is not very useful, for example, to notebook users.

The latest hibernating kexec patches boot a kexec'd modular kernel with 
initramfs into crashkernel=16M@16M in less than one second.  Switch-back is 
almost instant.  Add to this the time required to either store or restore 
the image, and it may be obvious that this approach isn't slower, but maybe 
even faster than the current swsusp.


Thanks!

--
Al

