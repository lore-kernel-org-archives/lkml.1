Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbZGPREu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbZGPREu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbZGPREu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:04:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbZGPREt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:04:49 -0400
Date: Thu, 16 Jul 2009 20:03:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, anthony@codemonkey.ws, avi@redhat.com,
       kvm@vger.kernel.org, chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090716170346.GA22095@redhat.com>
References: <20090715201340.GA12279@redhat.com> <20090715220829.GB31962@suse.de> <20090716140709.GA16321@redhat.com> <20090716151254.GD3642@local> <20090716155208.GA2375@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090716155208.GA2375@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:52:08AM -0700, Greg KH wrote:
> On Thu, Jul 16, 2009 at 05:12:55PM +0200, Hans J. Koch wrote:
> > On Thu, Jul 16, 2009 at 05:07:10PM +0300, Michael S. Tsirkin wrote:
> > > On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> > > > How about moving that documentation into a place that people will notice
> > > > it, like the rest of the UIO documentation?
> > > 
> > > Greg,
> > > 
> > > would it make more sense to add this to
> > > Documentation/DocBook/uio-howto.xml, or to create
> > > Documentation/uio_pci_generic.txt ?
> > 
> > Hi Michael,
> > I'd prefer to have it in uio-howto.xml so that people only have to look in
> > one place. In does not have to be very detailled, just a short explanation
> > what this driver is all about and a short example how to use it.
> 
> I agree, that would be the best place for it.
> 
> thanks,
> 
> greg k-h

OK. Could you take a look at the following please?

-->

doc: Document uio_pci_generic

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 8f6e3b2..4d4ce0e 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -25,6 +25,10 @@
 	<year>2006-2008</year>
 	<holder>Hans-Jürgen Koch.</holder>
 </copyright>
+<copyright>
+	<year>2009</year>
+	<holder>Red Hat Inc, Michael S. Tsirkin (mst@redhat.com)</holder>
+</copyright>
 
 <legalnotice>
 <para>
@@ -42,6 +46,13 @@ GPL version 2.
 
 <revhistory>
 	<revision>
+	<revnumber>0.9</revnumber>
+	<date>2009-07-16</date>
+	<authorinitials>mst</authorinitials>
+	<revremark>Added generic pci driver
+		</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.8</revnumber>
 	<date>2008-12-24</date>
 	<authorinitials>hjk</authorinitials>
@@ -809,6 +820,158 @@ framework to set up sysfs files for this region. Simply leave it alone.
 
 </chapter>
 
