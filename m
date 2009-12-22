Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZLVQaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZLVQaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZLVQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:30:10 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:42799 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753657AbZLVQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:30:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NJuyD6U6zTMDCJscqKpokLYPc1KrRF9lJIYLIm9DBqzzywXEEIC7EoJLGgBTRS10uvr0D+2dv6il4ICH/DxZmccC5kJBffYADjZEhotdnrbLPRgI+fOEWOWHMldPl1ue;
Date: Tue, 22 Dec 2009 08:30:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFD] Asynchronous suspend/resume of PCI devices
Message-ID: <20091222083001.10ce3948@jbarnes-x200>
In-Reply-To: <200912200031.38775.rjw@sisk.pl>
References: <200912200031.38775.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.217.62.130 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009 00:31:38 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> I'd like to know your opinions about the viability of suspending and
> resuming PCI devices asynchronously during system-wide PM transitions
> (suspend to RAM and hibernation).
> 
> Linus says it's generally dangerous, because some PCI devices may
> indirectly depend on the others, but if that's the case, I wonder if
> we really can power manage PCI devices at run time.
> 
> It follows from my experiments that suspending and resuming PCI
> devices asynchronously doesn't lead to problems as long as we make
> sure that every PCI device is suspended before and resumed after its
> ACPI "shadow" partner. However, I'm not sure if this is generally
> correct.
> 
> What are possible problems we can run into while doing asynchronous
> suspend and resume of PCI devices?  What do we need to do in general
> to avoid that problems?
> 
> Please tell me what you think.

AFAIK it should be *mostly* safe.  Individual drivers are generally
independent of one another.  However, there are quite a few
multifunction devices (some exposed as such, some exposed as multiple
busses and devices on the same device) where interdependencies are
possible.  In some cases, we just won't see power savings until the
whole chip is powered down (which may require extra code in the form of
a "bus" driver of some sort), in other cases a driver may inadvertently
power down a piece of a device needed by another driver.

That said, the best practice for those sorts of devices is to create a
bus driver anyway, that binds to the master device and has a few
child drivers, so maybe even that case won't be much trouble...

Jesse
