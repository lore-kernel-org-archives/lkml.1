Return-Path: <linux-kernel-owner+w=401wt.eu-S1946416AbXBCJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946416AbXBCJ20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946417AbXBCJ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:28:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946416AbXBCJ2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:28:25 -0500
Date: Sat, 3 Feb 2007 01:24:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?RnLpZOlyaWM=?= Riss <frederic.riss@gmail.com>,
       Matt Domsch <Matt_Domsch@dell.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
Message-Id: <20070203012426.120ec586.akpm@linux-foundation.org>
In-Reply-To: <1170494391.31373.25.camel@funkylaptop>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<20070202054916.GA3754@stusta.de>
	<20070202175504.a3bab5ac.akpm@linux-foundation.org>
	<1170494391.31373.25.camel@funkylaptop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Feb 2007 10:19:51 +0100 Frédéric Riss <frederic.riss@gmail.com> wrote:

> Le vendredi 02 février 2007 à 17:55 -0800, Andrew Morton a écrit :
> > - I have efi-x86-pass-firmware-call-parameters-on-the-stack.patch, but
> >   I'm not sure it's right and unless something really rapid happens, we'll
> >   ship with that bug unfixed.
> 
> Things I can say:
>  - Works for me :-)
>  - When you look at the code, it's obvious that switching to -mregparm=3
> changed the way we call into EFI runtime services. If you consider that
> that old code was correct, then the patch is needed to keep the good
> calling convention.
>  - It touches only arch/i386/kernel/efi.c which is compiled only with
> CONFIG_EFI && X86
>  - It changes code that is called only when booted in EFI mode.
> 
> Last 2 points mean the user base is pretty limited, which can be taken
> both as an argument to push it for the release or not to. I'd obviously
> prefer that someone knowledgeable about EFI looks at it and ACKs before
> it goes in.
> 

OK, well here it is again for everyone's reviwing pleasure:


From: Frederic Riss <frederic.riss@gmail.com>

When calling into the EFI firmware, the parameters need to be passed on
the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
This patch is needed to allow the new Intel-based Macs to suspend to ram
(efi.get_time is called during the suspend phase).

Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: <artiom.myaskouvskey@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/efi.c |   89 +++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/efi.c~efi-x86-pass-firmware-call-parameters-on-the-stack arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~efi-x86-pass-firmware-call-parameters-on-the-stack
+++ a/arch/i386/kernel/efi.c
@@ -473,6 +473,70 @@ static inline void __init check_range_fo
 }
 
 /*
+ * Wrap all the virtual calls in a way that forces the parameters on the stack.
+ */
+
+#define efi_call_virt(f, args...) \
+     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return efi_call_virt(get_time, tm, tc);
+}
+
+static efi_status_t virt_efi_set_time (efi_time_t *tm)
+{
+	return efi_call_virt(set_time, tm);
+}
+
+static efi_status_t virt_efi_get_wakeup_time (efi_bool_t *enabled,
+					      efi_bool_t *pending,
+					      efi_time_t *tm)
+{
+	return efi_call_virt(get_wakeup_time, enabled, pending, tm);
+}
+
+static efi_status_t virt_efi_set_wakeup_time (efi_bool_t enabled,
+					      efi_time_t *tm)
+{
+	return efi_call_virt(set_wakeup_time, enabled, tm);
+}
+
+static efi_status_t virt_efi_get_variable (efi_char16_t *name,
+					   efi_guid_t *vendor, u32 *attr,
+					   unsigned long *data_size, void *data)
+{
+	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_variable (unsigned long *name_size,
+						efi_char16_t *name,
+						efi_guid_t *vendor)
+{
+	return efi_call_virt(get_next_variable, name_size, name, vendor);
+}
+
+static efi_status_t virt_efi_set_variable (efi_char16_t *name,
+					   efi_guid_t *vendor,
+					   unsigned long attr,
+					   unsigned long data_size, void *data)
+{
+	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count (u32 *count)
+{
+	return efi_call_virt(get_next_high_mono_count, count);
+}
+
+static void virt_efi_reset_system (int reset_type, efi_status_t status,
+				   unsigned long data_size,
+				   efi_char16_t *data)
+{
+	efi_call_virt(reset_system, reset_type, status, data_size, data);
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor and update
@@ -525,22 +589,15 @@ void __init efi_enter_virtual_mode(void)
 	 * pointers in the runtime service table to the new virtual addresses.
 	 */
 
-	efi.get_time = (efi_get_time_t *) efi.systab->runtime->get_time;
-	efi.set_time = (efi_set_time_t *) efi.systab->runtime->set_time;
-	efi.get_wakeup_time = (efi_get_wakeup_time_t *)
-					efi.systab->runtime->get_wakeup_time;
-	efi.set_wakeup_time = (efi_set_wakeup_time_t *)
-					efi.systab->runtime->set_wakeup_time;
-	efi.get_variable = (efi_get_variable_t *)
-					efi.systab->runtime->get_variable;
-	efi.get_next_variable = (efi_get_next_variable_t *)
-					efi.systab->runtime->get_next_variable;
-	efi.set_variable = (efi_set_variable_t *)
-					efi.systab->runtime->set_variable;
-	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
-					efi.systab->runtime->get_next_high_mono_count;
-	efi.reset_system = (efi_reset_system_t *)
-					efi.systab->runtime->reset_system;
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
 }
 
 void __init
_

