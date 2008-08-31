Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbYHaOfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbYHaOfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbYHaOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:35:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbYHaOfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=I+vBycIGIIk7BgQ1pJOwmkpvHtqv40P4n+gUvorYrHtr/PFlVdWvWjeYP8tUg9tswC
         bXxbcKcXNuk5Y+P36fSscVy2Yr7zviBSP/iaOQsAEgRbH1/hyiadpXdwct341he4PB/t
         sESTgQ0c0gcy4By2t6LZ73Fqm7zWk1WY8jRsY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
Date: Sun, 31 Aug 2008 16:32:04 +0200
User-Agent: KMail/1.9.9
Cc: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87wshzplvk.fsf@denkblock.local> <87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com>
In-Reply-To: <48BA969C.4060207@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808311632.04584.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 31 August 2008, Tejun Heo wrote:
> Hello,
> 
> Elias Oltmanns wrote:
> >> Ah.. you need to part ATAPI too?  If so, just test for
> >> ata_dev_enabled().
> > 
> > Well, I'm not quite sure really. Perhaps you are right and I'd better
> > leave ATAPI alone, especially given the problem that the unload command
> > might mess up a CD/DVD write operation. As long as no laptop HDs are
> > identified as ATAPI devices, there should be no problem with that.
> 
> Hmm... I think it would be safer to stick with ATA for the time being.

Seconded.  To be honest I also don't like the change to issue UNLOAD to
all devices on the port (it only needlessly increases complexity right now
since the _only_ use case at the moment is ThinkPad w/ hdaps + 1 HD).

[ I really hoped for the minimal initial implementation. ]

> >> Can you please elaborate a bit?  The reloading is done by the kernel
> >> after a timeout, right?  What kind of precarious situation can the
> >> kernel get into regarding suspend?
> > 
> > Sorry, I haven't expressed myself very clearly there, it seems. The user
> > space process detects some acceleration and starts writing timeouts to
> > the sysfs file. This causes the unload command to be issued to the
> > device and stops all I/O until the user space daemon decides that the
> > danger has passed, writes 0 to the sysfs file and leaves it alone
> > afterwards. Now, if the daemon happens to request head parking right at
> > the beginning of a suspend sequence, this means that we are in danger of
> > falling, i.e. we have to make sure that I/O is stopped until that user
> > space daemon gives the all-clear. However, suspending implies freezing
> > all processes which means that the daemon can't keep checking and
> > signalling to the kernel. The last timeout received before the daemon
> > has been frozen will expire and the suspend procedure goes ahead. By
> > means of the notifiers we can make sure that suspend is blocked until
> > the daemon says that everything is alright.
> 
> Is it really worth protecting against that?  What if the machine
> started to fall after the userland tasks have been frozen?  And how
> long the usual timeout would be?  If the machine has been falling for
> 10 secs, there really isn't much point in trying to protect anything
> unless there also is ATA DEPLOY PARACHUTE command somewhere in the new
> revision.
> 
> In libata, as with any other exceptions, suspend/resume are handled by
> EH so while emergency head unload is in progress, suspend won't
> commence which is about the same effect as the posted code sans the
> timeout extension part.  I don't really think there's any significant
> danger in not being able to extend timeout while suspend is in
> progress.  It's not a very big window after all.  If you're really
> worried about it, you can also let libata reject suspend if head
> unload is in progress.
> 
> Also, the suspend operation is unloading the head and spin down the
> drive which sound like a good thing to do before crashing.  Maybe we
> can modify the suspend sequence such that it always unload the head
> first and then issue spindown.  That will ensure the head is in safe
> position as soon as possible.  If it's done this way, it'll be
> probably a good idea to split unloading and loading operations and do
> loading only when EH is being finished and the disk is not spun down.
> 
> To me, much more serious problem seems to be during hibernation.  The
> kernel is actively writing memory image to userland and it takes quite
> a while and there's no protection whatsoever during that time.

Which also brings again the question whether it is really the best to
use user-space solution instead of kernel thread?

After taking the look into the deamon program and hdaps driver I tend
to "Nope." answer.  The kernel-space solution would be more reliable,
should result in significatly less code and would free us from having
a special purpose libata/ide interfaces.  It should also make the
maintainance and future enhancements (i.e. making hibernation unload
friendly) a lot easier.

I imagine that this comes a bit late but can we at least give it an
another thought, please?

Thanks,
Bart
