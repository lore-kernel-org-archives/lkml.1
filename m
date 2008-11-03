Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYKCV1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYKCV1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYKCV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:27:34 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36912 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYKCV1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:27:33 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH v2 2/3] ACPI: Behave uniquely based on processor declaration definition type
Date: Mon, 3 Nov 2008 15:27:29 -0600
User-Agent: KMail/1.9.10
Cc: Myron Stowe <myron.stowe@hp.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
References: <20081030215410.30683.95368.stgit@bob.kio> <1225680700.8772.86.camel@localhost> <1225684742.26020.30.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1225684742.26020.30.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031427.30511.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 November 2008 08:59:02 pm Zhao Yakui wrote:
> On Mon, 2008-11-03 at 10:51 +0800, Myron Stowe wrote:
> > On Mon, 2008-11-03 at 09:15 +0800, Zhao Yakui wrote:
> > > On Mon, 2008-11-03 at 08:10 +0800, Myron Stowe wrote:
> > > > On Fri, 2008-10-31 at 09:19 +0800, Zhao Yakui wrote:
> > > > > On Fri, 2008-10-31 at 06:13 +0800, Myron Stowe wrote:
> > snip
> > > > > >  
> > > > > > @@ -562,8 +571,11 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > > > >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > > > > >  				  "No bus mastering arbitration control\n"));
> > > > > >  
> > > > > > -	/* Check if it is a Device with HID and UID */
> > > > > > -	if (has_uid) {
> > > > > > +	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_HID)) {
> > > > > > +		/*
> > > > > > +		 * Declared with "Device" statement; match _UID.
> > > > > > +		 * Note that we don't handle string _UIDs yet.
> > > > > Looks very good. 
> > > > > Can you add the check whether the device.flags.unique_id exists before
> > > > > evaluating the _UID object? 
> > > > > If not exist, it indicates that the processor definition is incorrect.
> > > > 
> > > > The additional check would create a relationship with
> > > > 'device.flags.unique_id' which seems redundant and would introduce
> > > > unnecessary complexity going forward.  While such an additional check
> > > > would possibly short circuit the call to 'acpi_evaluate_integer()' -
> > > > when FW is in error and a _UID child object does not exist; a case that
> > > > is already caught - this code is not in a performance path and thus
> > > > seems to yield no benefit.
> > > In your patch the device.flags.unique_id is not used.
> > Yes, instead the explicit indicator that [Patch 1/3] introduced was used
> > so one can explicitly destinguish between "Processor" declared CPU
> > devices and "Device" declared CPU devices.  This was mainly because it
> > is valid for both declaration types to have _UID child objects (but only
> > "Device" declared devices will use the _UID for mapping purposes as we
> > have already covered and agreed upon).
> > >  Maybe on some
> > > systems the processor is defined by Device. But there is no _UID
> > > object.This is incorrect.
> > Agreed, this would be incorrect - a platform FW error.
> When there is no _UID object for the processor definition using Device,
> it is a FW error. And this error should be printed. 
> Of course this error is detected by the acpi_evaluate_integer. But if a
> string is returned by _UID object, the acpi_evaluate_integer will also
> return failure. But in such case we can't know the exact error from the
> dmesg.
> 
> IMO It is unnecessary to evaluate the _UID object when there is _UID
> object(by checking the device.flags.unique_id). In such case the error
> info is printed. (" BIOS bug : no _UID object for the processor
> definition using device").
> 
> When there exists the _UID object, the acpi_evaluate_integer will be
> called.  And the return value of _UID is regarded as the ACPI processor
> ID. If AE_OK is not returned by acpi_evaluate_integer, maybe it is
> caused by other error(For example: mismatch type). In such case the log
> info is helpful to get the root cause.
> 
> Of course it is also OK that the error is detected by the
> acpi_evaluate_integer.

I think you're proposing this (this is only pseudo-code):

	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_HID)) {
		/* Declared with "Device" statement; match _UID. */
		if (!device->flags.unique_id) {
			printk(KERN_ERR PREFIX "BIOS bug: no _UID object for processor Device definition\n");
			return -ENODEV;
		}
                status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID, NULL, &value);
		if (ACPI_FAILURE(status)) {
			printk(KERN_ERR PREFIX "Evaluating processor _UID\n");
			return -ENODEV;
		}
	} else {
		/* Declared with "Processor" statement; match ProcessorID */
		...
	}

I think it is pointless to add code to check device->flags.unique_id.

The only benefit is that we get a different error message for a
specific kind of firmware defect.  For someone bringing up a platform
with new firmware that uses a string _UID or is defective, this might
save five minutes.  But the extra code takes up space in *everybody's*
kernel all the time.

And it makes the code more complicated because it adds a
dependency on "device->flags.unique_id", so code readers now have
to figure out what that means and whether it is set correctly.

Maybe it would be worthwhile to change the second error message to
something like this:

	printk(KERN_ERR PREFIX "Evaluating processor _UID (%x)\n", status);

Then one could probably distinguish the "_UID didn't exist" error from
the "_UID is not an integer" error.

Would that address your concern?

Bjorn
