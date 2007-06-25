Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXFYPg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXFYPg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXFYPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:36:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39720 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751365AbXFYPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:36:50 -0400
Date: Mon, 25 Jun 2007 11:36:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070625105249.EB5E3D0002@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706251054360.4207-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Roland McGrath wrote:

> > "A waste to store one"?  Waste of what?  It isn't a waste of space; the 
> > space would otherwise be unused.  Waste of an instruction, perhaps.
> 
> Yes.  

Of course, calling register_kernel_hw_breakpoint() with three extra
arguments is a waste of an instruction also, if one of those arguments 
isn't used.

And yet it's not clear that either of these really is a waste.  Suppose
somebody ports code from x86 to PPC64 and leaves a breakpoint length
set to HW_BREAKPOINT_LEN_4.  Clearly we would want to return an error.  
This means that the length value _has_ to be tested, even if it won't
be used for anything.  And this means the length _has_ to be passed
along somehow, either as an argument or as a field value.

> > You might want to examine the check in validate_settings() for address 
> > alignment; it might not be valid if other values get stored in the 
> > low-order bits of the address.  This is a tricky point; it's not safe 
> > to mix bits around unless you know that the data values are correct, 
> > but in validate_settings() you don't yet know that.
> 
> This is why I didn't bring up encoded addresses earlier on. :-)  
> 
> These kinds of issues are why I prefer unambiguously opaque arch-specific
> encodings.  validate_settings is indeed wrong for the natural ppc encoding.
> 
> The values must be set by a call that can return an error.  That means you
> can't really have a static initializer macro, unless it's intended to mean
> "unspecified garbage if not used exactly right".  I favor just going back
> to passing three more args to register_kernel_hw_breakpoint.

All right, I'll change it.  And I'll encapsulate those fields.  I still 
think it will accomplish nothing more than hiding some implementation 
details which don't really need to be hidden.


> > Tests show that my CPU does not clear DR_STEP when a data breakpoint is
> > hit.  Conversely, the DR_TRAPn bits are cleared even when a single-step 
> > exception occurs.
> 
> Ok, this is pretty consistent with what the newest Intel manuals say.
> 
> > If you're interested, I can send you the code I used to do this testing
> > so you can try it on your machine.
> 
> Ok.

It's below.  The patch logs the value of DR6 when each debug interrupt 
occurs, and it adds another sysfs attribute to the bptest driver.  The 
attribute is named "test", and it contains the value that the IRQ 
handler will write back to DR6.  Combine this with the Alt-SysRq-P 
change already submitted, and you can get a clear view of what's going 
on.


> > We have three things to consider: ptrace, utrace, and hw-breakpoint.  
> > Ultimately hw-breakpoint should become part of utrace; we might not
> > want to bother with a standalone version.
> 
> It is not hard to make it a separate option, so there is no reason not to.
> 
> > Furthermore, hw-breakpoint takes over the ptrace's mechanism for
> > breakpoint handling.  If we want to allow a configuration where ptrace
> > is present and hw-breakpoint isn't, then I would have to add an
> > alternate implementation containing only support for the legacy
> > interface.
> 
> I was not suggesting that.  CONFIG_PTRACE would require HW_BREAKPOINT on
> machines where arch ptrace code uses it.

I see.  So I could add a CONFIG_HW_BREAKPOINT option and make 
CONFIG_PTRACE depend on it.  That will be simple enough.

Do you think it would make sense to allow utrace without hw-breakpoint?


> > I made a few other changes to do_debug.  For instance, it no longer 
> > checks whether notify_die() returns NOTIFY_STOP.  That check was a 
> > mistake to begin with; NOTIFY_STOP merely means to cut the notifier 
> > chain short -- it doesn't mean that the debug exception can be ignored.  
> 
> This is incorrect.  The usage of notify_die in all other cases, at least of
> machine exceptions on x86, is to test for == NOTIFY_STOP and when true
> short-circuit the normal effect of the exception (signal, oops).  The
> notifiers should return NOTIFY_STOP if they consumed the exception wholly.
> If none uses NOTIFY_STOP, then the normal user signal should happen.

All right, I'll fix that back up.

> > Also it sends the SIGTRAP when any of the DR_STEP or DR_TRAPn bits are 
> > set in vdr6; this is now the appropriate condition.
> 
> From what you've said, DR_STEP will remain set on a later debug exception.
> So if a non-ptrace hw breakpoint consumed the exception and left no
> DR_TRAPn bits set, the thread would generate a second SIGTRAP from the
> prior single-step.  Currently userland expects to have to clear DR_STEP in
> dr6 via ptrace itself, but does not expect it can get a duplicate SIGTRAP
> if it doesn't.

No, because do_debug always writes a 0 to DR6 after reading it;  
consequently DR_STEP does not remain set on later exceptions.  Unless
we do something like this we would never know whether we entered the
handler because of a single-step exception or not.

But the same effect could occur because of a bogus debug exception 
caused by lazy DR7 switching.  I'll have to add back in code to detect 
that case.

Alan Stern



Index: usb-2.6/arch/i386/kernel/traps.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/traps.c
+++ usb-2.6/arch/i386/kernel/traps.c
@@ -802,13 +802,17 @@ fastcall void __kprobes do_int3(struct p
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
  */
+unsigned long dr6test;
+EXPORT_SYMBOL(dr6test);
+
 fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long dr6;
 
 	get_debugreg(dr6, 6);
-	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
+	printk(KERN_INFO "dr6 = %08lx\n", dr6);
+	set_debugreg(dr6test, 6);	/* DR6 may or may not be cleared by the CPU */
 
 	/* Store the virtualized DR6 value */
 	tsk->thread.vdr6 = dr6;
Index: usb-2.6/bptest/bptest.c
===================================================================
--- usb-2.6.orig/bptest/bptest.c
+++ usb-2.6/bptest/bptest.c
@@ -58,6 +58,22 @@ MODULE_AUTHOR("Alan Stern <stern@rowland
 MODULE_DESCRIPTION("Hardware Breakpoint test driver");
 MODULE_LICENSE("GPL");
 
+extern unsigned long dr6test;
+
+static ssize_t test_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	if (sscanf(buf, "%lx", &dr6test) <= 0)
+		return -EIO;
+	return count;
+}
+
+static ssize_t test_show(struct device_driver *d, char *buf)
+{
+	return sprintf(buf, "dr6test: %08lx\n", dr6test);
+}
+static DRIVER_ATTR(test, 0600, test_show, test_store);
+
 
 static struct hw_breakpoint bps[4];
 
@@ -402,6 +418,7 @@ static struct driver_attribute *(bptest_
 	&driver_attr_call,
 	&driver_attr_read,
 	&driver_attr_write,
+	&driver_attr_test,
 	NULL
 };
 

