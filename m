Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYCYX1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYCYX1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYCYX1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:27:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbYCYX1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:27:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Date: Tue, 25 Mar 2008 19:27:14 -0400
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <57127.43039.qm@web25812.mail.ukl.yahoo.com>
In-Reply-To: <57127.43039.qm@web25812.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251927.14211.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008, Michael Meyer wrote:
> 
> --- Andi Kleen <andi@firstfloor.org> schrieb:
> 
> > Luciano Rocha <luciano@eurotux.com> writes:
> > 
> > > On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael
> > Meyer wrote:
> > > > Hi, 
> > > > 
> > > > what is the difference between booting a dual
> > core
> > > > machine with "maxcpus=1" or by deactivating the
> > second
> > > > core at run time with "echo 0 >
> > > > /sys/devices/system/cpu/cpu1/online"?
> > > 
> > > maxcpus=1 should turn off the SMP alternative and
> > switch to UP only,
> > > optimising some locks and instructions.
> > 
> > CPU hot unplug will do the same. But it is unlikely
> > it accounts
> > for that much performance difference.
> > 
> > If he used maxcpus=0 it would make sense. maxcpus=0
> > disables
> > the IO-APIC which likely makes a large difference.
> > But it should
> > be actually slower.
> > 
> > There should be actually no difference in theory
> > between max_cpus=1
> > and hot unplug to one CPU. Might be some bug.
> 
> I had the following time values:
> 
> maxcpus=1:
> real	0m1.642s
> user	0m1.528s
> sys	0m0.068s
> 
> maxcpus=2 and 
> echo 1 > /sys/devices/system/cpu/cpu1/online:
> real	0m2.579s
> user	0m4.096s
> sys	0m0.160s

this above is the baseline, yes?
it is same as if you used no boot param
and did not touch the online file, yes?

> maxcpus=2 and
> echo 0 > /sys/devices/system/cpu/cpu1/online:
> real	0m3.757s
> user	0m3.632s
> sys	0m0.112s

Please post the contents of 
# grep . /sys/devices/system/cpu/cpu*/cpufreq/*
and also
grep . /proc/acpi/processor/*/power

My guess that the maxcpus=1 case benefits from turbo mode, aka EIDA.
That benefit, however, is subject to this bug:
http://bugzilla.kernel.org/show_bug.cgi?id=5471
because for a single thread to run faster than the marketing MHz,
the other thread must be in deep-idle, which is prevented
by the bug above.

If your scaling_available_frequencies includes 2401000
then you probably have a turbo-mode enabled processor.

one way to verify this would be to disable turbo mode
by pegging the MHz like so:

# echo 2400000 > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
# echo 2400000 > /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq

-Len
