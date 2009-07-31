Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZGaJYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZGaJYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZGaJYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:24:37 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53856 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZGaJYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hVy+7tcUfm9f14QR3micYfgBWo2FvbEb7UE+mp36wpR4K9tysfU3lr4Evlnd1dfZGB
         hv2Xyb9igtjTY95k4iqiU16zKfcFxQCkGEiQLsDjomlb+ku0Ht3DOuMgWWhoZ9Lm/i9C
         W9LZCiLSmuWF5ScZ/tDTjxhFwCE8Vq/gUt4pI=
Date: Fri, 31 Jul 2009 13:23:13 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] pcf50633: use a dedicated workqueue for irq processing
Message-ID: <20090731092313.GA21633@home.pavel.comp>
References: <200907281845.n6SIjIlf025081@home.pavel.comp> <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 03:34:25PM -0700, Andrew Morton wrote:
> On Tue, 28 Jul 2009 00:41:15 +0400
> Paul Fertser <fercerpav@gmail.com> wrote:
> 
> > Using the default kernel "events" workqueue causes problems with
> > synchronous adc readings if initiated from some task on the same
> > workqueue.
> > 
> > I had a deadlock trying to use pcf50633_adc_sync_read from a
> > power_supply class driver because the reading was initiated from the
> > workqueue and it waited for the irq processing to complete (to get the
> > result) and that was put on the same workqueue.
> 
> I don't get it.
> 
> Do you meant that pcf50633_adc_sync_read() was called via a
> schedule_work() handler?  If so, wasn't that a bug?

Andrew, i think it is called this way:

power_supply_changed -> schedule_work(&psy->changed_work) ->
power_supply_changed_work -> kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE)
-> power_supply_uevent -> power_supply_show_property -> get_property ->
bat->pdata->get_voltage -> pcf50633_adc_sync_read

I assumed that since power_supply class is well-established and widely used
that's an intended behaviour. CCing relevant maintainers to get their
opinions.

A bit of background: we sometimes want to use dumb batteries with our
openmoko devices (for gta01 aka Neo1973 there's no alternative even), so
power_class driver needs to be able to obtain battery voltage measured by
PMU.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
