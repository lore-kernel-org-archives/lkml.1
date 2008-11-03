Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYKCDwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYKCDwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 22:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYKCDwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 22:52:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:17582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbYKCDwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 22:52:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,532,1220252400"; 
   d="scan'208";a="399117901"
Subject: Re: [PATCH v2 2/3] ACPI: Behave uniquely based on processor
	declaration definition type
From: Zhao Yakui <yakui.zhao@intel.com>
To: Myron Stowe <myron.stowe@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <1225680700.8772.86.camel@localhost>
References: <20081030215410.30683.95368.stgit@bob.kio>
	 <20081030221319.30683.23234.stgit@bob.kio>
	 <1225415958.3993.10.camel@yakui_zhao.sh.intel.com>
	 <1225671037.8772.30.camel@localhost>
	 <1225674917.26020.10.camel@yakui_zhao.sh.intel.com>
	 <1225680700.8772.86.camel@localhost>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:59:02 +0800
Message-Id: <1225684742.26020.30.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 10:51 +0800, Myron Stowe wrote:
> On Mon, 2008-11-03 at 09:15 +0800, Zhao Yakui wrote:
> > On Mon, 2008-11-03 at 08:10 +0800, Myron Stowe wrote:
> > > On Fri, 2008-10-31 at 09:19 +0800, Zhao Yakui wrote:
> > > > On Fri, 2008-10-31 at 06:13 +0800, Myron Stowe wrote:
> snip
> > > > >  
> > > > > @@ -562,8 +571,11 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > > >  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> > > > >  				  "No bus mastering arbitration control\n"));
> > > > >  
> > > > > -	/* Check if it is a Device with HID and UID */
> > > > > -	if (has_uid) {
> > > > > +	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_HID)) {
> > > > > +		/*
> > > > > +		 * Declared with "Device" statement; match _UID.
> > > > > +		 * Note that we don't handle string _UIDs yet.
> > > > Looks very good. 
> > > > Can you add the check whether the device.flags.unique_id exists before
> > > > evaluating the _UID object? 
> > > > If not exist, it indicates that the processor definition is incorrect.
> > > 
> > > The additional check would create a relationship with
> > > 'device.flags.unique_id' which seems redundant and would introduce
> > > unnecessary complexity going forward.  While such an additional check
> > > would possibly short circuit the call to 'acpi_evaluate_integer()' -
> > > when FW is in error and a _UID child object does not exist; a case that
> > > is already caught - this code is not in a performance path and thus
> > > seems to yield no benefit.
> > In your patch the device.flags.unique_id is not used.
> Yes, instead the explicit indicator that [Patch 1/3] introduced was used
> so one can explicitly destinguish between "Processor" declared CPU
> devices and "Device" declared CPU devices.  This was mainly because it
> is valid for both declaration types to have _UID child objects (but only
> "Device" declared devices will use the _UID for mapping purposes as we
> have already covered and agreed upon).
> >  Maybe on some
> > systems the processor is defined by Device. But there is no _UID
> > object.This is incorrect.
> Agreed, this would be incorrect - a platform FW error.
When there is no _UID object for the processor definition using Device,
it is a FW error. And this error should be printed. 
Of course this error is detected by the acpi_evaluate_integer. But if a
string is returned by _UID object, the acpi_evaluate_integer will also
return failure. But in such case we can't know the exact error from the
dmesg.

IMO It is unnecessary to evaluate the _UID object when there is _UID
object(by checking the device.flags.unique_id). In such case the error
info is printed. (" BIOS bug : no _UID object for the processor
definition using device").

When there exists the _UID object, the acpi_evaluate_integer will be
called.  And the return value of _UID is regarded as the ACPI processor
ID. If AE_OK is not returned by acpi_evaluate_integer, maybe it is
caused by other error(For example: mismatch type). In such case the log
info is helpful to get the root cause.

Of course it is also OK that the error is detected by the
acpi_evaluate_integer.

Best regards.
   Yakui
> >    IMO in such case we should catch such error.
> There are a number of reasons that 'acpi_processor_get_info()' can fail.
> They all return some type of -ERRNO to 'acpi_processor_start()' which,
> upon receiving a non-zero value, short circuits out due to "Processor is
> physically not present".
> 
> Are you suggesting that this case is significantly different from any of
> the other error cases and should be handled seperately (currently all
> error cases are handled in the same fashion)?  If so, what specifically
> were you thinking should be done?
> 
> Thanks,
> Myron
> >   
> > Best regards.
> >    Yakui
> > > Was there some other aspect that you were thinking of?
> > > 
> > > Myron
> > > 
> > > > Thanks.
> > > > > +		 */
> > > > >  		unsigned long long value;
> > > > >  		status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
> > > > >  						NULL, &value);
> > > > > @@ -571,13 +583,10 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > > >  			printk(KERN_ERR PREFIX "Evaluating processor _UID\n");
> > > > >  			return -ENODEV;
> > > > >  		}
> > > > > +		device_declaration = 1;
> > > > >  		pr->acpi_id = value;
> > > > >  	} else {
> > > > > -		/*
> > > > > -		* Evalute the processor object.  Note that it is common on SMP to
> > > > > -		* have the first (boot) processor with a valid PBLK address while
> > > > > -		* all others have a NULL address.
> > > > > -		*/
> > > > > +		/* Declared with "Processor" statement; match ProcessorID */
> > > > >  		status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
> > > > >  		if (ACPI_FAILURE(status)) {
> > > > >  			printk(KERN_ERR PREFIX "Evaluating processor object\n");
> > > > > @@ -590,7 +599,7 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
> > > > >  		*/
> > > > >  		pr->acpi_id = object.processor.proc_id;
> > > > >  	}
> > > > > -	cpu_index = get_cpu_id(pr->handle, pr->acpi_id);
> > > > > +	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);
> > > > >  
> > > > >  	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
> > > > >  	if (!cpu0_initialized && (cpu_index == -1) &&
> > > > > @@ -662,7 +671,7 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
> > > > >  
> > > > >  	pr = acpi_driver_data(device);
> > > > >  
> > > > > -	result = acpi_processor_get_info(pr, device->flags.unique_id);
> > > > > +	result = acpi_processor_get_info(device);
> > > > >  	if (result) {
> > > > >  		/* Processor is physically not present */
> > > > >  		return 0;
> > > > > 
> > > > 
> > 

