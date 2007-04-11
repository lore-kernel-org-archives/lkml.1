Return-Path: <linux-kernel-owner+w=401wt.eu-S1161335AbXDKWx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335AbXDKWx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161337AbXDKWx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:53:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55508 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335AbXDKWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:53:58 -0400
Date: Wed, 11 Apr 2007 15:51:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Verych <olecom@flower.upol.cz>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 01/31] kbuild: fix dependency generation
Message-ID: <20070411225114.GB24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kbuild-fix-dependency-generation.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Beulich <jbeulich@novell.com>

Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
the split config tree is built, but failed to also adjust fixdep
accordingly - if changing a config option from or to m, files
referencing the respective CONFIG_..._MODULE (but not the
corresponding CONFIG_...) didn't get rebuilt.

The problem is that trisate symbol are represent with three
different symbols:
SYMBOL=n => no symbol defined
SYMBOL=y => CONFIG_SYMBOL defined to '1'
SYMBOL=m => CONFIG_SYMBOL_MODULE defined to '1'

But conf_split_config do not distingush between the =y and =m case,
so only the =y case is honoured.
This is fixed in fixdep so when a CONFIG symbol with
_MODULE is found we skip that part and only look
for the CONFIG_SYMBOL version.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/basic/fixdep.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -28,9 +28,11 @@
  * the dependency on linux/autoconf.h by a dependency on every config
  * option which is mentioned in any of the listed prequisites.
  *
- * To be exact, split-include populates a tree in include/config/,
- * e.g. include/config/his/driver.h, which contains the #define/#undef
- * for the CONFIG_HIS_DRIVER option.
+ * kconfig populates a tree in include/config/ with an empty file
+ * for each config symbol and when the configuration is updated
+ * the files representing changed config options are touched
+ * which then let make pick up the changes and the files that use
+ * the config symbols are rebuilt.
  *
  * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
  * which depend on "include/linux/config/his/driver.h" will be rebuilt,
@@ -245,6 +247,8 @@ void parse_config_file(char *map, size_t
 		continue;
 
 	found:
+		if (!memcmp(q - 7, "_MODULE", 7))
+			q -= 7;
 		use_config(p+7, q-p-7);
 	}
 }

-- 
