Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234Ab0AQSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0AQSD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812Ab0AQSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:03:55 -0500
Received: from isilmar.linta.de ([213.133.102.198]:51504 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743Ab0AQSDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:03:54 -0500
Date: Sun, 17 Jan 2010 19:03:51 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] sysfs: Add lockdep annotations for the sysfs active reference
Message-ID: <20100117180351.GA17688@isilmar.linta.de>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Ming Lei <tom.leiming@gmail.com>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	David Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, linux-pcmcia@lists.infradead.org
References: <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> <m1fx6rtu31.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> <m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org> <m11vi8yyrb.fsf_-_@fess.ebiederm.org> <20100118002647.35035e77@tom-lei> <m1eilo7iqd.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eilo7iqd.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Jan 17, 2010 at 09:18:34AM -0800, Eric W. Biederman wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
> 
> > On Sat, 02 Jan 2010 13:37:12 -0800
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> 
> >> Holding locks over device_del -> kobject_del -> sysfs_deactivate can
> >> cause deadlocks if those same locks are grabbed in sysfs show or store
> >> methods.
> >> 
> >> The I model s_active count + completion as a sleeping read/write lock.
> >> I describe to lockdep sysfs_get_active as a read_trylock,
> >> sysfs_put_active as a read_unlock, and sysfs_deactivate as a
> >> write_lock and write_unlock pair.  This seems to capture the essence
> >> for purposes of finding deadlocks, and in my testing gives finds real
> >> issues and ignores non-issues.
> >> 
> >> This brings us back to holding locks over kobject_del is a problem
> >> that ideally we should find a way of addressing, but at least lockdep
> >> can tell us about the problems instead of requiring developers to
> >> debug rare strange system deadlocks, that happen when sysfs files are
> >> removed while being written to.
> >
> > The model has hit a possible deadlock in pcmcia, and the lockdep warning
> > comes when I unplug my wlan card from pcmcia slot.
> >
> > Looks like socket->skt_mutex is held in remove path, and it is also
> > grabbed in .stor method.
> 
> 
> Looking a little closer this is simultaneously a legitimate problem
> and also a false positive.
> 
> This is only legitimate if you add/remove a cardbus bridge, plugged into
> another cardbus bridge, which I think is unlikely but physically possible.

Unfortunately, it is not a false positive, as removing a PCMCIA device
racing with "pccardctl eject" seems to trigger this path as well. Patch is
being prepared...

Best,
	Dominik
