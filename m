Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZGBPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZGBPWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZGBPWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:22:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZGBPWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:22:25 -0400
Subject: Re: fanotify: the fscking all notification system
From: Eric Paris <eparis@redhat.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
In-Reply-To: <alpine.LSU.2.00.0907021654360.26791@fbirervta.pbzchgretzou.qr>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
	 <alpine.LSU.2.00.0907021654360.26791@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 11:22:03 -0400
Message-Id: <1246548123.2855.7.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 17:02 +0200, Jan Engelhardt wrote:
> On Monday 2009-06-29 22:08, Eric Paris wrote:
> >
> >struct fanotify_event_metadata {
> >        __u32 event_len;
> >        __s32 fd;
> >        __u32 mask;
> >        __u32 f_flags;
> >        pid_t pid;
> >        pid_t tgid;
> >        __u64 cookie;
> >}  __attribute__((packed));
> 
> Why pid_t and not s32 like the other fields are?

I'll change them just to be sure userspace/kernel space have to be
consistent.

> >3) call getsockattr on the socket to get back data about events that
> >took place and to get fd's opened in your context
> >[..].
> >This provides information about the event including the type, the
> >location of the new fd that was opened pointing to the object in
> >question, and it provides information about the process which triggered
> >the event.
> 
> Now the question would be whether getsockattr (meant getsockopt?)
> returns data about one event or multiple events.

yes, getsockopt().  Currently it fills your buffer with as many of these
as it can.  The FAN_EVENT_OK and FAN_EVENT_NEXT macros are intended to
make it easy to process the whole buffer full.

> Why is not read() used? Sure, it is not as easy, but if you require
> the size argument to read() being at least sizeof(event_metadata),
> things should fit, should not they?
> Using getsockopt feels like an ioctl - and they for one are
> more or less discouraged in light of netlink for example.

I can't think of a reason why the event polling process couldn't be done
using read() on the socket instead of getsockopt().  I'll try to code
something up today to make sure it works like I think it will.

> >fanotify has two basic 'modes' directed and global.  fanotify directed
> >works much like inotify in that userspace marks inodes it is interested
> >in and gets events from those inodes.  fanotify global instead indicates
> >that it wants everything on the system and then individually marks
> >inodes that it doesn't care about.
> 
> So indexers and such only need a single fd for getting notifications
> about touched files? Sounds great.

That's the gist, then again, that's how inotify is supposed to work too
(although the indexer in inotify has to use the wd to open the file that
just got touched, fanotify gives you the open fd with the event)

-Eric

