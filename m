Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYFROHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYFROHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYFROG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:06:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43190 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYFROG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:06:56 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 10:06:45 EDT
Message-ID: <48591008.7040104@redhat.com>
Date: Wed, 18 Jun 2008 09:39:20 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>	 <46C9A867.6090509@redhat.com>	 <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>	 <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>	 <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com>	 <33633.simon.1188386980@5ec7c279.invalid>	 <25ae38200708290454r5be02a2ct568260cb429e4f1a@mail.gmail.com>	 <46D5794D.7030507@redhat.com>	 <25ae38200806180502i4d78e240l210b261f05f10507@mail.gmail.com> <25ae38200806180505m61d51440ma5754fa817dfbc0b@mail.gmail.com>
In-Reply-To: <25ae38200806180505m61d51440ma5754fa817dfbc0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anand Jahagirdar wrote:
> Hi
>    First of all Very sorry for late reply. I just gone through Hangwatch 
> code. It triggers the SysRq whenever there is hang, but in case of fork 
> bombing attack kernel itself prevents it, if setting for every user in 
> /etc/security/limits.conf are properly set. due to this setting there is 
> no "hang" in the system in case of fork bombing attack.
>     My aim is just to inform administrator about a user who* *has 
> crossed his process limit. If non root user is crossing the limit 
> its not good(considered as threat) from system(kernel) point of view 
> thats why limits are set. so if any non root user is crossing the 
> limit admin should know it. isnt it? 
>     To get this user limit information there is no provision in user 
> space, only kernel has the information. i was unable to print any kind 
> of message in hangwatch regarding a user who has crossed the limit. i am 
> ok with doing it in user space, but user space dont have sufficient 
> information regarding process limit. hangwatch aims to prevent system 
> from hang, which differs from my aim (to inform administrator about 
> limit crossing).chris please suggest. am i missing something?

Yes.  Your patch creates a denial of service in the process of warning 
that it has prevented a different denial of service.  Syslog syncs after 
each logged message, to ensure that if the system goes down, its dying 
gasps make it to disk.  Even if you ratelimit the printk, you still get 
log flooding, which can fill your /var/log partition, causing all sorts 
of things to go wrong, particularly since /var/log is on the root 
filesystem in most distros.  Even if you mitigate this with aggressive 
logrotate settings, you lose important messages to make room for these 
unimportant messages.  Even if you create an enormous /var/log 
partition, you still create a condition where the flood of messages can 
hide something more important when a human reads through the logs to try 
to figure out what's going on.

The only way this would be acceptable is if it were at a debug loglevel, 
so it would be off by default.  The problem is, it's not a kernel 
debugging feature, it's a userspace debugging feature.  This just isn't 
the right place to solve your problem.  If you feel very strongly about 
it, feel free to patch it into your own kernels, but please don't put it 
in mine.

-- Chris

> On 8/29/07, *Chris Snook* <csnook@redhat.com <mailto:csnook@redhat.com>> 
> wrote:
> 
>     Anand Jahagirdar wrote:
> 
>         Hi
>           consider a case:
>         if non root user request admin for more number of processes than
>         root
>         user,admin needs to modify settings in /etc/security/limits.conf
>         file
>         and if that user is not trustworthy and if does fork bombing
>         attack it
>         will kill the box.
> 
> 
>     If root is dumb enough to give the user whatever privileges they ask
>     for, fork-bombing is the least of your problems.
> 
>         (I have already tried this attack). in that case this loop will
>         work,
>         but by the time attack might have killed the box (Bcoz so many
>         processes has already been created at that time) . so in that case
>         admin wont come to know that what has happened.
> 
> 
>     On large multi-user SMP systems, the default ulimits will keep the
>     box responsive, if sluggish.  Perhaps you should file a bug with
>     your distribution if you believe the default settings in limits.conf
>     are too high.  There's no way to algorithmically distinguish a
>     forkbomb from a legitimate highly-threaded workload.
> 
>         Like this there are many cases..(actually these cases has
>         already been
>         discussed On LKML 2 months before in my thread named "fork bombing
>         attack").
>         in all these cases this printk helps adminstrator a lot.
> 
> 
>     What exactly does this patch help the administrator do?  If a box is
>     thrashing, you still have sysrq.  You can also use cpusets and
>     taskset to put your root login session on a dedicated processor,
>     which is getting to be pretty cheap on modern many-core, many-thread
>     systems.  Group scheduling is in the oven, which will allow you to
>     prioritize classes of users in a more general manner, even on UP
>     systems.
> 
>         On 8/29/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> 
>             On Wed, August 29, 2007 10:48, Anand Jahagirdar wrote:
> 
>                 Hi
>                                printk_ratelimit function takes care of
>                 flooding the
>                 syslog. due to printk_ratelimit function syslog will not
>                 be flooded
> 
> 
>     Um, no.  printk_ratelimit is on the order of *seconds*.  This
>     prevents error conditions from causing the system to spend all of
>     its CPU and I/O time logging.  It does very little to prevent log
>     spamming.  If I sent you an email every second, it would make it
>     much more difficult for you to find other messages in your inbox.
>      It's possible (easy, even) to write a forkbomber that doesn't
>     actually harm system responsiveness, but will still trigger this
>     printk as fast as possible.  If we merge this patch, every cracking
>     toolkit in existence will add such a feature, because log spamming
>     makes it harder for the administrator to find more important
>     messages, and even if the administrator uses grep judiciously to
>     filter them out, that doesn't help if logrotate has already deleted
>     the log containing the information they need to keep /var/log from
>     filling up.
> 
>                 anymore. as soon as administrator gets this message, he
>                 can take
>                 action against that user (may be block user's access on
>                 server). i
>                 think the my fork patch is very useful and helps
>                 administrator lot.
> 
> 
>     You still haven't explained why this can't be done in userspace.  If
>     forkbombing is a serious threat (and it's not) you can run a
>     forkbomb monitor with realtime priority that won't be severely
>     impacted by thrashing among normal priority processes.  Userspace
>     has room for much more sophisticated processing anyway, so doing
>     this in the kernel doesn't make much sense.
> 
>                                i would also like to mention that in some
>                 of the cases
>                 ulimit solution wont work. in that case fork bombing
>                 takes the machine
>                 and server needs a reboot. i am sure in that situation
>                 this printk
>                 statement helps administrator to know what has happened.
> 
> 
>     SysRq-t makes it quite obvious that the system has been forkbombed,
>     allowing the administrator to lower ulimits if the box can't handle
>     the load permitted by the default settings.  Sometimes SysRq is
>     inconvenient due to lack of physical access, which is why I wrote
>     hangwatch[1].
> 
>     Hangwatch monitors /proc/loadavg and writes the specified set of
>     SysRq triggers into /proc/sysrq-trigger when the specified load
>     average is exceeded, with the specified frequency.  It doesn't
>     require forks or dynamic memory allocation, so it works basically
>     any time the box isn't locked up enough to trigger NMI watchdog,
>     though realtime users may want to run it with chrt priority.  It's
>     very simple, but it's proven so effective that there really hasn't
>     been much need to develop it further since I initially wrote it a
>     year ago.
> 
>     Given how much we can already do in userspace, I don't really see a
>     need to implement this in the kernel.  If you'd like me to add
>     features to hangwatch, let's talk about that.  You can even fork it
>     yourself, since it's GPL.
> 
>            -- Chris
> 
>     [1] http://people.redhat.com/csnook/hangwatch/
>     <http://people.redhat.com/csnook/hangwatch/>
> 
> 

