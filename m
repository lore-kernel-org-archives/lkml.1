Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0AQRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0AQRS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AQRS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:18:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34104 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0AQRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:18:56 -0500
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       linux-pcmcia@lists.infradead.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] sysfs: Add lockdep annotations for the sysfs active reference
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
	<m11vi8yyrb.fsf_-_@fess.ebiederm.org>
	<20100118002647.35035e77@tom-lei>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 17 Jan 2010 09:18:34 -0800
In-Reply-To: <20100118002647.35035e77@tom-lei> (Ming Lei's message of "Mon\, 18 Jan 2010 00\:26\:47 +0800")
Message-ID: <m1eilo7iqd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:

> On Sat, 02 Jan 2010 13:37:12 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> Holding locks over device_del -> kobject_del -> sysfs_deactivate can
>> cause deadlocks if those same locks are grabbed in sysfs show or store
>> methods.
>> 
>> The I model s_active count + completion as a sleeping read/write lock.
>> I describe to lockdep sysfs_get_active as a read_trylock,
>> sysfs_put_active as a read_unlock, and sysfs_deactivate as a
>> write_lock and write_unlock pair.  This seems to capture the essence
>> for purposes of finding deadlocks, and in my testing gives finds real
>> issues and ignores non-issues.
>> 
>> This brings us back to holding locks over kobject_del is a problem
>> that ideally we should find a way of addressing, but at least lockdep
>> can tell us about the problems instead of requiring developers to
>> debug rare strange system deadlocks, that happen when sysfs files are
>> removed while being written to.
>
> The model has hit a possible deadlock in pcmcia, and the lockdep warning
> comes when I unplug my wlan card from pcmcia slot.
>
> Looks like socket->skt_mutex is held in remove path, and it is also
> grabbed in .stor method.


Looking a little closer this is simultaneously a legitimate problem
and also a false positive.

This is only legitimate if you add/remove a cardbus bridge, plugged into
another cardbus bridge, which I think is unlikely but physically possible.

Eric
