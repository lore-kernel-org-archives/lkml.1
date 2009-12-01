Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZLAISe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZLAISe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZLAISe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:18:34 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59234 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZLAISd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yHu2H5YTW8Q7i+j1/tsb3GxuuAicIOrqfQG2PffpfUXnxvuQWSqxLlEe6E4JwgekFh
         jD7Z5TZwqQxDyNv/v16qtDQtlYzzPCAyRbJf1no6tHd8WB5AnH/Q7NIro+m811KpA70t
         OVzmV6xDMhoJmDwQGeufqG5D46WtLF7horJkQ=
MIME-Version: 1.0
In-Reply-To: <20091130081918.GM17484@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> 
	<20091123114550.GB25575@elte.hu> <20091123120100.GC2287@wotan.suse.de> 
	<20091123120849.GB32009@elte.hu> <20091123122731.GE2287@wotan.suse.de> 
	<20091123124615.GA27808@elte.hu> <20091124063653.GB20981@wotan.suse.de> 
	<28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com> 
	<20091130081918.GM17484@wotan.suse.de>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Tue, 1 Dec 2009 00:18:19 -0800
Message-ID: <28f2fcbc0912010018mb2d2f5ahf96c5eddb5018801@mail.gmail.com>
Subject: Re: newidle balancing in NUMA domain?
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 12:19 AM, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Nov 24, 2009 at 09:24:26AM -0800, Jason Garrett-Glaser wrote:
>> > Quite a few being one test case, and on a program with a horrible
>> > parallelism design (rapid heavy weight forks to distribute small
>> > units of work).
>>
>> > If x264 is declared dainbramaged, that's fine with me too.
>>
>> We did multiple benchmarks using a thread pool and it did not help.
>> If you want to declare our app "braindamaged", feel free, but pooling
>> threads to avoid re-creation gave no benefit whatsoever.  If you think
>> the parallelism methodology is wrong as a whole, you're basically
>> saying that Linux shouldn't be used for video compression, because
>> this is the exact same threading model used by almost every single
>> video encoder ever made.  There are actually a few that use
>> slice-based threading, but those are actually even worse from your
>> perspective, because slice-based threading spawns mulitple threads PER
>> FRAME instead of one per frame.
>>
>> Because of the inter-frame dependencies in video coding it is
>> impossible to efficiently get a granularity of more than one thread
>> per frame.  Pooling threads doesn't change the fact that you are
>> conceptually creating a thread for each frame--it just eliminates the
>> pthread_create call.  In theory you could do one thread per group of
>> frames, but that is completely unrealistic for real-time encoding
>> (e.g. streaming), requires a catastrophically large amount of memory,
>> makes it impossible to track the bit buffer, and all other sorts of
>> bad stuff.
>
> If you can scale to N threads by having 1 frame per thread, then
> you can scale to N/2 threads and have 2 frames per thread. Can't
> you?
>
> Is your problem in scaling to a large N?
>
>

x264's threading is described here:
http://akuvian.org/src/x264/sliceless_threads.txt

By example (3 threads), simplified:

Step 0:
Frame 0: 0% done

Step 1:
Frame 0: 33% done
Frame 1: 0% done

Step 2:
Frame 0: 66% done
Frame 1: 33% done
Frame 2: 0% done

Step 3:
Frame 0: 100% done
Frame 1: 66% done
Frame 2: 33% done
Frame 3: 0% done

Step 4:
Frame 1: 100% done
Frame 2: 66% done
Frame 3: 33% done
Frame 4: 0% done

(etc)

The motion search is restricted so that, for example, in Step 3, frame
2 doesn't look beyond the completed 66% of frame 1.

There's room reserved in terms of height for sync so that each thread
doesn't have to be exactly in lock-step with the others.  This avoids
most unnecessary waiting.

The problem is that each frame is inherently one "work unit".  Its
dependencies all consist on the previous frame (Frame 1 depends on
Frame 0).  It doesn't make any sense to try to lump multiple frames
together into a work unit when the dependencies don't work that way.
Just dumping two frames arbitrarily in one thread turns this into a
thread pool, which as mentioned previously probably wouldn't help
significantly.  If you meant working on two frames simultaneously in
the same thread, that's even worse--it's going to be a cache thrashing
disaster, since the scheduler can no longer move two threads to
separate cores, and you now have two totally separate sets of
processing trying to dump themselves into the same cache.
Furthermore, that doesn't reduce the main limitation on threading: the
vertical height of the frame.

Also, another thing to note is that "fast thread creation" isn't the
only problem here: the changes to the scheduler gave x264 enormous
speed boosts even at *slower* encoding modes.  One user reported a
gain from 25fps -> 39fps, for example; that's dozens of milliseconds
per thread, far longer than I would think would cause problems due to
threads being too short lived.  You should probably consider doing
some testing with slower encoding as well, both in terms of fast
settings and high-resolution inputs--and slow settings with
low-resolution inputs, where the bottleneck is purely computational.

Some resources for such testing:

1.  http://media.xiph.org/video/derf/ has a lot of free test clips (HD
ones at the bottom).
2.  x264 --help lists a set of presets from "ultrafast" to "placebo"
which can be used for testing purposes.  "veryslow" and "placebo" are
probably not very suitable as they often tend to be horrifically
lookahead-bottlenecked.

Jason
