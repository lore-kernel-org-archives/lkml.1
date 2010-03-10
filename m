Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0CJORi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:17:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46749 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0CJORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:17:36 -0500
Date: Wed, 10 Mar 2010 23:16:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 	platform
Message-ID: <20100310141645.GB22729@linux-sh.org>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com> <4B973CF6.4030009@st.com> <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com> <4B977067.3050108@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B977067.3050108@st.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 03:41:51PM +0530, Viresh KUMAR wrote:
> On 3/10/2010 3:01 PM, Linus Walleij wrote:
> > 2010/3/10 Viresh KUMAR <viresh.kumar@st.com>:
> >> Linus Walleij:
> >>> If this file is only supposed to be used from plat-spear/time.c, move it down
> >>> into plat-spear/gpt.h and #include "gpt.h" so noone else will
> >>> accidentally use it.
> >>
> >> GPT's on SPEAr can be used from time.c, platform specific drivers and machine
> >> specific drivers or any driver wishing to use hardware timer.
> >> In first two cases "gpt.h" will work, but in rest of cases we need gpt.h to be
> >> in plat-spear/include/plat
> >>
> >> Is it okay?
> > 
> > If you have or have already planned to write such platform, machine
> > or subsystem drivers, it's OK, if there are no such users and you cannot
> > easily give one, it's overdesigned IMHO. Some realistic examples of such
> > drivers will make me change my mind :-)
> > 
> > The reason I persist is that I've seen such unutilized timer API:s before and
> > no other user than the system timer in sight. I never understood what they
> > were to be used for, and I still don't, so help me understand. The kernel
> > has many internal timer API:s based on clockevent available already so
> > why add yet another, platform-specific one?
> > 
> 
> As you may have seen in spear.h files in mach folders, we have multiple hardware
> timers in our design (3 in spear3xx, 4 in spear6xx and each timer have two
> independent channels. That doubles the timers count, so it is 6 and 8).
> One timer (or two channels) are used by clock event and clock source, but rest of
> the timers are still available. So we need some way to export this functionality
> of our hardware. It can be considered simply as a driver for GPT.
> 
> What do you say?
> 
This is hardly a unique situation for your platform, this is true for
most platforms. There's no reason why clockevents couldn't just be
extended and drivers could then just grab unused clockevents and pin them
accordingly. Most of the infrastructure is already in place for something
like that, without really having to do anything special.

Having said that, most drivers have pretty lame reasons for trying to get
at fixed timer channels, and most of the time they can easily get by with
an hrtimer instead. There's also the issue that you're effectively
bypassing nohz by having some timer channel off on the side doing who
knows what. You would need a pretty compelling reason for why you are
sidestepping all of the existing infrastructure anyways.

There are still some legitimate users for dedicated timers that we may
want to have decoupled from sched_clock() (like the trace clock) and so
on, but when people start rolling their own timer APIs it always sets off
warning bells, as it's almost always because they want to do something in
a driver that existing infrastructure already provides for them.

In cases like these, it's better to see what precisely you plan to do
with these timer channels before getting in to API semantics, though.
