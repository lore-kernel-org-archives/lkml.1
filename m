Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZLWCpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZLWCpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 21:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZLWCpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 21:45:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:58665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZLWCpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 21:45:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,440,1257148800"; 
   d="scan'208";a="581457740"
Date: Wed, 23 Dec 2009 10:45:13 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
Message-ID: <20091223024513.GA30764@sli10-desk.sh.intel.com>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
 <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
 <20091218022112.GA30333@sli10-desk.sh.intel.com>
 <20091218051457.GB417@elte.hu>
 <4B309AB9.7030208@kernel.org>
 <20091223005637.GA16783@sli10-desk.sh.intel.com>
 <4B317491.5050303@kernel.org>
 <86802c440912221809w35dbb1eegcf6133ed1f190069@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440912221809w35dbb1eegcf6133ed1f190069@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 10:09:04AM +0800, Yinghai Lu wrote:
> On Tue, Dec 22, 2009 at 5:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > Shaohua Li wrote:
> >> On Tue, Dec 22, 2009 at 06:08:57PM +0800, Yinghai Lu wrote:
> >>> Ingo Molnar wrote:
> >>>> * Shaohua Li <shaohua.li@intel.com> wrote:
> >>>>
> >>>>> On Fri, Dec 18, 2009 at 09:28:50AM +0800, Yinghai Lu wrote:
> >>>>>> On Wed, Dec 16, 2009 at 12:06 PM, Len Brown <lenb@kernel.org> wrote:
> >>>>>>> Hi Linus,
> >>>>>>>
> >>>>>>> please pull from:
> >>>>>>>
> >>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> >>>>>>>
> >>>>>> ;..
> >>>>>>> Shaohua Li (3):
> >>>>>>> ? ? ?ACPI: Add a generic API for _OSC -v2
> >>>>>>> ? ? ?ACPI: cleanup pci_root _OSC code.
> >>>>>>> ? ? ?ACPI: Add platform-wide _OSC support.
> >>>>>> it seems these three patches broke the _OSC on my intel new systems.
> >>>>>>
> >>>>>> revert them fix the problem with AER and pciehp and etc
> >>>>> can you give more details? I just cleaned up the _OSC code for AER and
> >>>>> pciehp, no function changes.
> >>>> Famous last words ;-)
> >>>>
> >>>> Yinghai, i suspect Shaohua needs the kind of info you'd need if you tried to
> >>>> fix it: acpidump, before/after debug boot log, a description of what goes bad,
> >>>> etc.
> >>> the so called clean up, change the ret length checking.
> >>>
> >>> -       if (!output.length)
> >>> -               return AE_NULL_OBJECT;
> >>> -
> >>>
> >>> +       /* return buffer should have the same length as cap buffer */
> >>> +       if (context->ret.length != context->cap.length)
> >>> +               return AE_NULL_OBJECT;
> >> Wield BIOS. ACPI spec does mention the return buffer have the same length.
> >> Does changing the check back make the issue go away?
> >
> > change to
> > if (context->ret.length < context->cap.length)
> >
> > make AER work, but pciehp still fail.
Can you try below patch please? Looks the returned acpi buffer is a two-tiled buffer.
Strange is it doesn't fail at my hand.

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 65f7e33..0c1ad31 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -397,6 +397,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 	union acpi_object *out_obj;
 	u8 uuid[16];
 	u32 errors;
+	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
 
 	if (!context)
 		return AE_ERROR;
@@ -419,16 +420,16 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 	in_params[3].buffer.length 	= context->cap.length;
 	in_params[3].buffer.pointer 	= context->cap.pointer;
 
-	status = acpi_evaluate_object(handle, "_OSC", &input, &context->ret);
+	status = acpi_evaluate_object(handle, "_OSC", &input, &output);
 	if (ACPI_FAILURE(status))
 		return status;
 
-	/* return buffer should have the same length as cap buffer */
-	if (context->ret.length != context->cap.length)
+	if (!output.length)
 		return AE_NULL_OBJECT;
 
-	out_obj = context->ret.pointer;
-	if (out_obj->type != ACPI_TYPE_BUFFER) {
+	out_obj = output.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER
+		|| out_obj->buffer.length != context->cap.length) {
 		acpi_print_osc_error(handle, context,
 			"_OSC evaluation returned wrong type");
 		status = AE_TYPE;
@@ -457,11 +458,20 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 		goto out_kfree;
 	}
 out_success:
-	return AE_OK;
+	context->ret.length = out_obj->buffer.length;
+	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	if (!context->ret.pointer) {
+		status =  AE_NO_MEMORY;
+		goto out_kfree;
+	}
+	memcpy(context->ret.pointer, out_obj->buffer.pointer,
+		context->ret.length);
+	status =  AE_OK;
 
 out_kfree:
-	kfree(context->ret.pointer);
-	context->ret.pointer = NULL;
+	kfree(output.pointer);
+	if (status != AE_OK)
+		context->ret.pointer = NULL;
 	return status;
 }
 EXPORT_SYMBOL(acpi_run_osc);
