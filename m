Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZKFNbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZKFNbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZKFNbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:31:02 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61725 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZKFNbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:31:00 -0500
Date: Fri, 6 Nov 2009 14:31:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to
 unlocked_ioctl
Message-ID: <20091106143103.2fca8368@hyperion.delvare>
In-Reply-To: <200911061422.49596.arnd@arndb.de>
References: <20091015202722.372890083@linutronix.de>
	<20091015202758.400949170@linutronix.de>
	<20091106141542.12404c5c@hyperion.delvare>
	<200911061422.49596.arnd@arndb.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 14:22:49 +0100, Arnd Bergmann wrote:
> On Friday 06 November 2009, Jean Delvare wrote:
> > I'm not sure why we need to hold the mutex here? My understanding is
> > that watchdog_data_mutex protects watchdog_data_list and each
> > watchdog's kref. And the above code doesn't touch either.
> > 
> > What I am more worried about is why ident is declared static. This
> > looks like a bug to me. Instead of abusing watchdog_data_mutex to
> > workaround this, I'd rather remove the "static". I guess that the
> > current code happens to work because neither data->revision nor
> > nowayout can change over time, but this looks needlessly fragile.
> > 
> > Hans, any comment?
> 
> The data copied into the watchdog_info data structure is completely
> static. To make that clearer, I'd suggest moving it outside of
> the ioctl function, and initializing it from fschmd_init.
> Then it becomes obvious that the mutex is not needed to protect it.

Thinking about it some more... The driver supports the case where
several chips are present on the system. I don't think we've ever seen
this, but it is possible in theory. In this case, each chip would have
its data->revision, and then the watchdog_info data structure is no
longer static. We would need one watchdog_info data structure per
fschmd_data. Whether allocating and initializing them at device probing
time makes sense, I'm not so sure... I doubt this ioctl is
performance-critical, so generating the data on-the-fly sounds quite
sane to me.

-- 
Jean Delvare