+<chapter id="uio_pci_generic" xreflabel="Using Generic driver for PCI cards">
+<?dbhtml filename="uio_pci_generic.html"?>
+<title>Generic PCI UIO driver</title>
+	<para>
+	The generic driver is a kernel module named uio_pci_generic.
+	It can work with any device compliant to PCI 2.3 (circa 2002) and
+	any compliant PCI Express device. Using this, you only need to
+        write the userspace driver, removing the need to write
+        a hardware-specific kernel module.
+	</para>
+
+<sect1 id="uio_pci_generic_binding">
+<title>Making the driver recognize the device</title>
+	<para>
+Since the driver does not declare any device ids, it will not get loaded
+automatically and will not automatically bind to any devices, you must load it
+and allocate id to the driver yourself. For example:
+	<programlisting>
+ modprobe uio_pci_generic
+ echo &quot;8086 10f5&quot; &gt; /sys/bus/pci/drivers/uio_pci_generic/new_id
+	</programlisting>
+	</para>
+	<para>
+If there already is a hardware specific kernel driver for your device, the
+generic driver still won't bind to it, in this case if you want to use the
+generic driver (why would you?) you'll have to manually unbind the hardware
+specific driver and bind the generic driver, like this:
+	<programlisting>
+    echo -n 0000:00:19.0 &gt; /sys/bus/pci/drivers/e1000e/unbind
+    echo -n 0000:00:19.0 &gt; /sys/bus/pci/drivers/uio_pci_generic/bind
+	</programlisting>
+	</para>
+	<para>
+You can verify that the device has been bound to the driver
+by looking for it in sysfs, for example like the following:
+	<programlisting>
+    ls -l /sys/bus/pci/devices/0000:00:19.0/driver
+	</programlisting>
+Which if successful should print
+	<programlisting>
+  .../0000:00:19.0/driver -&gt; ../../../bus/pci/drivers/uio_pci_generic
+	</programlisting>
+Note that the generic driver will not bind to old PCI 2.2 devices.
+If binding the device failed, run the following command:
+	<programlisting>
+  dmesg
+	</programlisting>
+and look in the output for failure reasons
+	</para>
+</sect1>
+
+<sect1 id="uio_pci_generic_internals">
+<title>Things to know about uio_pci_generic</title>
+	<para>
+Interrupts are handled using the Interrupt Disable bit in the PCI command
+register and Interrupt Status bit in the PCI status register.  All devices
+compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
+support these bits.  uio_pci_generic detects this support, and won't bind to
+devices which do not support the Interrupt Disable Bit in the command register.
+	</para>
+	<para>
+On each interrupt, uio_pci_generic sets the Interrupt Disable bit.
+This prevents the device from generating further interrupts
+until the bit is cleared. The userspace driver should clear this
+bit before blocking and waiting for more interrupts.
+	</para>
+</sect1>
+<sect1 id="uio_pci_generic_userspace">
+<title>Writing userspace driver using uio_pci_generic</title>
+	<para>
+Userspace driver can use pci sysfs interface, or the
+libpci libray that wraps it, to talk to the device and to
+re-enable interrupts by writing to the command register.
+	</para>
+</sect1>
+<sect1 id="uio_pci_generic_example">
+<title>Example code using uio_pci_generic</title>
+	<para>
+Here is some sample userspace driver code using uio_pci_generic:
+<programlisting>
+#include &lt;stdlib.h&gt;
+#include &lt;stdio.h&gt;
+#include &lt;unistd.h&gt;
+#include &lt;sys/types.h&gt;
+#include &lt;sys/stat.h&gt;
+#include &lt;fcntl.h&gt;
+#include &lt;errno.h&gt;
+
+int main()
+{
+	int uiofd;
+	int configfd;
+	int err;
+	int i;
+	unsigned icount;
+	unsigned char command_high;
+
+	uiofd = open(&quot;/dev/uio0&quot;, O_RDONLY);
+	if (uiofd &lt; 0) {
+		perror(&quot;uio open:&quot;);
+		return errno;
+	}
+	configfd = open(&quot;/sys/class/uio/uio0/device/config&quot;, O_RDWR);
+	if (uiofd &lt; 0) {
+		perror(&quot;config open:&quot;);
+		return errno;
+	}
+
+	/* Read and cache command value */
+	err = pread(configfd, &amp;command_high, 1, 5);
+	if (err != 1) {
+		perror(&quot;command config read:&quot;);
+		return errno;
+	}
+	command_high &amp;= ~0x4;
+
+	for(i = 0;; ++i) {
+		/* Print out a message, for debugging. */
+		if (i == 0)
+			fprintf(stderr, &quot;Started uio test driver.\n&quot;);
+		else
+			fprintf(stderr, &quot;Interrupts: %d\n&quot;, icount);
+
+		/****************************************/
+		/* Here we got an interrupt from the
+		   device. Do something to it. */
+		/****************************************/
+
+		/* Re-enable interrupts. */
+		err = pwrite(configfd, &amp;command_high, 1, 5);
+		if (err != 1) {
+			perror(&quot;config write:&quot;);
+			break;
+		}
+
+		/* Wait for next interrupt. */
+		err = read(uiofd, &amp;icount, 4);
+		if (err != 4) {
+			perror(&quot;uio read:&quot;);
+			break;
+		}
+
+	}
+	return errno;
+}
+
+</programlisting>
+	</para>
+</sect1>
+
+</chapter>
+
 <appendix id="app1">
 <title>Further information</title>
 <itemizedlist>

