Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYHZL3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYHZL3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYHZL3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:29:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYHZL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:29:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Diggs <kevdig@hypersurf.com>
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
Date: Tue, 26 Aug 2008 13:29:22 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <48B28F23.1000906@hypersurf.com> <200808251343.18027.arnd@arndb.de> <48B354FC.1090001@hypersurf.com>
In-Reply-To: <48B354FC.1090001@hypersurf.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808261329.22699.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18TB4cMQ2hspchoUEOHXWoSG+PqRZGdgfQx37p
 /REy4a0HUMuShGFx9Rn9sJVRGSyZpZIwo5MC0eYDgA+czqxRUI
 OSgSuo0OR+LkRjCdRJxVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Kevin Diggs wrote:
> Arnd Bergmann wrote:
> > On Monday 25 August 2008, Kevin Diggs wrote:

> > Most people list their email address here as well
> > 
> For reasons I'd rather not go into, my email address is not likely
> to remain valid for much longer.

Maybe you should get a freemail account somewhere then.
It's better if people have a way to Cc the author of
a file when they make changes to it.

> > drop the _t here, or make explicit what is meant by it.
> > 
> Now that I look at it the _t is supposed to be at the end. It is
> meant to indicate that this is a structure tag or type. I'll
> remove it.

Ok, thanks for the explanation. I now saw that you also
use '_v' for variables (I guess). These should probably
go the same way.

> >>+static DECLARE_COMPLETION(cf750gx_v_exit_completion);
> >>+
> >>+static unsigned int override_min_core = 0;
> >>+static unsigned int override_max_core = 0;
> >>+static unsigned int minmaxmode = 0;
> >>+
> >>+static unsigned int cf750gx_v_min_core = 0;
> >>+static unsigned int cf750gx_v_max_core = 0;
> >>+static int cf750gx_v_idle_pll_off = 0;
> >>+static int cf750gx_v_min_max_mode = 0;
> >>+static unsigned long cf750gx_v_state_bits = 0;
> > 
> > 
> > Is 0 a meaningful value for these? If it just means 'uninitialized',
> > then better don't initialize them in the first place, for clarity.
> > 
> The first 3 are module parameters. For the first 2, 0 means
> that they were not set. minmaxmode is a boolean. 0 is the
> default of disabled.

Then at least for the first two, the common coding style would
be to leave out the '= 0'. For minmaxmode, the most expressive
way would be to define an enum, like

enum {
	MODE_NORMAL,
	MODE_MINMAX,
};

int minmaxmode = MODE_NORMAL;

> When I was initially writing the code I figured I would
> need the min and max core frequencies in several places.
> As it turns out they are only used in the code
> initialization routine (cf750gx_init()). I have made
> them locals.

ah, good.
 
> ..._idle_pll_off is a boolean for a sysfs attribute. 0 is
> the default of disabled.

ok

> ..._min_max_mode is a boolean to hold the state of
> minmaxmode. Seems to be only used to print the current
> value.

this looks like a duplicate then. why would you need both?
It seems really confusing to have both a cpufreq attribute
and a module attribute with the same name, writing to
different variables. 

> ..._state_bits is a global to maintain state.
> 
> Does the PowerPC suffer any performance penalties when
> accessing shorts compared to ints? Can I save a few bytes
> by using shorts?

Don't bother. Using int is the general way to say 'some number'.
If you use short, people will wonder why you require a 16 bit
number.

> >>+static struct cpufreq_frequency_table *cf750gx_v_f_table;
> >>+static struct cpufreq_frequency_table *cf750gx_v_freq_table;
> >>+static struct cpufreq_frequency_table *cf750gx_v_min_max_freq_table;
> >>+
> >>+static struct cf750gx_t_call_data cf750gx_v_switch_call_data;
> >>+static struct cf750gx_t_call_data cf750gx_v_lock_call_data;
> >>+static struct notifier_block cf750gx_v_pll_switch_nb;
> >>+static struct notifier_block cf750gx_v_pll_lock_nb;
> > 
> > 
> > Also, in general, try to avoid global variables here, even 
> > in file scope (static), but rather put all device specific
> > data into a per-device data structure.
> > 
> How big of a problem is this? I regret the decision to rip
> the SMP stuff out. But it is kinda done. If absolutely
> necessary I can put these into a structure?

