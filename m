Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYINPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYINPVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYINPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:21:28 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55571 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYINPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sfDrJxyhygDte5Wxbl9NQocq+XNkr1QuwE4ZWaIbMaWUNMVM5rBmxmKsgPcKOA8Tcf
         KMBANDt5/FkXm8kFIbsvjGHwOa1Me1r/MbeexE8w62lX946Y+/sD1/J1WNwXIrT1+LxT
         NC0UZdQhAgRwLhq06IFoPmgKQ1bCti2E+N/Q8=
Message-ID: <a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
Date: Sun, 14 Sep 2008 08:21:26 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080908141555.GB31784@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080901160343.75a89ec9@infradead.org>
	 <20080901161423.59ebf2fc@infradead.org>
	 <20080902100439.GA11383@elf.ucw.cz>
	 <20080902060323.70245b83@infradead.org>
	 <20080908132713.GA18486@elf.ucw.cz>
	 <20080908064002.7abc2a22@infradead.org>
	 <20080908141555.GB31784@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 7:15 AM, Pavel Machek <pavel@suse.cz> wrote:
> Ok, so select()/poll() may default to non-zero slack for legacy apps.

That's the goal.

> Yes, it is a great advantage, but it feels like a hack. Maybe it is
> better done with LD_PRELOAD or something?
>
> I'd certianly want the applications to specify slack themselves in
> like 10 years.

LD_PRELOAD is not a solution.  LD_PRELOAD always has been and always
will be a hack.  You use it to work around problems or to test
something.  Nothing else.

LD_PRELOAD and other variables are ignored in security-relevant
contexts and environments are cleared in many situations.  Sure, you
could use /etc/ld.so.preload but that works around only one problem.
Furthermore, there is a significant cost associated with preloading.
There are additional files to be loaded and it disables prelinking.

The prctl() way plus a default non-zero value is the best way for
legacy apps.  And you'll hopefully get your wish that apps will take
fate into their own hand by specifying the slack themselves.  Arjan's
proposal also introduces new poll/select-like interface which take the
additional slack value (at least that's what we discussed before).

I'm strongly opposed to using LD_PRELOAD.  And I think requiring the
libc implementation of select/ poll, ... etc to wrap around the new
interfaces which take the slack and determine the slack at userlevel
(by reading some file) is too expensive.  It's one little value per
process (group) to be kept by the kernel.  That's not much.
