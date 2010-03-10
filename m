Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0CJXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:30:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48075 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab0CJXaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:30:07 -0500
Date: Thu, 11 Mar 2010 08:29:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Viresh KUMAR <viresh.kumar@st.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr platform
Message-ID: <20100310232914.GC22729@linux-sh.org>
References: <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com> <4B973CF6.4030009@st.com> <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com> <4B977067.3050108@st.com> <20100310141645.GB22729@linux-sh.org> <alpine.LFD.2.00.1003101732010.22855@localhost.localdomain> <20100310221652.GS2900@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310221652.GS2900@atomide.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 02:16:53PM -0800, Tony Lindgren wrote:
> * Thomas Gleixner <tglx@linutronix.de> [100310 08:38]:
> > On Wed, 10 Mar 2010, Paul Mundt wrote:
> > > This is hardly a unique situation for your platform, this is true for
> > > most platforms. There's no reason why clockevents couldn't just be
> > > extended and drivers could then just grab unused clockevents and pin them
> > > accordingly. Most of the infrastructure is already in place for something
> > > like that, without really having to do anything special.
> > > 
> > > Having said that, most drivers have pretty lame reasons for trying to get
> > > at fixed timer channels, and most of the time they can easily get by with
> > > an hrtimer instead. There's also the issue that you're effectively
> > > bypassing nohz by having some timer channel off on the side doing who
> > > knows what. You would need a pretty compelling reason for why you are
> > > sidestepping all of the existing infrastructure anyways.
> > 
> > Right, and that's exactly the reason why we did not add the few
> > missing bits to make clock events directly usable from drivers.
> 
> Yeah still no direct users so far for the 12 hardware timers on
> omaps.. I guess the only use I could see is bit banging data
> over a few GPIO lines using a FIQ handler.
> 
> Another thing to consider is that most likely all hardware timers
> are not able to wake up the system from idle, which would easily
> cause some mysterious errors for drivers.
> 
Even if most drivers shouldn't be touching clockevents directly, there
are still legitimate cases. In SMP configurations where a single timer
block is shared across multiple CPUs it would be easier to have the boot
CPU register all of the timer channels under clockevents and have the
secondaries grab one at random for setting up their local timers. (Even
if they're not truly "local" timers, it's still a better situation than
broadcast IPIs). clockevents would need some minor extension, including
dealing with unregistration for the CPU hotplug case, but it's a pretty
good fit for the problem otherwise.

If all timer channels are equal then there's also the possibility of
matching device IDs against the CPU's struct device, but depending on the
CPU topology is a pretty dire hack, particularly as most timer channels
have differing capabilities.
