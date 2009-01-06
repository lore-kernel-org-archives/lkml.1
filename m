Return-Path: <hjk@linutronix.de>
X-Sieve: CMU Sieve 2.2
X-Spam-Score: -2.11
Date: Wed, 7 Jan 2009 00:15:39 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
	Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH RESEND] UIO: Add name attributes for mappings and port
	regions
Message-ID: <20090106231539.GD3057@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, did you miss this one or is it still being reviewed?


If a UIO device has several memory mappings, it can be difficult for userspace
to find the right one. The situation becomes even worse if the UIO driver can
handle different versions of a card that have different numbers of mappings.
Benedikt Spranger has such cards and pointed this out to me. Thanks, Bene!

To address this problem, this patch adds "name" sysfs attributes for each
mapping. Userspace can use these to clearly identify each mapping. The name
string is optional. If a driver doesn't set it, an empty string will be
returned, so this patch won't break existing drivers.

The same problem exists for port region information, so a "name" attribute is
added there, too.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 Documentation/DocBook/uio-howto.tmpl |   29 +++++++++++++++++++++++++----
 drivers/uio/uio.c                    |   22 ++++++++++++++++++++++
 include/linux/uio_driver.h           |    4 ++++
 3 files changed, 51 insertions(+), 4 deletions(-)

Index: linux-2.6.28-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.28-rc.orig/drivers/uio/uio.c	2008-12-24 22:46:52.000000000 +0100
+++ linux-2.6.28-rc/drivers/uio/uio.c	2008-12-25 01:03:34.000000000 +0100
@@ -61,6 +61,14 @@
 };
 #define to_map(map) container_of(map, struct uio_map, kobj)
 
+static ssize_t map_name_show(struct uio_mem *mem, char *buf)
+{
+	if (unlikely(!mem->name))
+		mem->name = "";
+
+	return sprintf(buf, "%s\n", mem->name);
+}
+
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
 	return sprintf(buf, "0x%lx\n", mem->addr);
@@ -82,6 +90,8 @@
 	ssize_t (*store)(struct uio_mem *, const char *, size_t);
 };
 
+static struct map_sysfs_entry name_attribute =
+	__ATTR(name, S_IRUGO, map_name_show, NULL);
 static struct map_sysfs_entry addr_attribute =
 	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
 static struct map_sysfs_entry size_attribute =
@@ -90,6 +100,7 @@
 	__ATTR(offset, S_IRUGO, map_offset_show, NULL);
 
 static struct attribute *attrs[] = {
+	&name_attribute.attr,
 	&addr_attribute.attr,
 	&size_attribute.attr,
 	&offset_attribute.attr,
@@ -133,6 +144,14 @@
 };
 #define to_portio(portio) container_of(portio, struct uio_portio, kobj)
 
+static ssize_t portio_name_show(struct uio_port *port, char *buf)
+{
+	if (unlikely(!port->name))
+		port->name = "";
+
+	return sprintf(buf, "%s\n", port->name);
+}
+
 static ssize_t portio_start_show(struct uio_port *port, char *buf)
 {
 	return sprintf(buf, "0x%lx\n", port->start);
@@ -159,6 +178,8 @@
 	ssize_t (*store)(struct uio_port *, const char *, size_t);
 };
 
+static struct portio_sysfs_entry portio_name_attribute =
+	__ATTR(name, S_IRUGO, portio_name_show, NULL);
 static struct portio_sysfs_entry portio_start_attribute =
 	__ATTR(start, S_IRUGO, portio_start_show, NULL);
 static struct portio_sysfs_entry portio_size_attribute =
@@ -167,6 +188,7 @@
 	__ATTR(porttype, S_IRUGO, portio_porttype_show, NULL);
 
 static struct attribute *portio_attrs[] = {
+	&portio_name_attribute.attr,
 	&portio_start_attribute.attr,
 	&portio_size_attribute.attr,
 	&portio_porttype_attribute.attr,
Index: linux-2.6.28-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.28-rc.orig/include/linux/uio_driver.h	2008-12-24 22:47:07.000000000 +0100
+++ linux-2.6.28-rc/include/linux/uio_driver.h	2008-12-24 22:59:57.000000000 +0100
@@ -22,6 +22,7 @@
 
 /**
  * struct uio_mem - description of a UIO memory region
+ * @name:		name of the memory region for identification
  * @addr:		address of the device's memory
  * @size:		size of IO
  * @memtype:		type of memory addr points to
@@ -29,6 +30,7 @@
  * @map:		for use by the UIO core only.
  */
 struct uio_mem {
+	const char		*name;
 	unsigned long		addr;
 	unsigned long		size;
 	int			memtype;
@@ -42,12 +44,14 @@
 
 /**
  * struct uio_port - description of a UIO port region
+ * @name:		name of the port region for identification
  * @start:		start of port region
  * @size:		size of port region
  * @porttype:		type of port (see UIO_PORT_* below)
  * @portio:		for use by the UIO core only.
  */
 struct uio_port {
+	const char		*name;
 	unsigned long		start;
 	unsigned long		size;
 	int			porttype;
Index: linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.28-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-12-25 01:17:08.000000000 +0100
+++ linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl	2008-12-25 01:28:06.000000000 +0100
@@ -42,6 +42,13 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.8</revnumber>
+	<date>2008-12-24</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Added name attributes in mem and portio sysfs directories.
+		</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.7</revnumber>
 	<date>2008-12-23</date>
 	<authorinitials>hjk</authorinitials>
@@ -303,12 +310,19 @@
 	appear if the size of the mapping is not 0.
 </para>
 <para>
-	Each <filename>mapX/</filename> directory contains two read-only files
-	that show start address and size of the memory:
+	Each <filename>mapX/</filename> directory contains four read-only files
+	that show attributes of the memory:
 </para>
 <itemizedlist>
 <listitem>
 	<para>
+	<filename>name</filename>: A string identifier for this mapping. This
+	is optional, the string can be empty. Drivers can set this to make it
+	easier for userspace to find the correct mapping.
+	</para>
+</listitem>
+<listitem>
+	<para>
 	<filename>addr</filename>: The address of memory that can be mapped.
 	</para>
 </listitem>
@@ -366,12 +380,19 @@
 	<filename>/sys/class/uio/uioX/portio/</filename>.
 </para>
 <para>
-	Each <filename>portX/</filename> directory contains three read-only
-	files that show start, size, and type of the port region:
+	Each <filename>portX/</filename> directory contains four read-only
+	files that show name, start, size, and type of the port region:
 </para>
 <itemizedlist>
 <listitem>
 	<para>
+	<filename>name</filename>: A string identifier for this port region.
+	The string is optional and can be empty. Drivers can set it to make it
+	easier for userspace to find a certain port region.
+	</para>
+</listitem>
+<listitem>
+	<para>
 	<filename>start</filename>: The first port of this region.
 	</para>
 </listitem>
