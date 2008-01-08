Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYAHHF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYAHHF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYAHHFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:05:14 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:12238 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753444AbYAHHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:05:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uNtCUWeM4a9whlu+PGtKL4e5G5SlZ4FOqGCdJhlFo++7wKTrIIsfqmokKUCpOlfEfmslhs/Kv0mZ0WbJsHkX8ZLtj36NK3tZl6TN1+/xtkN8b+40veufvPihaqguXxEerH+77rhFRShbLDvbfNVPbNzG4GJEGrQerGrraZHcNfI=
Message-ID: <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
Date: Tue, 8 Jan 2008 15:05:10 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com, dbrownell@users.sourceforge.net,
       linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org,
       cbou@mail.ru, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <20080107172009.GA25943@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	 <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	 <20080107084528.GA8365@suse.de>
	 <200801070101.15168.david-b@pacbell.net>
	 <478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de>
	 <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 1:20 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 07, 2008 at 06:13:37PM +0100, Stefan Richter wrote:
> > It's already in the driver core to the most part.  It remains to be seen
> > what is less complicated in the end:  Transparent mutex-protected list
> > accesses provided by driver core (requires the iterator), or all the
> > necessary locking done by the drivers themselves (requires some more
> > lock-taking but perhaps fewer lock instances overall in the drivers, and
> > respective redefinitions and documentation of the driver core API).
>
> I favor changing the driver core api and doing this kind of thing there.
> It keeps the drivers simpler and should hopefully make their lives
> easier.

What about this?

#define class_for_each_dev(pos, head, member) \
        for (mutex_lock(&(container_of(head, struct class, devices))->mutex), po
s = list_entry((head)->next, typeof(*pos), member); \
        prefetch(pos->member.next), &pos->member != (head) ? 1 : (mutex_unlock(&
(container_of(head, struct class, devices))->mutex), 0); \
        pos = list_entry(pos->member.next, typeof(*pos), member))

>
> > Semi off-topic:  What about struct device.sem?  Is there any chance to
> > rip this out of the driver core and let drivers serialize everything?  I
> > suppose not...
>
> See the previous long threads about this very topic, that is what caused
> this class.sem patches :)
>
> thanks,
>
> greg k-h
>
