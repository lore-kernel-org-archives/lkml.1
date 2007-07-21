Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbXGUD5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbXGUD5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGUD5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:57:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:49990 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGUD5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UXRYWaZ7djTiB6+6iDuP/E97VHvM0y8lFICMpHu+jyDS0mcrnu4/7vTeR0xQAQ9iRb+yBZqcvjfltYbaG3hBvoIMNB92NQB6IpiChwFmCujmOwj6Fxe2BZ2gXI3KoGuxrXuDhC5T8sBCJ9jx9gDNXuuUaKp3vc2bVTAmyxXt+VM=
Message-ID: <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
Date: Sat, 21 Jul 2007 09:27:09 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <20070720155912.079c5a27.akpm@linux-foundation.org>
	 <20070720231052.GA19752@suse.de>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
	 <20070721010257.GA9561@suse.de>
	 <20070720183733.c53b511b.akpm@linux-foundation.org>
	 <20070721014419.GA10761@suse.de>
	 <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hopefully this bug should be 100% reproducible at boot time anyway.
> Don't care much for XFS and unionfs, but hoping deselecting ATA from
> the config doesn't change the variables much in this equation. ]


Gargh! My system obviously cannot boot without libata. Guess it's
time to go through git log and see how to fix that build breakage
myself ...

Michal, how did you even manage to build / boot this kernel!


> On 7/21/07, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Jul 20, 2007 at 06:37:33PM -0700, Andrew Morton wrote:
> > > On Fri, 20 Jul 2007 18:02:57 -0700 Greg KH <gregkh@suse.de> wrote:
> > >
> > > > --- a/kernel/params.c
> > > > +++ b/kernel/params.c
> > > > @@ -567,7 +567,11 @@ static void __init kernel_param_sysfs_se
> > > >     kobject_set_name(&mk->kobj, name);
> > > >     kobject_init(&mk->kobj);
> > > >     ret = kobject_add(&mk->kobj);
> > > > -   BUG_ON(ret < 0);
> > > > +   if (ret) {
> > > > +           printk(KERN_ERR "module '%s' failed to be added to sysfs, "
> > > > +                   "the system will be unstable now.\n", name);
> > > > +           return;
> > > > +   }
> > >
> > > It would be nice to print the value of `ret' too.
>
>
> What I'm surprised about is that %eax doesn't seem to contain the
> return value `ret' of kobject_add(). It's 1, which is funny, given:
>
> ret = kobject_add(&mk->kobj);
> BUG_ON(ret < 0);
>
> One wouldn't expect BUG() -- or the corresponding exception handler --
> to clobber registers, that would be a sad day.


But I cracked this one alright. His .config has CONFIG_PROFILE_LIKELY=y
which replaces unlikely() / likely() with do_check_likely() and forces
gcc to clobber %eax with the condition itself, which in our case was
(ret < 0) == TRUE, and thus, the "1" value we saw in %eax in the
register dumps.

We should probably document somewhere that CONFIG_PROFILE_LIKELY
is not good for debugging.

Hmmm ... thinking out aloud here, but probably I don't need to fix that
libata breakage at all. I'll just put the BUG_ON(ret < 0) back in the
code, deselect PROFILE_LIKELY, and this time we _will_ have the
return of kobject_add() in %eax ...


That'll at least clear up the EEXIST vs EINVAL mystery, that'll be a
good data point, yes.

Anyway, I guess I must stop my running commentary -- will only post
after this is cleared up now :-)

Satyam
