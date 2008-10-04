Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYJDPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYJDPcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 11:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYJDPcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 11:32:00 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33225 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYJDPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 11:31:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Sat, 4 Oct 2008 09:31:43 -0600
User-Agent: KMail/1.9.9
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver> <200810031601.31322.bjorn.helgaas@hp.com> <ac3eb2510810040509q24b26c8ek2bd6ca75343e2553@mail.gmail.com>
In-Reply-To: <ac3eb2510810040509q24b26c8ek2bd6ca75343e2553@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810040931.44067.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2008 6:09:38 am Kay Sievers wrote:
> On Sat, Oct 4, 2008 at 12:01 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Friday 22 August 2008 06:43:05 am Kay Sievers wrote:
> >> On Fri, 2008-08-22 at 06:06 -0600, Bjorn Helgaas wrote:
> >> > Since PNP currently doesn't generate any uevents or modalias files,
> >> > I expect that a non-ACPI system will be unable to autoload modules
> >> > for ISAPNP or PNPBIOS devices.  Right?
> >>
> >> They do create events, but without modalias. The shell script hack,
> >> which udev runs, will make the event behave like it contained one.
> >
> > I'm finally looking at this again; sorry for the long hiatus.  I'm
> > working on a patch to add PNP uevent support, modalias sysfs files
> > for PNP, and file2alias.c changes to match, and I just want to
> > make sure I'm understanding this correctly.
>
> Sounds good, just in mind, that there are custom modprobe configs out
> there, that rely on the current pnp alias format, like:
>   alias pnp:dPNP0510 irtty-sir
>   alias pnp:dPNP0511 irtty-sir
>   alias pnp:dPNP0700 floppy
>   alias pnp:dPNP0303 atkbd
>   alias pnp:dPNP0f13 psmouse
>   ...
> We should make sure, that this still works, which wouldn't if we just
> do the acpi style aliases.

My thought is to make PNP emit uevents with modaliases like
"MODALIAS=pnp:PNP0501:PNP0500:" and make file2alias generate
aliases like "alias pnp*:PNP0500:* 8250_pnp".

Modprobe configs like "alias pnp:dPNP0510 irtty-sir" would
still work but would continue to depend on the udev shell hack.

If we just move the udev shell hack to the isapnp package, those
"alias pnp:dPNP0510 irtty-sir" configs would then depend on isapnp,
which doesn't seem like quite what we want.  We can certainly have
PNP0510 ACPI devices that don't depend on isapnp.

All I want to do now is *enable* more conventional configs like
"alias pnp*:PNP0510:* irtty-sir" to work without extra hacks.
I don't have any plan for actually removing the hacks or doing
any user-space transition.

> > Before your file2alias.c changes[1], I think we generated this:
> >    alias pnp:dPNP0500* 8250_pnp
> >
> > We relied on the udev shell hack to run "modprobe -a pnp:dPNP0500"
> > based on the contents of /sys/bus/pnp/devices/00:05/id.
> >
> > With your file2alias.c changes, we now generate this:
> >    alias acpi*:PNP0500:* 8250_pnp
> >    alias pnp:dPNP0500* 8250_pnp
> >
> > On ACPI systems, this works fine because "acpi*:PNP0500:*" matches
> > the ACPI-generated uevents like:
> >    MODALIAS=acpi:PNP0501:PNP0500:
> >
> > We can load 8250_pnp without relying on the udev shell hack
> > *on ACPI systems*.
> >
> > I thought the object of your file2alias.c changes was to remove the
> > need for the udev shell hack, but don't we still require it on
> > non-ACPI systems because they won't emit the ACPI uevents?
>
> Yes, the plan is to move that rule from the default udev rule set to
> the isapnp package.

