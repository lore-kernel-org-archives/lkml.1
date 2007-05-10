Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXEJV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXEJV7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXEJV7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:59:30 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3364 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbXEJV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:59:29 -0400
Date: Thu, 10 May 2007 22:59:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>, sam@ravnborg.org
Cc: cw@f00f.org, linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510215920.GH29713@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, sam@ravnborg.org,
	cw@f00f.org, linux-kernel@vger.kernel.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510.140725.99616053.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 02:07:25PM -0700, David Miller wrote:
> From: Russell King <rmk+lkml@arm.linux.org.uk>
> Date: Thu, 10 May 2007 21:54:27 +0100
> 
> > I've not had one accurate one on ARM yet.
> > 
> > Here's another example:
> > 
> > WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> >  from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'
> > 
> > from init/main.c:
> > 
> > static void noinline rest_init(void)
> >         __releases(kernel_lock)
> > 
> > static void run_init_process(char *init_filename)
> > 
> > Clearly, it just does _not_ work.
> 
> Russell, the symbols are where the reference to an .init.text
> section are coming from, they are not the .init.text function
> being referenced itself.
> 
> It is saying that something between rest_init and run_init_processes,
> which are not .init.text, are referencing an .init.text object.

I'd like to make a suggestion to make the wording of the warning
clearer:

WARNING: init/built-in.o(.text+0x4c): section mismatch: reference to
 .init.text:blah (between 'rest_init' and 'run_init_process')

I think this would remove the confusion - the primary information
relating to where the reference is located is contained together
("init/built-in.o(.text+0x4c)") and the confusing "between" clause
which seems to only be a hint becomes entirely secondary.

Moreover, it's similar to binutils warnings - which are of the form:

file:(section+offset): message

so is of a form that we're used to reading.

Patch below.  Also fixes the obviously wrong ordering of arguments
in the final case in the string of ifs.





Change modpost section mismatch warnings to be less confusing;
model them on the binutils linker warnings which we all know how
to interpret.

Also, fix the wrong ordering of arguments for the final case -
fromsec and refsymname were reversed.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 scripts/mod/modpost.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..6d7864d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -885,29 +885,29 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 		return;
 
 	if (before && after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "between '%s' (at offset 0x%llx) and '%s'\n",
-		     modname, secname, refsymname, fromsec,
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(between '%s' and '%s')\n",
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
 		     elf->strtab + before->st_name,
-		     (long long)r.r_offset,
 		     elf->strtab + after->st_name);
 	} else if (before) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "after '%s' (at offset 0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + before->st_name,
-		     (long long)r.r_offset);
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(after '%s')\n",
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + before->st_name);
 	} else if (after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "before '%s' (at offset -0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + after->st_name,
-		     (long long)r.r_offset);
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + after->st_name);
 	} else {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(offset 0x%llx)\n",
-		     modname, secname, fromsec, refsymname,
-		     (long long)r.r_offset);
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname);
 	}
 }
 


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
