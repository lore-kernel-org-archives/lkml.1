Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZHPPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZHPPus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZHPPur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:50:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48192 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752018AbZHPPuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:50:46 -0400
Date: Sun, 16 Aug 2009 11:50:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
In-Reply-To: <200908152254.23227.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908161130590.6522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Rafael J. Wysocki wrote:

> > The only remaining question is how to expose this in sysfs in a way 
> > that won't be confusing and that won't be confused with the "wakeup" 
> > attribute.  One possibility is to use the "level" attribute introduced 
> > in USB; possible levels are "on" (no runtime PM) and "auto" (runtime 
> > PM allowed).  Then a new "runtime_wakeup" attribute could contain 
> > nothing (if wakeup is not available), "enabled", or "disabled".
> 
> That seems to require two flags.
> 
> runtime_forbidden - if unset, the driver decides whether or not to use runtime
>   PM; that could be exposed through sysfs as 'runtime' under the 'power'
>   subdirectory with the following values:
>   * 'disabled' - runtime_forbidden is set by the user space
>   * 'on' - runtime_forbidden is unset, runtime PM is used (disable_depth == 0)
>   * 'off' - runtime_forbidden is unset, runtime PM is not used
>   To set/unset the user space writes 'enabled'/'disabled' to it, respectively.
>   The default is unset.

Too confusing.  The difference between "disabled" and "off" is so
subtle that even I don't understand it!

All we need for this is a simple on/off switch.  Or to be consistent
with the terms that are already exposed to userspace for USB devices:  
"auto"/"on", where "auto" means the system automatically changes power
levels (runtime PM is enabled) and "on" means the device is always on
(runtime PM is disabled).

And I don't like the "runtime_forbidden" name either.  It's long and
it's a negative, making it harder to understand.  ("off" means that the
device is permanently on!)  What's wrong with "level", as in
"power/level"?  That seems very intuitive.

> runtime_wakeup - if set, the device is allowed to do remote wakeup at run time
>   That could be represented as 'runtime_wakeup' under 'power' with the
>   following values:
>   * no value (empty file) is 'runtime' is 'disabled'
>   * 'enabled'
>   * 'disabled'
>   To set/unset the user space writes 'enabled'/'disabled' to it, respectively.
>   The default is set.

This is okay except for your definition of empty file.  This makes it
dependent on the power/level setting.  The two should be independent.  
Thus, empty file should mean that the device doesn't support remote
wakeup, in which case writes are ignored.

This scheme, like yours, requires two new bitflags.  We could call them
something like "may_runtime_suspend" and "may_runtime_wakeup".

Alan Stern

