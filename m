Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDIENX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDIENX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZDIENN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:13:13 -0400
Received: from ozlabs.org ([203.10.76.45]:60618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZDIENN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:13:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module/module_param
Date: Thu, 9 Apr 2009 13:42:58 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
       alex@shark-linux.de, Russell King <rmk+lkml@arm.linux.org.uk>,
       =?utf-8?q?Micha=C5=82_Januszewski?= <spock@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904091342.59628.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f4efdd65b754ebbf41484d3a2255c59282720650:    
  Linus Torvalds (1):                                                           
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus                

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Andreas Schwab (1):
      module: fix try_then_request_module

Rusty Russell (6):
      cyber2000fb.c: use proper method for stopping unload if CONFIG_ARCH_SHARK
      module_param: invbool should take a 'bool', not an 'int'
      module_param: split perm field into flags and perm
      module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
      module_param: allow 'bool' module_params to be bool, not just int.
      uvesafb: improve parameter handling.

 drivers/video/aty/aty128fb.c |    2 +-
 drivers/video/cyber2000fb.c  |    9 +++----
 drivers/video/uvesafb.c      |   10 +++-----
 include/linux/compiler.h     |    5 ++++
 include/linux/kmod.h         |    2 +-
 include/linux/moduleparam.h  |   40 ++++++++++++++++++++++++++----------
 kernel/params.c              |   46 ++++++++++++++++++++++++++++-------------
 7 files changed, 75 insertions(+), 39 deletions(-)

commit 8188c26f4bdd6ea8ae9f018e24ee8609394020f4
Author: Andreas Schwab <schwab@linux-m68k.org>
Date:   Wed Apr 8 22:05:21 2009 +0200

    module: fix try_then_request_module
    
    Impact: fix wireless modules, broken by acae05156551fd7528fbb616271e672789388e3c
    
    Fix try_then_request_module to use waiting __request_module again.
    
    Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
    Cc: Arjan van de Ven <arjan@linux.intel.com>

 include/linux/kmod.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 39897a8bb87ea98fec0376bf4921ab62ce3f17e3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:18 2009 -0600

    cyber2000fb.c: use proper method for stopping unload if CONFIG_ARCH_SHARK
    
    Russell explains the __module_get():
    > cyber2000fb.c does it in its module initialization function
    > to prevent the module (when built for Shark) from being unloaded.  It
    > does this because it's from the days of 2.2 kernels and no one bothered
    > writing the module unload support for Shark.
    
    Since 2.4, the correct answer has been to not define an unload fn.
    
    Cc: Russell King <rmk+lkml@arm.linux.org.uk>
    Cc: alex@shark-linux.de
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/video/cyber2000fb.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

commit 615091aca19a429526b48f4c3604040896f2826e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:19 2009 -0600

    module_param: invbool should take a 'bool', not an 'int'
    
    It takes an 'int' for historical reasons, and there are only two
    users: simply switch it over to bool.
    
    The other user (uvesafb.c) will get a (harmless-on-x86) warning until
    the next patch is applied.
    
    Cc: Brad Douglas <brad@neruo.com>
    Cc: Michal Januszewski <spock@gentoo.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/video/aty/aty128fb.c |    2 +-
 include/linux/moduleparam.h  |    2 +-
 kernel/params.c              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

commit b45c80a3c89291c75e199d221a43d10040123b1f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:19 2009 -0600

    module_param: split perm field into flags and perm
    
    Impact: cleanup
    
    Rather than hack KPARAM_KMALLOCED into the perm field, separate it out.
    Since the perm field was 32 bits and only needs 16, we don't add bloat.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/moduleparam.h |    8 ++++++--
 kernel/params.c             |    9 +++------
 2 files changed, 9 insertions(+), 8 deletions(-)

commit d0344073c22759ea76d91f0e3c008d2fa759f1ae
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:20 2009 -0600

    module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
    
    Impact: new API
    
    __builtin_types_compatible_p() is a little awkward to use: it takes two
    types rather than types or variables, and it's just damn long.
    
    (typeof(type) == type, so this works on types as well as vars).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/compiler.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

commit b33cf5ea44dd2b53e55313be98f82ff3deca0c68
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:21 2009 -0600

    module_param: allow 'bool' module_params to be bool, not just int.
    
    Impact: API cleanup
    
    For historical reasons, 'bool' parameters must be an int, not a bool.
    But there are around 600 users, so a conversion seems like useless churn.
    
    So we use __same_type() to distinguish, and handle both cases.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/moduleparam.h |   32 +++++++++++++++++++++++---------
 kernel/params.c             |   33 ++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 16 deletions(-)

commit d4cf25003a2ce55cede7f5d703121de8937b0ee5
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Apr 9 13:38:21 2009 -0600

    uvesafb: improve parameter handling.
    
    1) Now module_param(..., invbool, ...) requires a bool, and similarly
       module_param(..., bool, ...) allows it, change pmi_setpal to a bool.
    2) #define param_get_scroll to NULL, since it can never be called (perm
       argument to module_param_named is 0).
    3) Return -EINVAL from param_set_scroll if the value is bad, so it's
       reported.
    
    Note that I don't think the old fb_get_options() is required for new
    drivers: the parameters automatically work as uvesafb.XXX=... anyway.
    
    Acked-by: Michał Januszewski <spock@gentoo.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/video/uvesafb.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)
