Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYKCCvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYKCCvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 21:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYKCCvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 21:51:44 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:22321 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYKCCvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 21:51:43 -0500
Subject: Re: [PATCH v2 2/3] ACPI: Behave uniquely based on processor
 declaration definition type
From: Myron Stowe <myron.stowe@hp.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <1225674917.26020.10.camel@yakui_zhao.sh.intel.com>
References: <20081030215410.30683.95368.stgit@bob.kio>
	 <20081030221319.30683.23234.stgit@bob.kio>
	 <1225415958.3993.10.camel@yakui_zhao.sh.intel.com>
	 <1225671037.8772.30.camel@localhost>
	 <1225674917.26020.10.camel@yakui_zhao.sh.intel.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 19:51:40 -0700
Message-Id: <1225680700.8772.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 09:15 +0800, Zhao Yakui wrote:
> On Mon, 2008-11-03 at 08:10 +0800, Myron Stowe wrote:
> > On Fri, 2008-10-31 at 09:19 +0800, Zhao Yakui wrote:
> > > On Fri, 2008-10-31 at 06:13 +0800, Myron Stowe wrote:
snip
> > > >  
> > > > @@ -562,8 +571,11 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > > >  				  "No bus mastering arbitration control\n"));
> > > >  
> > > > -	/* Check if it is a Device with HID and UID */
> > > > -	if (has_uid) {
> > > > +	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_HID)) {
> > > > +		/*
> > > > +		 * Declared with "Device" statement; match _UID.
> > > > +		 * Note that we don't handle string _UIDs yet.
> > > Looks very good. 
> > > Can you add the check whether the device.flags.unique_id exists before
> > > evaluating the _UID object? 
> > > If not exist, it indicates that the processor definition is incorrect.
> > 
> > The additional check would create a relationship with
> > 'device.flags.unique_id' which seems redundant and would introduce
> > unnecessary complexity going forward.  While such an additional check
> > would possibly short circuit the call to 'acpi_evaluate_integer()' -
> > when FW is in error and a _UID child object does not exist; a case that
> > is already caught - this code is not in a performance path and thus
> > seems to yield no benefit.
> In your patch the device.flags.unique_id is not used.
Yes, instead the explicit indicator that [Patch 1/3] introduced was used
so one can explicitly destinguish between "Processor" declared CPU
devices and "Device" declared CPU devices.  This was mainly because it
is valid for both declaration types to have _UID child objects (but only
"Device" declared devices will use the _UID for mapping purposes as we
have already covered and agreed upon).
>  Maybe on some
> systems the processor is defined by Device. But there is no _UID
> object.This is incorrect.
Agreed, this would be incorrect - a platform FW error.
>    IMO in such case we should catch such error.
There are a number of reasons that 'acpi_processor_get_info()' can fail.
They all return some type of -ERRNO to 'acpi_processor_start()' which,
upon receiving a non-zero value, short circuits out due to "Processor is
physically not present".

Are you suggesting that this case is significantly different from any of
the other error cases and should be handled seperately (currently all
error cases are handled in the same fashion)?  If so, what specifically
were you thinking should be done?

Thanks,
Myron
>   
> Best regards.
>    Yakui
> > Was there some other aspect that you were thinking of?
> > 
> > Myron
> > 
> > > Thanks.
> > > > +		 */
> > > >  		unsigned long long value;
> > > >  		status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
> > > >  						NULL, &value);
> > > > @@ -571,13 +583,10 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > >  			printk(KERN_ERR PREFIX "Evaluating processor _UID\n");
> > > >  			return -ENODEV;
> > > >  		}
> > > > +		device_declaration = 1;
> > > >  		pr->acpi_id = value;
> > > >  	} else {
> > > > -		/*
> > > > -		* Evalute the processor object.  Note that it is common on SMP to
> > > > -		* have the first (boot) processor with a valid PBLK address while
> > > > -		* all others have a NULL address.
> > > > -		*/
> > > > +		/* Declared with "Processor" statement; match ProcessorID */
> > > >  		status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
> > > >  		if (ACPI_FAILURE(status)) {
> > > >  			printk(KERN_ERR PREFIX "Evaluating processor object\n");
> > > > @@ -590,7 +599,7 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > >  		*/
> > > >  		pr->acpi_id = object.processor.proc_id;
> > > >  	}
> > > > -	cpu_index = get_cpu_id(pr->handle, pr->acpi_id);
> > > > +	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);
> > > >  
> > > >  	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
> > > >  	if (!cpu0_initialized && (cpu_index == -1) &&
> > > > @@ -662,7 +671,7 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
> > > >  
> > > >  	pr = acpi_driver_data(device);
> > > >  
> > > > -	result = acpi_processor_get_info(pr, device->flags.unique_id);
> > > > +	result = acpi_processor_get_info(device);
> > > >  	if (result) {
> > > >  		/* Processor is physically not present */
> > > >  		return 0;
> > > > 
> > > 
> 
-- 
Myron Stowe                             HP Open Source & Linux Org

