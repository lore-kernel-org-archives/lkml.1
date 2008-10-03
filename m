Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYJCWBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYJCWBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYJCWBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:01:37 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:25612 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYJCWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:01:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Fri, 3 Oct 2008 16:01:30 -0600
User-Agent: KMail/1.9.9
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver> <200808220606.39722.bjorn.helgaas@hp.com> <1219408985.20723.66.camel@lgn.site>
In-Reply-To: <1219408985.20723.66.camel@lgn.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031601.31322.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 06:43:05 am Kay Sievers wrote:
> On Fri, 2008-08-22 at 06:06 -0600, Bjorn Helgaas wrote:
> > Since PNP currently doesn't generate any uevents or modalias files,
> > I expect that a non-ACPI system will be unable to autoload modules
> > for ISAPNP or PNPBIOS devices.  Right?
> 
> They do create events, but without modalias. The shell script hack,
> which udev runs, will make the event behave like it contained one.

I'm finally looking at this again; sorry for the long hiatus.  I'm
working on a patch to add PNP uevent support, modalias sysfs files
for PNP, and file2alias.c changes to match, and I just want to
make sure I'm understanding this correctly.

Before your file2alias.c changes[1], I think we generated this:
    alias pnp:dPNP0500* 8250_pnp

We relied on the udev shell hack to run "modprobe -a pnp:dPNP0500"
based on the contents of /sys/bus/pnp/devices/00:05/id.

With your file2alias.c changes, we now generate this:
    alias acpi*:PNP0500:* 8250_pnp
    alias pnp:dPNP0500* 8250_pnp

On ACPI systems, this works fine because "acpi*:PNP0500:*" matches
the ACPI-generated uevents like:
    MODALIAS=acpi:PNP0501:PNP0500:

We can load 8250_pnp without relying on the udev shell hack
*on ACPI systems*.

I thought the object of your file2alias.c changes was to remove the
need for the udev shell hack, but don't we still require it on
non-ACPI systems because they won't emit the ACPI uevents?

Bjorn

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22454cb99fc39f2629ad06a7eccb3df312f8830e
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e4c6564c95ce127beeefe75e15cd11c93487436
