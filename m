Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbZEHVcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbZEHVcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZEHVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:31:50 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34118 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZEHVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:31:49 -0400
Date: Fri, 8 May 2009 23:33:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com
Subject: Re: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to take multiple inputs
Message-ID: <20090508213358.GA18712@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-6-git-send-email-hpa@linux.intel.com> <20090508074234.GD12808@uranus.ravnborg.org> <4A0493B0.3090204@linux.intel.com> <20090508204747.GA18041@uranus.ravnborg.org> <4A049AF5.7090300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A049AF5.7090300@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 01:49:57PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >
> >I did a quick attempt to integrate it in the Makefile - not pretty.
> >So I dropped that idea.
> >
> >It is mainly that we should not fill up scripts/ with small
> >undocumented scripts.
> >
> >Could you add something like this in the top of the file:
> >
> ># Find the sum of the size of all files specified and
> ># output the size as an escaped hex string.
> >#
> ># Sample:
> ># $ ls -l foo
> ># $ -rw-rw-r-- 1 xxx xxx 146 May  8 22:28 foo
> ># $ bin_size foo
> ># $ \\x92\\x00\\x00\\x00
> ># 146 equals 92 hex
> >
> 
> OK, I see your point (especially since that's not what it does.)
> 
> To be honest, how ugly would it be to get a C program in here?  Doing 
> this in shell is horrid, and people tend to whine about Perl (which is 
> perfect for this kind of job.)

Lets just include it in the Makefile and be done with it.
I took our patch and ended up with this - untested - patch.

If you are OK with this you can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>


I forgot to delete bin_size - it is no longer needed...

	Sam


diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cba61ca..827ebf6 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -188,20 +188,34 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = gzip -f -9 < $< > $@
+cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
+	(rm -f $@ ; false)
 
 
 # Bzip2
 # ---------------------------------------------------------------------------
 
 # Bzip2 does not include size in file... so we have to fake that
-size_append=$(CONFIG_SHELL) $(srctree)/scripts/bin_size
+size_append = $(shell                                             \
+dec_size=0;                                                       \
+for F in $1; do                                                   \
+	fsize=$$(stat -c "%s" $$F);                               \
+	dec_size=$$(expr $$dec_size + $$fsize);                   \
+done;                                                             \
+hex=$$(printf "%08x" $$dec_size |                                 \
+sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'); \
+echo -ne $$hex                                                    \
+)
 
 quiet_cmd_bzip2 = BZIP2    $@
-cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
+cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
+	bzip2 -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
+cmd_lzma = (cat $(filter-out FORCE,$^) | \
+	lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
