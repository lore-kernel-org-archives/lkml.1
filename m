Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYD2NHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYD2NHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYD2NHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:07:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:38355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYD2NHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:07:05 -0400
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <lenb@kernel.org>,
       Matthew <jackdachef@gmail.com>, linux-acpi@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>, "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <1209406784.11608.15.camel@localhost>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <200804182151.49021.lenb@kernel.org>
	 <200804231143.10875.maximlevitsky@gmail.com>
	 <1209406784.11608.15.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Tue, 29 Apr 2008 15:07:03 +0200
Message-Id: <1209474423.1784.837.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 20:19 +0200, Kasper Sandberg wrote:
> On Wed, 2008-04-23 at 11:43 +0300, Maxim Levitsky wrote:
> > On Saturday, 19 April 2008 04:51:48 Len Brown wrote:
> > > On Friday 18 April 2008, Matthew wrote:
> > > > Hi everyone, hi Linus,
> > > > 
> > > > congratulations on this new great kernel-release :)
> > > > 
> > > > I've another "regression" to report for 2.6.25:
> > > > 
> > > > it's concerning much higher temperatures being read out by the
> > > > "coretemp" kernel-module in comparison to 2.6.24* series
> > > > 
> > > > e.g. where temperatures were around 40-47°C they are now constantly
> > > > jumping around 55-70°C (even in idle !)
> > 
> > I just updated from 2.6.24 to 2.6.25
> > (I usually follow whole development cycle, but I was very busy, so I skipped 2.6.25 cycle)
> > 
> > I confirm this.
> > I *know* that temperatures reported now are wrong.
> 
> I too can confirm that it reports incorrect temperatures.
> 
> I have a Q9450, and this is my "sensors" output:
> it8718-isa-0290
> Adapter: ISA adapter
> <snip>
> temp1:       +44Â°C  (low  =  +127Â°C, high =  +127Â°C)   sensor =
> thermistor
> temp2:       +22Â°C  (low  =  +127Â°C, high =   +60Â°C)   sensor = diode
> temp3:        -2Â°C  (low  =  +127Â°C, high =  +127Â°C)   sensor =
> thermistor
> vid:      +0.000 V
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> Core 0:      +44Â°C  (high =  +100Â°C)
> 
> coretemp-isa-0001
> Adapter: ISA adapter
> Core 1:      +44Â°C  (high =  +100Â°C)
> 
> coretemp-isa-0002
> Adapter: ISA adapter
> Core 2:      +43Â°C  (high =  +100Â°C)
> 
> coretemp-isa-0003
> Adapter: ISA adapter
> Core 3:      +41Â°C  (high =  +100Â°C)
> 
> 
> temp2 is the cpu temperature(matches bios), temp1 is the northbridge(i
> think, bios says "system temp").
> 
> i have watercooling, and well :P when i touch the "tube", its normal
> room temperature, and believe me, i would notice if it was 45.. this is
> with my cpu at idle - at full load on all 4 cores, temp2 says 35, and
> ~60 on coretemp, and THIS i would surely be able to notice over room
> temp :)
> 
> any progress on this bug?
> 
> > 
> > The reason is that bios did report same temperatures as coretemp in 2.6.24,
> > moreover some time ago I have run a cpu tool (don't remember its name) on windows
> > which similar to coretemp reads from each core directly, sensor data , 
> > and I noticed that temperature that bios reports is exactly the average 
> > temperature of both cores
> > (I had to run this on windows - intel haven't released 
> > drivers for their QST for temperature monitoring from bios - very sad)
> > 
> > And the driver did say in kernel log that TJMAX is 85C
> > 
> > Lets at least make a kernel option to override tjmax?
> > 

Could it be that due to latest thermal changes ACPI is reading
temperatures more often, or started to read sensors that interfere with
libsensors?

There was a patch-set that detect such interference from myself and Jean
which was not accepted by Linus.
This is what I got from Jean recently, he should be able to point you to
the latest patches if you want to give them a try:
----------------------------------------------
On Mon, 28 Apr 2008 22:13:13 -0700, Andrew Morton wrote:
> In light of Linus's dummyspit last time around I guess I'll drop
> this patch.

That's OK, I'll include it in my i2c tree instead. While Linus doesn't
like it, he didn't actually provide replacement code, only a vague idea
which Thomas and myself know by experience, won't work well anyway. As
the checks done by this driver are valuable, having it in -mm and
linux-next is still good.

-- 
Jean Delvare
----------------------------------------------


If you get a conflict you should see something like this when loading
the hwmon/sensor driver:
i2c /dev entries driver
f71805f: Found F71805F/FG chip at 0x290, revision 19
ACPI: I/O resource f71805f [0x290-0x297] conflicts with ACPI region IP__ [0x295-0x296]
ACPI: Device needs an ACPI driver

   Thomas

