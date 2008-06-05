Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYFEBav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYFEBav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbYFEBa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756233AbYFEBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:30:27 -0400
Date: Wed, 4 Jun 2008 18:29:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [patch -v3 16/22] acpi: use memory_read_from_buffer
Message-Id: <20080604182952.c536f82f.akpm@linux-foundation.org>
In-Reply-To: <1212628886.10730.2.camel@yakui_zhao.sh.intel.com>
References: <20080604115633.116832712@gmail.com>
	<20080604115824.062644468@gmail.com>
	<1212628886.10730.2.camel@yakui_zhao.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 09:21:26 +0800 Zhao Yakui <yakui.zhao@intel.com> wrote:

> On Wed, 2008-06-04 at 20:56 +0900, Akinobu Mita wrote:
> > plain text document attachment
> > (acpi-use-memory-read-from-buffer.patch)
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: linux-acpi@vger.kernel.org
> > ---
> >  drivers/acpi/system.c |   15 ++-------------
> >  1 file changed, 2 insertions(+), 13 deletions(-)
> > 
> > Index: 2.6-git/drivers/acpi/system.c
> > ===================================================================
> > --- 2.6-git.orig/drivers/acpi/system.c
> > +++ 2.6-git/drivers/acpi/system.c
> > @@ -77,7 +77,6 @@ static ssize_t acpi_table_show(struct ko
> >  	    container_of(bin_attr, struct acpi_table_attr, attr);
> >  	struct acpi_table_header *table_header = NULL;
> >  	acpi_status status;
> > -	ssize_t ret_count = count;
> >  
> >  	status =
> >  	    acpi_get_table(table_attr->name, table_attr->instance,
> > @@ -85,18 +84,8 @@ static ssize_t acpi_table_show(struct ko
> >  	if (ACPI_FAILURE(status))
> >  		return -ENODEV;
> >  
> > -	if (offset >= table_header->length) {
> > -		ret_count = 0;
> > -		goto end;
> > -	}
> > -
> > -	if (offset + ret_count > table_header->length)
> > -		ret_count = table_header->length - offset;
> > -
> > -	memcpy(buf, ((char *)table_header) + offset, ret_count);
> > -
> > -      end:
> > -	return ret_count;
> > +	return memory_read_from_buffer(buf, count, &offset,
> > +					table_header, table_header->length);
> >  }
> it seems that there is no definition of memory_read_from_buffer. 
> Where is the function of memory_read_from_buffer defined?

Earlier in the patch series.  (The "16/22" is a hint!)

> Is there a bug about the current function of acpi_table_show?

No, it's just a cleanup.


From: Akinobu Mita <akinobu.mita@gmail.com>

This patch introduces memory_read_from_buffer().

The only difference between memory_read_from_buffer() and
simple_read_from_buffer() is which address space the function copies to.

simple_read_from_buffer copies to user space memory.
memory_read_from_buffer copies to normal memory.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c         |   18 ++++++++++++++++++
 include/linux/fs.h |    5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN fs/libfs.c~introduce-memory_read_from_buffer fs/libfs.c
--- a/fs/libfs.c~introduce-memory_read_from_buffer
+++ a/fs/libfs.c
@@ -528,6 +528,23 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
+ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+				const void *from, size_t available)
+{
+	loff_t pos = *ppos;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= available)
+		return 0;
+	if (count > available - pos)
+		count = available - pos;
+	memcpy(to, from + pos, count);
+	*ppos = pos + count;
+
+	return count;
+}
+
 /*
  * Transaction based IO.
  * The file expects a single write which triggers the transaction, and then
@@ -800,6 +817,7 @@ EXPORT_SYMBOL(simple_statfs);
 EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
+EXPORT_SYMBOL(memory_read_from_buffer);
 EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
diff -puN include/linux/fs.h~introduce-memory_read_from_buffer include/linux/fs.h
--- a/include/linux/fs.h~introduce-memory_read_from_buffer
+++ a/include/linux/fs.h
@@ -2025,7 +2025,10 @@ extern int simple_fill_super(struct supe
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 
-extern ssize_t simple_read_from_buffer(void __user *, size_t, loff_t *, const void *, size_t);
+extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
+			loff_t *ppos, const void *from, size_t available);
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
_

