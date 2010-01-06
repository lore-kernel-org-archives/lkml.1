Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265Ab0AFBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0AFBQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036Ab0AFBQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:16:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0AFBQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:16:43 -0500
Date: Tue, 5 Jan 2010 17:15:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ben@decadent.org.uk, tbm@cyrius.com, Kalle Valo <kalle.valo@iki.fi>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-omap@vger.kernel.org, rusty@rustcorp.com.au, roland@redhat.com,
       dave@hiauly1.hia.nrc.ca, Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
Message-Id: <20100105171550.8aef9b15.akpm@linux-foundation.org>
In-Reply-To: <4B3D145C.2080106@gmx.de>
References: <87k4w4wux9.fsf@purkki.valot.fi>
	<1262188157.2749.21.camel@mulgrave.site>
	<4B3D145C.2080106@gmx.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 22:15:08 +0100
Helge Deller <deller@gmx.de> wrote:

> On 12/30/2009 04:49 PM, James Bottomley wrote:
> > A better, and more comprehensive patch would be to try not to count the
> > empty text sections when we're building the notes section (and actually
> > anywhere else in the file).  This patch actually relies on the fact that
> > if sh_size is zero for the text section it should be for the
> > corresponding notes section.  If that doesn't work, we'd actually have
> > to do the matching in the construction piece.
> >
> > Can you try it to see if it works for you?  If it doesn't, I'll try
> > matching notes to text.  It works fine on parisc, but as we don't have a
> > notes section, that's not saying much ...
> >
> > Thanks,
> >
> > James
> 
> 
> Ben Hutchings already sent a similar patch.
> See: http://patchwork.kernel.org/patch/68925/
> 
> IMHO James patch below seems better since it
> checks if a section will be allocated at a few more
> places...
> 

Ben's patch (which is below) is currently in linux-next, via a Rusty
tree.  It is marked for -stable backporting.

If James's patch is preferable then there's an opportunity to do the
swap if we move promptly.




commit 9e9b48a89ed43c73d7355ff999b8e87b0628e1cd
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Sat Dec 19 14:43:01 2009 +0000
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Tue Jan 5 08:44:50 2010 +1100

    modules: Skip empty sections when exporting section notes
    
    Commit 35dead4 "modules: don't export section names of empty sections
    via sysfs" changed the set of sections that have attributes, but did
    not change the iteration over these attributes in add_notes_attrs().
    This can lead to add_notes_attrs() creating attributes with the wrong
    names or with null name pointers.
    
    Introduce a sect_empty() function and use it in both add_sect_attrs()
    and add_notes_attrs().
    
    Reported-by: Martin Michlmayr <tbm@cyrius.com>
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Tested-by: Martin Michlmayr <tbm@cyrius.com>
    Cc: stable@kernel.org
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index e96b8ed..f82386b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1010,6 +1010,12 @@ static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
+
+static inline bool sect_empty(const Elf_Shdr *sect)
+{
+	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+}
+
 struct module_sect_attr
 {
 	struct module_attribute mattr;
@@ -1051,8 +1057,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < nsect; i++)
-		if (sechdrs[i].sh_flags & SHF_ALLOC
-		    && sechdrs[i].sh_size)
+		if (!sect_empty(&sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(sizeof(*sect_attrs)
 			+ nloaded * sizeof(sect_attrs->attrs[0]),
@@ -1070,9 +1075,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 	sattr = &sect_attrs->attrs[0];
 	gattr = &sect_attrs->grp.attrs[0];
 	for (i = 0; i < nsect; i++) {
-		if (! (sechdrs[i].sh_flags & SHF_ALLOC))
-			continue;
-		if (!sechdrs[i].sh_size)
+		if (sect_empty(&sechdrs[i]))
 			continue;
 		sattr->address = sechdrs[i].sh_addr;
 		sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
@@ -1156,7 +1159,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
 	for (i = 0; i < nsect; i++)
-		if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
+		if (!sect_empty(&sechdrs[i]) &&
 		    (sechdrs[i].sh_type == SHT_NOTE))
 			++notes;
 
@@ -1172,7 +1175,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	notes_attrs->notes = notes;
 	nattr = &notes_attrs->attrs[0];
 	for (loaded = i = 0; i < nsect; ++i) {
-		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;

