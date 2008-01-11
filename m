Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbYAKTAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbYAKTAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYAKS74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:59:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53397 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbYAKS7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:59:55 -0500
Date: Fri, 11 Jan 2008 19:59:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Help needed to fix section mismatch warnings
Message-ID: <20080111185958.GI28624@uranus.ravnborg.org>
References: <20080106140728.GA3504@uranus.ravnborg.org> <20080109222542.422c90e0.randy.dunlap@oracle.com> <20080110111918.42e4fa0b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110111918.42e4fa0b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:19:18AM -0800, Randy Dunlap wrote:
> On Wed, 9 Jan 2008 22:25:42 -0800 Randy Dunlap wrote:
> 
> > On Sun, 6 Jan 2008 15:07:28 +0100 Sam Ravnborg wrote:
> > 
> > 
> > > This is the current list of warnings
> > 
> > Sam,
> > 
> > Several of these are due to driver variable names not matching
> > the whitelisted names in modpost.  I have patches for the ones
> > that I have identified so far.  And I have patches for a few of
> > the others that are true section mismatch problems (total of 8
> > patches ready for now).
> > 
> > The whitelisted names will always be a (small) problem.
> > Can __init_refok be used in these cases.. or some other new
> > attribute, instead of forever adding to the whitelist or
> > modifying variable names?
> 
> Sam (or anyone :),
> 
> I guess that I'm a little confused.  Instead of changing
> variable names to match the modpost whitelist, I tested adding
> __init_refok or __initdata_refok to these (driver) structs that
> generated the modpost warnings.
> 
> Example:  drivers/char/tpm/tpm_infineon.c
> 
> --- linux-2.6.24-rc7-git1.orig/drivers/char/tpm/tpm_infineon.c
> +++ linux-2.6.24-rc7-git1/drivers/char/tpm/tpm_infineon.c
> @@ -611,7 +611,7 @@ static __devexit void tpm_inf_pnp_remove
>  	}
>  }
>  
> -static struct pnp_driver tpm_inf_pnp = {
> +static struct pnp_driver __init_refok tpm_inf_pnp = {
>  	.name = "tpm_inf_pnp",
>  	.driver = {
>  		.owner = THIS_MODULE,
> 
> This has a build warning with my toolchain:
> 
>   CC      drivers/char/tpm/tpm_infineon.o
> linux-2.6.24-rc7-git1/drivers/char/tpm/tpm_infineon.c:614: warning: 'noinline' attribute ignored
> {standard input}: Assembler messages:
> {standard input}:2315: Warning: setting incorrect section attributes for .text.init.refok
> 
> but otherwise no section mismatch warning.
> 
> OTOH, using __initdata_refok has no build warning and no section
> mismatch warning... but it (__initdata_refok) doesn't make sense
> to me.  Should it (make sense/be used)?

What we try to do is to tell modpost that from this
particular spot in the code it is not a bug when a
__init/__exit function is called.
The whitelisting uses the name of the variable to determine
is this is a bug and not.
But traditionally we have in the kernel used annotation for this.
The __initdata_refok  wer invented as a tag that could be used
to tell modpost that this variable may call an __init function.

What happens is that the variable is placed in a section named:
.data.init.refok and when modpost encounter a variable in this
section then it does not warn.

Likewise __init_refok teach gcc to locate the function in a
section named .text.init.refok and modpost uses this to 
know that __init referneces are not a bug when they happens
in this section. In addition __init_refok contains noinline
to avoid agressive gcc inlining which gcc does across different
sections.

> Is there a __refok that should be used here, instead of having
> to modify variable names?

So far I have favoured consistent variable namings but
I could be persuaded to use annotation as the preferred method.
If for no other reason then because the annotation is a nice
way to document that in this spot the reference is OK.
But better named annothation is then needed...

	Sam
