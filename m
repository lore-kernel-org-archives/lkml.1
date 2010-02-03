Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0BCU3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:29:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab0BCU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q24XpnCqilnn56erxp/daQYgTPKugHymCNleDw8ZAgEN8mV2tU/MOZzK3N6aomBAff
         XpU5dIDzjN4PjBvDF561dE9eqJETFo1vdeDhpSxaDMqw3uLDS0ZlRegDyLQPRJXmXAg0
         cqbuUvQ5TWXqAh4Egun+PmrNkRVscVOO4qqk4=
Date: Wed, 3 Feb 2010 21:29:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs deadlock
Message-ID: <20100203202909.GA5068@nowhere>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com> <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:08:57PM +0300, Alexander Beregalov wrote:
> On 3 February 2010 22:03, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> > Hi Frederic
> >
> > I do not have previous messages and do not know how to reproduce it.
> > Kernel was 2.6.33-rc5-00237-g9a3cbe3
> >
> 
> Hm, I have the same after reboot.
> 
> Do you need me to do anything before I try to fsck ?


Yeah. Rebooting again makes your kernel soft lockup?

Usually such softlockup happens because we have a lock
inversion, in which case you should have a lockdep report
before the softlockup.

Otherwise this can also happen when we wait for an event
that needs the lock to complete but
that can not happen because we already have the lock.

Task A hold reiserfs lock and wait for event 1
Task B wants to complete event 1 but it need the reisers lock
for that => deadlock.

This can usually be found in a softlockup report: lots of
tasks are blocked on reiserfs_write_lock/mutex_lock
except one, and this one is important as it is probably
the waiter: the task that holds the lock and that is waiting
for another event (that in turn needs the lock to complete).

Having more reports could probably help us:

echo 100 > /proc/sys/kernel/hung_task_warnings

Hopefully you can still reproduce it :-s

Thanks a lot!

