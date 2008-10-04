Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYJDMJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYJDMJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 08:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYJDMJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 08:09:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44952 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYJDMJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 08:09:40 -0400
Message-ID: <ac3eb2510810040509q24b26c8ek2bd6ca75343e2553@mail.gmail.com>
Date: Sat, 4 Oct 2008 14:09:38 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
In-Reply-To: <200810031601.31322.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
	 <200808220606.39722.bjorn.helgaas@hp.com>
	 <1219408985.20723.66.camel@lgn.site>
	 <200810031601.31322.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 12:01 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Friday 22 August 2008 06:43:05 am Kay Sievers wrote:
>> On Fri, 2008-08-22 at 06:06 -0600, Bjorn Helgaas wrote:
>> > Since PNP currently doesn't generate any uevents or modalias files,
>> > I expect that a non-ACPI system will be unable to autoload modules
>> > for ISAPNP or PNPBIOS devices.  Right?
>>
>> They do create events, but without modalias. The shell script hack,
>> which udev runs, will make the event behave like it contained one.
>
> I'm finally looking at this again; sorry for the long hiatus.  I'm
> working on a patch to add PNP uevent support, modalias sysfs files
> for PNP, and file2alias.c changes to match, and I just want to
> make sure I'm understanding this correctly.

Sounds good, just in mind, that there are custom modprobe configs out
there, that rely on the current pnp alias format, like:
  alias pnp:dPNP0510 irtty-sir
  alias pnp:dPNP0511 irtty-sir
  alias pnp:dPNP0700 floppy
  alias pnp:dPNP0303 atkbd
  alias pnp:dPNP0f13 psmouse
  ...
We should make sure, that this still works, which wouldn't if we just
do the acpi style aliases.

> Before your file2alias.c changes[1], I think we generated this:
>    alias pnp:dPNP0500* 8250_pnp
>
> We relied on the udev shell hack to run "modprobe -a pnp:dPNP0500"
> based on the contents of /sys/bus/pnp/devices/00:05/id.
>
> With your file2alias.c changes, we now generate this:
>    alias acpi*:PNP0500:* 8250_pnp
>    alias pnp:dPNP0500* 8250_pnp
>
> On ACPI systems, this works fine because "acpi*:PNP0500:*" matches
> the ACPI-generated uevents like:
>    MODALIAS=acpi:PNP0501:PNP0500:
>
> We can load 8250_pnp without relying on the udev shell hack
> *on ACPI systems*.
>
> I thought the object of your file2alias.c changes was to remove the
> need for the udev shell hack, but don't we still require it on
> non-ACPI systems because they won't emit the ACPI uevents?

Yes, the plan is to move that rule from the default udev rule set to
the isapnp package.

Thanks,
Kay
