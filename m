Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0CLEdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:33:11 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60393 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0CLEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:33:08 -0500
MIME-Version: 1.0
In-Reply-To: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Mar 2010 05:32:48 +0100
Message-ID: <ac3eb2511003112032s6d4b097aqda02143edfec5a3@mail.gmail.com>
Subject: Re: firmware loading vs. initrd
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 23:39, Johannes Berg <johannes@sipsolutions.net> wrote:
> We recently converted a few wireless drivers to use
> request_firmware_nowait() in order to be able to load firmware from
> probe. We would like to continue with that so we can load the firmware
> before registering with any other subsystems, as we had discussed at the
> wireless summit last year.
>
> However, in actually trying this today, I noticed that there's a problem
> with this. I made my drivers all built in, and then I ended up with it
> not working because the firmware agent that was in my initrd was telling
> [1], and the kernel that the firmware could not be found.
>
> I thought of modifying the firmware agent in the initrd to not tell the
> kernel it doesn't have it, but that is problematic when using
> request_firmware(), the kernel boot will be delayed until the timeout
> (one minute).
>
> This can be solved by adding an environment variable to the uevent that
> tells userspace whether or not this is coming from request_firmware() or
> request_firmware_nowait(). I will follow up with a patch doing that.
>
> Additionally, however, we need to make a change like below to the
> firmware agent in order to not reply to asynchronous firmware loads
> during the initrd stage. I'm not sure how to actually check that we're
> running in an initrd (is that possible?) nor did I actually verify that
> the NOWAIT environment variable is set properly.
>
> Thoughts? It seems like this would solve our problems nicely if we can
> determine whether we're in the initrd or not.

I don't think we can reliably make the decision that the firmware is
not available at a later point.

Depending on the system, we can have several re-trigger of the same
events during bootup, and the firmware loader does not have any idea
in which state the system is.

What's wrong to leave the request staying around for forever, until it
is possibly canceled from userspace? So this event could be
re-triggered from userspace any time later. Whatever will cancel the
firmware requests in the end, it needs to be something that knows more
about the state of "booting" than the firmware loader knows today, I
guess.

Thanks,
Kay
