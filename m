Return-Path: <linux-kernel-owner+w=401wt.eu-S935288AbXGUDVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935288AbXGUDVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXGUDVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:21:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:40199 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbXGUDVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m+lxHcmdikyxrYQLa3pR50dIpPfBTT7LWTGETs2YKr6SuivUR/iVR2lmNYt1Kw5wNfefqjhAdDCBXSdcORgFBwhgtFnTmQevIMkSvON4+o1l3KKIq5fvhMeaw8Ce0vsmewiTOn10QQXII84rupz6eDy+sz3SqB6uo2Jpweev74I=
Message-ID: <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
Date: Sat, 21 Jul 2007 08:51:36 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070721014419.GA10761@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <20070720225047.GA17520@suse.de>
	 <20070720155912.079c5a27.akpm@linux-foundation.org>
	 <20070720231052.GA19752@suse.de>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
	 <20070721010257.GA9561@suse.de>
	 <20070720183733.c53b511b.akpm@linux-foundation.org>
	 <20070721014419.GA10761@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Considering this has sufficiently excited me, I became the second person
to illegitimately download 2.6.22-mm1 and am presently building Michal's
config. The strange thing is that I couldn't get 22-mm1 to even build with
the posted .config -- so had to deselect XFS, ATA, unionfs.

Hopefully this bug should be 100% reproducible at boot time anyway.
Don't care much for XFS and unionfs, but hoping deselecting ATA from
the config doesn't change the variables much in this equation. ]


On 7/21/07, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jul 20, 2007 at 06:37:33PM -0700, Andrew Morton wrote:
> > On Fri, 20 Jul 2007 18:02:57 -0700 Greg KH <gregkh@suse.de> wrote:
> >
> > > --- a/kernel/params.c
> > > +++ b/kernel/params.c
> > > @@ -567,7 +567,11 @@ static void __init kernel_param_sysfs_se
> > >     kobject_set_name(&mk->kobj, name);
> > >     kobject_init(&mk->kobj);
> > >     ret = kobject_add(&mk->kobj);
> > > -   BUG_ON(ret < 0);
> > > +   if (ret) {
> > > +           printk(KERN_ERR "module '%s' failed to be added to sysfs, "
> > > +                   "the system will be unstable now.\n", name);
> > > +           return;
> > > +   }
> >
> > It would be nice to print the value of `ret' too.


What I'm surprised about is that %eax doesn't seem to contain the
return value `ret' of kobject_add(). It's 1, which is funny, given:

ret = kobject_add(&mk->kobj);
BUG_ON(ret < 0);

One wouldn't expect BUG() -- or the corresponding exception handler --
to clobber registers, that would be a sad day.


> Ok, how about this version:
>
> ---
>  kernel/params.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -567,7 +567,12 @@ static void __init kernel_param_sysfs_se
>         kobject_set_name(&mk->kobj, name);
>         kobject_init(&mk->kobj);
>         ret = kobject_add(&mk->kobj);
> -       BUG_ON(ret < 0);
> +       if (ret) {
> +               printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
> +                     "error number %d\n", name, ret);
> +               printk(KERN_ERR "The system will be unstable now.\n");
> +               return;
> +       }
>         param_sysfs_setup(mk, kparam, num_params, name_skip);
>         kobject_uevent(&mk->kobj, KOBJ_ADD);
>  }


I'm building with this:

if (ret) {
        printk("~~~~~ .%s.%d.%s. ~~~~~\n", name, ret, kparam->name);
        return;
}

To also print out the evil kparam->name that caused us to crash.
When ret == EINVAL, name would be "", so not so helpful alone.

Also enabling netconsole, though I'm sure there's zero chances
of NET / ethXXX / netconsole being up _this_ early in the boot ...

Will keep you guys posted :-)

Satyam
