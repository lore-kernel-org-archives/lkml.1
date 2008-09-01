Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYIAPmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYIAPmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYIAPmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:42:40 -0400
Received: from nebensachen.de ([195.34.83.29]:33413 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYIAPmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:42:39 -0400
X-Hashcash: 1:20:080901:bzolnier@gmail.com::LlB7z+/YO88rgK4F:00000000000000000000000000000000000000000002YD/
X-Hashcash: 1:20:080901:htejun@gmail.com::rbJoSa4RYFh4hTgq:01lQQ
X-Hashcash: 1:20:080901:alan@lxorguk.ukuu.org.uk::Ybr6A6Hei2e2SjWK:00000000000000000000000000000000000002r9E
X-Hashcash: 1:20:080901:akpm@linux-foundation.org::XNeOuAWivqdWyj4I:00000000000000000000000000000000000016sN
X-Hashcash: 1:20:080901:hmh@hmh.eng.br::5M7vKOAbermLtOgU:0003+S9
X-Hashcash: 1:20:080901:jeff@garzik.org::iGW1dCr4rCh3sR8j:001i3c
X-Hashcash: 1:20:080901:randy.dunlap@oracle.com::04OO5KtADpAl5HaM:000000000000000000000000000000000000002w/d
X-Hashcash: 1:20:080901:linux-ide@vger.kernel.org::o8jrLNVEUvTLIHxq:00000000000000000000000000000000000056yf
X-Hashcash: 1:20:080901:linux-kernel@vger.kernel.org::CK/ud/XGZ6VeShDV:0000000000000000000000000000000002AYz
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<200808311632.04584.bzolnier@gmail.com>
	<87wshxkt9c.fsf@denkblock.local>
	<200808312135.56424.bzolnier@gmail.com>
Date: Mon, 01 Sep 2008 17:41:44 +0200
In-Reply-To: <200808312135.56424.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Sun, 31 Aug 2008 21:35:56 +0200")
Message-ID: <87iqtflvpj.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Sunday 31 August 2008, Elias Oltmanns wrote:
>> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
>> > Hi,
>> >
>> > On Sunday 31 August 2008, Tejun Heo wrote:
[...]
>> >> To me, much more serious problem seems to be during hibernation.  The
>> >> kernel is actively writing memory image to userland and it takes quite
>> >> a while and there's no protection whatsoever during that time.
>> >
>> > Which also brings again the question whether it is really the best to
>> > use user-space solution instead of kernel thread?
>> >
>> > After taking the look into the deamon program and hdaps driver I tend
>> > to "Nope." answer.  The kernel-space solution would be more reliable,
>> > should result in significatly less code and would free us from having
>> > a special purpose libata/ide interfaces.  It should also make the
>> > maintainance and future enhancements (i.e. making hibernation unload
>> > friendly) a lot easier.
>> >
>> > I imagine that this comes a bit late but can we at least give it an
>> > another thought, please?
>> 
>> Right, I'll try to give a concise statement of the problem. First
>> though, I absolutely agree that with regard to the suspend / hibernate
>> problem, an in kernel solution would ultimately be the safest option.
>
> Not only that, IIRC there were some concerns regarding having bigger
> power consumption with user/kernel-space solution.
>
>> However, the way I see it, we would need a module with the following
>> characteristics:
>> 
>> - Policy: logic to decide when to park / unpark disks and an interface
>>   to export tunables to user space.
>> - Input: capability to recognise and register with acceleration sensors
>>   in the system and to gather data in an efficient manner. Since this is
>>   kernel space, we have to make it bulletproof and account for the
>>   possibility that there may be more than one such sensor installed in
>>   the system (think: plug and play).
>> - Action: find all rotating media in the system and decide which of them
>>   to protect how. Probably, some tunables for the user to fiddle with
>>   are required here too. Remember that we have docking stations and the
>>   like so more than one HD may show up on the bus.
>> 
>> All these corner cases that most users don't care or even tink about
>> won't hurt anyone as long as the daemon is in user space. This way, we
>> have a very simple solution for all of them: The user decides for each
>> instance of the daemon which accelerometer it gets its data from and
>> which HD it is supposed to protect. I don't like giving impressively
>> high percentages when all I'm doing is intelligent guess work, but the
>> vast majority of users will have only one daemon running, getting its
>> data from one accelerometer and protecting exactly one HD. However, it
>> is hard to imagine anything disastrous to happen *if* somebody should
>> happen to install a second accelerometer or connect to the docking
>> station. In kernel space we would have to take care of the oddest things
>> because a system supposed to increase security would suffer under a
>> reputation of locking the machine for good.
>
> We may attack the problem from the different angle in which we won't
> have to worry about any odd corner cases at all:
>
> - Add disk_shock module with the needed logic, keeping track of "system
>   accelerometer" & "system disk" objects, responsible for polling and also
>   (optionally) exporting tunables.
>
> - When ATA devices are initialized check if they support UNLOAD
>   command and if yes advertise such capability to the block layer
>   (like we do it with flush cache currently).  We can also solve
>   the problem of forcing UNLOAD support with using kernel parameters.
>
> - Add [un]register_system_accelerometer() interface to disk_shock
>   and make accelerometer drivers decide whether to use it (currently
>   only hdaps driver will use it).  Also add some standard methods for
>   obtaining data from accelerometer drivers.  We may even glue the
>   new disk_shock with hdaps for now.
>
> - Simlarly add [un]register_system_disk() interface (getting us a
>   access to disk queue) and make storage drivers decide whether to
>   use it (it is actually easier than in case of system accelerometer
>   devices since an extra UNLOAD command on shock is not a problem,
>   while false shock alert is).
>
> - On shock disk_shock will queue the special REQ_PARK_HEADS request
>   and later it will queue REQ_UNPARK_HEADS one (this may need minor
>   tweaks in block layer as we needed for PM support in ide, which is
>   done in very similar way).

First of all, I'm rather adverse to the idea that block layer is the
right place to interface with storage devices for in this particular
case. The only arguments for such a decision are that libata and ide
look the same on that level and that we have solved the issue of
serialisation. Nonetheless, we really are talking about an ATA specific
feature here and since I have had no luck with any suggestion to sneak
REQ_TYPE_LINUX_BLOCK requests past the scsi midlayer, I'd very much like
to avoid going down this route again. Instead, I'd probably suggest
something similar to the pm_notifiers for that purpose.

>
> Given that at the moment we need to only handle _1_ accelerometer
> we may start _really_ small and get things working.  Later we can
> extend the functionality and interfaces as needed (like allowing
> user to specify arbitrary system accelerometer(s)/disk(s) mappings).
>
> [ It is also entirely possible that we will never need to extend it! ]

I'm not convinced that putting all this directly into the hdaps module
is the right thing to do or would be accepted by the maintainers, for
that matter. In fact, since the mainline implementation of hdaps is
known to be broken and a lot of people (and distros) use the externally
maintained tp_smapi version instead, I think we should change that code
as little as possible. Which means that we will have to write a seperate
module.

>
> It may sound as we would need to start from scratch and throw out
> the current solution.  This is not true, majority of code can be
> nicely-recycled (i.e. logic from daemon, libata/ide UNLOAD support).
>
> There is also one big pro of simplified kernel solution from user POV,
> she/he doesn't have to worry about setting up _anything_.  The feature
> just "magically" starts working with the next kernel upgrade.

Still, it'll take time to add the missing bits and I'm going to have
less time to spare for the next few months than I had during the last
weeks. I wonder whether, from a user's POV, it is more valuable to have
a solution *now* which doesn't require recompiling the kernel but some
configuration in user space, or whether a complete solution with choice
between all-in-kernel or mixed-user-kernel-space some time in the future
is what they are waiting for. Arguably, this all is going to be obsolete
in the not so distant future since HDs with everything onboard are on
the market already. Then, of course, a software solution is more
flexible.

>
> PS please note that I'm not NACK-ing the current solution, I'm just
> thinking loudly if we can and should put some extra effort which will
> results in better long-term solution (and of course less maintenance
> work for me :)

Yes, I appreciate that. It's just that I have tried to get this thing
upstream somehow for quite some time now and I really have no idea how
long it is going to take me to figure out how to write this disk_shock
module and to get it past the maintainers (whoever that might be in this
case). Obviously, me getting impatient isn't a technical (or any good)
argument in favour of the current solution, but I have to say that your
PS was well placed in order to help cooling my temper. Don't worry, I'll
behave myself and listen to your arguments. In fact, I'm very greatful
for all your responses because at least I have the feeling we are
getting somewhere and people actually care.

Regards,

Elias
