Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYLXDF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYLXDF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLXDFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:05:14 -0500
Received: from www.tglx.de ([62.245.132.106]:44547 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYLXDFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:05:13 -0500
Date: Wed, 24 Dec 2008 04:04:03 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Magnus Damm <damm@igel.co.jp>
Subject: [PATCH] UIO: Add missing documentation of features added recently
Message-ID: <20081224030400.GB3081@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following features were added to the UIO framework in the near past:

* Generic drivers for platform devices (uio_pdrv, uio_pdrv_genirq)
* an "offset" sysfs attribute for memory mappings

Unfortunately, all this went in without documentation (won't happen again...)

This patch updates UIO documentation.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 Documentation/DocBook/uio-howto.tmpl |   88 +++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

Index: linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.28-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-12-24 01:15:17.000000000 +0100
+++ linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl	2008-12-24 03:29:37.000000000 +0100
@@ -42,6 +42,12 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.7</revnumber>
+	<date>2008-12-23</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added generic platform drivers and offset attribute.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.6</revnumber>
 	<date>2008-12-05</date>
 	<authorinitials>hjk</authorinitials>
@@ -312,6 +318,16 @@
 	pointed to by addr.
 	</para>
 </listitem>
+<listitem>
+	<para>
+	<filename>offset</filename>: The offset, in bytes, that has to be
+	added to the pointer returned by <function>mmap()</function> to get
+	to the actual device memory. This is important if the device's memory
+	is not page aligned. Remember that pointers returned by
+	<function>mmap()</function> are always page aligned, so it is good
+	style to always add this offset.
+	</para>
+</listitem>
 </itemizedlist>
 
 <para>
@@ -594,6 +610,78 @@
 	</para>
 </sect1>
 
+<sect1 id="using_uio_pdrv">
+<title>Using uio_pdrv for platform devices</title>
+	<para>
+	In many cases, UIO drivers for platform devices can be handled in a
+	generic way. In the same place where you define your
+	<varname>struct platform_device</varname>, you simply also implement
+	your interrupt handler and fill your
+	<varname>struct uio_info</varname>. A pointer to this
+	<varname>struct uio_info</varname> is then used as
+	<varname>platform_data</varname> for your platform device.
+	</para>
+	<para>
+	You also need to set up an array of <varname>struct resource</varname>
+	containing addresses and sizes of your memory mappings. This
+	information is passed to the driver using the
+	<varname>.resource</varname> and <varname>.num_resources</varname>
+	elements of <varname>struct platform_device</varname>.
+	</para>
+	<para>
+	You now have to set the <varname>.name</varname> element of
+	<varname>struct platform_device</varname> to
+	<varname>"uio_pdrv"</varname> to use the generic UIO platform device
+	driver. This driver will fill the <varname>mem[]</varname> array
+	according to the resources given, and register the device.
+	</para>
+	<para>
+	The advantage of this approach is that you only have to edit a file
+	you need to edit anyway. You do not have to create an extra driver.
+	</para>
+</sect1>
+
+<sect1 id="using_uio_pdrv_genirq">
+<title>Using uio_pdrv_genirq for platform devices</title>
+	<para>
+	Especially in embedded devices, you frequently find chips where the
+	irq pin is tied to its own dedicated interrupt line. In such cases,
+	where you can be really sure the interrupt is not shared, we can take
+	the concept of <varname>uio_pdrv</varname> one step further and use a
+	generic interrupt handler. That's what
+	<varname>uio_pdrv_genirq</varname> does.
+	</para>
+	<para>
+	The setup for this driver is the same as described above for
+	<varname>uio_pdrv</varname>, except that you do not implement an
+	interrupt handler. The <varname>.handler</varname> element of
+	<varname>struct uio_info</varname> must remain
+	<varname>NULL</varname>. The  <varname>.irq_flags</varname> element
+	must not contain <varname>IRQF_SHARED</varname>.
+	</para>
+	<para>
+	You will set the <varname>.name</varname> element of
+	<varname>struct platform_device</varname> to
+	<varname>"uio_pdrv_genirq"</varname> to use this driver.
+	</para>
+	<para>
+	The generic interrupt handler of <varname>uio_pdrv_genirq</varname>
+	will simply disable the interrupt line using
+	<function>disable_irq_nosync()</function>. After doing its work,
+	userspace can reenable the interrupt by writing 0x00000001 to the UIO
+	device file. The driver already implements an
+	<function>irq_control()</function> to make this possible, you must not
+	implement your own.
+	</para>
+	<para>
+	Using <varname>uio_pdrv_genirq</varname> not only saves a few lines of
+	interrupt handler code. You also do not need to know anything about
+	the chip's internal registers to create the kernel part of the driver.
+	All you need to know is the irq number of the pin the chip is
+	connected to.
+	</para>
+</sect1>
+
 </chapter>
 
 <chapter id="userspace_driver" xreflabel="Writing a driver in user space">
