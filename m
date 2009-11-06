Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZKFMeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZKFMeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 07:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZKFMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 07:34:04 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64968 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZKFMeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 07:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kCXQY1TYNe0gGJ9YmVUD/p9jzSiYVmJdtgDh4cbi9j3VWkzxwjOsYqOGdPOKZs62RW
         jhSpXl1JfLiGjdBFsKm0bCJjfzSn+aqXIxvqfcpxyoyYjn9juI36rsdXKIdDCVzSCzxF
         iDQCDiTM9hvNN9sTSRFfr6lD/IyjyQtG7S3js=
Date: Fri, 6 Nov 2009 13:34:03 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091106123403.GB18592@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
 <20091105153742.GA18592@alberich.amd.com>
 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 07:40:53PM +0100, Dmitry Adamushko wrote:
> 2009/11/5 Andreas Herrmann <herrmann.der.user@googlemail.com>:
> > The patches don't properly work here.
> >
> > (1) For instance I got following log entries when doing
> >    suspend/resume, doing CPU offline/online test and reloading the
> >    module:
> 
> To avoid possible misunderstandings, I'd like to clarify the output below.
> 
> >  microcode: original microcode versions...
> >  microcode: CPU0-3: patch_level=0x1000065
> 
> So this is the 1st time you have loaded a module.
> 
> >  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> >  ...
> >  microcode: CPU0-1,3: patch_level=0x1000083
> 
> before or after loading a module? CPU2 is down, isn't it?

No, no CPU was offline at this moment. They all were brought back
online after some CPU hotplug and/or suspend/resume tests.
 
> >  microcode: CPU2-3: patch_level=0x1000065

Both messages showed up after same ucode-update process.
 
> same question as above.

Same answer as above all CPUs are online.

> Here, either CPUs 0 and 1 are down or have a
> different version. Both above messages don't make sense taken together

See, and that's the problem.

> (CPU3 belongs to both sets) unless summarize_cpu_info() is utterly
> broken.

I didn't check that yet.

> >  Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> >
> > The patch levels are:
> >
> >  # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
> >  PATCH_LEVEL          = 0x0000000001000083
> >  PATCH_LEVEL          = 0x0000000001000083
> >  PATCH_LEVEL          = 0x0000000001000065
> >  PATCH_LEVEL          = 0x0000000001000065
> 
> this is after your test has been stopped and all the CPUs are up, right?

Yes.

> > (2) During suspend/resume the ucode is not updated:
> >
> >  hadburg linux # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
> >  PATCH_LEVEL          = 0x0000000001000083
> >  PATCH_LEVEL          = 0x0000000001000083
> >  PATCH_LEVEL          = 0x0000000001000083
> >  PATCH_LEVEL          = 0x0000000001000083
> >  hadburg linux # pm-suspend
> >  hadburg linux # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
> >  PATCH_LEVEL          = 0x0000000001000065
> >  PATCH_LEVEL          = 0x0000000001000065
> >  PATCH_LEVEL          = 0x0000000001000065
> >  PATCH_LEVEL          = 0x0000000001000065
> >
> >
> > That used to work w/o your patches. Didn't have time to look why this
> > is now failing. You've changed mc_cpu_callback() -- most likely that
> > is causing this regression.
> 
> Hmm, cpu-event-callbacks seem to be working on my (Intel) setup. I
> have enabled pr_debug messages and also did a little trick to allow
> ucode of the same version to be loaded (my cpu is of the recent ucode
> by itself) and I can see cpu-callback events for both resuming and
> cpu-up cases.
> 
> (firstly, upgraded with microcode_ctl as I only have a .dat file)
> 
> suspend-resume
> ...
> [  584.506371] microcode: CPU1 removed
> [  584.516018] microcode: CPU0 updated to revision 0x57, date = 2007-03-15
> [  584.597326] microcode: CPU1 updated upon resume
> [  584.597562] microcode: CPU1 updated to revision 0x57, date = 2007-03-15
> [  584.597565] microcode: CPU1 added
> ...
> 
> and now cpu1 : down -> up
> 
> [ 1616.932249] microcode: CPU1 removed
> [ 1633.942502] platform microcode: firmware: requesting intel-ucode/06-0f-02
> [ 1633.954638] microcode: data file intel-ucode/06-0f-02 load failed
> [ 1633.954642] microcode: CPU1 added
> 
> 
> as I understand, you don't see " platform microcode: firmware:
> requesting intel-ucode" messages upon 'upping' a cpu, do you?

Sure, no intel-ucode messages as I tested with AMD CPUs ;-)
But otherwise no, no messages.

> sure, my test is somewhat limited... anyway, first of all I'd like to
> get a clear understanding of your logs. Thanks for yout test btw. :-))

I'll send you full logs asap.


Regards,
Andreas
