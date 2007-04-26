Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXDZBOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXDZBOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXDZBOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:14:43 -0400
Received: from mail37.syd.optusnet.com.au ([211.29.133.221]:51289 "EHLO
	mail37.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbXDZBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:14:41 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Mattie <codermattie@gmail.com>, ck@vds.kolivas.org
Subject: Re: rsdl v46 report,numbers,comments
Date: Thu, 26 Apr 2007 11:13:10 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>
References: <20070424112601.56f5bfb6@reforged>
In-Reply-To: <20070424112601.56f5bfb6@reforged>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261113.10307.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 04:26, Mike Mattie wrote:
> Hello,
>
> 0. intro
>
> I am very happy to report that v46 of RSDL subjectively is much better than
> v42. As you (Con Kolivas) might remember from a previous mail I was
> experimenting with using nice levels effectively. I have refined these
> levels to this layout:
>
> -2  : clock (ntpd)
> -1  : syslog,sshd,X
> 0   : command; default for shells
> 1   : audacious (audio), xfce window manager (with compositor on )
> 2   :  emacs (SCHED_OTHER), desktop/window manager infrastructure (dbus),
> ssh-agent , bind (batch scheduled ) 3   : desktop applications (mail ,
> xchat, openoffice )
> 5   : spamd,batch scheduled compiles/test-suites.
> 10  : cron jobs
>
> 1. Some numbers
>
> My machine is a particularly tough case I think. A uni-processor Athlon XP
> 3000+ (involuntary pre-empt) with a software RAID5 on PATA drives. I load
> it heavily with compiles/test-suites, and I am very sensitive to audio
> glitches.
>
> here are some stats for idle:
>
> ---load-avg--- ------memory-usage----- ----total-cpu-usage----
> ----interrupts--- ---system-- _1m_ _5m_ 15m_|_used _buff _cach _free|usr
> sys idl wai hiq siq|__17_ __18_ __20_|_int_ _csw_ 0.2  0.2  0.2| 170M   15M
>  309M 6560k|  2   1  94   4   0   0|   1     7   150 | 238   208 0.2  0.2 
> 0.2| 170M   15M  309M 6568k|  1   0  99   0   0   0|   0     0     0 |  76 
>   55 0.2  0.2  0.2| 170M   15M  309M 6568k|  0   1  99   0   0   0|   0    
> 0     0 |  75    47 0.2  0.2  0.2| 170M   15M  309M 6624k|  4   0  96   0  
> 0   0|   0     0     0 |  75    37 0.2  0.2  0.2| 170M   15M  309M 6624k| 
> 1   0  99   0   0   0|   0     0     0 |  75    36
>
> here are some stats for music playing:
>
> ---load-avg--- ------memory-usage----- ----total-cpu-usage----
> ----interrupts--- ---system-- _1m_ _5m_ 15m_|_used _buff _cach _free|usr
> sys idl wai hiq siq|__17_ __18_ __20_|_int_ _csw_ 0.9  0.4  0.2| 175M   15M
>  305M 5652k|  2   1  94   4   0   0|   1     7   150 | 238   210 0.9  0.4 
> 0.2| 175M   15M  305M 5652k| 10   1  89   0   0   0|   0     3   989 |1068 
> 1510 0.9  0.4  0.2| 175M   15M  305M 5592k| 13   0  87   0   0   0|   0    
> 3  1013 |1093  1565 0.9  0.4  0.2| 175M   15M  304M 6300k| 11   1  88   0  
> 0   0|   0     3  1000 |1078  1496 0.9  0.4  0.2| 175M   15M  305M 6300k|
> 13   0  87   0   0   0|   0     3  1006 |1084  1509 0.8  0.4  0.2| 175M  
> 15M  305M 6180k| 13   1  86   0   0   0|   0     3  1000 |1078  1524 0.8 
> 0.4  0.2| 175M   15M  305M 6060k| 12   1  87   0   0   0|   0     3  1000
> |1078  1564
>
> The context switches are high, but so are the interrupts (USB 2.0 Audigy
> NX)
>
> To see how effective using these nice levels were I decided to play with
> rr_interval, on the theory that with priorities strictly enforced and used
> aggressively that a longer time-slice would not cause audio delay. So far
> that theory is holding. All of these numbers are with rr_internal = 20, and
> I have less audio problems than any previous kernel/tuning setup.
>
> That is very impressive.
>
> as far as batch loading goes I tried a kernel compile. These numbers look
> nice for RSDL but there are some caveats:
>
> kernel compile , CFS v3                     : make  756.83s user 89.37s
> system 58% cpu 24:08.21 total kernel compile , v46 rr_interval = default  :
> make  754.66s user 89.74s system 59% cpu 23:35.38 total kernel compile ,
> v46 rr_interval = 20       : make  682.83s user 84.34s system 73% cpu
> 17:29.57 total
>
> 1. The system was noisy. I did this intentionally. My typical load is a
> mixture of desktop/compile. All three numbers were generated while
> listening to music, reading docs/web/news, using emacs etc. with each of
> the compiles I tried running a visualization plugin (ProjectM inside
> audacious ) for a minute or so.
>
>    This skews the numbers for comparison , but I was looking for an
> impression that was based off a *real* work-load.
>
>    It would like to add as well that before RSDL the mainline scheduler
> failed completely at running ProjectM even when it was the only application
> on the desktop. ( It stalled for seconds with a rock steady period ).
>
> 2. All of these ran nice 5 sched: BATCH
>
> 3. I have the xfce compositor turned on, using the transparency.
>
> 4. compiled on software RAID 5 (md) -> dev mapper -> lvm2 -> ext3 , 4
> drives, write-cache disabled, external 512 mg flash drive for a external
> journal , commit=15, journal=data
>
> From the caveats above , especially the deep stack for the block layer,
> plus meeting audio deadlines while sharing a interrupt with the journal
> drive (arghh) this is very impressive system behavior for me.
>
> Here is the stats for doing a kernel compile with audacious running, plus
> mail,editor etc.
>
> ---load-avg--- ------memory-usage----- ----total-cpu-usage----
> ----interrupts--- ---system-- _1m_ _5m_ 15m_|_used _buff _cach _free|usr
> sys idl wai hiq siq|__17_ __18_ __20_|_int_ _csw_ 1.3    1  0.8| 198M   22M
>  269M   11M|  3   1  92   4   0   0|   1     7   199 | 287   348 1.3    1 
> 0.8| 204M   22M  269M 6072k| 79  12   0   9   0   0|   0     7  1003 |1087 
> 2160 1.3    1  0.8| 195M   22M  268M   16M| 82  18   0   0   0   0|   0    
> 8  1003 |1085  2703 1.3    1  0.8| 200M   22M  268M   10M| 82  16   0   2  
> 0   0|   0     8  1009 |1094  2204 1.4    1  0.8| 195M   22M  269M   15M|
> 83  15   0   2   0   0|   0     8  1014 |1099  3007 1.4    1  0.8| 200M  
> 22M  269M 9488k| 82  14   0   4   0   0|   0     7  1000 |1082  2361 1.4   
> 1  0.8| 200M   22M  267M   12M| 83  15   0   2   0   0|   0     7  1000
> |1085  2579
>
>
> Now for some comments from the peanut gallery.
>
> 2. Window Manager scheduler hinting ?
>
> On reflection my workload may be the easy case. As a developer I run a
> somewhat small number of applications, typically the lightest I can find,
> except emacs :)
>
> A more typical desktop user might not be able to use my sort of setup,
> where I can push a batchy job down in priority and wait for it. I also
> write shell functions, aliases etc to set this up, which is easy for a
> distro, but not necessarily average user usable. For the users where they
> are running multiple monolithic CPU hog programs, like openoffice,firefox
> etc This sort of approach won't suit them.
>
> However the strict enforcement of RSDL could be leveraged for the desktop
> user as well. The Mac OSX scheduler has layered on-top of the typical nice
> priority levels the concept of foreground and background scheduling.
> Basically the Mac window manager can tune the scheduling based on window
> focus.
>
> I think something like this combined with RSDL could be a worthy
> experiment. If the window manager can calculate the "attention" a user
> gives a window then it could nice it up/down within a small range. Mac OS X
> has a nasty behavior of being jerky when switching focus under load. I
> think this is due to a simplistic knee-jerk response to window focus in
> scheduling (or my ibook has to little RAM).
>
> If a linux window manager were to rank the attention of windows, and be
> smart about cycling between groups of apps I think three priority levels
> could be used like this:
>
> 1  : foreground ( frequent attention )
> 2  : background ( infrequent attention )
> 3  : batchy ( downloaders, other long running infrequently monitored
> programs )
>
> Think of how easy this is for a window-manager to compute, compared to
> trying to re-build the information in-kernel with heuristics.
>
> If this idea is actually pursued there may need to be a new feature in
> RSDL. With this scheme it is very important to ensure that a particular
> nice level does not become overloaded ( think foreground ) . The current
> linux schedulers report a load value for the total system. This scheme
> needs to know the load value for a individual nice level as well, that way
> the foreground nice level could remain responsive by worst case kicking a
> program down a level or two if it starts becoming unresponsive.
>
> 3. Better throughput
>
> I think that this mixed developer work-load is actually the worst case for
> a scheduler. It has to meet deadlines and provide decent throughput. Beyond
> pre-empt and clock precise scheduling I am not sure if there is much more
> that can be done for interactive.
>
> I do think that SCHED_BATCH provides alot of room for interesting ideas
> though since the guarantees are so loose. As I understand it SCHED_BATCH is
> guaranteed to not starve and that is about it.
>
> Since I am commenting freely here is a idea to be taken with a huge grain
> of salt. Is it possible that the scheduler could compute and combine the
> deadlines for both audio/video ? If the scheduler can compute the longest
> interval between both video/audio refresh then scheduling could be arranged
> like so:
>
> refresh -> interactive -> batch -> refresh
>
> The interactive processes would run first, that way the risk of missing a
> refresh would be minimized. Once the scheduler has ran all the interactive
> stuff, for the case of a small set of programs such as audio player and
> editor, it would be very likely that alot of time is left.
>
> Next assume that the SCHED_BATCH has been sorted into CPU intensive and IO
> intensive. For the CPU intensive it would be nice if the scheduler would
> give it a massive time-slice, why not all the time until the next refresh
> point ? Basically reduce the context-switching to mostly
> interrupts/background noise. The SCHED_BATCH programs may take longer to
> run, as they are being interleaved more than balanced, but I think it's
> possible that overall throughput could be increased considerably. If
> something like this could be done while still honoring the nice values
> (though not as strictly as for interactive programs ) it would be a big
> win. With huge time-slices other parts of the system such as VM management
> might behave more efficiently as well.
>
> I think linux would be quite special if it was the best in throughput
> efficiency (ignoring completion time, just how much processor etc used to
> run the same work-load ) for SETI like work-loads while still running a
> fully responsive interactive desktop.
>
> btw, the above concept is articulated from a distant background of
> programming a VGA adapter on a 286. That the last time I dealt with
> hard-deadlines hands on. I haven't had a reason to code at bare-metal since
> I started using linux so please consider it a vehicle for articulating a
> concept.
>
> 4. Outro
>
> In summary I like the RSDL scheduler quite a bit. It is consistent and
> doesn't do magic so I can build a priority scheme on-top of it with a very
> compact and reliable behavior model. Using the priority levels seems to
> allow me to use larger time-slices without sacrificing interactivity. This
> is unsuprising as I am actually telling the scheduler what I want ......
>
> I think that the window manager can use simple algorithms to calculate what
> the kernel would have to guess at with hairy heuristics. Hacking nice
> throttling into the window manager combined with a very simple but reliable
> scheduler may work pretty well for desktop users. Maybe that will excite
> someone enough to go try it, or dig up some existing implementation (other
> than OSX).
>
> I also think that SCHED_BATCH is where alot of fun experiments can be
> played. Especially in regards to CPU intensive programs. This combination
> is actually quite common I would think in audio/video production.
>
> At this point with how well my system works the itch has been scratched as
> far as the in-kernel part goes. I am interested though in playing around
> with your idlerun program though.
>
> Later on , possibly much later I will cook up some better
> numbers/comparisons. I really don't trust subjective evaluations of
> scheduling, my own included. I think people really want a new kernel patch
> to work better, which is a horrible way to start an evaluation. I want to
> measure both throughput, and interactivity in a double-blind like way.
> (random option for grub ?)
>
> With most of my work-load IO bound I expect the performance improvements to
> come from places like CFQ,ext4,syslet etc.
>
> Thank you to all for a good kernel. Linux user-space is quite comfortable
> these days.

Thanks for extensive report. The only thing I can say in a short time space at 
the pc is that SCHED_BATCH as defined by Ingo in the current mainline kernel, 
which if I am to abide by in SD, means "I want the same total cpu percentage 
as other tasks at this nice level but I am latency insensitive". ie it is not 
the "idle priority" type of SCHED_BATCH. That sort of thing is implemented 
in -ck as SCHED_IDLEPRIO. If I have pc time and health I'll be reimplementing 
it for -ck when it moves to the SD scheduler.

-- 
-ck
