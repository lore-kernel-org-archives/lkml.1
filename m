Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZCRAUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZCRAUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZCRAUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:20:10 -0400
Received: from mail-ew0-f168.google.com ([209.85.219.168]:58871 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZCRAUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gk6f4B+0725e+y4uZjFEVFvyFE1WZ2OmzAC88biKBcs4j77xDsZ2rn2OvfA5nsrf0I
         7y7963DK0B3ezQvei7YwI1f/bcRjVLM+6LteC+xyq5eb8xXtCNwvw3vQfJm5oe4xqLXP
         e7qPUqGKibdwhbX0aIFmn6SyGay42HSsjPssg=
Date: Wed, 18 Mar 2009 01:20:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090318001955.GB5143@nowhere>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au> <20090316200736.GD8393@nowhere> <1237244137.4964.54.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237244137.4964.54.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:25:37AM +1030, Kevin Shanahan wrote:
> On Mon, 2009-03-16 at 21:07 +0100, Frederic Weisbecker wrote:
> > I've looked a bit at your traces.
> > I think it's probably too wide to find something inside.
> > Latest -tip is provided with a new set of events tracing, meaning
> > that you will be able to produce function graph traces with various
> > sched events included.
> > 
> > Another thing, is it possible to reproduce it with only one ping?
> > Or testing perioding pings and keep only one that raised a relevant
> > threshold of latency? I think we could do a script that can do that.
> > It would make the trace much clearer.
> 
> Yeah, I think that should be possible. If you can come up with such a
> script, that would be great.

Ok, I've made a small script based on yours which could do this job.
You will just have to set yourself a threshold of latency
that you consider as buggy. I don't remember the latency you observed.
About 5 secs right?

It's the "thres" variable in the script.

The resulting trace should be a mixup of the function graph traces
and scheduler events which look like this:

 gnome-screensav-4691  [000]  6716.774277:   4691:120:S ==> [000]     0:140:R <idle>
  xfce4-terminal-4723  [001]  6716.774303:   4723:120:R   + [001]  4289:120:S Xorg
  xfce4-terminal-4723  [001]  6716.774417:   4723:120:S ==> [001]  4289:120:R Xorg
            Xorg-4289  [001]  6716.774427:   4289:120:S ==> [001]     0:140:R <idle>

+ is a wakeup and ==> is a context switch.


The script will loop trying some pings and will only keep the trace that matches
the latency threshold you defined.

Tell if the following script work for you.

You will need to pull the latest -tip tree and enable the following:

CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_EVENT_TRACER=y

Thanks!

Ah and you will need python too (since bash can't do floating point
operation, it uses python here).

#!/bin/bash

# Switch off all CPUs except for one to simplify the trace
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online


# Make sure debugfs has been mounted
if [ ! -d /sys/kernel/debug/tracing ]; then
    mount -t debugfs debugfs /sys/kernel/debug
fi

# Set up the trace parameters
pushd /sys/kernel/debug/tracing || exit 1
echo 0 > tracing_enabled
echo function_graph > current_tracer
echo funcgraph-abstime > trace_options
echo funcgraph-proc    > trace_options

# Set here the kvm IP addr
addr=""

# Set here a threshold of latency in sec
thres="5"
found="False"
lat=0
prefix=/sys/kernel/debug/tracing

echo 1 > $prefix/events/sched/sched_wakeup/enable
echo 1 > $prefix/events/sched/sched_switch/enable

while [ "$found" != "True" ]
do
	# Flush the previous buffer
	echo nop > $prefix/current_tracer

	# Reset the function_graph tracer
	echo function_graph > $prefix/current_tracer

	echo 1 > $prefix/tracing_enabled
	lat=$(ping -c 1 $addr | grep rtt | grep -Eo " [0-9]+.[0-9]+")
	echo 0 > $prefix/tracing_enabled

	found=$(python -c "print float(str($lat).strip()) > $thres")
	sleep 0.01
done

echo 0 > $prefix/events/sched/sched_wakeup/enable
echo 0 > $prefix/events/sched/sched_switch/enable


echo "Found buggy latency: $lat"
echo "Please send the trace you will find on $prefix/trace"



> 
> > Just wait a bit, I'm looking at which event could be relevant to enable
> > and I come back to you with a set of commands to test.
> 
> Excellent! Thanks for looking into this.
> 
> Cheers,
> Kevin.
> 
> 

