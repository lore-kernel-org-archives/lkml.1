Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYHaTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYHaTjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYHaTjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:39:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:51726 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbYHaTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=DODGbzpeoHAgjIk+OkmEQ/2XPiHX3MyfH3Q5k3/efeqIdaMlIWmTYLLW37664LB362
         oFt8NJ8qtY3aBsVloyebyNiWV+beyVh1kZPs5ewXO+HrgPLaqocNTRnX4H70CEhb1p7a
         wNtXqCocu9LLcO/AHIbSL1JnthECuffVaYK40=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
Date: Sun, 31 Aug 2008 21:35:56 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87wshzplvk.fsf@denkblock.local> <200808311632.04584.bzolnier@gmail.com> <87wshxkt9c.fsf@denkblock.local>
In-Reply-To: <87wshxkt9c.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808312135.56424.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > Hi,
> >
> > On Sunday 31 August 2008, Tejun Heo wrote:
> >> Hello,
> >> 
> >> Elias Oltmanns wrote:
> >> >> Ah.. you need to part ATAPI too?  If so, just test for
> >> >> ata_dev_enabled().
> >> > 
> >> > Well, I'm not quite sure really. Perhaps you are right and I'd better
> >> > leave ATAPI alone, especially given the problem that the unload command
> >> > might mess up a CD/DVD write operation. As long as no laptop HDs are
> >> > identified as ATAPI devices, there should be no problem with that.
> >> 
> >> Hmm... I think it would be safer to stick with ATA for the time being.
> >
> > Seconded.  To be honest I also don't like the change to issue UNLOAD to
> > all devices on the port (it only needlessly increases complexity right now
> > since the _only_ use case at the moment is ThinkPad w/ hdaps + 1 HD).
> 
> Admittedly, I don't know very much about it myself but I seem to
> remember that there are other vendors now shipping similar technology.
> Even in the Thinkpad case I don't *know* that all relevant models have
> HD and optical drives on seperate ports although I'm willing to believe
> it if somebody tells me so.
> 
> Anyway, I've added Henrique to the Cc: list since he knows far more
> about Thinkpads than I do and possibly about other notebooks too.
> 
> >
> > [ I really hoped for the minimal initial implementation. ]
> 
> There is a lot to be said for the per-port solution as far as libata is
> concerned. For the sake of consistency I tried to mimic the same
> behaviour in ide but I agree that it makes things more complex there.
> 
> >
> >> >> Can you please elaborate a bit?  The reloading is done by the kernel
> >> >> after a timeout, right?  What kind of precarious situation can the
> >> >> kernel get into regarding suspend?
> >> > 
> >> > Sorry, I haven't expressed myself very clearly there, it seems. The user
> >> > space process detects some acceleration and starts writing timeouts to
> >> > the sysfs file. This causes the unload command to be issued to the
> >> > device and stops all I/O until the user space daemon decides that the
> >> > danger has passed, writes 0 to the sysfs file and leaves it alone
> >> > afterwards. Now, if the daemon happens to request head parking right at
> >> > the beginning of a suspend sequence, this means that we are in danger of
> >> > falling, i.e. we have to make sure that I/O is stopped until that user
> >> > space daemon gives the all-clear. However, suspending implies freezing
> >> > all processes which means that the daemon can't keep checking and
> >> > signalling to the kernel. The last timeout received before the daemon
> >> > has been frozen will expire and the suspend procedure goes ahead. By
> >> > means of the notifiers we can make sure that suspend is blocked until
> >> > the daemon says that everything is alright.
> >> 
> >> Is it really worth protecting against that?  What if the machine
> >> started to fall after the userland tasks have been frozen?  And how
> >> long the usual timeout would be?  If the machine has been falling for
> >> 10 secs, there really isn't much point in trying to protect anything
> >> unless there also is ATA DEPLOY PARACHUTE command somewhere in the new
> >> revision.
> >> 
> >> In libata, as with any other exceptions, suspend/resume are handled by
> >> EH so while emergency head unload is in progress, suspend won't
> >> commence which is about the same effect as the posted code sans the
> >> timeout extension part.  I don't really think there's any significant
> >> danger in not being able to extend timeout while suspend is in
> >> progress.  It's not a very big window after all.  If you're really
> >> worried about it, you can also let libata reject suspend if head
> >> unload is in progress.
> >> 
> >> Also, the suspend operation is unloading the head and spin down the
> >> drive which sound like a good thing to do before crashing.  Maybe we
> >> can modify the suspend sequence such that it always unload the head
> >> first and then issue spindown.  That will ensure the head is in safe
> >> position as soon as possible.  If it's done this way, it'll be
> >> probably a good idea to split unloading and loading operations and do
> >> loading only when EH is being finished and the disk is not spun down.
> >> 
> >> To me, much more serious problem seems to be during hibernation.  The
> >> kernel is actively writing memory image to userland and it takes quite
> >> a while and there's no protection whatsoever during that time.
> >
> > Which also brings again the question whether it is really the best to
> > use user-space solution instead of kernel thread?
> >
> > After taking the look into the deamon program and hdaps driver I tend
> > to "Nope." answer.  The kernel-space solution would be more reliable,
> > should result in significatly less code and would free us from having
> > a special purpose libata/ide interfaces.  It should also make the
> > maintainance and future enhancements (i.e. making hibernation unload
> > friendly) a lot easier.
> >
> > I imagine that this comes a bit late but can we at least give it an
> > another thought, please?
> 
> Right, I'll try to give a concise statement of the problem. First
> though, I absolutely agree that with regard to the suspend / hibernate
> problem, an in kernel solution would ultimately be the safest option.

