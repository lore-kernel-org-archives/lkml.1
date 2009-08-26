Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZHZKaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZHZKaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZHZKap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZHZKam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:42 -0400
Date: Wed, 26 Aug 2009 13:29:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090826102908.GA21523@redhat.com>
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:57:01PM -0700, Davide Libenzi wrote:
> On Tue, 25 Aug 2009, Michael S. Tsirkin wrote:
> 
> > Yes, we don't want that. The best thing is to try to restate the problem
> > in a way that is generic, and then either solve or best use existing
> > solution. Right?
> > 
> > I thought I had that, but apparently not.  The reason I'm Cc-ing you is
> > not to try and spam you until you give up and accept the patch, it's
> > hoping that you see the pattern behind our usage, and help generalize
> > it.
> > 
> > If I understand it correctly, you believe this is not possible and so
> > any solution will have to be in KVM? Or maybe I didn't state the problem
> > clearly enough and should restate it?
> 
> Please do.
> 
> 
> 
> - Davide


Problem looks like this:

There are multiple processes (devices) where each has a condition
(interrupt line) which it has logic to determine is either true or
false.

A single other process (hypervisor) is interested in a condition
(interrupt level) which is a logical OR of all interrupt lines.
On changes, an interrupt level value needs to be read and copied to
guest virtual cpu.

We also want ability to replace some or all processes above by a kernel
components, with condition changes done potentially from hardware
interrupt context.


How we wanted to solve it with EFD_STATE: Share a separate eventfd
between each device and the hypervisor.  device sets state to either 0
or 1.  hypervisor polls all eventfds, reads interrupt line on changes,
calculates the interrupt level and updates guest.

Alternative solution: shared memory where each device writes interrupt
line value. This makes setup more complex (need to share around much more
than just an fd), and makes access from interrupt impossible unless we
lock the memory (and locking userspace memory introduces yet another set
of issues).


-- 
MST
