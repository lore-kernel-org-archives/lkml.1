Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYKYXOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYKYXOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKYXOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:14:22 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51630 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbYKYXOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:14:21 -0500
Subject: Re: [Patch 3/3] OProfile SPU event profiling support for IBM Cell
	processor
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org
In-Reply-To: <200811251658.32327.arnd@arndb.de>
References: <1227569215.6509.216.camel@carll-linux-desktop>
	 <200811251658.32327.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 15:13:25 -0800
Message-Id: <1227654805.6509.263.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-11-25 at 16:58 +0100, Arnd Bergmann wrote:

<snip>

> >  struct pmc_cntrl_data {
> >  	unsigned long vcntr;
> > @@ -111,6 +126,8 @@ struct pm_cntrl {
> >  	u16 trace_mode;
> >  	u16 freeze;
> >  	u16 count_mode;
> > +	u16 spu_addr_trace;
> > +	u8  trace_buf_ovflw;
> >  };
> >  
> >  static struct {
> > @@ -128,7 +145,7 @@ static struct {
> >  #define GET_INPUT_CONTROL(x) ((x & 0x00000004) >> 2)
> >  
> >  static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
> > -
> > +static unsigned long spu_pm_cnt[MAX_NUMNODES * NUM_SPUS_PER_NODE];
> >  static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
> 
> Can't you add this data to an existing data structure, e.g. struct spu,
> rather than adding a new global?

The data structure above holds flags for how the performance counters
are to be setup on each node.  This is not per SPU data.  It is per
system data.  The flags are setup once and then used when configuring
the various performance counter control registers on each node via one
of the PPU threads on each node.

<snip>

> > +
> > +void stop_spu_profiling_events(void)
> > +{
> > +	spu_prof_running = 0;
> >  }
> 
> Is this atomic? What if two CPUs access the spu_prof_running variable at
> the same time?
> 
> 	Arnd <><

When the user issues the command opcontrol --start then a series of
functions gets called by one CPU in the system that eventually gets down
to making the assignment spu_prof_running = 1.  Similarly, the variable
is set to 0 when the user executes the command opcontrol --stop.  In
each case, only one CPU in the system is executing the code to change
the value of the flag.  Once OProfile is started, you can't change the
event being profiled until after oprofile is stopped.  Hence, you can't
get the situation where spu_prof_running is set by the start and not
reset by the next stop command.  Now, as for multiple users issuing
opcontrol --start and/or opcontrol --stop at the same time, there is no
protection at the user level to prevent this.  If this occurs, then what
happens will depend on the order the OProfile file system serializes the
writes file for start/stop.  It is up to the users to not step on each
other.  If they do, the chances are they both will get bad data.

The other things you noted for this patch were easily fixed up.

