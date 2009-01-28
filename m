Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZA1X2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZA1X2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZA1X16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:27:58 -0500
Received: from kroah.org ([198.145.64.141]:56970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbZA1X15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:27:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] UIO: Add missing documentation of features added recently
Date: Wed, 28 Jan 2009 15:26:35 -0800
Message-Id: <1233185196-23064-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232543.GA23030@kroah.com>
References: <20090128232543.GA23030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

The following features were added to the UIO framework in the near past:

* Generic drivers for platform devices (uio_pdrv, uio_pdrv_genirq)
* an "offset" sysfs attribute for memory mappings

Unfortunately, all this went in without documentation (won't happen again...)

This patch updates UIO documentation.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Uwe Kleine-König <ukleinek@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |   88 ++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index b787e47..52e1b79 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -42,6 +42,12 @@ GPL version 2.
 
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
@@ -312,6 +318,16 @@ interested in translating it, please email me
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
@@ -594,6 +610,78 @@ framework to set up sysfs files for this region. Simply leave it alone.
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
-- 
1.6.0.2

