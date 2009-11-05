Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZKETL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZKETL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZKETLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:11:38 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:39281 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbZKETLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:11:35 -0500
To: "TuxOnIce users' list" <tuxonice-users@lists.tuxonice.net>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [TuxOnIce-users] An assortment of TuxOnIce resume panics on a Radeon KMS-running system in 2.6.31.5, lzo-related?
References: <87ocnim1bj.fsf@spindle.srvr.nix> <4AF1F611.6050206@crca.org.au>
	<874op9n8k7.fsf@spindle.srvr.nix> <4AF21DA2.6060601@crca.org.au>
From: Nix <nix@esperi.org.uk>
Emacs: more boundary conditions than the Middle East.
Date: Thu, 05 Nov 2009 19:11:33 +0000
In-Reply-To: <4AF21DA2.6060601@crca.org.au> (Nigel Cunningham's message of "Thu, 05 Nov 2009 11:34:42 +1100")
Message-ID: <87d43wlrbu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Nov 2009, Nigel Cunningham uttered the following:

>> It's odd that it manifested as a decompressor failure. I suppose if
>> something corrupts the data en route to or from the disk you might see
>> this? (wild speculation: maybe ordinary swapping happened on top of it,
>> though this seems rather unlikely).
>
> Well, if I've got an error in the algorithm for deciding which device to
> read/write next (this is what I've been modifying), it makes sense.

Ew. Yeah, that would cause all *sorts* of problems :)

I just turned off all but one swap partition and did some hibernate/resume
rounds. The first four worked fine, but on the fifth, well, at the end of
the cache restoration phase (tuxonice_userui had kicked up and was at 100%),
it said

'Read of data failed --- press SPACE to continue'

and when I did so:

kernel panic: Read chunk returned (1)
Reboot in 5 seconds...

(followed by, uh, no reboot)

Different symptoms, not sure if it's a different bug.

>> I'm impressed with how well ToI works, btw: it must have saved me about
>> twenty quid in power costs on this desktop box already and I've only
>> been using it for a couple of months. I was even more impressed that
>> nothing went wrong when I started using KMS, once I'd boosted the
>> reserved pages enough: took a while to figure out the cause of those
>> crashes, though. Maybe you should print a very loud message when the
>> number of reserved pages that haven't been consumed drops below some
>> smallish number, if it's detectable, 'cos right now exceeding it
>> generally results in a crash at suspension time and newbies like me
>> can't tell the cause easily...
>
> Not having a big enough allowance for drivers' memory allocations
> shouldn't cause problems. There's code in place to automatically back
> out and retry with a larger allocation and then abort if that doesn't
> work, and I've never had a report of it not working before now. (You'll
> see messages in dmesg if this happens). If you have userui enabled, it
> will also tell you it's restarting and why.

Er, yeah, well, sort of. What I saw was that immediately after 'Atomic
copy/restore' (just after the screen flashes to black as KMS is
suspended), the progress bar flips back to zero: it briefly states
'Preparing image, try I' (which isn't something it says at the start of
the hibernate run), and restarts the hibernation process: upon
resumption the extra_pages count has risen (to 34613 in my case). I'm
not sure 'Preparing image, try I' really says what's going on, not least
since it's actually try II :)

(I had a strange failure a couple of days ago where it did that and then
the second atomic copy/restore basically soft-froze: the keyboard worked
and tuxonice_userui responded to keys like R and ESC by changing the
state of the screen, but it never left what it claimed was atomic
copy/restore and aborts of hibernation never came back to me. After ten
minutes I just turned the box off...)


It's peculiar, too. I suspect I ran out of extra pages in this case, so
it auto-restarted, but what I see in /sys/power/tuxonice/debug_info is

- Extra pages    : 610 used/34613.

Now the kernel-configured extra page allowance is 20000, so it's plainly
boosted it... but to then use only 610 of them? Weird. I'm happy to
boost it (at least I am as long as these pages are only reserved during
hibernation), but still it's strange.
