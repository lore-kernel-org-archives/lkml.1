Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYJ2PLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYJ2PLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYJ2PL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:11:27 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:60543 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYJ2PL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:11:26 -0400
Date: Wed, 29 Oct 2008 13:12:07 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       herton@mandriva.com.br
Subject: Re: snd-hda-intel prevents machine to power off
Message-ID: <20081029131207.01666623@doriath.conectiva>
In-Reply-To: <s5hwsfrltnb.wl%tiwai@suse.de>
References: <20081028135933.36778d60@doriath.conectiva>
	<s5hskqgbt4h.wl%tiwai@suse.de>
	<20081028141916.610a2847@doriath.conectiva>
	<s5hod14br3h.wl%tiwai@suse.de>
	<20081028164433.2b2c6db4@doriath.conectiva>
	<s5hzlkoh6uu.wl%tiwai@suse.de>
	<s5hwsfrltnb.wl%tiwai@suse.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 29 Oct 2008 08:58:32 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

| At Tue, 28 Oct 2008 20:12:09 +0100,
| I wrote:
| > 
| > At Tue, 28 Oct 2008 16:44:33 -0200,
| > Luiz Fernando N. Capitulino wrote:
| > > 
| > > Em Tue, 28 Oct 2008 17:51:30 +0100
| > > Takashi Iwai <tiwai@suse.de> escreveu:
| > > 
| > > | At Tue, 28 Oct 2008 14:19:16 -0200,
| > > | Luiz Fernando N. Capitulino wrote:
| > > | > 
| > > | > Em Tue, 28 Oct 2008 17:07:42 +0100
| > > | > Takashi Iwai <tiwai@suse.de> escreveu:
| > > | > 
| > > | > | >  Hi Takashi,
| > > | > | > 
| > > | > | >  If I have some process with the sound device opened in my eeepc
| > > | > | > (say KDE's kmix) and try to power off the machine, for example with:
| > > | > | > 
| > > | > | > # echo o > /proc/sysrq-trigger
| > > | > | > 
| > > | > | >  The machine will not power off.
| > > | > | 
| > > | > | At which point does it stop?
| > > | > | What shows alt-sysrq-t (or w) output?
| > > | > 
| > > | >  I'm wondering how to get that kind of output because everything
| > > | > is disabled at that point (display inclusive).
| > > | 
| > > | OK, then it's hard to see.
| > > | A good news is that it goes at least fairly end point, thus likely no
| > > | hanging task, etc.
| > > | 
| > > | 
| > > | > | >  But it does work if I remove the snd-hda-intel module before issuing
| > > | > | > the echo above.
| > > | > | > 
| > > | > | >  This problem seems to be pretty popular among distros, I could find
| > > | > | > it reported for Mandriva, Ubuntu and Fedora.
| > > | > | 
| > > | > | Hmm, I haven't heard of unfixed issues.
| > > | > 
| > > | >  Well, these are the tickets I've found:
| > > | > 
| > > | > https://bugzilla.redhat.com/show_bug.cgi?id=444115
| > > | > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/126140
| > > | > https://qa.mandriva.com/show_bug.cgi?id=44752
| > > | 
| > > | Looking through the comments that the power-saving helps, the problem
| > > | may disappear even without disabling the pci device.  The power-saving
| > > | doesn't involve with pci_disable_device() or changing the power-state
| > > | of the controler.  So, at least, the problem is either in the codec
| > > | or the controller setup.
| > > | 
| > > | Suppose you already use the power-saving and it solves the shutdown
| > > | problem, could you set power_save_controller=0 option for
| > > | snd-hda-intel, and check whether the shutdown still works or not?
| > > | If the shutdown doesn't work with this option, it means that
| > > | azx_stop_chip() is what would be needed.
| > > 
| > >  Yes, power_save_controller=0 doesn't work while the power-saving
| > > one works.
| > 
| > OK, then could you check which call in azx_stop_chip() is critical?
| > You can comment out each and check the difference.
| > 
| > >  Where should I put a call to azx_stop_ship()? I'm not an alsa
| > > hacker. :)
| > 
| > This is the problem.  If it's a fast call like azx_int_clear() or
| > azx_int_enable(), it can be relatively easily done at each time.
| > But, it's like freeing memories, it shouldn't be done at each
| > operation.
| 
| On the second thought, we may just use a reboot notifier as a
| workaround for this kind of problem.
| Below is a quick fix.  Could you give it a try?

 Yeah, it fixes the problem for me.

| Anyway, could you create a kernel bugzilla entry?  This will help
| to keep records in a commit changelog greatly, why this ugly hack is
| needed.
| You can list the relevant URLs there as references, too.

 Here you are:

http://bugzilla.kernel.org/show_bug.cgi?id=11889

 Takashi, Thank you very much for your help.

-- 
Luiz Fernando N. Capitulino