Not only that, IIRC there were some concerns regarding having bigger
power consumption with user/kernel-space solution.

> However, the way I see it, we would need a module with the following
> characteristics:
> 
> - Policy: logic to decide when to park / unpark disks and an interface
>   to export tunables to user space.
> - Input: capability to recognise and register with acceleration sensors
>   in the system and to gather data in an efficient manner. Since this is
>   kernel space, we have to make it bulletproof and account for the
>   possibility that there may be more than one such sensor installed in
>   the system (think: plug and play).
> - Action: find all rotating media in the system and decide which of them
>   to protect how. Probably, some tunables for the user to fiddle with
>   are required here too. Remember that we have docking stations and the
>   like so more than one HD may show up on the bus.
> 
> All these corner cases that most users don't care or even tink about
> won't hurt anyone as long as the daemon is in user space. This way, we
> have a very simple solution for all of them: The user decides for each
> instance of the daemon which accelerometer it gets its data from and
> which HD it is supposed to protect. I don't like giving impressively
> high percentages when all I'm doing is intelligent guess work, but the
> vast majority of users will have only one daemon running, getting its
> data from one accelerometer and protecting exactly one HD. However, it
> is hard to imagine anything disastrous to happen *if* somebody should
> happen to install a second accelerometer or connect to the docking
> station. In kernel space we would have to take care of the oddest things
> because a system supposed to increase security would suffer under a
> reputation of locking the machine for good.

We may attack the problem from the different angle in which we won't
have to worry about any odd corner cases at all:

- Add disk_shock module with the needed logic, keeping track of "system
  accelerometer" & "system disk" objects, responsible for polling and also
  (optionally) exporting tunables.

- When ATA devices are initialized check if they support UNLOAD
  command and if yes advertise such capability to the block layer
  (like we do it with flush cache currently).  We can also solve
  the problem of forcing UNLOAD support with using kernel parameters.

- Add [un]register_system_accelerometer() interface to disk_shock
  and make accelerometer drivers decide whether to use it (currently
  only hdaps driver will use it).  Also add some standard methods for
  obtaining data from accelerometer drivers.  We may even glue the
  new disk_shock with hdaps for now.

- Simlarly add [un]register_system_disk() interface (getting us a
  access to disk queue) and make storage drivers decide whether to
  use it (it is actually easier than in case of system accelerometer
  devices since an extra UNLOAD command on shock is not a problem,
  while false shock alert is).

- On shock disk_shock will queue the special REQ_PARK_HEADS request
  and later it will queue REQ_UNPARK_HEADS one (this may need minor
  tweaks in block layer as we needed for PM support in ide, which is
  done in very similar way).

Given that at the moment we need to only handle _1_ accelerometer
we may start _really_ small and get things working.  Later we can
extend the functionality and interfaces as needed (like allowing
user to specify arbitrary system accelerometer(s)/disk(s) mappings).

[ It is also entirely possible that we will never need to extend it! ]

It may sound as we would need to start from scratch and throw out
the current solution.  This is not true, majority of code can be
nicely-recycled (i.e. logic from daemon, libata/ide UNLOAD support).

There is also one big pro of simplified kernel solution from user POV,
she/he doesn't have to worry about setting up _anything_.  The feature
just "magically" starts working with the next kernel upgrade.

PS please note that I'm not NACK-ing the current solution, I'm just
thinking loudly if we can and should put some extra effort which will
results in better long-term solution (and of course less maintenance
work for me :)

Thanks,
Bart
