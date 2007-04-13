Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXDMJAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXDMJAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbXDMJAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:00:53 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56935 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbXDMJAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:00:48 -0400
Date: Fri, 13 Apr 2007 11:03:13 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
Message-ID: <20070413110313.352330ce@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 17:23:18 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> Here's a not-so-theoretical question.
> 
> I've got a module which registers a struct device.  (It represents a
> virtual device, not a real one, but that doesn't matter.)  Obviously the
> module's exit routine has to wait until the release() routine for that
> device has been invoked -- if it returned too early then the release()
> call would oops.
> 
> How should it wait?

Device lifetime vs. module lifetime - that's a fun one...

> 
> The most straightforward approach is to use a struct completion, like 
> this:
> 
> 	static struct {
> 		struct device dev;
> 		...
> 	} my_dev;
> 
> 	static DECLARE_COMPLETION(my_completion);
> 
> 	static void my_release(struct device *dev)
> 	{
> 		complete(&my_completion);
> 	}
> 
> 	static void __exit my_exit(void)
> 	{
> 		device_unregister(&my_dev.dev);
> 		wait_for_completion(&my_completion);
> 	}
> 
> The problem is that there is no guarantee a context switch won't take
> place after my_release() has called complete() and before my_release()  
> returns.  If that happens and my_exit() finishes running, then the module
> will be unloaded and the next context switch back to finish off
> my_release() will oops.
> 
> Other approaches have similar defects.  So how can this problem be solved?

What I see that a device driver may do now is the following:
- disallow module unloading (duh)
- move the release function outside the module

To make the completion approach work, the complete() would need to be
after the release function. This would imply an upper layer, but this
upper layer would need to access the completion structure in the
module...

One could think about a owner field (for getting/putting the module
reference) for the object (with a final module_put() after the release
function has been called). The problem there would be that it would
preclude unloading of the module if there isn't a "self destruct" knob
for the object.
