Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZBJN5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZBJN5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZBJN5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:57:38 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:27076 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZBJN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:57:37 -0500
Date: Tue, 10 Feb 2009 14:57:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090210145716.105ab58b@hyperion.delvare>
In-Reply-To: <20090204142015.GB3923@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291130.35434.trenn@suse.de>
	<68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
	<alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
	<20090204060513.GA28321@srcf.ucam.org>
	<498953DF.5050306@redhat.com>
	<20090204131708.GA2739@srcf.ucam.org>
	<20090204142606.1823661b@hyperion.delvare>
	<20090204142015.GB3923@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Sorry for the late answer.

On Wed, 4 Feb 2009 14:20:15 +0000, Matthew Garrett wrote:
> On Wed, Feb 04, 2009 at 02:26:06PM +0100, Jean Delvare wrote:
> > On Wed, 4 Feb 2009 13:17:09 +0000, Matthew Garrett wrote:
> > > Personally, I'd rather that it was "strict" on everything. We might 
> > > break some existing setups, but they're already working mostly by luck.
> > 
> > Are you the new hwmon and i2c subsystems maintainer and I wasn't aware
> > of it?
> 
> If you've got some programmatic way to tell the difference between safe 
> and dangerous reuse of ACPI resources then that would obviously be 
> preferable, but I doubt that's practical.

I wish we had such a way, but I don't know of any. If someone can think
of one, that would be someone who knows ACPI much better than I do.

> auto is a compromise that 
> avoids one specific case of breakage, but it does nothing to protect us 
> on the majority of systems. Allowing the firmware and the OS to attempt 
> to access the same hardware without any locking is an invitation for 
> disaster, and in the absence of any way to prevent the firmware from 
> doing it...

In theory you are, of course, perfectly right. The question is, how do
we get there without making people angry because of the regression? I
had yet another example a few days ago:

http://lists.lm-sensors.org/pipermail/lm-sensors/2009-February/025297.html

That system implements an ACPI thermal zone, which apparently reads its
values from the second temperature channel of the IT8716F Super-I/O
chip. This channels happens to be broken (not sure why but that's not
really the point) and returns a wrong temperature value.

The same chip can be driven by our native it87 driver, which, on this
specific board, provides support for 9 voltages, 3 fans, and 1 working
temperature. Do we really have to tell the user to not use the it87
driver and instead use the ACPI thermal driver "because that's what the
firmware wants"?

In this case, I really would like to be able to blacklist the ACPI
thermal device, and let the it87 driver handle the device. If we can
have such a blacklist in the kernel, then I am fine switching the
resource conflict check to "strict" by default. But is is possible? I
would like the ACPI people to tell me. Basically the logic would be as
follows:

if (not laptop) {
	if (ACPI thermal zone defined
	 && no custom ACPI code dealing with thermal conditions) {
		disable ACPI thermal zone and free its resources for native driver
	}
}

But I guess there is no way to know what exactly the ACPI thermal zone
is doing, except by looking at the DSDT, so this can't be automated?

Is it at least possible to disable the ACPI thermal zone either as a
command-line parameter or an internal blacklist?

> But. Hans asked for my opinion - the maintainer's is obviously more 
> relevant.

Well, officially I am not the maintainer of the hwmon subsystem, only
whose of the i2c subsystem. But the fact is that the resource conflict
checking policy affects both the same way. That being said, I'm not
sure how worth my opinion (about this specific matter) is these days...

What I want you (and everyone) to realize is that just switching the
default checking level to strict tomorrow isn't going to work. If we
want the default to be strict then we will have to add a number of
mechanisms to let the user override this in a way which is as easy and
transparent as possible for the user.

One approach that may work is to change the default based on the ACPI
implementation year (I think the info is available, right?) We could
default to strict for systems with year >= 2009. This may still prevent
users from getting the best out of their system, but at least won't
cause a regression for users of older systems where the native driver
has been used so far. I know it's not an ideal solution, but ACPI
implementations aren't ideal either.

-- 
Jean Delvare
