Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZHRN32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZHRN32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbZHRN32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:29:28 -0400
Received: from ru.mvista.com ([213.79.90.228]:42066 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758831AbZHRN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:29:27 -0400
Date: Tue, 18 Aug 2009 17:29:28 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] pcf50633: use a dedicated workqueue for irq processing
Message-ID: <20090818132928.GA32765@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <200907281845.n6SIjIlf025081@home.pavel.comp>
 <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
 <20090731092313.GA21633@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090731092313.GA21633@home.pavel.comp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 01:23:13PM +0400, Paul Fertser wrote:
> On Thu, Jul 30, 2009 at 03:34:25PM -0700, Andrew Morton wrote:
> > On Tue, 28 Jul 2009 00:41:15 +0400
> > Paul Fertser <fercerpav@gmail.com> wrote:
> > 
> > > Using the default kernel "events" workqueue causes problems with
> > > synchronous adc readings if initiated from some task on the same
> > > workqueue.
> > > 
> > > I had a deadlock trying to use pcf50633_adc_sync_read from a
> > > power_supply class driver because the reading was initiated from the
> > > workqueue and it waited for the irq processing to complete (to get the
> > > result) and that was put on the same workqueue.
> > 
> > I don't get it.
> > 
> > Do you meant that pcf50633_adc_sync_read() was called via a
> > schedule_work() handler?  If so, wasn't that a bug?
> 
> Andrew, i think it is called this way:
> 
> power_supply_changed -> schedule_work(&psy->changed_work) ->
> power_supply_changed_work -> kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE)
> -> power_supply_uevent -> power_supply_show_property -> get_property ->
> bat->pdata->get_voltage -> pcf50633_adc_sync_read
> 
> I assumed that since power_supply class is well-established and widely used
> that's an intended behaviour. CCing relevant maintainers to get their
> opinions.

The thing is that power_supply_changed() is supposed to be callable
from any context (including hard IRQs), so we use schedule_work().

I see the deadlock problem, and it could be fixed by a dedicated
workqueue either in the pcf50633 driver, or power supply class.
I don't mind either way.

Another option is to implement power_supply_changed_can_sleep(),
which won't use schedule_work(), and so we won't need another
thread.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
