Return-Path: <linux-kernel-owner+w=401wt.eu-S966306AbXDGUIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966306AbXDGUIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDGUIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:08:12 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:26851 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965712AbXDGUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:08:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=fop2f+oLSl+yy6mTUNiULg+iAMghEd3fRJG2Gh1Kfaa+ohfjkyYSFA8l2ZcTi3HDFAEWoWzRnBGdjDkpStQ4L2fkyhxsGONTZ7b+3Afbr2sLfNeZmY6IfRppbvHh4F0P1JotbL949uF+V5vS4BZoSuDpiR49/wFtVfcCpw5hKoI=  ;
X-YMail-OSG: yJQ6nL0VM1k4gAtryGVl_4nP.DaKnhFfdIePDraixW2pG5bU_A1iPYVw6fUFyWPTCSeqmJCdpQ--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Sat, 7 Apr 2007 13:08:07 -0700
User-Agent: KMail/1.7.1
Cc: Zhang Rui <rui.zhang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <200704060843.30723.david-b@pacbell.net> <20070407050131.GB25511@kroah.com>
In-Reply-To: <20070407050131.GB25511@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704071308.07571.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 10:01 pm, Greg KH wrote:

> Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
> pointing to the same acpi node?  Or the other way around?  If so, you
> are going to have to change the name to be something more unique.

I've wondered that too.  The short answer:  APCI only supports 1-1
here.  It will emit warnings if it tries to bind more than one ACPI
device to a given "real" device ... but errors the other way are
silently ignored.

By adding a warning over this create-links patch, I found that the
system in the $SUBJECT patch (and likely every ACPI system) has
two different nodes that correspond to one ACPI node:

	/sys/devices/pci0000:00 ... pci root node
	/sys/devices/pnp0/00:00 ... id PNP0a03
	/sys/devices/acpi_system:00/device:00/PNP0A03:00 ... ditto

Arguably that's too many sysfs nodes for one device...

Plus, there's the issue of flakey ACPI tables; in the $SUBJECT patch
both MDM and AUD nodes exist in the ACPI namespace, but they could
only refer to one PCI device (with MDM as the wakeup source, not AUD
as listed in the table).  Or maybe that's another case where the ACPI
code isn't handling the tables as sensibly as it might...


> Or how about "firmware" instead of "acpi" to be able to have the
> userspace tools work on any type of firmware that provides this, like
> openfirmware?

Assuming they all adopt that same "parallel tree" model, that seems
like a good idea.  The tools will likely need to understand how ACPI
and OF differ, but there's no point in reserving more names than we
really need.  Though it may be that "parallel trees" should go away.

A small glitch in the patch:  lines bigger than 80 characters.  :)

- Dave
