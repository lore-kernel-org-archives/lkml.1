Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYG3XgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYG3XgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760743AbYG3Xfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:35:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328AbYG3Xfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:35:43 -0400
Date: Wed, 30 Jul 2008 16:27:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: [patch 10/29] markers: fix duplicate modpost entry
Message-ID: <20080730232704.GK30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="markers-fix-duplicate-modpost-entry.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

commit: d35cb360c29956510b2fe1a953bd4968536f7216

When a kernel was rebuilt, the previous Module.markers was not cleared.
It caused markers with different format strings to appear as duplicates
when a markers was changed.  This problem is present since
scripts/mod/modpost.c started to generate Module.markers, commit
b2e3e658b344c6bcfb8fb694100ab2f2b5b2edb0

It therefore applies to 2.6.25, 2.6.26 and linux-next.

I merely merged the patches from Roland, Wenji and Takashi here.

Credits to
Roland McGrath <roland@redhat.com>
Wenji Huang <wenji.huang@oracle.com>
and
Takashi Nishiie <t-nishiie@np.css.fujitsu.com>

for providing the individual fixes.

- Changelog :
  - Integrated Takashi's Makefile modification to clear Module.markers upon
    make clean.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Roland McGrath <roland@redhat.com>
Cc: Wenji Huang <wenji.huang@oracle.com>
Cc: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile                 |    3 ++-
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1126,7 +1126,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name 'Module.markers' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -87,6 +87,7 @@ quiet_cmd_kernel-mod = MODPOST $@
       cmd_kernel-mod = $(modpost) $@
 
 vmlinux.o: FORCE
+	@rm -fr $(kernelmarkersfile)
 	$(call cmd,kernel-mod)
 
 # Declare generated files as targets for modpost
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1973,7 +1973,8 @@ static void read_markers(const char *fna
 			mod->skip = 1;
 		}
 
-		add_marker(mod, marker, fmt);
+		if (!mod->skip)
+			add_marker(mod, marker, fmt);
 	}
 	return;
 fail:

-- 
