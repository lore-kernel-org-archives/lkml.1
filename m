Return-Path: <linux-kernel-owner+w=401wt.eu-S1161510AbXD2WTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510AbXD2WTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161513AbXD2WTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:19:06 -0400
Received: from www.osadl.org ([213.239.205.134]:40648 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161510AbXD2WTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:19:02 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
To: tglx@linutronix.de
Subject: Re: Flaws with "UIO: Add the User IO core code" (with patch)
Date: Mon, 30 Apr 2007 00:18:34 +0200
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <1177794532.7646.313.camel@localhost.localdomain> <200704282314.15274.hjk@linutronix.de>
In-Reply-To: <200704282314.15274.hjk@linutronix.de>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704300018.35064.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 23:14 schrieb Hans-Jürgen Koch:
> Am Samstag 28 April 2007 23:08 schrieb Thomas Gleixner:
> > On Sat, 2007-04-28 at 23:03 +0200, Hans-Jürgen Koch wrote:
> > > Am Samstag 28 April 2007 22:24 schrieb Alan Cox:
> > > > > > AFAIK we don't currently have any platform that runs binaries with
> > > > > > different sizes of "int" but this is a) an unsigned value anyway, and b)
> > > > > > should be a fixed type (eg u32)
> > > > > 
> > > > > I reviewed the code once more and find it OK. There is only one legal
> > > > > value for the parameter "count" of uio_read(), and that's sizeof(int).
> > > > 
> > > > If you are a box with multiple supported binary types how big is an
> > > > "int". We use explicit sizes to ensure that uio_read() will work when/if
> > > > we get platforms which support binaries with differing ideas of the size
> > > > of "int". Thus it should use s32 or s64 or similar.
> > > 
> > > Here's a fix to that effect:
> > 
> > Can you please add a matching paragraph to the documentation ?
> > 
> 
> Yes, I'll add a "How to write userspace code" section tomorrow. I'll send a 
> patch as soon as it's ready.
> 
> Hans
>  

Here's the promised update for the documentation:

Hans


Index: linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.22-rc.orig/Documentation/DocBook/uio-howto.tmpl	2007-04-29 22:17:45.000000000 +0200
+++ linux-2.6.22-rc/Documentation/DocBook/uio-howto.tmpl	2007-04-30 00:15:38.000000000 +0200
@@ -30,6 +30,12 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.3</revnumber>
+	<date>2007-04-29</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added section about userspace drivers.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.2</revnumber>
 	<date>2007-02-13</date>
 	<authorinitials>hjk</authorinitials>
@@ -484,14 +490,121 @@
 
 </sect1>
 
+<sect1 id="userspace_driver" xreflabel="Writing a driver in user space">
+<?dbhtml filename="userspace_driver.html"?>
+<title>Writing a driver in userspace</title>
+	<para>
+	Once you have a working kernel module for your hardware, you can
+	write the userspace part of your driver. You don't need any special
+	libraries, your driver can be written in any reasonable language,
+	you can use floating point numbers and so on. In short, you can
+	use all the tools and libraries you'd normally use for writing a
+	userspace application.
+	</para>
+
+<sect2 id="getting_uio_information">
+<title>Getting information about your UIO device</title>
+	<para>
+	Information about all UIO devices is available in sysfs. The
+	first thing you should do in your driver is check
+	<varname>name</varname> and <varname>version</varname> to
+	make sure your talking to the right device and that its kernel
+	driver has the version you expect.
+	</para>
+	<para>
+	You should also make sure that the memory mapping you need
+	exists and has the size you expect.
+	</para>
+	<para>
+	There is a tool called <varname>lsuio</varname> that lists
+	UIO devices and their attributes. It is available here:
+	</para>
+	<para>
+	<ulink url="http://www.osadl.org/projects/downloads/UIO/user/">
+		http://www.osadl.org/projects/downloads/UIO/user/</ulink>
+	</para>
+	<para>
+	With <varname>lsuio</varname> you can quickly check if your
+	kernel module is loaded and which attributes it exports.
+	Have a look at the manpage for details.
+	</para>
+	<para>
+	The source code of <varname>lsuio</varname> can serve as an
+	example for getting information about an UIO device.
+	The file <filename>uio_helper.c</filename> contains a lot of
+	functions you could use in your userspace driver code.
+	</para>
+</sect2>
+
+<sect2 id="mmap_device_memory">
+<title>mmap() device memory</title>
+	<para>
+	After you made sure you've got the right device with the
+	memory mappings you need, all you have to do is to call
+	<function>mmap()</function> to map the device's memory
+	to userspace.
+	</para>
+	<para>
+	The parameter <varname>offset</varname> of the
+	<function>mmap()</function> call has a special meaning
+	for UIO devices: It is used to select which mapping of
+	your device you want to map. To map the memory of
+	mapping N, you have to use N times the page size as
+	your offset:
+	</para>
+<programlisting format="linespecific">
+	offset = N * getpagesize();
+</programlisting>
+	<para>
+	N starts from zero, so if you've got only one memory
+	range to map, set <varname>offset = 0</varname>.
+	A drawback of this technique is that memory is always
+	mapped beginning with its start address.
+	</para>
+</sect2>
+
+<sect2 id="wait_for_interrupts">
+<title>Waiting for interrupts</title>
+	<para>
+	After you successfully mapped your devices memory, you
+	can access it like an ordinary array. Usually, you will
+	perform some initialization. After that, your hardware
+	starts working and will generate an interrupt as soon
+	as it's finished, has some data available, or needs your
+	attention because an error occured.
+	</para>
+	<para>
+	<filename>/dev/uioX</filename> is a read-only file. A
+	<function>read()</function> will always block until an
+	interrupt occurs. There is only one legal value for the
+	<varname>count</varname> parameter of
+	<function>read()</function>, and that is the size of a
+	signed 32 bit integer (4). Any other value for
+	<varname>count</varname> causes <function>read()</function>
+	to fail. The signed 32 bit integer read is the interrupt
+	count of your device. If the value is one more than the value
+	you read the last time, everything is OK. If the difference
+	is greater than one, you missed interrupts.
+	</para>
+	<para>
+	You can also use <function>select()</function> on
+	<filename>/dev/uioX</filename>.
+	</para>
+</sect2>
+
+</sect1>
+
 <appendix id="app1">
 <title>Further information</title>
 <itemizedlist>
 	<listitem><para>
+			<ulink url="http://www.osadl.org">
+				OSADL homepage.</ulink>
+		</para></listitem>
+	<listitem><para>
 		<ulink url="http://www.linutronix.de">
 		 Linutronix homepage.</ulink>
 		</para></listitem>
-	<listitem><para>...</para></listitem>
 </itemizedlist>
 </appendix>
 
