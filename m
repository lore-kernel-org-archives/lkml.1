Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYDJAip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYDJAip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYDJAih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:38:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58079 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYDJAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:38:36 -0400
X-Greylist: delayed 8594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 20:38:36 EDT
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: sukadev@us.ibm.com, Containers <containers@lists.osdl.org>, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <47FC138B.4070408@zytor.com>
References: <20080408215333.GA8799@us.ibm.com>  <47FC138B.4070408@zytor.com>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 15:15:13 -0700
Message-Id: <1207779313.16926.12.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: hpa@zytor.com, sukadev@us.ibm.com, containers@lists.osdl.org, clg@fr.ibm.com, linux-kernel@vger.kernel.org, xemul@openvz.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 17:53 -0700, H. Peter Anvin wrote:
> sukadev@us.ibm.com wrote:
> > Devpts namespace patchset
> > 
> > In continuation of the implementation of containers in mainline, we need to
> > support multiple PTY namespaces so that the PTY index (ie the tty names) in
> > one container is independent of the PTY indices of other containers.  For
> > instance this would allow each container to have a '/dev/pts/0' PTY and
> > refer to different terminals.
> > 
> 
> Why do we "need" this?  There isn't a fundamental need for this to be a 
> dense numberspace (in fact, there are substantial reasons why it's a bad 
> idea; the only reason the namespace is dense at the moment is because of 
> the hideously bad handing of utmp in glibc.)  Other than indicies, this 
> seems to be a more special case of device isolation across namespaces, 
> would that be a more useful problem to solve across the board?

In short application migration.  When you move a running applicaiton
from one machine to another you want to be able to keep the same pseudo
devices.

The isolation that you have noticed is also an important application and
like the rest of the namespaces if we can solve the duplicate identifier
problem needed to restore checkpoints we also largely solve the
isolation problem.

This problem is much larger then ptys.  ptys are the really in your face
aspect of it.  There are a more pseudo devices in the kernel and it is
the device number to device mapping that we are abstracting.  So this
really should be done as a device namespace not a pty namespace.

I would be happy if the first version of the device namespace could not
map anything but pty's (assuming an incremental implementation path).  I
really don't think we should do a special case for each kind of device.

Oh and just skimming the patch summary I'm pretty certain this
implementation breaks /sys/class/tty/ptyXX/uevent.  Which is another
reason why it would be good to have a single device namespace.  So we
only to capture one more namespace and figure out how to deal with it
when mounting sysfs. 

Eric

