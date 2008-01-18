Return-Path: <linux-kernel-owner+w=401wt.eu-S1765137AbYARUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765137AbYARUAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbYARUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:00:33 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:29272 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760112AbYARUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nz/omsKln2H7xAAoO8ObHgaRxn34RAPvfrmbR1mWPOcu83Z1jVFM8D5uIjjt6NAlUic7QQ55tg1s44Own9MBsyYxTJX2D6RmRyvqwP/UWS4bX+qQp7sb3AdipZSmP2g0spxKJS84p1H9MhgQ/tRq0EWgIAqsXuae3Q5yR2s3zHA=
Message-ID: <170fa0d20801181200p50556132v3a9bafc9ad9e8c91@mail.gmail.com>
Date: Fri, 18 Jan 2008 15:00:28 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Martin Knoblauch" <spamtrap@knobisoft.de>,
       "Fengguang Wu" <wfg@mail.ustc.edu.cn>,
       "Peter Zijlstra" <peterz@infradead.org>, jplatte@naasa.net,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       James.Bottomley@steeleye.com
In-Reply-To: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <166634.14296.qm@web32603.mail.mud.yahoo.com>
	 <20080118160123.GB11840@csn.ul.ie>
	 <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 12:46 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 18 Jan 2008, Mel Gorman wrote:
> >
> > Right, and this is consistent with other complaints about the PFN of the
> > page mattering to some hardware.
>
> I don't think it's actually the PFN per se.
>
> I think it's simply that some controllers (quite probably affected by both
> driver and hardware limits) have some subtle interactions with the size of
> the IO commands.
>
> For example, let's say that you have a controller that has some limit X on
> the size of IO in flight (whether due to hardware or driver issues doesn't
> really matter) in addition to a limit on the size of the scatter-gather
> size. They all tend to have limits, and they differ.
>
> Now, the PFN doesn't matter per se, but the allocation pattern definitely
> matters for whether the IO's are physically contiguous, and thus matters
> for the size of the scatter-gather thing.
>
> Now, generally the rule-of-thumb is that you want big commands, so
> physical merging is good for you, but I could well imagine that the IO
> limits interact, and end up hurting each other. Let's say that a better
> allocation order allows for bigger contiguous physical areas, and thus
> fewer scatter-gather entries.
>
> What does that result in? The obvious answer is
>
>   "Better performance obviously, because the controller needs to do fewer
>    scatter-gather lookups, and the requests are bigger, because there are
>    fewer IO's that hit scatter-gather limits!"
>
> Agreed?
>
> Except maybe the *real* answer for some controllers end up being
>
>   "Worse performance, because individual commands grow because they don't
>    hit the per-command limits, but now we hit the global size-in-flight
>    limits and have many fewer of these good commands in flight. And while
>    the commands are larger, it means that there are fewer outstanding
>    commands, which can mean that the disk cannot scheduling things
>    as well, or makes high latency of command generation by the controller
>    much more visible because there aren't enough concurrent requests
>    queued up to hide it"
>
> Is this the reason? I have no idea. But somebody who knows the AACRAID
> hardware and driver limits might think about interactions like that.
> Sometimes you actually might want to have smaller individual commands if
> there is some other limit that means that it can be more advantageous to
> have many small requests over a few big onees.
>
> RAID might well make it worse. Maybe small requests work better because
> they are simpler to schedule because they only hit one disk (eg if you
> have simple striping)! So that's another reason why one *large* request
> may actually be slower than two requests half the size, even if it's
> against the "normal rule".
>
> And it may be that that AACRAID box takes a big hit on DIO exactly because
> DIO has been optimized almost purely for making one command as big as
> possible.
>
> Just a theory.

Oddly enough, I'm seeing the opposite here with 2.6.22.16 w/ AACRAID
configured with 5 LUNS (each 2disk HW RAID0, 1024k stripesz).  That
is, with dd the avgrqsiz (from iostat) shows DIO to be ~130k whereas
non-DIO is a mere ~13k! (NOTE: with aacraid, max_hw_sectors_kb=192)

DIO cmdline:  dd if=/dev/zero of=/dev/sdX bs=8192k count=1k
non-DIO cmdline: dd if=/dev/zero of=/dev/sdX bs=8192k count=1k

DIO is ~80MB/s on all 5 LUNs for a total of ~400MB/s
non-DIO is only ~12MB on all 5 LUNs for a mere ~70MB/s aggregate
(deadline w/ nr_requests=32)

Calls into question the theory of small requests being beneficial for
AACRAID.  Martin, what are you seeing for the avg request size when
you're conducting your AACRAID tests?

I can fire up 2.6.24-rc8 in short order to see if things are vastly
improved (as Martin seems to indicate that he is happy with AACRAID on
2.6.24-rc8).  Although even Martin's AACRAID numbers from 2.6.19.2 are
still quite good (relative to mine).  Martin can you share any tuning
you may have done to get AACRAID to where it is for you right now?

regards,
Mike
