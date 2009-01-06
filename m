Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZAFWfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZAFWfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZAFWO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:26 -0500
Received: from kroah.org ([198.145.64.141]:51335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755274AbZAFWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 59/60] UIO: Documentation for UIO ioport info handling
Date: Tue,  6 Jan 2009 14:12:18 -0800
Message-Id: <1231279939-32728-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

This patch updates UIO documentation with the changes introduced by
previous UIO patch.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |   97 ++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index df87d1b..6116b93 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -42,6 +42,12 @@ GPL version 2.
 
 <revhistory>
 	<revision>
+	<revnumber>0.6</revnumber>
+	<date>2008-12-05</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added description of portio sysfs attributes.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.5</revnumber>
 	<date>2008-05-22</date>
 	<authorinitials>hjk</authorinitials>
@@ -318,6 +324,54 @@ interested in translating it, please email me
 offset = N * getpagesize();
 </programlisting>
 
+<para>
+	Sometimes there is hardware with memory-like regions that can not be
+	mapped with the technique described here, but there are still ways to
+	access them from userspace. The most common example are x86 ioports.
+	On x86 systems, userspace can access these ioports using
+	<function>ioperm()</function>, <function>iopl()</function>,
+	<function>inb()</function>, <function>outb()</function>, and similar
+	functions.
+</para>
+<para>
+	Since these ioport regions can not be mapped, they will not appear under
+	<filename>/sys/class/uio/uioX/maps/</filename> like the normal memory
+	described above. Without information about the port regions a hardware
+	has to offer, it becomes difficult for the userspace part of the
+	driver to find out which ports belong to which UIO device.
+</para>
+<para>
+	To address this situation, the new directory
+	<filename>/sys/class/uio/uioX/portio/</filename> was added. It only
+	exists if the driver wants to pass information about one or more port
+	regions to userspace. If that is the case, subdirectories named
+	<filename>port0</filename>, <filename>port1</filename>, and so on,
+	will appear underneath
+	<filename>/sys/class/uio/uioX/portio/</filename>.
+</para>
+<para>
+	Each <filename>portX/</filename> directory contains three read-only
+	files that show start, size, and type of the port region:
+</para>
+<itemizedlist>
+<listitem>
+	<para>
+	<filename>start</filename>: The first port of this region.
+	</para>
+</listitem>
+<listitem>
+	<para>
+	<filename>size</filename>: The number of ports in this region.
+	</para>
+</listitem>
+<listitem>
+	<para>
+	<filename>porttype</filename>: A string describing the type of port.
+	</para>
+</listitem>
+</itemizedlist>
+
+
 </sect1>
 </chapter>
 
@@ -356,6 +410,13 @@ See the description below for details.
 </para></listitem>
 
 <listitem><para>
+<varname>struct uio_port port[ MAX_UIO_PORTS_REGIONS ]</varname>: Required
+if you want to pass information about ioports to userspace. For each port
+region you need to fill one of the <varname>uio_port</varname> structures.
+See the description below for details.
+</para></listitem>
+
+<listitem><para>
 <varname>long irq</varname>: Required. If your hardware generates an
 interrupt, it's your modules task to determine the irq number during
 initialization. If you don't have a hardware generated interrupt but
@@ -448,6 +509,42 @@ Please do not touch the <varname>kobj</varname> element of
 <varname>struct uio_mem</varname>! It is used by the UIO framework
 to set up sysfs files for this mapping. Simply leave it alone.
 </para>
+
+<para>
+Sometimes, your device can have one or more port regions which can not be
+mapped to userspace. But if there are other possibilities for userspace to
+access these ports, it makes sense to make information about the ports
+available in sysfs. For each region, you have to set up a
+<varname>struct uio_port</varname> in the <varname>port[]</varname> array.
+Here's a description of the fields of <varname>struct uio_port</varname>:
+</para>
+
+<itemizedlist>
+<listitem><para>
+<varname>char *porttype</varname>: Required. Set this to one of the predefined
+constants. Use <varname>UIO_PORT_X86</varname> for the ioports found in x86
+architectures.
+</para></listitem>
+
+<listitem><para>
+<varname>unsigned long start</varname>: Required if the port region is used.
+Fill in the number of the first port of this region.
+</para></listitem>
+
+<listitem><para>
+<varname>unsigned long size</varname>: Fill in the number of ports in this
+region. If <varname>size</varname> is zero, the region is considered unused.
+Note that you <emphasis>must</emphasis> initialize <varname>size</varname>
+with zero for all unused regions.
+</para></listitem>
+</itemizedlist>
+
+<para>
+Please do not touch the <varname>portio</varname> element of
+<varname>struct uio_port</varname>! It is used internally by the UIO
+framework to set up sysfs files for this region. Simply leave it alone.
+</para>
+
 </sect1>
 
 <sect1 id="adding_irq_handler">
-- 
1.6.0.4