Not a huge problem in this case, because it is not strictly a
device driver to start with. In most device drivers, you want
a strict separation between global (per-driver) data and
per-instance data.

Are there even SMP boards based on a 750? I thought only 74xx
and 603/604 were SMP capable.

> >>+static int cf750gx_pll_switch_cb(struct notifier_block *nb, unsigned long
> >>+       action, void *data)
> >>+{
> >>+struct cf750gx_t_call_data *cd;
> >>+unsigned int idle_pll;
> >>+unsigned int pll_off_cmd;
> >>+unsigned int new_pll;
> > 
> > 
> > The whitespace appears damaged here.
> > 
> Just a coding style thing. I put declarations (or definitions -
> I get the two confused?) on the same indent as the block they are
> in. Is this a 15 yard illegal procedure penalty?

I've never seen that style before. Better do what everyone
else does here, e.g. using 'indent -kr -i8'.

> >>+       dprintk(__FILE__">%s()-%d:  Modifying PLL:  0x%x\n", __func__, __LINE__,
> >>+               new_pll);
> > 
> > 
> > Please go through all your dprintk and see if you really really need all of them.
> > Usually they are useful while you are doing the initial code, but only get in the
> > way as soon as it starts working.
> > 
> This from a code readability standpoint? Or an efficiency one?
> I think the cpufreq stuff has a debug configure option that
> disables compilation of these unless enabled.

It's more about readability.

> >>+       result = pllif_register_pll_switch_cb(&cf750gx_v_pll_switch_nb);
> >>+
> >>+       cf750gx_v_pll_lock_nb.notifier_call = cf750gx_pll_lock_cb;
> >>+       cf750gx_v_pll_lock_nb.next =
> >>+               (struct notifier_block *)&cf750gx_v_lock_call_data;
> > 
> > 
> > These casts look wrong, cf750gx_v_lock_call_data is not a notifier_block.
> > What are you trying to do here?
> > 
> Just a little sneaky. I should document in the kernel doc though.

No, better avoid such hacks instead of documenting them. I think I
now understand what you do there, and if I got it right, you should
just pass two arguments to pllif_register_pll_switch_cb.

> >>+static int cf750gx_cpu_exit(struct cpufreq_policy *policy)
> >>+{
> >>+       dprintk("%s()\n", __func__);
> >>+
> >>+       /*
> >>+        * Wait for any active requests to ripple through before exiting
> >>+        */
> >>+       wait_for_completion(&cf750gx_v_exit_completion);
> > 
> > 
> > This "wait for anything" use of wait_for_completion looks wrong, 
> > because once any other function has done the 'complete', you won't
> > wait here any more.
> > 
> > What exactly are you trying to accomplish with this?
> > 
> Originall I had something like:
> 
> 	while(some_bit_is_still_set)
> 		sleep
> 
> I think you suggested I use a completion because it is in
> fact simpler than a sleep. Now that I think about it also seems
> intuitive to give the system a hint as to when something will
> be done. 'complete' just means there is no timer pending (unless,
> of course, I screwed up the code).

The completion would certainly be better than the sleep here, but
I think you shouldn't need that in the first place. AFAICT, you
have three different kinds of events that you need to protect
against, when some other code can call into your module:

1. timer function,
2. cpufreq notifier, and
3. sysfs attribute.

In each case, the problem is a race between two threads that you
need to close. In case of the timer, you need to call del_timer_sync
because the timers already have this method builtin. For the other
two, you already unregister the interfaces, which ought to be enough.

	Arnd <><
