Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYGXP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYGXP1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYGXP1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:27:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:43340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYGXP1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:27:44 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: ACPI OSI disaster on latest HP laptops - critical temperature shutdowns
Date: Thu, 24 Jul 2008 17:27:40 +0200
User-Agent: KMail/1.9.9
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>,
       Christian Kornacker <ckornacker@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241727.41715.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this BIOS bug some days ago.
The positive with this one is, that it nicely shows the
need of some things I lately came up with
(point 1. and 2., 3. and 4. are further suggestions):

1) Do not be transparent to Windows in ACPI OSI parts
   -> and do not fake to be Windows as long term goal

2) Document _OSI BIOS developer usage in
   Documentation/acpi/known_bios_osi_workarounds

3) Linuxfirmwarekit needs kernel support

4) ACPI AML functionality to report errors to the OS


The problem:

HP extensively makes use of ACPI thermal zones.
It seems they hit a bug in Vista which probably caused their
machines to be shut down through a critical temperature event.
They now workaround that Vista bug by returning zero for _CRT
(which is the critical temperature in Kelvin * 10).
So they return -273 degree Celsius which leads to a critical
temperature shutdown as soon as the ACPI thermal driver is loaded.

This is in short the corresponding ACPI BIOS code:

# BIOS checks which OS is running (most parts cut off)
# Linux is returning true for all but not for "Windows 2006 SP1"
# (Vista SP1) and not for "Linux"
                ...
                If (_OSI ("Windows 2001 SP3"))
                {
                    Store (0x12, OSTB)
                    Store (0x12, TPOS)
                }
                If (_OSI ("Windows 2006"))
                {
                    Store (0x40, OSTB)
                    Store (0x40, TPOS)
                }

                If (_OSI ("Windows 2006 SP1"))
                {
                    Store (0x41, OSTB)
                    Store (0x40, TPOS)
                }

                If (_OSI ("Linux"))
                {
                    Store (One, LINX)
                    Store (0x80, OSTB)
                    Store (0x80, TPOS)
                }


# Valid critical/hot temperature: 105 (0x69)
        Name (TPC, 0x69)
        ...
           Method (_HOT, 0, Serialized)
            {
# Match for Vista only, not for Vista SP1 !
!!!                If (LEqual (TPOS, 0x40))
                {
                    Return (Add (0x0AAC, Multiply (TPC, 0x0A)))
                }
                Else
                {
                    Return (Zero)
                }
            }
            Method (_CRT, 0, Serialized)
            {
# Returns valid values for all Windows version before Vista
!!!                If (LLess (TPOS, 0x40))
                {
# This is the valid one: 105 C -> (105 * 10) + 2732 (Kelvin * 10)
                    Return (Add (0x0AAC, Multiply (TPC, 0x0A)))
                }
                Else
                {
# This is returned on Windows Vista
                    Return (Zero)
                }
            }
----------------------

This is the fix for this from Arjan:

    ACPI: Reject below-freezing temperatures as invalid critical temperatures

    My laptop thinks that it's a good idea to give -73C as the critical
    CPU temperature.... which isn't the best thing since it causes a shutdown
    right at bootup.

    Temperatures below freezing are clearly invalid critical thresholds
    so just reject these as such.

commit a39a2d7c72b358c6253a2ec28e17b023b7f6f41c
@@ -364,10 +364,17 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
        if (flag & ACPI_TRIPS_CRITICAL) {
                status = acpi_evaluate_integer(tz->device->handle,
                                "_CRT", NULL, &tz->trips.critical.temperature);
-               if (ACPI_FAILURE(status)) {
+               /*
+                * Treat freezing temperatures as invalid as well; some
+                * BIOSes return really low values and cause reboots at startup.
+                * Below zero (Celcius) values clearly aren't right for sure..
+                * ... so lets discard those as invalid.
+                */
+               if (ACPI_FAILURE(status) ||
+                               tz->trips.critical.temperature <= 2732) {
                        tz->trips.critical.flags.valid = 0;
                        ACPI_EXCEPTION((AE_INFO, status,
-                                       "No critical threshold"));
+                                       "No or invalid critical threshold"));
                        return -ENODEV;
                } else {
                        tz->trips.critical.flags.valid = 1;


----------------------


What are the consequences of:
  1) The fact that BIOS vendors have to fix Windows bugs/erratas through
     ACPI _OSI hooks (this is nearly the only way BIOS vendors do use the
     _OSI interface)
  2) The current Linux _OSI implementation being transparent to Windows
  3) The invalid critical temperature is simply ignored and the trip
     point not shown to userspace


1) One must assume that such a Vista or Vista SP1 only bug workaround has to
   be spread by HP to all of their BIOSes, thus killing all ACPI aware Linux
   kernels to work.

