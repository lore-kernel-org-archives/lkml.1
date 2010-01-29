Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0A2UZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0A2UZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169Ab0A2UZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:25:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35570 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0A2UZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:25:38 -0500
To: Greg KH <gregkh@suse.de>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	<m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>
	<m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 29 Jan 2010 12:25:22 -0800
In-Reply-To: <20100129142223.GB12539@suse.de> (Greg KH's message of "Fri\, 29 Jan 2010 06\:22\:23 -0800")
Message-ID: <m1d40sr74d.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> Heh, this whole mess is the very reason we didn't add lockdep support to
> the driver core.  Nested devices that all look alike from the driver
> core, are really different objects and the locking lifetimes are
> separate, but lockdep can't see that.
>
> I suggest we just remove the original patch, as it seems to be causing
> way too many problems.
>
> Any objections to that?

I think the hit rate for real problems has been about 25-50%.  Of the
false positives a lot of those have been, code that is at least
questionable.

Furthermore there are problems we can find this way that we won't know
about any other way.  Unfortunately I haven't had much time to do
anything kernel related lately, or I would have done more with this.
My comment was about simply about finding a good way to increase the
signal to noise ration so investigations can reasonably start with the
presumption that code lockdep is complaining about real problems.

The deadlocks that we can hit in sysfs are very nasty to find, they
have persisted for years, and they pop back up after they are fixed.
So far the pain from lockdep annotations seems a lot lower.

Right now annotating with subclasses as Amerigo is attempting will work,
and remove the false positives.  I was simply hoping to find a faster
way to get there.

So yes, I do object to removing the original patch.  Let's put in the
work to find a good path to remove the handful of cases that cause
false positives.

It's a shame we aren't getting stack overflow errors on the same paths
that are removing sysfs attributes from the callback handlers of sysfs
attributes, or we could just rule out that questionable practice and
call all of the lockdep warnings valid.  Unfortunately that would just
be the tail wagging the horse.

Eric
