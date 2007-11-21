Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbXKTXne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbXKTXne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763793AbXKTXmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:42:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46364 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763523AbXKTXmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:42:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [lm-sensors] broken suspend [Was: 2.6.24-rc2-mm1]
Date: Wed, 21 Nov 2007 01:00:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Rudolf Marek <r.marek@assembler.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <4741EB91.9080000@assembler.cz> <Pine.LNX.4.44L0.0711191521170.3129-100000@iolanthe.rowland.org> <20071120131520.GC12077@jupiter.solarsys.private>
In-Reply-To: <20071120131520.GC12077@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210100.43049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 of November 2007, Mark M. Hoffman wrote:
> Hi all:
> 
> * Alan Stern <stern@rowland.harvard.edu> [2007-11-19 15:27:14 -0500]:
> > On Mon, 19 Nov 2007, Rudolf Marek wrote:
> > 
> > > Hello all,
> > > >>> gives coretemp_cpu_callback -> coretemp_device_remove ->
> > > >>> platform_device_unregister, so coretemp seems to be what I have and you don't.
> > > > 
> > > > Yes.
> > > > 
> > > > For the coretemp developers: coretemp_cpu_callback() needs to be more 
> > > > careful about what it does.  During a system sleep transition (suspend, 
> > > > hibernate, resume) it isn't possible to register or unregister a 
> > > > device.  Attempts to register will fail and attempts to unregister will 
> > > > block until the system sleep is over -- and for this callback that 
> > > > means hanging.
> > > 
> > > Well I wrote the driver. Thanks for the clarification. If I recall correctly I 
> > > looked how this part should be done from others drivers. Now while checking
> > > what happened to the file, seems Rafael added something related.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8bb7844286fb8c9fce6f65d8288aeb09d03a5e0d
> > 
> > That does look like it was meant for exactly this sort of situation.
> > 
> > > > It's not clear what the best way is to fix this.  Perhaps the CPU 
> > > > notification should be sent along with a special flag indicating that 
> > > > the CPU transition is part of a system sleep (although this seems 
> > > > racy).  Perhaps the driver should notice when a system sleep begins, 
> > > > and defer all CPU-change handling until after the sleep is over.
> > > 
> > > maybe it does exist?  CPU_DOWN_PREPARE ?
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/cpu-hotplug.txt;hb=HEAD
> > > 
> > > Unfortunately I'm not very familiar with this, calling the 
> > > coretemp_device_remove from CPU_DOWN_PREPARE would help? Looking at microcode 
> > > driver, seems it just hide sysfs interface from user.
> 
> AFAICT from that documentation, it would have been better to unregister
> the device on CPU_DOWN_PREPARE anyway.  CPU_DEAD seems to be too late -
> it's already gone by then.
> 
> > I'm not sure exactly what you want to do here.  But it seems like a 
> > waste to unregister the coretemp devices at the start of a system sleep 
> > and then register them back at the end.
> > 
> > Could you simply leave the devices registered throughout the entire
> > sleep?  Of course, at the end you would have to check that all the CPUs
> > really did come back up, and unregister the devices for the CPUs that
> > are still offline.
> 
> Is it possible to unregister a driver on CPU_DOWN_PREPARE_FROZEN?

No.  In that case the suspend core is holding the device's mutex and your
attempt to unregister it will deadlock with it.

Do you _have_ _to_ unregister the device at all?  Why don't you just leave
it registered on CPU_DOWN_PREPARE_FROZEN?  The CPU is not going away
physically in this case and it's _guaranteed_ that _cpu_up() will be called on
it as soon as the hibernation image is ready or we are back from suspend.

> If so, then the simplest fix would be the patch below (Jiri: feel free to
> try it). Otherwise it would take a bit of refactoring to bring the sysfs
> interface down/up for suspend/resume.
> 
> commit ce9c7b78c839a6304696d90083eac08baad524ce
> Author: Mark M. Hoffman <mhoffman@lightlink.com>
> Date:   Tue Nov 20 07:51:50 2007 -0500
> 
>     hwmon: (coretemp) fix suspend/resume hang
>     
>     Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

I'd do it like this:

> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 5c82ec7..afe2d31 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -338,10 +338,12 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>  	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> +	case CPU_DOWN_FAILED:
>  		coretemp_device_add(cpu);
+	case CPU_DOWN_FAILED_FROZEN: 
>  		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> +	case CPU_DOWN_PREPARE:
>  		coretemp_device_remove(cpu);
+	case CPU_DOWN_PREPARE_FROZEN:
>  		break;
>  	}

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