2) Vendors who want to provide Linux and Windows support
   have to provide a separate BIOS or patch the Linux kernel so that they
   need not to run Windows errata workarounds through _OSI hooks.

3) This Vista bug can be workarounded by checking for zero.
   Things could get more complex.
   Linux cannot implement all Windows bugs of all Windows versions on
   long-term.

4) HP certifies (at least some of) their laptops to work with distributions.
   The above patch absorbs the BIOS bug, making it impossible for the current
   Linuxfirmwarekit implementation to detect it.
   Above BIOS update could have been rejected by certification -> needs
   a kernel facility to report BIOS bugs. Or at least the certified
   distribution could have been patched along with with this BIOS update/
   breakage.

5) It is just a matter of time until Windows version specific ACPI bugs are
   workarounded in BIOSes in the server area also.

Therefore some suggestions (from above):

1) As a long term goal Linux should not be transparent to Windows.
   Nearly all _OSI conditions where ACPI code is checking which OS is
   running, do implement Windows bug workarounds. Vendors are not able
   to fix the Windows implementation, therefore they have to do it in
   BIOS. While the next Windows generation might have fixed the cause,
   Linux tries to implement (be compatible with) all Windows bugs.

2) Document Windows bugs workarounded via _OSI in
   Documentation/acpi/known_osi_hooks

3) Document Linux _OSI behavior. No ACPI BIOS developer is aware that
   Linux violates the Spec. All latest ACPI BIOSes do check for "Linux"
   as running OS, but Linux does not return true for the call.
   I have started to document current _OSI behavior on Linux. I then
   realized it might be a good idea to extend it a bit and talk about
   general ACPI BIOS problems on Linux. It's here: ftp://ftp.suse.com/pub/people/trenn/ACPI_BIOS_on_Linux_guide/acpi_guideline_for_vendors.pdf
   Comments for enhancements, additions, etc. are appreciated.
   I'll anounce that separately.

4) Provide a facility to tell userspace about BIOS bugs.
   The:
   FIRMWARE_BUG(severity, "Message");
   interface idea I mentioned recently in an unrelated thread.
   The idea is something similar to printk, but to be able use it intensively
   on each possible bogus value returned from BIOS (also for documentation)
   and to be able to compile it out to not waste that much memory on
   production kernels.
   At the end is a patch that extends Arjan's patch by also checking return
   values for hot (is an issue with HP Bioses already), passive and active
   trip points, in wrong BIOS value case we want to inform userspace
   that something in BIOS is bogus, so that HW vendors who care about Linux
   see that something could go wrong.

5) Something ACPI specific, maybe Intel is able to push this into the
   ACPI specification on (very) long-term:
     ACPI BIOS developers cannot report error conditions.
     Therefore you often end up in invalid values as they have to return
     a value if a function is provided even
     they know it does not make any sense at all.
     Ideas:
         1) Provide an error object similar to the debug object.
            -> Just to have something in the logs
         2) Add error values to each or sets of ACPI function
            -> cumbersome
         3) Introduce return_error statement which can be used instead of
            return. If it is used, the kernel must ignore the value
            of the function.
            -> would help a lot, similar functionality like 2., but easier


       Thomas


This patch also fixes hot, passive and active trip points in case
zero is returned as temperature invalidating the trip point.
Hopefully this can be reported as a firmware bug soon.

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 84c795f..f6344f6 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -400,7 +400,8 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 	if (flag & ACPI_TRIPS_HOT) {
 		status = acpi_evaluate_integer(tz->device->handle,
 				"_HOT", NULL, &tz->trips.hot.temperature);
-		if (ACPI_FAILURE(status)) {
+		if (ACPI_FAILURE(status) ||
+				tz->trips.hot.temperature <= 2732) {
 			tz->trips.hot.flags.valid = 0;
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					"No hot threshold\n"));
@@ -425,7 +426,8 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 				"_PSV", NULL, &tz->trips.passive.temperature);
 		}
 
-		if (ACPI_FAILURE(status))
+		if (ACPI_FAILURE(status) ||
+				tz->trips.passive.temperature <= 2732)
 			tz->trips.passive.flags.valid = 0;
 		else {
 			tz->trips.passive.flags.valid = 1;
@@ -480,7 +482,8 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 		if (flag & ACPI_TRIPS_ACTIVE) {
 			status = acpi_evaluate_integer(tz->device->handle,
 				name, NULL, &tz->trips.active[i].temperature);
-			if (ACPI_FAILURE(status)) {
+			if (ACPI_FAILURE(status) ||
+			    tz->trips.active[i].temperature <= 2732) {
 				tz->trips.active[i].flags.valid = 0;
 				if (i == 0)
 					break;
