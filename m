Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXIMAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXIMAuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 20:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXIMAuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 20:50:04 -0400
Received: from mylar.outflux.net ([69.93.193.226]:44438 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXIMAuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 20:50:03 -0400
Date: Wed, 12 Sep 2007 17:49:37 -0700
From: Kees Cook <kees@ubuntu.com>
To: Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>,
       Michael Wu <flamingice@sourmilk.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] modpost: detect unterminated device id lists
Message-ID: <20070913004937.GM8183@outflux.net>
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org> <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com> <20070912215356.GC23294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912215356.GC23294@kroah.com>
Organization: Ubuntu
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 02:53:56PM -0700, Greg KH wrote:
> On Wed, Sep 12, 2007 at 03:48:49PM +0400, Alexey Dobriyan wrote:
> > On 9/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> > > Kees Cook wrote:
> > > > This patch against 2.6.23-rc6 fixes a couple drivers that do not
> > > > correctly terminate their pci_device_id lists.  This results in garbage
> > > > being spewed into modules.pcimap when the module happens to not have
> > > > 28 NULL bytes following the table, and/or the last PCI ID is actually
> > > > truncated from the table when calculating the modules.alias PCI aliases,
> > > > cause those unfortunate device IDs to not auto-load.
> > > >
> > > > Signed-off-by: Kees Cook <kees@ubuntu.com>
> > >
> > > ACK
> > 
> > I mut say, non-terminated PCI ids lists are constant PITA. There should be
> > a way to a) put it in macro[1], so that terminator automatically added, and
> > b) still allow #ifdef inside table like, e.g. 8139too does.
> > 
> > [1] or not macro, because #ifdef inside macros aren't allowed.
> 
> If you know of a way to do this in an easier manner, patches are always
> gladly accepted :)

This patch against 2.6.23-rc6 will cause modpost to fail if any device
id lists are incorrectly terminated, after reporting the offender.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
 linux-2.6.23-rc6/scripts/mod/file2alias.c |   39 ++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)
---
diff -urp -x '*.o' linux-2.6.23-rc6~/scripts/mod/file2alias.c linux-2.6.23-rc6/scripts/mod/file2alias.c
--- linux-2.6.23-rc6~/scripts/mod/file2alias.c	2007-09-11 23:17:49.000000000 -0700
+++ linux-2.6.23-rc6/scripts/mod/file2alias.c	2007-09-12 17:41:30.000000000 -0700
@@ -55,10 +55,13 @@ do {                                    
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
  * on actual size which is a bug.
+ * Also verify that the final entry in the table is all zeros.
  **/
-static void device_id_size_check(const char *modname, const char *device_id,
-				 unsigned long size, unsigned long id_size)
+static void device_id_check(const char *modname, const char *device_id,
+			    unsigned long size, unsigned long id_size,
+			    void *symval)
 {
+	int i;
 	if (size % id_size || size < id_size) {
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
 		      "of the size of section __mod_%s_device_table=%lu.\n"
@@ -66,6 +69,18 @@ static void device_id_size_check(const c
 		      "in mod_devicetable.h\n",
 		      modname, device_id, id_size, device_id, size, device_id);
 	}
+	/* Verify last one is a terminator */
+	for (i = 0; i < id_size; i++ ) {
+		if ( *(uint8_t*)(symval+size-id_size+i) ) {
+			fprintf(stderr,"%s: struct %s_device_id is %lu bytes.  The last of %lu is:\n", modname, device_id, id_size, size / id_size);
+			for (i = 0; i < id_size; i++ ) {
+				fprintf(stderr,"0x%02x ", *(uint8_t*)(symval+size-id_size+i) );
+			}
+			fprintf(stderr,"\n");
+			fatal("%s: struct %s_device_id is not terminated "
+				"with a NULL entry!\n", modname, device_id);
+		}
+	}
 }
 
 /* USB is special because the bcdDevice can be matched against a numeric range */
@@ -168,7 +183,7 @@ static void do_usb_table(void *symval, u
 	unsigned int i;
 	const unsigned long id_size = sizeof(struct usb_device_id);
 
-	device_id_size_check(mod->name, "usb", size, id_size);
+	device_id_check(mod->name, "usb", size, id_size, symval);
 
 	/* Leave last one: it's the terminator. */
 	size -= id_size;
@@ -505,7 +520,7 @@ static void do_table(void *symval, unsig
 	char alias[500];
 	int (*do_entry)(const char *, void *entry, char *alias) = function;
 
-	device_id_size_check(mod->name, device_id, size, id_size);
+	device_id_check(mod->name, device_id, size, id_size, symval);
 	/* Leave last one: it's the terminator. */
 	size -= id_size;
 
@@ -527,14 +542,22 @@ void handle_moddevtable(struct module *m
 			Elf_Sym *sym, const char *symname)
 {
 	void *symval;
+	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
 	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
 		return;
 
-	symval = (void *)info->hdr
-		+ info->sechdrs[sym->st_shndx].sh_offset
-		+ sym->st_value;
+	/* Handle all-NULL symbols allocated into .bss */
+	if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
+		zeros = calloc(1, sym->st_size);
+		symval = zeros;
+	}
+	else {
+		symval = (void *)info->hdr
+			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ sym->st_value;
+	}
 
 	if (sym_is(symname, "__mod_pci_device_table"))
 		do_table(symval, sym->st_size,
@@ -599,6 +622,8 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct parisc_device_id), "parisc",
 			 do_parisc_entry, mod);
+
+	if (zeros) free(zeros);
 }
 
 /* Now add out buffered information to the generated C source */


-- 
Kees Cook
