Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbZKXRYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbZKXRYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbZKXRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:24:40 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:63968 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZKXRYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UOYIO1ERinbc6SXQUJ7CVQplNSdiRFsjo3wlQfS6lVfZEH0h9Kd0KVSMU+/B4AFHxv
         kdFXtFhkilNNEjkuYOqYnx0cCfK4T8r0PcgSkWUWeA85sqQrULiAAqcI14lQ9SrgUcv+
         j9Xg+yutKC2+MVHKblM2vODpHiQI4ELNKQyGU=
MIME-Version: 1.0
In-Reply-To: <20091124063653.GB20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> 
	<20091123114550.GB25575@elte.hu> <20091123120100.GC2287@wotan.suse.de> 
	<20091123120849.GB32009@elte.hu> <20091123122731.GE2287@wotan.suse.de> 
	<20091123124615.GA27808@elte.hu> <20091124063653.GB20981@wotan.suse.de>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Tue, 24 Nov 2009 09:24:26 -0800
Message-ID: <28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com>
Subject: Re: newidle balancing in NUMA domain?
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quite a few being one test case, and on a program with a horrible
> parallelism design (rapid heavy weight forks to distribute small
> units of work).

> If x264 is declared dainbramaged, that's fine with me too.

We did multiple benchmarks using a thread pool and it did not help.
If you want to declare our app "braindamaged", feel free, but pooling
threads to avoid re-creation gave no benefit whatsoever.  If you think
the parallelism methodology is wrong as a whole, you're basically
saying that Linux shouldn't be used for video compression, because
this is the exact same threading model used by almost every single
video encoder ever made.  There are actually a few that use
slice-based threading, but those are actually even worse from your
perspective, because slice-based threading spawns mulitple threads PER
FRAME instead of one per frame.

Because of the inter-frame dependencies in video coding it is
impossible to efficiently get a granularity of more than one thread
per frame.  Pooling threads doesn't change the fact that you are
conceptually creating a thread for each frame--it just eliminates the
pthread_create call.  In theory you could do one thread per group of
frames, but that is completely unrealistic for real-time encoding
(e.g. streaming), requires a catastrophically large amount of memory,
makes it impossible to track the bit buffer, and all other sorts of
bad stuff.

Jason Garrett-Glaser
