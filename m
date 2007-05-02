Return-Path: <linux-kernel-owner+w=401wt.eu-S2992917AbXEBImL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992917AbXEBImL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992916AbXEBImL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:42:11 -0400
Received: from www.osadl.org ([213.239.205.134]:41954 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992917AbXEBImG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:42:06 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Wed, 2 May 2007 10:41:35 +0200
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de
References: <20070427224957.GA17967@kroah.com> <11777142633770-git-send-email-gregkh@suse.de> <20070501164239.00d209c8.randy.dunlap@oracle.com>
In-Reply-To: <20070501164239.00d209c8.randy.dunlap@oracle.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021041.35422.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:

> > +<title>The Userspace I/O HOWTO</title>
> 
> Most of this reads well.  Thanks.
> A few typo corrections are below...

Thank you for your work. I generated a new patch that includes all your 
suggestions and also fixes the build problems.

[...]
> 
> However, it still fails 'make htmldocs' for me.
> What am I missing?  How did it work for you?
> My DTD doesn't like to see <varname> inside a <listitem>:
> 
> 
> linux-2.6.21-rc7-mm2/Documentation/DocBook/uio-howto.xml:333: element listitem: validity error : Element listitem content does not follow the DTD, expecting (calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | caution | important | note | tip | warning | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable | equation | example | figure | table | msgset | procedure | sidebar | qandaset | anchor | bridgehead | remark | highlights | abstract | authorblurb | epigraph | indexterm | beginpage)+, got (varname CDATA)
> 
> 
> so I removed most of the <varname>s and still had errors.
> Any suggestions?

Yes, this only occurs when the <listitem> content is not surrounded by 
<para></para>. I fixed that. I also changed the whole thing from
"article" to "book" as all the other *.tmpl files are books. 


[...]
> > <listitem>
> > +<varname>void *internal_addr</varname>: If you have to access this memory
> > +region from within your kernel module, you will want to map it internally by
> > +using something like <function>ioremap_nocache()</function>. Addresses
> > +returned by this function can not be mapped to user space, so you must not
> 
>                              cannot

Here I also replaced ioremap_nocache() by ioremap(). I just fixed that in
uio_cif.c and don't want to encourage other people to write the same nonsense.

Here's my patch, as I said, it should include your fixes as well:

Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-05-02 08:32:19.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-05-02 09:10:40.000000000 +0200
@@ -234,7 +234,7 @@
 
 /**
  * uio_event_notify - trigger an interrupt event
- * @idev: UIO device where the event occured
+ * @info: UIO device capabilities
  */
 void uio_event_notify(struct uio_info *info)
 {
@@ -583,8 +583,9 @@
 /**
  * uio_register_device - register a new userspace IO device
  *
+ * @owner:	module that creates the new device
  * @parent:	parent device
- * @idev:	device capabilities
+ * @info:	UIO device capabilities
  *
  * returns zero on success or a negative error code.
  */
@@ -660,9 +661,8 @@
 
 /**
  * uio_unregister_device - unregister a industrial IO device
- * @uiodev:	UIO device driver identifier
+ * @info:	UIO device capabilities
  *
- * returns 0 on success
  */
 void uio_unregister_device(struct uio_info *info)
 {
Index: linux-2.6.22-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.22-rc.orig/include/linux/uio_driver.h	2007-05-02 08:24:38.000000000 +0200
+++ linux-2.6.22-rc/include/linux/uio_driver.h	2007-05-02 08:42:42.000000000 +0200
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 
 /**
- * uio_mem - description of a UIO memory region
+ * struct uio_mem - description of a UIO memory region
  * @kobj:		kobject for this mapping
  * @addr:		address of the device's memory
  * @size:		size of IO
@@ -39,13 +39,13 @@
 struct uio_device;
 
 /**
- * uio_info - UIO device capabilities
+ * struct uio_info - UIO device capabilities
  * @uio_dev:		the UIO device this info belongs to
  * @name:		device name
  * @version:		device driver version
  * @mem:		list of mappable memory regions, size==0 for end of list
  * @irq:		interrupt number or UIO_IRQ_CUSTOM
- * @irq_flags		flags for request_irq()
+ * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
  * @mmap:		mmap operation for this uio device
@@ -56,7 +56,7 @@
 	struct uio_device	*uio_dev;
 	char			*name;
 	char			*version;
-	struct uio_mem		mem[ MAX_UIO_MAPS ];
+	struct uio_mem		mem[MAX_UIO_MAPS];
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
Index: linux-2.6.22-rc/Documentation/DocBook/Makefile
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/Makefile	2007-05-02 09:00:32.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/Makefile	2007-05-02 09:43:06.000000000 +0200
@@ -11,7 +11,7 @@
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml
+	    genericirq.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
Index: linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/uio-howto.tmpl	2007-05-02 08:54:24.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl	2007-05-02 10:24:18.000000000 +0200
@@ -1,9 +1,9 @@
 <?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE article PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
-"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
+"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" []>
 
-<article id="index">
-<articleinfo>
+<book id="index">
+<bookinfo>
 <title>The Userspace I/O HOWTO</title>
 
 <author>
@@ -48,13 +48,13 @@
 	<revremark>First draft.</revremark>
 	</revision>
 </revhistory>
-</articleinfo>
+</bookinfo>
 
-<sect1 id="aboutthisdoc">
+<chapter id="aboutthisdoc">
 <?dbhtml filename="about.html"?>
 <title>About this document</title>
 
-<sect2 id="copyright">
+<sect1 id="copyright">
 <?dbhtml filename="copyright.html"?>
 <title>Copyright and License</title>
 <para>
@@ -63,9 +63,9 @@
 This documentation is Free Software licensed under the terms of the
 GPL version 2.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="translations">
+<sect1 id="translations">
 <?dbhtml filename="translations.html"?>
 <title>Translations</title>
 
@@ -73,9 +73,9 @@
 interested in translating it, please email me
 <email>hjk@linutronix.de</email>.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="preface">
+<sect1 id="preface">
 <title>Preface</title>
 	<para>
 	For many types of devices, creating a Linux kernel driver is
@@ -94,25 +94,25 @@
 	user space. This simplifies development and reduces the risk of
 	serious bugs within a kernel module.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="thanks">
+<sect1 id="thanks">
 <title>Acknowledgments</title>
 	<para>I'd like to thank Thomas Gleixner and Benedikt Spranger of
 	Linutronix, who have not only written most of the UIO code, but also
 	helped greatly writing this HOWTO by giving me all kinds of background
 	information.</para>
-</sect2>
+</sect1>
 
-<sect2 id="feedback">
+<sect1 id="feedback">
 <title>Feedback</title>
 	<para>Find something wrong with this document? (Or perhaps something
 	right?) I would love to hear from you. Please email me at
 	<email>hjk@linutronix.de</email>.</para>
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="about">
+<chapter id="about">
 <?dbhtml filename="about.html"?>
 <title>About UIO</title>
 
@@ -139,7 +139,7 @@
 </listitem>
 </itemizedlist>
 
-<sect2 id="how_uio_works">
+<sect1 id="how_uio_works">
 <title>How UIO works</title>
 	<para>
 	Each UIO device is accessed through a device file and several
@@ -188,7 +188,7 @@
 	files.  A custom kernel driver module can add its own
 	attributes to the device owned by the uio driver, but not added
 	to the UIO device itself at this time.  This might change in the
-	future if it would be found to be useful
+	future if it would be found to be useful.
 	</para>
 
 	<para>
@@ -264,10 +264,10 @@
 offset = N * getpagesize();
 </programlisting>
 
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="using-uio_dummy" xreflabel="Using uio_dummy">
+<chapter id="using-uio_dummy" xreflabel="Using uio_dummy">
 <?dbhtml filename="using-uio_dummy.html"?>
 <title>Using uio_dummy</title>
 	<para>
@@ -277,7 +277,7 @@
 	kernel module that you will have to write yourself.
 	</para>
 
-<sect2 id="what_uio_dummy_does">
+<sect1 id="what_uio_dummy_does">
 <title>What uio_dummy does</title>
 	<para>
 	The kernel module <filename>uio_dummy.ko</filename> creates a
@@ -316,10 +316,10 @@
 	Use <function>cat count</function> to see how the interrupt
 	frequency changes.
 	</para>
-</sect2>
 </sect1>
+</chapter>
 
-<sect1 id="custom_kernel_module" xreflabel="Writing your own kernel module">
+<chapter id="custom_kernel_module" xreflabel="Writing your own kernel module">
 <?dbhtml filename="custom_kernel_module.html"?>
 <title>Writing your own kernel module</title>
 	<para>
@@ -328,7 +328,7 @@
 	sections of this file.
 	</para>
 
-<sect2 id="uio_info">
+<sect1 id="uio_info">
 <title>struct uio_info</title>
 	<para>
 	This structure tells the framework the details of your driver,
@@ -336,24 +336,24 @@
 	</para>
 
 <itemizedlist>
-<listitem>
+<listitem><para>
 <varname>char *name</varname>: Required. The name of your driver as
 it will appear in sysfs. I recommend using the name of your module for this.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>char *version</varname>: Required. This string appears in
 <filename>/sys/class/uio/uioX/version</filename>.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>struct uio_mem mem[ MAX_UIO_MAPS ]</varname>: Required if you
 have memory that can be mapped with <function>mmap()</function>. For each
 mapping you need to fill one of the <varname>uio_mem</varname> structures.
 See the description below for details.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>long irq</varname>: Required. If your hardware generates an
 interrupt, it's your modules task to determine the irq number during
 initialization. If you don't have a hardware generated interrupt but
@@ -363,35 +363,35 @@
 routine. If you had no interrupt at all, you could set
 <varname>irq</varname> to <varname>UIO_IRQ_NONE</varname>, though this
 rarely makes sense.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long irq_flags</varname>: Required if you've set
 <varname>irq</varname> to a hardware interrupt number. The flags given
 here will be used in the call to <function>request_irq()</function>.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*mmap)(struct uio_info *info, struct vm_area_struct
 *vma)</varname>: Optional. If you need a special
 <function>mmap()</function> function, you can set it here. If this
 pointer is not NULL, your <function>mmap()</function> will be called
 instead of the built-in one.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*open)(struct uio_info *info, struct inode *inode)
 </varname>: Optional. You might want to have your own
 <function>open()</function>, e.g. to enable interrupts only when your
 device is actually used.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>int (*release)(struct uio_info *info, struct inode *inode)
 </varname>: Optional. If you define your own
 <function>open()</function>, you will probably also want a custom
 <function>release()</function> function.
-</listitem>
+</para></listitem>
 </itemizedlist>
 
 <para>
@@ -402,36 +402,36 @@
 </para>
 
 <itemizedlist>
-<listitem>
+<listitem><para>
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
 <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
 memory (e.g. allocated with <function>kmalloc()</function>). There's also
 <varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long addr</varname>: Required if the mapping is used.
 Fill in the address of your memory block. This address is the one that
 appears in sysfs.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>unsigned long size</varname>: Fill in the size of the
 memory block that <varname>addr</varname> points to. If <varname>size</varname>
 is zero, the mapping is considered unused. Note that you
 <emphasis>must</emphasis> initialize <varname>size</varname> with zero for
 all unused mappings.
-</listitem>
+</para></listitem>
 
-<listitem>
+<listitem><para>
 <varname>void *internal_addr</varname>: If you have to access this memory
 region from within your kernel module, you will want to map it internally by
-using something like <function>ioremap_nocache()</function>. Addresses
-returned by this function can not be mapped to user space, so you must not
+using something like <function>ioremap()</function>. Addresses
+returned by this function cannot be mapped to user space, so you must not
 store it in <varname>addr</varname>. Use <varname>internal_addr</varname>
 instead to remember such an address.
-</listitem>
+</para></listitem>
 </itemizedlist>
 
 <para>
@@ -439,9 +439,9 @@
 <varname>struct uio_mem</varname>! It is used by the UIO framework
 to set up sysfs files for this mapping. Simply leave it alone.
 </para>
-</sect2>
+</sect1>
 
-<sect2 id="adding_irq_handler">
+<sect1 id="adding_irq_handler">
 <title>Adding an interrupt handler</title>
 	<para>
 	What you need to do in your interrupt handler depends on your
@@ -453,7 +453,7 @@
 	hand, your hardware <emphasis>needs</emphasis> some action to
 	be performed after each interrupt, then you
 	<emphasis>must</emphasis> do it in your kernel module. Note
-	that you cannot rely on the userspace part of your driver.Your
+	that you cannot rely on the userspace part of your driver. Your
 	userspace program can terminate at any time, possibly leaving
 	your hardware in a state where proper interrupt handling is
 	still required.
@@ -486,11 +486,11 @@
 	frequently happens on the PC platform, you can save yourself a
 	lot of trouble by supporting interrupt sharing.
 	</para>
-</sect2>
-
 </sect1>
 
-<sect1 id="userspace_driver" xreflabel="Writing a driver in user space">
+</chapter>
+
+<chapter id="userspace_driver" xreflabel="Writing a driver in user space">
 <?dbhtml filename="userspace_driver.html"?>
 <title>Writing a driver in userspace</title>
 	<para>
@@ -502,7 +502,7 @@
 	userspace application.
 	</para>
 
-<sect2 id="getting_uio_information">
+<sect1 id="getting_uio_information">
 <title>Getting information about your UIO device</title>
 	<para>
 	Information about all UIO devices is available in sysfs. The
@@ -534,9 +534,9 @@
 	The file <filename>uio_helper.c</filename> contains a lot of
 	functions you could use in your userspace driver code.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="mmap_device_memory">
+<sect1 id="mmap_device_memory">
 <title>mmap() device memory</title>
 	<para>
 	After you made sure you've got the right device with the
@@ -561,9 +561,9 @@
 	A drawback of this technique is that memory is always
 	mapped beginning with its start address.
 	</para>
-</sect2>
+</sect1>
 
-<sect2 id="wait_for_interrupts">
+<sect1 id="wait_for_interrupts">
 <title>Waiting for interrupts</title>
 	<para>
 	After you successfully mapped your devices memory, you
@@ -590,10 +590,10 @@
 	You can also use <function>select()</function> on
 	<filename>/dev/uioX</filename>.
 	</para>
-</sect2>
-
 </sect1>
 
+</chapter>
+
 <appendix id="app1">
 <title>Further information</title>
 <itemizedlist>
@@ -608,4 +608,4 @@
 </itemizedlist>
 </appendix>
 
-</article>
+</book>
