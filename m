Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYLFBZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYLFBZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYLFBZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:25:22 -0500
Received: from www.tglx.de ([62.245.132.106]:48928 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbYLFBZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:25:20 -0500
Date: Sat, 6 Dec 2008 02:25:13 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Mike Frysinger <vapier@gentoo.org>,
       John Ogness <jogness@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 2/2] UIO: Documentation for UIO ioport info handling
Message-ID: <20081206012513.GC3081@local>
References: <20081123121419.GA3087@local> <20081206012313.GB3081@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206012313.GB3081@local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates UIO documentation with the changes introduced by
PATCH 1/2.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 Documentation/DocBook/uio-howto.tmpl |   97 +++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

Index: linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.28-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-12-06 01:13:56.000000000 +0100
+++ linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl	2008-12-06 01:54:14.000000000 +0100
@@ -42,6 +42,12 @@
 
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
@@ -318,6 +324,54 @@
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
 
@@ -356,6 +410,13 @@
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
@@ -448,6 +509,42 @@
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
