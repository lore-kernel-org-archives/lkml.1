Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYHMT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYHMT3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYHMT3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:29:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYHMT3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:29:01 -0400
Date: Wed, 13 Aug 2008 15:05:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net,
       sam@ravnborg.org
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080813190533.GA6099@redhat.com>
References: <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com> <20080811173616.GC6103@redhat.com> <20080811223309.GD9810@kroah.com> <20080812194817.GD6056@redhat.com> <20080812200908.GA444@kroah.com> <20080812204619.GE6056@redhat.com> <20080813010804.GA17446@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080813010804.GA17446@kroah.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 06:08:04PM -0700, Greg KH wrote:
> On Tue, Aug 12, 2008 at 04:46:19PM -0400, Jason Baron wrote:
> > On Tue, Aug 12, 2008 at 01:09:08PM -0700, Greg KH wrote:
> > > So close, can I have a good changelog comment with the patch so people
> > > know what it is when they look in the logs?
> > > 
> > > Care to resend it with that?
> > > 
> > 
> > Base infrastructure to enable per-module debug messages.
> 
> Ah, so close...
> 
> With this patch, I get the following build error:
> 
>   CC [M]  drivers/usb/gadget/u_ether.o
> drivers/usb/gadget/u_ether.c: In function ‘gether_setup’:
> drivers/usb/gadget/u_ether.c:787: error: ‘KBUILD_MODNAME’ undeclared (first use in this function)
> drivers/usb/gadget/u_ether.c:787: error: (Each undeclared identifier is reported only once
> drivers/usb/gadget/u_ether.c:787: error: for each function it appears in.)
> drivers/usb/gadget/u_ether.c:787: error: unknown field ‘Usage’ specified in initializer
> drivers/usb/gadget/u_ether.c:787: error: expected expression before ‘.’ token
> drivers/usb/gadget/u_ether.c:787: error: initializer element is not constant
> drivers/usb/gadget/u_ether.c:787: error: (near initialization for ‘descriptor.hash’)
> drivers/usb/gadget/u_ether.c:787: error: ‘Usage’ undeclared (first use in this function)
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ‘long long int’ and ‘char *’)
> drivers/usb/gadget/u_ether.c:787: error: expected ‘)’ before ‘:’ token
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ‘long long int’ and ‘char *’)
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ‘long long int’ and ‘char *’)
> drivers/usb/gadget/u_ether.c:787: error: expected ‘)’ before ‘:’ token
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ‘long long int’ and ‘char *’)
> drivers/usb/gadget/u_ether.c:787: error: expected ‘)’ before ‘:’ token
> drivers/usb/gadget/u_ether.c:787: warning: passing argument 4 of ‘__dynamic_dbg_enabled_helper’ makes integer from pointer without a cast
> drivers/usb/gadget/u_ether.c:787: error: expected ‘)’ before ‘KBUILD_MODNAME’
> drivers/usb/gadget/u_ether.c:787: warning: too few arguments for format
> make[1]: *** [drivers/usb/gadget/u_ether.o] Error 1
> make: *** [_module_drivers/usb/gadget] Error 2
> 
> 
> Did you try a simple 'make allmodconfig'?
> 
> Also, I cleaned it up a bit to make it pass checkpatch.pl and sparse,
> doesn't anyone run these things anymore...
> 
> I've attached my fixed up version below.
> 
> Any ideas?
> 

I was working on an older kernel and so i didn't see this error.

There seem to be a couple of issues here.

First, KBUILD_MODNAME is not defined during the compile of  u_ether.c because
it is included from multiple sources. It seems that when there are multiple 
sources "modname" is set to a string of all the source names with spaces in 
between. So something used in foo and bar looks like: "foo bar".  From 
scripts/Makefile.lib:

# Note: It's possible that one object gets potentially linked into more
#       than one module. In that case KBUILD_MODNAME will be set to foo_bar,
#       where foo and bar are the name of the modules.
name-fix = $(subst $(comma),_,$(subst -,_,$1))
basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
modname_flags  = $(if $(filter 1,$(words $(modname))),\
                 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
.
.
.


So, the comment says that the KBUILD_MODNAME should be set to "foo_bar" if
its included from multiple files...however, the modname_flags definition is not
doing that. In fact, if there are multiple sources its simply setting a
NULL modname_flag. This issue is independent of the patchset I posted, and
probably is best fixed separately. A patch which resolves this issue:

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
  
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index b4ca38a..639d5dc 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -94,7 +94,8 @@ obj-dirs	:= $(addprefix $(obj)/,$(obj-dirs))
 name-fix = $(subst $(comma),_,$(subst -,_,$1))
 basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
-                 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
+		 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))",\
+		 -D"KBUILD_MODNAME=KBUILD_STR($(subst $(space),_,$(call name-fix,$(modname))))")
 
 #hash values
 ifdef CONFIG_DYNAMIC_PRINTK_DEBUG


The second issue is then that the hash functions that i introduced don't like 
these spaces either. So on top of the patch set i posted please add the patch
below. The kernel should then compile. I tested this on the 'linux-next' tree,
which did not boot on the system i was using, but i'm not sure it was related 
to this change. 

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

---


diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 639d5dc..3b5455b 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -99,8 +99,8 @@ modname_flags  = $(if $(filter 1,$(words $(modname))),\
 
 #hash values
 ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-debug_flags = -D"DEBUG_HASH=$(shell ./scripts/basic/hash djb2 $(@D)$(modname))"\
-              -D"DEBUG_HASH2=$(shell ./scripts/basic/hash r5 $(@D)$(modname))"
+debug_flags = -D"DEBUG_HASH=$(shell ./scripts/basic/hash djb2 $(@D)$(subst $(space),_,$(modname)))"\
+              -D"DEBUG_HASH2=$(shell ./scripts/basic/hash r5 $(@D)$(subst $(space),_,$(modname)))"
 else
 debug_flags =
 endif



